﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено Тогда
		Если ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения;
		ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
			И ДанныеЗаполнения.Свойство("Основание")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Основание.Метаданные()) Тогда
			ДокументОснование = ДанныеЗаполнения.Основание;
		КонецЕсли;

		Если ДокументОснование <> Неопределено Тогда
			ЗаполнитьПоДокументуОснованию(ДокументОснование);
		Иначе
			СуммаВключаетНДС = Истина;
		КонецЕсли;
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);

	РеквизитыСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ТипСклада, ТипЦенРозничнойТорговли");

	// Склад может заполниться по умолчанию значением, которое не должно выбираться
	Если ЗначениеЗаполнено(Склад) Тогда
		Если ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах Тогда
			Если РеквизитыСклада.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
				Склад = Справочники.Склады.ПустаяСсылка();
			КонецЕсли;
		Иначе
			Если РеквизитыСклада.ТипСклада <> Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
				Склад = Справочники.Склады.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Склад) Тогда
		ТипЦен = РеквизитыСклада.ТипЦенРозничнойТорговли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсДокумента      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьДокумента = СтруктураКурсаВзаиморасчетов.Кратность;
	
	ЭтоОтчетПоНТТ = 
		ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетНТТОПродажах;
	ЕстьСтрокиВТаблицеОплата = Оплата.Количество() > 0;
	
	Если ЭтоОтчетПоНТТ 
		и ЕстьСтрокиВТаблицеОплата Тогда
		Оплата.Очистить();
	КонецЕсли;
	
	Если ОбъектКопирования.ЕстьМаркируемаяПродукцияГИСМ Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "КиЗ_ГИСМ");
	КонецЕсли;
	
	РаботаСНоменклатурой.ОбновитьСодержаниеУслуг(АгентскиеУслуги, Дата);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПлательщикНДФЛ	= УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата);
	ПрименяетсяУСН 	= УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата);
	ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, Дата);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("Патент");
	
	// Реквизиты с проверкой по различным условиям
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.СтранаПроисхождения");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Субконто");

	ТребуетсяСчетРасходовПоОказаниюУслуг = РегистрыНакопления.РеализацияУслуг.ТребуетсяСчетРасходовПоОказаниюУслуг(Дата, Организация);
	
	СпособОценкиТоваровВРознице = УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата);
	УчетПоПродажнойСтоимости    = СпособОценкиТоваровВРознице = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
	
	ТипСклада	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");
	
	НТТПоПродажнойСтоимости = УчетПоПродажнойСтоимости
		И ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетНТТОПродажах;

	// Проверка: сумма безналичных оплат не должна превышать сумму по реализации товаров и услуг
	СуммаВыручки = Товары.Итог("Сумма") + ?(СуммаВключаетНДС, 0, Товары.Итог("СуммаНДС"))
		+ АгентскиеУслуги.Итог("Сумма") + ?(СуммаВключаетНДС, 0, АгентскиеУслуги.Итог("СуммаНДС"))
		+ ПодарочныеСертификаты.Итог("Сумма");
	
	Если Оплата.Итог("СуммаОплаты") > СуммаВыручки  Тогда
		
		ТекстОписаниеОшибки = НСтр("ru = 'Сумма безналичных оплат превышает сумму выручки от реализации!'");
		ТекстСообщения      = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Список", "Корректность",,, НСтр("ru = 'Безналичные оплаты'"), ТекстОписаниеОшибки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Оплата", "Объект", Отказ);
		
	КонецЕсли;
	
	Если ДеятельностьНаПатенте И Не ЗначениеЗаполнено(Патент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение",
			НСтр("ru = 'Доходы в НУ'"),,, ТекстСообщения);
		Поле = "ОтражениеДоходов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
	КонецЕсли;
	
	// Проверка ТЧ Товары

	МассивНоменклатуры     = Товары.ВыгрузитьКолонку("Номенклатура");
	РеквизитыНоменклатуры  = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивНоменклатуры, "Услуга");
	
	ПользовательУправляетСчетамиУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();

	ИменаПолей = Новый Структура;
	ИменаПолей.Вставить("Номенклатура", НСтр("ru = 'Номенклатура'"));
	ИменаПолей.Вставить("Количество", НСтр("ru = 'Количество'"));
	ИменаПолей.Вставить("СтранаПроисхождения", НСтр("ru = 'Страна происхождения'"));

	Для каждого СтрокаТаблицы Из Товары Цикл

		
		ЭтоУслуга = Ложь;
		СвойстваНоменклатуры = РеквизитыНоменклатуры[СтрокаТаблицы.Номенклатура];
		Если СвойстваНоменклатуры <> Неопределено Тогда
			ЭтоУслуга = СвойстваНоменклатуры.Услуга;
		КонецЕсли;
		
		Если НТТПоПродажнойСТоимости 
			И ЗначениеЗаполнено(СтрокаТаблицы.СчетУчета) 
			И ПользовательУправляетСчетамиУчета Тогда
			
			СвойстваСчетаУчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
			Если НЕ СвойстваСчетаУчета.Забалансовый Тогда
				ТекстОшибки = НСтр("ru = 'Продажи собственных товаров в НТТ при учете по продажной стоимости
				|должны отражаться документом ""Поступление наличных""!'");
				СообщитьОНекорректномЗначенииТаблицыТовары(СтрокаТаблицы.НомерСтроки, "Номенклатура", ИменаПолей.Номенклатура, ТекстОшибки, Отказ);
				МассивНепроверяемыхРеквизитов.Добавить("Товары.СчетУчета");
			КонецЕсли;
		КонецЕсли; 

		Если НЕ ЭтоУслуга И СтрокаТаблицы.Количество = 0 Тогда
				СообщитьОНезаполненномПолеТаблицыТовары(СтрокаТаблицы.НомерСтроки, "Количество", ИменаПолей.Количество, Отказ);
		КонецЕсли;
		
		// Проверка страны происхождения
		Если УчетТоваров.НеУказанаСтранаПроисхождения(СтрокаТаблицы.НомерГТД, СтрокаТаблицы.СтранаПроисхождения) Тогда
			СообщитьОНезаполненномПолеТаблицыТовары(СтрокаТаблицы.НомерСтроки, "СтранаПроисхождения", ИменаПолей.СтранаПроисхождения, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах 
		И (ПрименяетсяУСН ИЛИ ПрименяетсяУСНПатент)
		И ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Организация, Дата) Тогда
		
		// В режиме отложенного проведения для УСН и патента не поддерживается:
		// 1. работа с эквайрингом
		// 2. одновременная продажа и оплата собственными сертификатами, которые учитываются по разным договорам.

		МассивВидовОплат = ОбщегоНазначения.ВыгрузитьКолонку(ПодарочныеСертификаты, "ВидОплаты", Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			МассивВидовОплат, 
			ОбщегоНазначения.ВыгрузитьКолонку(Оплата, "ВидОплаты", Истина), 
			Истина);

		СведенияОВидахОплаты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
			МассивВидовОплат, "ТипОплаты, ДоговорКонтрагента");
		
		ДоговорыПоПроданнымСертификатам = Новый Соответствие;
		ДоговорыПоПринятымСертификатам	= Новый Соответствие;
		
		// Определяем различные договоры по проданным сертификатам.
		
		Для Каждого СтрокаТаблицы Из ПодарочныеСертификаты Цикл

			РеквизитыВидаОплаты = СведенияОВидахОплаты[СтрокаТаблицы.ВидОплаты];

			Если РеквизитыВидаОплаты = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если РеквизитыВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСобственный Тогда
				ДоговорыПоПроданнымСертификатам.Вставить(РеквизитыВидаОплаты.ДоговорКонтрагента, Истина);
			КонецЕсли;
			
		КонецЦикла;

		// Определяем различные договоры по принятым сертификатам.

		БылоСообщениеПроЭквайринг = Ложь;

		Для Каждого СтрокаТаблицы Из Оплата Цикл
		
			РеквизитыВидаОплаты = СведенияОВидахОплаты[СтрокаТаблицы.ВидОплаты];

			Если РеквизитыВидаОплаты = Неопределено Тогда
				Продолжить;
			КонецЕсли;

			Если РеквизитыВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПлатежнаяКарта
				ИЛИ РеквизитыВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.БанковскийКредит Тогда

				Если БылоСообщениеПроЭквайринг Тогда
					Продолжить;
				КонецЕсли;

				ТекстСообщения = НСтр("ru = 'В разделе ""Администрирование"" - ""Проведение документов"" установлен режим ""Расчеты выполняются при закрытии месяца"".
					|В этом случае для организаций, применяющих упрощенную или патентную систему налогообложения, не поддерживается оплата платежными картами и банковскими кредитами.'");
				ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Оплата", СтрокаТаблицы.НомерСтроки, "ВидОплаты");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПутьКТабличнойЧасти, "Объект", Отказ);
				
				БылоСообщениеПроЭквайринг = Истина;
				
			КонецЕсли;
			
			Если РеквизитыВидаОплаты.ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСобственный Тогда
				ДоговорыПоПринятымСертификатам.Вставить(РеквизитыВидаОплаты.ДоговорКонтрагента, Истина);
			КонецЕсли;
					
		КонецЦикла;
		
		Если ДоговорыПоПроданнымСертификатам.Количество() > 0
			И ДоговорыПоПринятымСертификатам.Количество() > 0 Тогда
			
			ДоговорыСовпадают = Ложь;

			Если ДоговорыПоПроданнымСертификатам.Количество() = 1 
				И ДоговорыПоПринятымСертификатам.Количество() = 1 Тогда
				Для Каждого КлючИЗначение Из ДоговорыПоПроданнымСертификатам Цикл
					Если ДоговорыПоПринятымСертификатам[КлючИЗначение.Ключ] <> Неопределено Тогда
						ДоговорыСовпадают = Истина;
					КонецЕсли;
				Конеццикла;
			КонецЕсли;
			
			Если НЕ ДоговорыСовпадают Тогда
				ТекстСообщения = НСтр("ru = 'В разделе ""Администрирование"" - ""Проведение документов"" установлен режим ""Расчеты выполняются при закрытии месяца"".
					|В этом случае для организаций, применяющих упрощенную или патентную систему налогообложения, 
					|документ ""Отчет о розничных продажах"" не поддерживает одновременно продажу и оплату cобственными подарочными сертификатами, которые учитываются на разных договорах.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПодарочныеСертификаты", "Объект", Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты) Тогда
		УчетДоходовИРасходовПредпринимателя.ПроверитьЗаполнениеСубконтоНоменклатурныеГруппы(
			ЭтотОбъект, 
			"СчетДоходов", 
			"Субконто", 
			НСтр("ru = 'Субконто'"), 
			"Товары", 
			НСтр("ru = 'Товары'"), 
			Отказ);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
	ИнтеграцияГИСМБП.УстановитьПризнакЕстьМаркируемаяПродукцияГИСМ(ЭтотОбъект);
	
	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Товары") 
		+ УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "АгентскиеУслуги")
		+ ПодарочныеСертификаты.Итог("Сумма");

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОтчетОРозничныхПродажах.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ

	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.Товары,
		ПараметрыПроведения.Реквизиты, Отказ);

	// Таблицы выручки от реализации: собственных товаров и услуг и отдельно комиссионных
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(ПараметрыПроведения.Реализация,
		Неопределено, ТаблицаСписанныеТовары, ПараметрыПроведения.Реквизиты, Отказ);

	ТаблицаТоварыУслугиКомитентов = ТаблицыРеализация.ТоварыУслугиКомитентов;
	
	// АТТ
	
	// Таблица проданных подарочных сертификатов с зачетом принятых ранее в оплату
	ПроданныеСертификатыВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.ВыручкаПоПодарочнымСертификатам, ПараметрыПроведения.Реквизиты, Отказ);
	
	// В безналичной оплате учтем взаиморасчеты по проданным ранее подарочным сертификатам
	БезналичныеОплатыВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовБезналичнаяРозничнаяВыручка(
		ПараметрыПроведения.БезналичныеОплаты,
		ПараметрыПроведения.РеквизитыБезналичныхОплат,
		Отказ);
	
	ТаблицыРаспределеннойВыручки = Документы.ОтчетОРозничныхПродажах.ПодготовитьТаблицыРаспределенияВыручкиПоОплатам(
		ПараметрыПроведения.ВыручкаДляРаспределенияОплатыУСН,
		БезналичныеОплатыВзаиморасчеты,
		ПроданныеСертификатыВзаиморасчеты,
		ПараметрыПроведения.Реквизиты,
		Отказ);
	
	ТаблицаБезналичныеОплаты    = ТаблицыРаспределеннойВыручки.БезналичныеОплаты;
	ТаблицаПроданныеСертификаты = ТаблицыРаспределеннойВыручки.ПроданныеСертификаты;
	ТаблицаНаличнаяОплата       = ТаблицыРаспределеннойВыручки.ТаблицаНаличнаяОплата;
	ТаблицаВыручкаУСН           = ТаблицыРаспределеннойВыручки.ТаблицаВыручка;
	
	ТаблицаПрочихРасчетовАТТ = Документы.ОтчетОРозничныхПродажах.ПодготовитьТаблицуПрочихРасчетовАТТ(
		ТаблицаБезналичныеОплаты,
		ПараметрыПроведения.РеквизитыБезналичныхОплат);
	
	// НТТ
	СтруктураТаблицВыручкиЗаМесяц = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиЗаМесяц(ПараметрыПроведения.РеквизитыВыручки, Отказ);
	
	// Сводная таблица выручки
	ТаблицаВыручкиЗаМесяц = СтруктураТаблицВыручкиЗаМесяц.ТаблицаВыручкиЗаМесяц;
	// Выручка по документам и отражению в НУ при УСН
	ТаблицаВыручкиПоДокументамПлатежа = СтруктураТаблицВыручкиЗаМесяц.ТаблицаВыручкиПоДокументамПлатежа;
	
	ТаблицыБезналичнойВыручкиНТТ = Документы.ОтчетОРозничныхПродажах.ПодготовитьСтруктуруТаблицБезналичнойВыручкиНТТ(
		ПараметрыПроведения.РеквизитыВыручки, ТаблицаВыручкиЗаМесяц, Отказ);
	
	ТаблицаПрочихРасчетовНТТ              = ТаблицыБезналичнойВыручкиНТТ.ТаблицаПрочихРасчетовНТТ;
	ТаблицаНеоплаченнойБезналичнойВыручки = ТаблицыБезналичнойВыручкиНТТ.ТаблицаНеоплаченнойБезналичнойВыручки;
	
	// Таблица оплаченной выручки за месяц при учете в НТТ в ценах продажи,
	ТаблицаОплаченнойВыручкиУСН = УчетДоходовРасходов.ПодготовитьТаблицуОплаченнойВыручкиЗаМесяц(
		ПараметрыПроведения.РеквизитыВыручки, ТаблицаВыручкиПоДокументамПлатежа, ТаблицаНеоплаченнойБезналичнойВыручки, Отказ);
		
	// Таблица для сторнирования ранее отраженной документами ПКО выручки НТТ при учете по продажной стоимости 
	// в случае реализации товаров комитента
	ТаблицаСторноВыручки = УчетДоходовРасходов.ПодготовитьТаблицуСторноВыручкиНТТ(ПараметрыПроведения.Выручка,
		ПараметрыПроведения.РеквизитыВыручки, ТаблицаВыручкиЗаМесяц, Отказ);
	ТаблицаСторноВыручкиНДС = Документы.ОтчетОРозничныхПродажах.ПодготовитьТаблицуНДСДокументаСторноВыручки(
		ТаблицаСторноВыручки, ПараметрыПроведения.РеквизитыВыручки, Ссылка);

	Документы.РеализацияТоваровУслуг.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура();
	СтруктураТаблицУСН.Вставить("ТаблицаТМЦ",               ТаблицаСписанныеТовары);      // Общ
	
	СтруктураТаблицУСН.Вставить("ПроданныеСертификаты",     ТаблицаПроданныеСертификаты); // АТТ
	СтруктураТаблицУСН.Вставить("БезналичныеОплаты",        ТаблицаБезналичныеОплаты);    // АТТ
	СтруктураТаблицУСН.Вставить("ТаблицаВыручка",           ТаблицаВыручкаУСН);           // АТТ
	
	СтруктураТаблицУСН.Вставить("ТаблицаРасчетов",          ТаблицаПрочихРасчетовНТТ);    // НТТ
	СтруктураТаблицУСН.Вставить("ТаблицаОплаченнойВыручки", ТаблицаОплаченнойВыручкиУСН); // НТТ в ценах продажи
	
	// Учет доходов и расходов ИП
	СписанныеМПЗ = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуСписанныеМПЗ(
		ТаблицаСписанныеТовары, ПараметрыПроведения.Реализация, ПараметрыПроведения.Реквизиты);
	
	ТаблицыСписанияТоваровИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицыСписанияМПЗ(
		СписанныеМПЗ, ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаОказаниеУслугИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОказаниеУслуг(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.Реквизиты);
	
	СтруктураТаблицИП = Документы.ОтчетОРозничныхПродажах.ПодготовитьСтруктуруТаблицИП(
		ПараметрыПроведения.ВыручкаДляРаспределенияОплатыИП, БезналичныеОплатыВзаиморасчеты, ПроданныеСертификатыВзаиморасчеты,
		ПараметрыПроведения.Реквизиты, ТаблицаВыручкиЗаМесяц);
	
	ТаблицаВзаиморасчетовИП = СтруктураТаблицИП.ТаблицаВзаиморасчетовИП;
	ТаблицаПрочихРасчетовИП = СтруктураТаблицИП.ТаблицаПрочихРасчетовИП;
	ТаблицаЗачтенныхОплатИП = СтруктураТаблицИП.ТаблицаЗачтенныхОплатИП;
	
	// Реализации, оплаченные проданными подарочными сертификатами
	ТаблицаОплаченныеПродажиИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОплатыПокупателя(
		ТаблицаЗачтенныхОплатИП, ПараметрыПроведения.Реквизиты);
	
	ТаблицаПрочихРасчетов = ТаблицаПрочихРасчетовНТТ.Скопировать();
	
	Если ЗначениеЗаполнено(ТаблицаПрочихРасчетовАТТ) Тогда
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПрочихРасчетовАТТ, ТаблицаПрочихРасчетов);
	КонецЕсли;
	Если ЗначениеЗаполнено(ТаблицаПрочихРасчетовИП) Тогда
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаПрочихРасчетовИП, ТаблицаПрочихРасчетов);
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	УчетТоваров.СформироватьДвиженияСписаниеТоваров(ТаблицаСписанныеТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетВзаиморасчетов.СформироватьДвиженияПоПрочимРасчетам(ТаблицаПрочихРасчетов, Движения, Отказ);
	
	Документы.ОтчетОРозничныхПродажах.СформироватьДвиженияПоСчетамУСН(ПараметрыПроведения.Реквизиты,
		ПараметрыПроведения.ВыручкаДляРаспределенияОплатыУСН, ТаблицаПрочихРасчетовНТТ, Движения, Отказ);

	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансовКомитентов(ТаблицыРеализация.ТоварыУслугиКомитентов,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияРеализация(ТаблицыРеализация.СобственныеТоварыУслуги,
		ТаблицыРеализация.ТоварыУслугиКомитентов, ТаблицыРеализация.РеализованныеТоварыКомитентов,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаТоваровВРознице(ПараметрыПроведения.Переоценка,
		ТаблицаСписанныеТовары, ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияРаспределениеРозничнойВыручки(ПараметрыПроведения.Выручка,
		ПараметрыПроведения.РеквизитыВыручки, ТаблицаВыручкиЗаМесяц, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияСторноРозничнойВыручки(ТаблицаСторноВыручки,
		ПараметрыПроведения.РеквизитыВыручки, Движения, Отказ);

	УчетВзаиморасчетов.СформироватьДвиженияПогашениеЗадолженности(
		ТаблицаПроданныеСертификаты,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);
	
	УчетВзаиморасчетов.СформироватьДвиженияПоступленияОтРозничныхПокупателей(ТаблицаБезналичныеОплаты,
		ТаблицаНаличнаяОплата, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	РегистрыНакопления.РеализацияУслуг.ДобавитьДвижения(
		Движения.РеализацияУслуг,
		ПараметрыПроведения.ТаблицаРеализацияУслуг,
		Неопределено, // Не надо пересчитывать по курсу аванса
		ПараметрыПроведения.Реквизиты);
		
	// Учет НДС
	УчетНДС.СформироватьДвиженияРеализацияТоваровУслуг(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.ТоварыНДС, ТаблицаСписанныеТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	// Сторнирование ранее начисленного НДС в НТТ при учете по продажной стоимости в случае реализации товаров комитента
	УчетНДС.СформироватьДвиженияРозничнаяВыручка(ТаблицаСторноВыручкиНДС, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетНДС.СформироватьДвиженияРеализацияКомиссионныхТоваров(
		ПараметрыПроведения.НДСТоварыНаКомиссииРеализация,
		ТаблицаТоварыУслугиКомитентов,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	// Учет доходов и расходов ИП
	ТаблицаИПМПЗОтгруженные	= УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияСписаниеМПЗ(
		ТаблицыСписанияТоваровИП,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	ТаблицаИПМПЗОтгруженныеУслуги	= УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОказаниеУслуг(
		ТаблицаОказаниеУслугИП,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаИПМПЗОтгруженныеУслуги, ТаблицаИПМПЗОтгруженные);
		
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияЗачетОплатыПокупателя(
		ТаблицаИПМПЗОтгруженные,
		ТаблицаВзаиморасчетовИП, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОплатаПокупателя(
		ТаблицаОплаченныеПродажиИП,
		ПараметрыПроведения.Реквизиты,
		Движения, Отказ);
	
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);

	// Регистрация в последовательности
	Документы.ОтчетОРозничныхПродажах.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект,
		ПараметрыПроведения,
		ТаблицаСписанныеТовары,
		Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


Процедура СообщитьОНезаполненномПолеТаблицыТовары(НомерСтроки, ИмяПоля, ЗначениеПоля, Отказ)

	ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Заполнение",
		ЗначениеПоля, НомерСтроки, НСтр("ru = 'Товары'"));

	Поле = "Товары[" + Формат(НомерСтроки - 1, "ЧН=0; ЧГ=") + "]." + ИмяПоля;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);

КонецПроцедуры

Процедура СообщитьОНекорректномЗначенииТаблицыТовары(НомерСтроки, ИмяПоля, ЗначениеПоля, ТекстОшибки, Отказ)

	ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
		ЗначениеПоля, НомерСтроки, НСтр("ru = 'Товары'"), ТекстОшибки);

	Поле = "Товары[" + Формат(НомерСтроки - 1, "ЧН=0; ЧГ=") + "]." + ИмяПоля;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);

КонецПроцедуры
 
// Заполнение документа по инвентаризации товаров на розничном складе
//
Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ИнвентаризацияТоваровНаСкладе") Тогда

		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание, "Организация,Склад");

		ИнвентаризацияТоваровНаСкладе = Основание;
		
		РеквизитыСклада = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Склад, "ТипЦенРозничнойТорговли, ТипСклада");

		Если ЗначениеЗаполнено(РеквизитыСклада.ТипЦенРозничнойТорговли) Тогда
			ТипЦен = РеквизитыСклада.ТипЦенРозничнойТорговли;
		КонецЕсли;

		СуммаВключаетНДС = Истина;

		Если РеквизитыСклада.ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
			ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетНТТОПродажах;
		КонецЕсли;

		// Заполнение ТЧ Товары
		Документы.ОтчетОРозничныхПродажах.ЗаполнитьТоварыПоИнвентаризацииТоваров(ЭтотОбъект, Основание);

	КонецЕсли;

КонецПроцедуры

#КонецЕсли
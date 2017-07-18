﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ТребованиеНакладная") Тогда

		Если Основание.МатериалыЗаказчика.Количество() = 0  Тогда
			ТекстСообщения = НСтр("ru = 'Требование накладная №%1 не отражает перемещение давальческого сырья в производство'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Основание.Номер);
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;

		СуммаВключаетНДС = Истина;

		Для Каждого СтрокаОснование ИЗ Основание.МатериалыЗаказчика Цикл

			Строка = МатериалыЗаказчика.Добавить();
			Строка.Номенклатура = СтрокаОснование.Номенклатура;
			Строка.СчетУчета    = СтрокаОснование.СчетПередачи;
			Строка.Количество   = СтрокаОснование.Количество;

		КонецЦикла;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда

		СуммаВключаетНДС = Истина;
		УслугиПоДаннымОВыпускеПродукции = Документы.РеализацияУслугПоПереработке.УслугиПоДаннымОВыпускеПродукции(ЭтотОбъект, Основание);
		Услуги.Загрузить(УслугиПоДаннымОВыпускеПродукции);
		
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьСубконто(СтрокаТабличнойЧасти)	Экспорт

	ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТабличнойЧасти.СчетДоходов);

	Если ДанныеСчета.КоличествоСубконто > 0 Тогда
		СтрокаТабличнойЧасти.Субконто = Новый(ДанныеСчета.ВидСубконто1.ТипЗначения.Типы()[0]);
		Если ТипЗнч(СтрокаТабличнойЧасти.Субконто) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда
			СтрокаТабличнойЧасти.Субконто = СтрокаТабличнойЧасти.Номенклатура.НоменклатурнаяГруппа;
		КонецЕсли;
	Иначе
		СтрокаТабличнойЧасти.Субконто = Неопределено;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов)

	Запрос = Новый Запрос;
	СчетаВыручкиЕНВД  = БухгалтерскийУчетПовтИсп.СчетаВыручкиЕНВД();
	СчетаРасходовЕНВД = БухгалтерскийУчетПовтИсп.СчетаРасходовЕНВД();
	СчетаВыручкиИРасходовЕНВД = ОбщегоНазначенияБПВызовСервера.ПолучитьКопиюКоллекции(СчетаВыручкиЕНВД);
	Для Каждого СчетРасхода Из СчетаРасходовЕНВД Цикл
		СчетаВыручкиИРасходовЕНВД.Добавить(СчетРасхода);
	КонецЦикла;
	Запрос.УстановитьПараметр("СчетаЕНВД", СчетаВыручкиИРасходовЕНВД);

	Запрос.Текст = "";

	Если Услуги.Количество() > 0 Тогда
		Запрос.УстановитьПараметр("ТаблицаУслуги", Услуги.Выгрузить());

		СтруктураРезультатов.Вставить("ТаблицаУслуги", СтруктураРезультатов.Количество());
		СтруктураРезультатов.Вставить("Услуги", СтруктураРезультатов.Количество());

		Запрос.Текст = Запрос.Текст +
		"ВЫБРАТЬ
		|	ВремТаблица.НомерСтроки,
		|	ВремТаблица.Номенклатура,
		|	ВремТаблица.Содержание,
		|	ВремТаблица.Количество,
		|	ВремТаблица.Сумма,
		|	ВремТаблица.СтавкаНДС,
		|	ВремТаблица.СуммаНДС,
		|	ВремТаблица.СчетУчетаНДСПоРеализации,
		|	ВремТаблица.СчетУчета,
		|	ВремТаблица.СчетДоходов,
		|	ВремТаблица.Субконто,
		|	ВремТаблица.СчетРасходов КАК СчетРасходов
		|ПОМЕСТИТЬ ТаблицаУслуги
		|ИЗ
		|	&ТаблицаУслуги КАК ВремТаблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДокумента.НомерСтроки,
		|	ТаблицаДокумента.Номенклатура,
		|	ТаблицаДокумента.Количество,
		|	ТаблицаДокумента.Сумма,
		|	ТаблицаДокумента.СтавкаНДС,
		|	ТаблицаДокумента.СуммаНДС,
		|	ТаблицаДокумента.СчетУчета,
		|	ЕСТЬNULL(ТаблицаДокумента.СчетУчета.Забалансовый, ЛОЖЬ) КАК СчетУчетаЗабалансовый,
		|	ТаблицаДокумента.СчетДоходов,
		|	ЕСТЬNULL(ТаблицаДокумента.СчетДоходов.Забалансовый, ЛОЖЬ) КАК СчетДоходовЗабалансовый,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.СчетДоходов В (&СчетаЕНВД)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК СчетДоходовЕНВД,
		|	ТаблицаДокумента.Субконто,
		|	ТаблицаДокумента.СчетУчетаНДСПоРеализации,
		|	ЕСТЬNULL(ТаблицаДокумента.СчетУчетаНДСПоРеализации.Забалансовый, ЛОЖЬ) КАК СчетУчетаНДСПоРеализацииЗабалансовый,
		|	ТаблицаДокумента.СчетРасходов,
		|	ЕСТЬNULL(ТаблицаДокумента.СчетРасходов.Забалансовый, ЛОЖЬ) КАК СчетРасходовЗабалансовый,
		|	ВЫБОР
		|		КОГДА ТаблицаДокумента.СчетРасходов В (&СчетаЕНВД)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК СчетРасходовЕНВД
		|ИЗ
		|	ТаблицаУслуги КАК ТаблицаДокумента
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаДокумента.НомерСтроки";
	КонецЕсли;

	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		Возврат Запрос.ВыполнитьПакет();
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура")
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	Иначе
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент)
		И (ЗначениеЗаполнено(ДоговорКонтрагента) ИЛИ НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам")) Тогда
		Документы.РеализацияУслугПоПереработке.ЗаполнитьСчетаУчетаРасчетов(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

	ЗачетАвансов.Очистить();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Документ, который не сделает проводок, считаем некорректно заполненным.
	// Следует заполнить данные в любой из табличных частей.
	// Использование материалов может быть отражено отдельно от реализации услуг.
	// В этом случае использование материалов отражается документом 
	// "Реализация услуг по переработке" с незаполненной табличной частью "Услуги".
	ОбщегоНазначенияБП.ИсключитьИзПроверкиОсновныеТабличныеЧасти(
		ЭтотОбъект, 
		"Услуги,МатериалыЗаказчика",
		ПроверяемыеРеквизиты);
	
	МассивНепроверяемыхРеквизитов = Новый Массив();

	ОтражатьВНалоговомУчете = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, Дата);
	ВестиУчетПоДоговорам    = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
	ЭтоКомиссия             = ВестиУчетПоДоговорам И ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	
	ПлательщикНДФЛ	= УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата);
	
	Если НЕ ВестиУчетПоДоговорам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	// В формах документа счет расчетов и счет авансов редактируются в специальной форме.
	// В случае, если они не заполнены, покажем сообщение возле соответствующей гиперссылки.
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовПоАвансам");

	Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
			НСтр("ru = 'Счет учета расчетов с контрагентом'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
			"ПорядокУчетаРасчетов", Отказ);
	КонецЕсли;

	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.НеЗачитывать Тогда
		Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовПоАвансам) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
				НСтр("ru = 'Счет учета расчетов по авансам'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
				"ПорядокУчетаРасчетов", Отказ);
		КонецЕсли;
	КонецЕсли;

	// Исключаем из проверки те реквизиты табличных частей, обязательность которых
	//	зависит от значений других рекивизитов в строках табличных частей:
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.Субконто");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.СтавкаНДС");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетУчетаНДСПоРеализации");

	// Получаем содержимое табличных частей объекта с вспомогательными реквизитами:
	СтруктураРезультатов = Новый Структура;
	ТаблицыДокумента = ПолучитьДанныеОбъектаДляПроверкиЗаполнения(СтруктураРезультатов);

	// Проверяем табличную часть "Товары":
	Если Услуги.Количество() > 0 Тогда

		ВыборкаУслуги = ТаблицыДокумента[СтруктураРезультатов.Услуги].Выбрать();
		ИмяСписка = НСтр("ru = 'Услуги'");
		Пока ВыборкаУслуги.Следующий() Цикл

			Префикс = "Услуги[" + Формат(ВыборкаУслуги.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";

			// Проверка заполнения счетов в зависимости от "забалансовости"...
			Если НЕ ЭтоКомиссия И НЕ ВыборкаУслуги.СчетУчетаЗабалансовый Тогда

				Если ВыборкаУслуги.СуммаНДС <> 0 И НЕ ЗначениеЗаполнено(ВыборкаУслуги.СчетУчетаНДСПоРеализации) Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет учета НДС по реализации'"),
						ВыборкаУслуги.НомерСтроки, ИмяСписка);
					Поле = Префикс + "СчетУчетаНДСПоРеализации";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;

				Если НЕ ЗначениеЗаполнено(ВыборкаУслуги.СчетДоходов) Тогда
					ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Счет доходов'"),
						ВыборкаУслуги.НомерСтроки, ИмяСписка);
					Поле = Префикс + "СчетДоходов";
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
				КонецЕсли;

			КонецЕсли;

			// Проверка на соответствие видов деятельности
			Если ЗначениеЗаполнено(ВыборкаУслуги.СчетДоходов) И ЗначениеЗаполнено(ВыборкаУслуги.СчетРасходов)
				И ВыборкаУслуги.СчетДоходовЕНВД <> ВыборкаУслуги.СчетРасходовЕНВД Тогда
				ТекстСообщения = НСтр("ru = 'Счета доходов и расходов для бухгалтерского учета относятся к разным видам деятельности.'");
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка", "Корректность",
					НСтр("ru = 'Счет доходов'"), ВыборкаУслуги.НомерСтроки, ИмяСписка, ТекстСообщения);
				Поле = Префикс + "СчетДоходов";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;

		КонецЦикла;
		
		Если ПлательщикНДФЛ Тогда
			
			УчетДоходовИРасходовПредпринимателя.ПроверитьЗаполнениеСубконтоНоменклатурныеГруппы(
				ЭтотОбъект, "СчетДоходов", "Субконто", НСтр("ru = 'Субконто'"), "Услуги", НСтр("ru = 'Продукция (услуги по переработке)'"), Отказ);
			
		КонецЕсли;

	КонецЕсли;

	// Табличная часть "Зачет авансов"
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	ИначеЕсли ЗачетАвансов.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки с документом аванса!'");
		Поле = "ПорядокУчетаРасчетов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
	КонецЕсли;

	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");

	УчетНДСПереопределяемый.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураВыданный");

	Документы.КорректировкаРеализации.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
	
		УчетНДСПереопределяемый.ПроверитьСоответствиеРеквизитовСчетаФактурыВыданного(ЭтотОбъект);		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.РеализацияУслугПоПереработке.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	// Таблица списанных товаров
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ПараметрыПроведения.СписаниеМатериаловТаблица,
		ПараметрыПроведения.СписаниеМатериаловРеквизиты, Отказ);

	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовТаблицаАвансов,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);

	// Таблицы выручки от реализации: собственных товаров и услуг и отдельно комиссионных
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, 
		ТаблицаВзаиморасчеты, 
		ТаблицаСписанныеТовары,
		ПараметрыПроведения.РеализацияРеквизиты, 
		Отказ);

	ТаблицаСобственныеТоварыУслуги = ТаблицыРеализация.СобственныеТоварыУслуги;
	ТаблицаТоварыУслугиКомитентов  = ТаблицыРеализация.ТоварыУслугиКомитентов;
	ТаблицаРеализованныеТоварыКомитентов = ТаблицыРеализация.РеализованныеТоварыКомитентов;
	Документы.РеализацияУслугПоПереработке.ДобавитьКолонкуСодержание(ТаблицыРеализация.СобственныеТоварыУслуги);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов", ТаблицаВзаиморасчеты);
	
	// Учет доходов и расходов ИП
	ТаблицаОказаниеУслугИП	= УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОказаниеУслуг(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.РеализацияРеквизиты);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(
		ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, 
		Движения, 
		Отказ);

	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицаСобственныеТоварыУслуги, 
		ТаблицаТоварыУслугиКомитентов, 
		ТаблицаРеализованныеТоварыКомитентов,
		ПараметрыПроведения.РеализацияРеквизиты, 
		Движения, 
		Отказ);

	УчетПроизводства.СформироватьДвиженияПлановаяСтоимостьУслугПоПереработке(
		ПараметрыПроведения.ПлановаяСебестоимостьТаблица,
		ПараметрыПроведения.ПлановаяСебестоимостьРеквизиты, 
		Движения, 
		Отказ);

	УчетТоваров.СформироватьДвиженияСписаниеТоваров(
		ТаблицаСписанныеТовары,
		ПараметрыПроведения.СписаниеМатериаловРеквизиты, 
		Движения, 
		Отказ);

	УчетНДС.СформироватьДвиженияРеализацияТоваровУслуг(
		ТаблицаСобственныеТоварыУслуги, 
		Неопределено, 
		Неопределено, 
		ПараметрыПроведения.РеализацияРеквизиты,
		Движения, 
		Отказ);
		
	//Движения регистра "Рублевые суммы документов в валюте"
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ТаблицаСобственныеТоварыУслуги, 
		ПараметрыПроведения.РеализацияРеквизиты, Движения, Отказ);
		
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	// Учет доходов и расходов ИП
	ТаблицаИПМПЗОтгруженные	= УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОказаниеУслуг(
		ТаблицаОказаниеУслугИП,
		ПараметрыПроведения.РеализацияРеквизиты, Движения, Отказ);
		
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияЗачетОплатыПокупателя(
		ТаблицаИПМПЗОтгруженные,
		ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.РеализацияРеквизиты, Движения, Отказ);
		
	// ПЕРЕОЦЕНКА ВАЛЮТНЫХ ОСТАТКОВ
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);

	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.ПереоценкаВалютныхОстатковРеквизиты, Движения, Отказ);
		
	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);

	// Регистрация в последовательности
	ТаблицаРегистрации = РаботаСПоследовательностями.ПодготовитьТаблицуСчетовТоваровДляАнализа(
		ТаблицаСписанныеТовары, ТаблицыРеализация.СобственныеТоварыУслуги);
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(ЭтотОбъект, Отказ,
		ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение, ТаблицаРегистрации);
		
	Движения.Записать();
	УчетНДСПереопределяемый.УстановкаПроведенияУСчетаФактуры(Ссылка, "СчетФактураВыданный", Истина, Отказ,
		ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект));
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	УчетНДСПереопределяемый.УстановкаПроведенияУСчетаФактуры(Ссылка, "СчетФактураВыданный", Ложь, Отказ);
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры


#КонецЕсли
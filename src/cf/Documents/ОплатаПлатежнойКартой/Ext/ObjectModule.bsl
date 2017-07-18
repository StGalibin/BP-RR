﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Проверяет установленные курсы валют документа перед пересчетом сумм
// Нулевые курсы устанавливаются в 1
//
Процедура ПроверкаКурсовВалют(СтрокаПлатежа) Экспорт

	КурсДокумента      = ?(КурсДокумента      = 0, 1, КурсДокумента);
	КратностьДокумента = ?(КратностьДокумента = 0, 1, КратностьДокумента);

	Если Не СтрокаПлатежа = Неопределено Тогда
		СтрокаПлатежа.КурсВзаиморасчетов      = ?(СтрокаПлатежа.КурсВзаиморасчетов      = 0, 1, СтрокаПлатежа.КурсВзаиморасчетов);
		СтрокаПлатежа.КратностьВзаиморасчетов = ?(СтрокаПлатежа.КратностьВзаиморасчетов = 0, 1, СтрокаПлатежа.КратностьВзаиморасчетов);

	КонецЕсли;

КонецПроцедуры // ПроверкаКурсовВалют()

// Пересчитывает сумму НДС
//
// Параметры:
//  Нет.
//
Процедура ПересчитатьСуммуНДС(СтрокаПлатежа) Экспорт

	ЗначениеСтавкиНДС     = УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаПлатежа.СтавкаНДС);

	СтрокаПлатежа.СуммаНДС = СтрокаПлатежа.СуммаПлатежа * ЗначениеСтавкиНДС / (100 + ЗначениеСтавкиНДС);

КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(Основание)
	
	// Заполнение реквизитов из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ВалютаДокумента = ВалютаРегламентированногоУчета;
	КурсДокумента      = 1;
	КратностьДокумента = 1;
	
	ВидДокументаОснования = ТипЗнч(Основание);
	
	ДокументОснование = Основание;
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
	
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента,
			|СчетУчетаРасчетовПоАвансам,
			|СчетУчетаРасчетовСКонтрагентом,
			|Организация");
			
	ИначеЕсли ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда 
			
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента, 
			|ВидОплаты, Эквайер, ДоговорЭквайринга");
			
	Иначе
			
		СтруктураОснование = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание,
			"Контрагент, ДоговорКонтрагента, 
			|Организация, Дата");
			
	КонецЕсли;
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") 
		ИЛИ ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю;
	Иначе
		ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя;
	КонецЕсли;
	
	Контрагент            = СтруктураОснование.Контрагент;
	ДоговорКонтрагента    = СтруктураОснование.ДоговорКонтрагента;
	
	ВалютаВзаиморасчетов = ДоговорКонтрагента.ВалютаВзаиморасчетов;
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, Дата);
	
	Если ВидДокументаОснования = Тип("ДокументСсылка.ОплатаПлатежнойКартой") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураОснование, "ВидОплаты, Эквайер, ДоговорЭквайринга");
		ТаблицаПлатежей = ДокументОснование.РасшифровкаПлатежа.Выгрузить();
		ТаблицаПлатежей.ЗаполнитьЗначения(Неопределено, "СчетНаОплату");
	Иначе
		ТаблицаПлатежей = РасшифровкаПлатежа.ВыгрузитьКолонки();
		Если ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			СтруктураОснование.Вставить("Основание",     Основание);
			СтруктураОснование.Вставить("ДатаОснования", СтруктураОснование.Дата);
			ТаблицаСуммОснования = СтатусыДокументов.ТаблицаСуммКОплатеВРазрезеСтавокНДС(
				СтруктураОснование,
				УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание));
		Иначе
			ТаблицаСуммОснования = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДСВРазрезеСтавокНДС(Основание);
		КонецЕсли;
		
		ТаблицаСуммОснования.Колонки.Сумма.Имя = "СуммаПлатежа";
		
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаСуммОснования, ТаблицаПлатежей);
		
		Если ТаблицаПлатежей.Количество() = 0 Тогда
			ТаблицаПлатежей.Добавить();
		КонецЕсли;
		ТаблицаПлатежей.ЗаполнитьЗначения(ДоговорКонтрагента,                     "ДоговорКонтрагента");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Курс,      "КурсВзаиморасчетов");
		ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураКурсаВзаиморасчетов.Кратность, "КратностьВзаиморасчетов");
		Если ВидДокументаОснования <> Тип("ДокументСсылка.СчетНаОплатуПокупателю")
			И ПолучитьФункциональнуюОпцию("УправлениеЗачетомАвансовПогашениемЗадолженности") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.ПоДокументу, "СпособПогашенияЗадолженности");
		Иначе
			ТаблицаПлатежей.ЗаполнитьЗначения(Перечисления.СпособыПогашенияЗадолженности.Автоматически, "СпособПогашенияЗадолженности");
		КонецЕсли;
		ТаблицаПлатежей.ЗаполнитьЗначения(Основание,"Сделка");

		ТаблицаПлатежей.ЗагрузитьКолонку(ТаблицаПлатежей.ВыгрузитьКолонку("СуммаПлатежа"), "СуммаВзаиморасчетов");

		Для каждого СтрокаПлатежа Из ТаблицаПлатежей Цикл
			ПроверкаКурсовВалют(СтрокаПлатежа);
			Если ДоговорКонтрагента.РасчетыВУсловныхЕдиницах Тогда
				Если Основание.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
					СтрокаПлатежа.СуммаВзаиморасчетов = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаПлатежа,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
					СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
						СтрокаПлатежа.СуммаНДС,
						ВалютаРегламентированногоУчета, ВалютаВзаиморасчетов,
						1, Основание.КурсВзаиморасчетов,
						1, Основание.КратностьВзаиморасчетов);
				КонецЕсли;
				
				СтрокаПлатежа.СуммаПлатежа = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаВзаиморасчетов,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
				СтрокаПлатежа.СуммаНДС = РаботаСКурсамиВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(
					СтрокаПлатежа.СуммаНДС,
					ВалютаВзаиморасчетов, ВалютаРегламентированногоУчета,
					СтрокаПлатежа.КурсВзаиморасчетов, 1,
					СтрокаПлатежа.КратностьВзаиморасчетов, 1);
			КонецЕсли;
		КонецЦикла;

		Если НЕ ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураОснование.СчетУчетаРасчетовПоАвансам,     "СчетУчетаРасчетовПоАвансам");
			ТаблицаПлатежей.ЗаполнитьЗначения(СтруктураОснование.СчетУчетаРасчетовСКонтрагентом, "СчетУчетаРасчетовСКонтрагентом");
		КонецЕсли;
		Если ТаблицаПлатежей.Количество() > 0 И НЕ ЗначениеЗаполнено(ТаблицаПлатежей[0].СчетУчетаРасчетовСКонтрагентом) Тогда
			СчетаУчета = БухгалтерскийУчетПереопределяемый.ПолучитьСчетаРасчетовСКонтрагентом(
				СтруктураОснование.Организация, Контрагент, ДоговорКонтрагента);
			ТаблицаПлатежей.ЗаполнитьЗначения(СчетаУчета.СчетАвансовПокупателя, "СчетУчетаРасчетовПоАвансам");
			ТаблицаПлатежей.ЗаполнитьЗначения(СчетаУчета.СчетРасчетовПокупателя, "СчетУчетаРасчетовСКонтрагентом");
		КонецЕсли;
		
		Если ВидДокументаОснования = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда
			ТаблицаПлатежей.ЗаполнитьЗначения(Основание, "СчетНаОплату");
		КонецЕсли;
		
	КонецЕсли;
	
	РасшифровкаПлатежа.Загрузить(ТаблицаПлатежей);
	
	СуммаДокумента = РасшифровкаПлатежа.Итог("СуммаПлатежа");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.РозничнаяВыручка Тогда
		ОграничениеТипаКонтрагента = Новый ОписаниеТипов("СправочникСсылка.Склады");
	КонецЕсли;
	
	Контрагент = ОграничениеТипаКонтрагента.ПривестиЗначение(Контрагент);
	
	ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ЭтотОбъект);
	НалоговыйУчетУСН.ЗаполнитьОтражениеДокументаВУСН(ЭтотОбъект, ПараметрыУСН);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	УчетПоПродажнойСтоимости =
		УчетнаяПолитика.СпособОценкиТоваровВРознице(Организация, Дата) = Перечисления.СпособыОценкиТоваровВРознице.ПоПродажнойСтоимости;
		
	ЕстьРасчетыСПокупателями = (ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя 
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю);
	
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.Сделка");              // Проверяем построчно
	МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов"); // Проверяем построчно
	
	Если ЕстьРасчетыСПокупателями Тогда
		
		Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
			МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
		КонецЕсли;
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом"); // Проверяем построчно
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СтавкаНДС");
		
		МассивНепроверяемыхРеквизитов.Добавить("Патент");
	КонецЕсли;
	
	Если ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.РозничнаяВыручка Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СпособПогашенияЗадолженности");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СуммаВзаиморасчетов");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентом");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовПоАвансам");
		
		Если НЕ УчетПоПродажнойСтоимости Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Патент");
			МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СтавкаНДС");
		КонецЕсли;
		
		Если НЕ ДеятельностьНаПатенте Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Патент");
		КонецЕсли;
	КонецЕсли;
	
	// Проверка соответствия суммы документа расшифровке платежа
	
	Если РасшифровкаПлатежа.Итог("СуммаПлатежа") <> СуммаДокумента Тогда
		ТекстСообщения = НСтр("ru = 'Не совпадают сумма документа и ее расшифровка'");
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Корректность", НСтр("ru = 'Сумма документа'"),,, ТекстСообщения); 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаДокумента", "Объект", Отказ);
	КонецЕсли;
	
	// Построчная проверка заполнения отдельных реквизитов ТЧ РасшифровкаПлатежа
	
	ПрименяетсяУСН = УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата);
	ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатент(Организация, Дата);
		
	ШаблонТекстаСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
		"Колонка", "Заполнение", "%1", "%2", НСтр("ru='Расшифровка платежа'"));
		
	ПредыдущийПатент = Неопределено;
		
	Для Каждого СтрокаПлатежа Из РасшифровкаПлатежа Цикл
	
		Если ЗначениеЗаполнено(СтрокаПлатежа.ДоговорКонтрагента) 
			И (СтрокаПлатежа.СуммаПлатежа > 0)
			И (СтрокаПлатежа.СуммаВзаиморасчетов = 0) Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НСтр("ru = 'Сумма расчетов'"), СтрокаПлатежа.НомерСтроки);
			Поле = "РасшифровкаПлатежа[" + Формат((СтрокаПлатежа.НомерСтроки-1), "ЧН=0; ЧГ=") + "].СуммаВзаиморасчетов";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
		Если ЕстьРасчетыСПокупателями
			И СтрокаПлатежа.СпособПогашенияЗадолженности = Перечисления.СпособыПогашенияЗадолженности.ПоДокументу
			И НЕ ЗначениеЗаполнено(СтрокаПлатежа.Сделка) Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НСтр("ru = 'Документ расчетов'"), СтрокаПлатежа.НомерСтроки);
			Поле = "РасшифровкаПлатежа[" + Формат((СтрокаПлатежа.НомерСтроки-1), "ЧН=0; ЧГ=") + "].Сделка";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
	
		Если ЕстьРасчетыСПокупателями
			И СтрокаПлатежа.СпособПогашенияЗадолженности <> Перечисления.СпособыПогашенияЗадолженности.НеПогашать
			И НЕ ЗначениеЗаполнено(СтрокаПлатежа.СчетУчетаРасчетовСКонтрагентом) Тогда
		
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонТекстаСообщения, НСтр("ru = 'Счет расчетов'"), СтрокаПлатежа.НомерСтроки);
			Поле = "РасшифровкаПлатежа[" + Формат((СтрокаПлатежа.НомерСтроки-1), "ЧН=0; ЧГ=") + "].СчетУчетаРасчетовСКонтрагентом";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		
		КонецЕсли;
		
	КонецЦикла;
	
	// В режиме отложенного проведения для организаций на УСН не поддерживаются операции по эквайрингу.
	Если (ПрименяетсяУСН ИЛИ ПрименяетсяУСНПатент)
		И ПроведениеСервер.ИспользуетсяОтложенноеПроведение(Организация, Дата) Тогда
		ТекстСообщения = НСтр("ru = 'В разделе ""Администрирование"" - ""Проведение документов"" установлен режим ""Расчеты выполняются при закрытии месяца"".
			|В этом случае для организаций, применяющих упрощенную или патентную систему налогообложения, не поддерживается оплата платежной картой.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Объект", "Организация", Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыУСН = УчетУСН.СтруктураПараметровОбъектаДляУСН(ЭтотОбъект);
	НалоговыйУчетУСН.ЗаполнитьДоходыРасходыВсего(ЭтотОбъект, ПараметрыУСН);
	
	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если (ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ОплатаПокупателя
		ИЛИ ВидОперации = Перечисления.ВидыОперацийОплатаПлатежнойКартой.ВозвратПокупателю)
		И РасшифровкаПлатежа.Количество() > 0 Тогда
		РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорВТабличнойЧастиПередЗаписью(РасшифровкаПлатежа, ЭтотОбъект);
		ДоговорКонтрагента = РасшифровкаПлатежа[0].ДоговорКонтрагента;
	Иначе
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ОплатаПлатежнойКартой.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.РасшифровкаПлатежа, ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаСуммовыхРазниц = УчетНДС.ПодготовитьТаблицуСуммовыхРазниц(ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.Реквизиты, Отказ);
		
	ТаблицаПрочихРасчетовУСН	= Документы.ОплатаПлатежнойКартой.ПодготовитьТаблицуПрочиеРасчетыУСН(
		ПараметрыПроведения.Реквизиты, ТаблицаВзаиморасчеты, Отказ);
	
	ТаблицаПрочихРасчетовИП		= Документы.ОплатаПлатежнойКартой.ПодготовитьТаблицуПрочиеРасчетыИП(
		ПараметрыПроведения.Реквизиты, ТаблицаВзаиморасчеты, Отказ);
		
	ЕдинаяТаблицаДляРегистраПрочихРасчетов = ТаблицаПрочихРасчетовУСН.Скопировать();
	
	ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(
		ТаблицаПрочихРасчетовИП, 
		ЕдинаяТаблицаДляРегистраПрочихРасчетов);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		ТаблицаСтатусовСчетов = СтатусыДокументов.ПодготовитьТаблицуСтатусовОплатыСчетов(
			ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты);
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетВзаиморасчетов.СформироватьДвиженияПоПрочимРасчетам(
			ЕдинаяТаблицаДляРегистраПрочихРасчетов, 
			Движения, 
			Отказ);
	
	УчетВзаиморасчетов.СформироватьДвиженияПогашениеЗадолженности(ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРозничнаяВыручкаОплатаПлатежнойКартой(ПараметрыПроведения.РозничнаяВыручка, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияСуммовыеРазницыРасчетыВУЕ(ТаблицаСуммовыхРазниц, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	Документы.ОплатаПлатежнойКартой.ОтразитьЗадолженностьПоСчетамУСН(ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияКурсовыеРазницы(ПараметрыПроведения.Реквизиты, 
		ТаблицаВзаиморасчеты, Движения, Отказ);
	
	УчетНДС.СформироватьДвиженияСуммовыеРазницы(ТаблицаСуммовыхРазниц, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);	
	
	УчетНДС.СформироватьДвиженияРозничнаяВыручка(ПараметрыПроведения.РозничнаяВыручкаНДС, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетУСН.СформироватьДвиженияКнигаУчетаДоходовИРасходов(ПараметрыПроведения.ТаблицаКУДиР, Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	СтатусыДокументов.СформироватьДвиженияОплатаСчетов(
		ПараметрыПроведения.ОплатаСчетов, ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	Если Не ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		СтатусыДокументов.СформироватьДвиженияСтатусовДокументов(
			ТаблицаСтатусовСчетов, ПараметрыПроведения.Реквизиты);
	КонецЕсли;

	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);

	// Регистрация в последовательности
	Документы.ОплатаПлатежнойКартой.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, ПараметрыПроведения, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный     = Пользователи.ТекущийПользователь();
	ДокументОснование = Неопределено;
	НомерЧекаККМ      = 0;
	
	НалоговыйУчетУСН.ПриКопированииДокумента(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецЕсли
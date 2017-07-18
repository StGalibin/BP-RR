﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьСтавки2017() Экспорт
	
	УдалитьСтавки();
	
	ОбновитьСтавки(2015);
	ОбновитьСтавки(2016);
	ОбновитьСтавки(2017);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьСтавки(Год)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РаботаВЛокальномРежиме = ПолучитьФункциональнуюОпцию("РаботаВЛокальномРежиме");
	
	Если РаботаВЛокальномРежиме Тогда
		
		НачалоПериода = Дата(Год, 1, 1);
		КонецПериода = Дата(Год, 12, ?(Год < 2016, 31, 15), 23, 59, 59);
		КонецПрошлогоПериода = ?(Год < 2016, НачалоПериода - 1, КонецПериода);
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("КонецПрошлогоПериода", КонецПрошлогоПериода);
		Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
		Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрацияТранспортныхСредствСрезПоследних.Период КАК Период,
		|	РегистрацияТранспортныхСредствСрезПоследних.Организация КАК Организация,
		|	РегистрацияТранспортныхСредствСрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_РегистрацииНаКонецПрошлогоПериода
		|ИЗ
		|	РегистрСведений.РегистрацияТранспортныхСредств.СрезПоследних(&КонецПрошлогоПериода, ) КАК РегистрацияТранспортныхСредствСрезПоследних
		|ГДЕ
		|	РегистрацияТранспортныхСредствСрезПоследних.ВключатьВНалоговуюБазу
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегистрацияТранспортныхСредств.Период КАК Период,
		|	РегистрацияТранспортныхСредств.Организация КАК Организация,
		|	РегистрацияТранспортныхСредств.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_РегистрацииВПервыйДеньПериода
		|ИЗ
		|	РегистрСведений.РегистрацияТранспортныхСредств КАК РегистрацияТранспортныхСредств
		|ГДЕ
		|	РегистрацияТранспортныхСредств.Период = &НачалоПериода
		|	И РегистрацияТранспортныхСредств.ВключатьВНалоговуюБазу
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(ВТ_РегистрацииВПервыйДеньПериода.Период, ВТ_РегистрацииНаКонецПрошлогоПериода.Период) КАК Период,
		|	ВТ_РегистрацииНаКонецПрошлогоПериода.Организация,
		|	ВТ_РегистрацииНаКонецПрошлогоПериода.ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_СписокОсновныхСредств
		|ИЗ
		|	ВТ_РегистрацииНаКонецПрошлогоПериода КАК ВТ_РегистрацииНаКонецПрошлогоПериода
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РегистрацииВПервыйДеньПериода КАК ВТ_РегистрацииВПервыйДеньПериода
		|		ПО ВТ_РегистрацииНаКонецПрошлогоПериода.Организация = ВТ_РегистрацииВПервыйДеньПериода.Организация
		|			И ВТ_РегистрацииНаКонецПрошлогоПериода.ОсновноеСредство = ВТ_РегистрацииВПервыйДеньПериода.ОсновноеСредство
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РегистрацияТранспортныхСредств.Период,
		|	РегистрацияТранспортныхСредств.Организация,
		|	РегистрацияТранспортныхСредств.ОсновноеСредство
		|ИЗ
		|	РегистрСведений.РегистрацияТранспортныхСредств КАК РегистрацияТранспортныхСредств
		|ГДЕ
		|	РегистрацияТранспортныхСредств.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И РегистрацияТранспортныхСредств.ВключатьВНалоговуюБазу
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТ_РегистрацииНаКонецПрошлогоПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТ_РегистрацииВПервыйДеньПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МИНИМУМ(СписокОсновныхСредств.Период) КАК Период,
		|	СписокОсновныхСредств.Организация КАК Организация,
		|	СписокОсновныхСредств.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_ПериодРегистрацииТранспортныхСредств
		|ИЗ
		|	ВТ_СписокОсновныхСредств КАК СписокОсновныхСредств
		|
		|СГРУППИРОВАТЬ ПО
		|	СписокОсновныхСредств.ОсновноеСредство,
		|	СписокОсновныхСредств.Организация
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Период,
		|	Организация,
		|	ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВТ_ПериодРегистрацииТранспортныхСредств.ОсновноеСредство,
		|	ВЫБОР
		|		КОГДА РегистрацияТранспортныхСредств.НалоговыйОрган = ЗНАЧЕНИЕ(Справочник.РегистрацииВНалоговомОргане.ПустаяСсылка)
		|			ТОГДА ЕСТЬNULL(РегистрацияТранспортныхСредств.Организация.РегистрацияВНалоговомОргане.КодПоОКТМО, """")
		|		ИНАЧЕ РегистрацияТранспортныхСредств.КодПоОКТМО
		|	КОНЕЦ КАК КодПоОКТМО,
		|	РегистрацияТранспортныхСредств.КодВидаТранспортногоСредства КАК КодВидаТранспортногоСредства,
		|	РегистрацияТранспортныхСредств.НалоговаяБаза КАК НалоговаяБаза,
		|	ВТ_ПериодРегистрацииТранспортныхСредств.ОсновноеСредство.ДатаВыпуска КАК ДатаВыпуска
		|ИЗ
		|	ВТ_ПериодРегистрацииТранспортныхСредств КАК ВТ_ПериодРегистрацииТранспортныхСредств
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияТранспортныхСредств КАК РегистрацияТранспортныхСредств
		|		ПО ВТ_ПериодРегистрацииТранспортныхСредств.Период = РегистрацияТранспортныхСредств.Период
		|			И ВТ_ПериодРегистрацииТранспортныхСредств.Организация = РегистрацияТранспортныхСредств.Организация
		|			И ВТ_ПериодРегистрацииТранспортныхСредств.ОсновноеСредство = РегистрацияТранспортныхСредств.ОсновноеСредство";
		
		РегистрацииТС = Запрос.Выполнить().Выгрузить();
		
		РегистрацииТС.Колонки.Добавить("ОКТМО", ОбщегоНазначения.ОписаниеТипаСтрока(8));
		РегистрацииТС.Колонки.Добавить("КатегорияТС", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииТранспортныхСредств"));
		РегистрацииТС.Колонки.Добавить("КоличествоЛетПрошедшихСГодаВыпускаТС", ОбщегоНазначения.ОписаниеТипаЧисло(3, 0));
		
		Макет = РегистрыСведений.РегистрацияТранспортныхСредств.ПолучитьМакет("КодыВидовИКатегорииТС");
		КодыВидовИКатегорииТС = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
		
		Для Каждого Регистрация Из РегистрацииТС Цикл
			
			КодПоОКТМО = Лев(Регистрация.КодПоОКТМО, 3);

			Если НЕ (КодПоОКТМО = "118" ИЛИ КодПоОКТМО = "718" ИЛИ КодПоОКТМО = "719") Тогда
				Регистрация.ОКТМО = Лев(КодПоОКТМО, 2) + "000000";
			Иначе
				Регистрация.ОКТМО = КодПоОКТМО + "00000";
			КонецЕсли;
			
			НайденнаяСтрока = КодыВидовИКатегорииТС.Найти(Регистрация.КодВидаТранспортногоСредства, "КодВида");
			Если НайденнаяСтрока <> Неопределено Тогда
				Регистрация.КатегорияТС = Перечисления.КатегорииТранспортныхСредств[НайденнаяСтрока.Категория];
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Регистрация.ДатаВыпуска) Тогда
				Регистрация.КоличествоЛетПрошедшихСГодаВыпускаТС = 
					Год - Год(Регистрация.ДатаВыпуска);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НовыеСтавки = РегистрыСведений.СтавкиТранспортногоНалога.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Дата(Год, 1, 1));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтавкиТранспортногоНалога.Период,
	|	СтавкиТранспортногоНалога.ОКТМО,
	|	СтавкиТранспортногоНалога.НаименованиеОбъектаНалогообложения,
	|	СтавкиТранспортногоНалога.МинимальноеЗначениеМощности,
	|	СтавкиТранспортногоНалога.МаксимальноеЗначениеМощности,
	|	СтавкиТранспортногоНалога.МинимальноеКоличествоЛетСГодаВыпускаТС,
	|	СтавкиТранспортногоНалога.МаксимальноеКоличествоЛетСГодаВыпускаТС,
	|	СтавкиТранспортногоНалога.НалоговаяСтавка
	|ИЗ
	|	РегистрСведений.СтавкиТранспортногоНалога КАК СтавкиТранспортногоНалога
	|ГДЕ
	|	СтавкиТранспортногоНалога.Период <= &Период";
	
	СуществующиеСтавки = Запрос.Выполнить().Выгрузить();
	
	Отбор = Новый Структура("ОКТМО,НаименованиеОбъектаНалогообложения,МинимальноеЗначениеМощности,МаксимальноеЗначениеМощности,
	                        |МинимальноеКоличествоЛетСГодаВыпускаТС,МаксимальноеКоличествоЛетСГодаВыпускаТС,НалоговаяСтавка");
	
	Макет = РегистрыСведений.РегистрацияТранспортныхСредств.ПолучитьМакет("СтавкиНалога" + Формат(Год, "ЧГ=0"));
	НалоговыеСтавки = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	Для Каждого Ставка Из НалоговыеСтавки Цикл
		Отбор.ОКТМО                                   = СтрокаВОКТМО(Ставка.A);
		Отбор.НаименованиеОбъектаНалогообложения      = Перечисления.КатегорииТранспортныхСредств[СокрЛП(Ставка.B)];
		Отбор.МинимальноеЗначениеМощности             = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.C);
		Отбор.МаксимальноеЗначениеМощности            = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.D);
		Отбор.МинимальноеКоличествоЛетСГодаВыпускаТС  = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.E);
		Отбор.МаксимальноеКоличествоЛетСГодаВыпускаТС = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.F);
		Отбор.НалоговаяСтавка                         = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.G);
		
		НайденныеСтроки = СуществующиеСтавки.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			Если РаботаВЛокальномРежиме Тогда
				
				ДобавлятьСтавку = Ложь;
				
				Для Каждого Регистрация Из РегистрацииТС Цикл
					
					Если Регистрация.ОКТМО = Отбор.ОКТМО
					   И Регистрация.КатегорияТС = Отбор.НаименованиеОбъектаНалогообложения
					   И Регистрация.НалоговаяБаза >= Отбор.МинимальноеЗначениеМощности
					   И ?(ЗначениеЗаполнено(Отбор.МаксимальноеЗначениеМощности),
					       Регистрация.НалоговаяБаза <= Отбор.МаксимальноеЗначениеМощности,
					       Истина)
					   И Регистрация.КоличествоЛетПрошедшихСГодаВыпускаТС >= Отбор.МинимальноеКоличествоЛетСГодаВыпускаТС
					   И ?(ЗначениеЗаполнено(Отбор.МаксимальноеКоличествоЛетСГодаВыпускаТС),
					       Регистрация.КоличествоЛетПрошедшихСГодаВыпускаТС <= Отбор.МаксимальноеКоличествоЛетСГодаВыпускаТС,
					       Истина) Тогда
						
						ДобавлятьСтавку = Истина;
						Прервать;
						
					КонецЕсли;
					
				КонецЦикла;
				
				Если Не ДобавлятьСтавку Тогда
					Продолжить;
				КонецЕсли;
				
			КонецЕсли;
			
			НоваяСтавка = НовыеСтавки.Добавить();
			НоваяСтавка.Период = Дата(Год, 1, 1);
			ЗаполнитьЗначенияСвойств(НоваяСтавка, Отбор);
		КонецЕсли;
	КонецЦикла;
	
	Набор = РегистрыСведений.СтавкиТранспортногоНалога.СоздатьНаборЗаписей();
	
	Для Каждого Ставка Из НовыеСтавки Цикл
		
		Набор.Отбор.Период.Установить(Ставка.Период);
		Набор.Отбор.ОКТМО.Установить(Ставка.ОКТМО);
		Набор.Отбор.НаименованиеОбъектаНалогообложения.Установить(Ставка.НаименованиеОбъектаНалогообложения);
		Набор.Отбор.МинимальноеЗначениеМощности.Установить(Ставка.МинимальноеЗначениеМощности);
		Набор.Отбор.МаксимальноеЗначениеМощности.Установить(Ставка.МаксимальноеЗначениеМощности);
		Набор.Отбор.МинимальноеКоличествоЛетСГодаВыпускаТС.Установить(Ставка.МинимальноеКоличествоЛетСГодаВыпускаТС);
		Набор.Отбор.МаксимальноеКоличествоЛетСГодаВыпускаТС.Установить(Ставка.МаксимальноеКоличествоЛетСГодаВыпускаТС);
		
		Если РаботаВЛокальномРежиме Тогда
			Набор.Прочитать();
			Если Набор.Количество() > 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Набор.Очистить();
		
		НоваяСтавка = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтавка, Ставка);
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		Исключение
			ШаблонСообщения = НСтр("ru = 'Не выполнено обновление ставок транспортного налога:
			                        |%1'");
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.РасчетНалогаНаИмущество,, 
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьСтавки()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = РегистрыСведений.СтавкиТранспортногоНалога.ПолучитьМакет("СтавкиКУдалению");
	НалоговыеСтавки = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	СтавкиКУдалению = РегистрыСведений.СтавкиТранспортногоНалога.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	Для Каждого Ставка Из НалоговыеСтавки Цикл
		
		НоваяСтавка = СтавкиКУдалению.Добавить();
		
		НоваяСтавка.Период                                  = Дата(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.Date), 1, 1);
		НоваяСтавка.ОКТМО                                   = СтрокаВОКТМО(Ставка.A);
		НоваяСтавка.НаименованиеОбъектаНалогообложения      = Перечисления.КатегорииТранспортныхСредств[СокрЛП(Ставка.B)];
		НоваяСтавка.МинимальноеЗначениеМощности             = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.C);
		НоваяСтавка.МаксимальноеЗначениеМощности            = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.D);
		НоваяСтавка.МинимальноеКоличествоЛетСГодаВыпускаТС  = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.E);
		НоваяСтавка.МаксимальноеКоличествоЛетСГодаВыпускаТС = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.F);
		НоваяСтавка.НалоговаяСтавка                         = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Ставка.G);
		
	КонецЦикла;
	
	НаборЗаписей = РегистрыСведений.СтавкиТранспортногоНалога.СоздатьНаборЗаписей();
	
	Для Каждого СтавкаКУдалению Из СтавкиКУдалению Цикл
		
		НаборЗаписей.Отбор.Период.Установить(СтавкаКУдалению.Период);
		НаборЗаписей.Отбор.ОКТМО.Установить(СтавкаКУдалению.ОКТМО);
		НаборЗаписей.Отбор.НаименованиеОбъектаНалогообложения.Установить(СтавкаКУдалению.НаименованиеОбъектаНалогообложения);
		НаборЗаписей.Отбор.МинимальноеЗначениеМощности.Установить(СтавкаКУдалению.МинимальноеЗначениеМощности);
		НаборЗаписей.Отбор.МаксимальноеЗначениеМощности.Установить(СтавкаКУдалению.МаксимальноеЗначениеМощности);
		НаборЗаписей.Отбор.МинимальноеКоличествоЛетСГодаВыпускаТС.Установить(СтавкаКУдалению.МинимальноеКоличествоЛетСГодаВыпускаТС);
		НаборЗаписей.Отбор.МаксимальноеКоличествоЛетСГодаВыпускаТС.Установить(СтавкаКУдалению.МаксимальноеКоличествоЛетСГодаВыпускаТС);
		
		НаборЗаписей.Прочитать();
		Для Каждого СтавкаИзНабора Из НаборЗаписей Цикл
			Если СтавкаИзНабора.НалоговаяСтавка = СтавкаКУдалению.НалоговаяСтавка Тогда
				НаборЗаписей.Очистить();
				
				Попытка
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
				Исключение
					ШаблонСообщения = НСтр("ru = 'Не выполнено удаление ставок транспортного налога:
					                        |%1'");
					ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					ЗаписьЖурналаРегистрации(
						ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
						УровеньЖурналаРегистрации.Ошибка,
						Метаданные.РегистрыСведений.СтавкиТранспортногоНалога,, 
						ТекстСообщения);
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция СтрокаВОКТМО(Знач ИсходнаяСтрока)
	
	ИсходнаяСтрока = СокрЛП(ИсходнаяСтрока);
	
	Если СтрДлина(ИсходнаяСтрока) = 1 Тогда
		ИсходнаяСтрока = "0" + ИсходнаяСтрока;
	КонецЕсли;
	
	ОКТМО = ?(СтрДлина(ИсходнаяСтрока) = 3, "" + ИсходнаяСтрока + "00000", "" + ИсходнаяСтрока + "000000");
	
	Возврат ОКТМО;
	
КонецФункции

#КонецОбласти

#КонецЕсли
﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ДокументОснование") И ЗначениеЗаполнено(Параметры.ДокументОснование) Тогда
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных("ДокументОснование");
		КоллекцияЭлементов = Список.КомпоновщикНастроек.Настройки.Отбор.Элементы;
		
		Для Каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
				И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
				КоллекцияЭлементов.Удалить(ЭлементОтбора);
			КонецЕсли;
		КонецЦикла;
		
		ЭлементОтбора = КоллекцияЭлементов.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = ПолеКомпоновки;
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = Параметры.ДокументОснование;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокЗапросовЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьОтветы(Команда)
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ОбработкаОтветовИзЕГАИС_Завершение", ЭтотОбъект);
	ИнтеграцияЕГАИСКлиент.НачатьОбработкуОтветов(ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОтветовИзЕГАИС_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.Результат Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Обработка ответов из ЕГАИС завершена.'"));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Использование = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Список");
	
	ПредставлениеЭлемента = НСтр("ru = 'Получен отказ из УТМ'");
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПолученОтказ");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
КонецПроцедуры

#КонецОбласти



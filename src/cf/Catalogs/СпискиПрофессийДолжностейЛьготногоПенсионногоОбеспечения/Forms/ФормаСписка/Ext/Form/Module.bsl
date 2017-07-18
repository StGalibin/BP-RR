﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Текст = НСтр("ru = 'Предусмотрена возможность подобрать должность из классификатора.
                  |Подобрать?'");
	Оповещение = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора();
	Иначе 
		ОткрытьФорму("Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.ФормаОбъекта");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодобратьИзКлассификатора(Команда)
	
	ПодобратьИзКлассификатора();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("Name", "НаименованиеПрофессии");
	
	КадровыйУчетКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения",
		"Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.КлассификаторПрофессийДолжностейЛьготногоПенсионногоОбеспечения",
		НСтр("ru='Списки производств, работ, профессий, должностей и показателей, дающих право на льготное пенсионное обеспечение'"),
		ЭтаФорма,
		СоответствиеПолей);
	
КонецПроцедуры

#КонецОбласти

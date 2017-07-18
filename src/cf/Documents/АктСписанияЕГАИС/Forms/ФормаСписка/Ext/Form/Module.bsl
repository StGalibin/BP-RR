﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Документы.АктСписанияЕГАИС.УстановитьУсловноеОформлениеСтатусаОбработки(ЭтотОбъект);
	
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
Процедура ВыгрузитьАкт(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = ИнтеграцияЕГАИСВызовСервера.ЗначениеРеквизитаОбъекта(Элементы.Список.ТекущиеДанные.Ссылка, "ВидДокумента");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Элементы.Список.ТекущиеДанные.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ВыгрузкаАкта_Завершение", ЭтотОбъект),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьОтменуПроведения(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросНаОтменуПроведенияАктаСписания");
	
	ПараметрыЗапроса = ИнтеграцияЕГАИСКлиентСервер.ПараметрыИсходящегоЗапроса(ВидДокумента);
	ПараметрыЗапроса.ДокументСсылка = Элементы.Список.ТекущиеДанные.Ссылка;
	
	ИнтеграцияЕГАИСКлиент.НачатьФормированиеИсходящегоЗапроса(
		Новый ОписаниеОповещения("ЗапросНаОтменуПроведения_Завершение", ЭтотОбъект),
		ВидДокумента,
		ПараметрыЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыгрузкаАкта_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Результат Тогда
		Элементы.Список.Обновить();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Документ успешно выгружен.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросНаОтменуПроведения_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Результат Тогда
		Элементы.Список.Обновить();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Запрос на отмену проведения успешно выгружен.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

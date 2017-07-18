﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипИсточника = ТипЗнч(Параметры.ИсточникСсылка);
	
	Если ТипИсточника = Тип("СправочникСсылка.ОтправкиФСРАР") Тогда
		HTMLТекст = Параметры.ИсточникСсылка.Протокол.Получить();
	Иначе //РегламентированныйОтчет или ЭлектронноеПредставление
		КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		ПоследняяОтправкаСсылка = КонтекстЭДО.ПолучитьПоследнююОтправкуОтчетаВФСРАР(Параметры.ИсточникСсылка);
		Если ПоследняяОтправкаСсылка<> Неопределено Тогда
			HTMLТекст = ПоследняяОтправкаСсылка.Протокол.Получить();
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.ИсточникСсылка.СтатусОтправки = Перечисления.СтатусыОтправки.Сдан Тогда
		Заголовок = НСтр("ru = 'Протокол о сдаче'");
	ИначеЕсли Параметры.ИсточникСсылка.СтатусОтправки = Перечисления.СтатусыОтправки.НеПринят Тогда
		Заголовок = НСтр("ru = 'Протокол ошибок'");
	Иначе
		Заголовок = НСтр("ru = 'Протокол'");
	КонецЕсли;
	
	Элементы.КнопкаПечать.Видимость = Параметры.Свойство("ПечатьВозможна") И Параметры.ПечатьВозможна = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Элементы.HTMLТекст.Документ.execCommand("Print");
	
КонецПроцедуры

#КонецОбласти

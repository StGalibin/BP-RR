﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли; 
	
	Параметры.Свойство("СотрудникСсылка", СотрудникСсылка);
	
	Если ЗначениеЗаполнено(СотрудникСсылка) Тогда
		
		ЗначенияРеквизитовСотрудника = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СотрудникСсылка, "ГоловнаяОрганизация,ФизическоеЛицо");
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ГоловнаяОрганизация", ЗначенияРеквизитовСотрудника.ГоловнаяОрганизация);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Сотрудник", СотрудникСсылка);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"Сотрудник",
			"Видимость",
			Ложь);
			
		Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитовСотрудника.ГоловнаяОрганизация, "ЕстьОбособленныеПодразделения") Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"Организация",
				"Видимость",
				Ложь);
			
		КонецЕсли; 
			
	Иначе
		
		ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список,, Параметр);
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.ОрганизацияЕГАИС.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ОрганизацияЕГАИС", Параметры.ОрганизацияЕГАИС);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("АлкогольнаяПродукция") Тогда
		Заголовок = НСтр("ru = 'Справки 2 для'") + " " + Строка(Параметры.Отбор.АлкогольнаяПродукция);
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

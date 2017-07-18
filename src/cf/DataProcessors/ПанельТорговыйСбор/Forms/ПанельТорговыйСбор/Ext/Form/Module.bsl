﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТорговыеТочки(Команда)
	
	ОткрытьФорму("Справочник.ТорговыеТочки.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Уведомления(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Уведомления"));
	ПараметрыФормы.Вставить("ВидУведомления",
		ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1"));
	
	ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

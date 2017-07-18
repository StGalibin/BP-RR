﻿#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Организация") Тогда 
		Список.Отбор.Элементы.Очистить();
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Организация");
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ПравоеЗначение = Параметры.Организация;
		ЭлементОтбора.Представление  = "";
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда 
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда 
		ОповеститьОВыборе(Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти



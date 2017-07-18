﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьОтборПоВладельцу();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьОтборПоВладельцу();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьОтборПоВладельцу();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ НАСТРОЙКИ ПОРЯДКА ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Правила, Элементы.Правила);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Правила, Элементы.Правила);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура УстановитьОтборПоВладельцу()
	
	Правила.Отбор.Элементы.Очистить();
	ЭлементОтбора = Правила.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	
	Элементы.Правила.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры


﻿//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтаФорма, Отказ);
	
	Если Не ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДатаСеанса());
	КонецЕсли;
	
	РежимСинхронизацииОрганизаций =
		?(ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьДанныеПоВсемОрганизациям");
		
	РежимСинхронизацииСправочников =
		?(ЗагружатьСправочникиИзБухгалтерииПредприятия, "СинхронизироватьДанные", "НеСинхронизироватьДанные");
		
	СинхронизацияОтраженияЗарплатыОбщейСуммой = ЗначениеЗаполнено(Сотрудник);
	Элементы.Сотрудник.Доступность = СинхронизацияОтраженияЗарплатыОбщейСуммой;
			
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ИспользоватьОтборПоОрганизациям = (РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	ЗагружатьСправочникиИзБухгалтерииПредприятия = (РежимСинхронизацииСправочников = "СинхронизироватьДанные");
	
	Если Не ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	
	ПолучитьОписаниеКонтекста();
	
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзменении(Элемент)
	
	РежимСинхронизацииОрганизацийПриИзмененииЗначения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтаФорма[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьОписаниеКонтекста()
	
	// фильтр справочников
	Если ЗагружатьСправочникиИзБухгалтерииПредприятия Тогда
		СправочникиОписание = НСтр("ru = 'Справочники Зарплаты синхронизируются изменениями Бухгалтерии предприятия'");
	Иначе
		СправочникиОписание = НСтр("ru = 'Справочники Зарплаты не синхронизируются изменениями Бухгалтерии предприятия'");
	КонецЕсли;
	
	// дата начала выгрузки документов
	Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ДатаНачалаВыгрузкиДокументовОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Данные документов будут синхронизироваться, начиная с %1'"),
			Формат(ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD")
		);
	Иначе
		ДатаНачалаВыгрузкиДокументовОписание = НСтр("ru = 'Данные документов будут синхронизироваться за весь период ведения учета в программах'");
	КонецЕсли;
	
	// отбор по Организациям
	Если ИспользоватьОтборПоОрганизациям Тогда
		ОрганизацииОписание = НСтр("ru = 'Только по организациям:'") + Символы.ПС + ИспользуемыеЭлементы("Организации");
	Иначе
		ОрганизацииОписание = НСтр("ru = 'По всем организациям.'");
	КонецЕсли;
	
	ОписаниеКонтекста = (""
		+ СправочникиОписание
		+ Символы.ПС
		+ Символы.ПС
		+ ДатаНачалаВыгрузкиДокументовОписание
		+ Символы.ПС
		+ Символы.ПС
		+ ОрганизацииОписание
	);
	
КонецПроцедуры

&НаСервере
Функция ИспользуемыеЭлементы(ИмяТаблицы)
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(
			ЭтаФорма[ИмяТаблицы].Выгрузить(Новый Структура("Использовать", Истина)).ВыгрузитьКолонку("Представление"),
			Символы.ПС
	);
	
КонецФункции

&НаКлиенте
Процедура РежимСинхронизацииОрганизацийПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииОрганизаций = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям")
	;
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияОтраженияЗарплатыОбщейСуммойПриИзменении(Элемент)
	Элементы.Сотрудник.Доступность = СинхронизацияОтраженияЗарплатыОбщейСуммой;
	Сотрудник = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
КонецПроцедуры

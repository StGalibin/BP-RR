﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "ПодсистемыЦККВМоделиСервиса".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс


////////////////////////////////////////////////////////////////////////////////
// Добавление обработчиков служебных событий (подписок)

Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Вызывается в момент определения списка задач для периодического мониторинга счетчиков и инцидентов для ЦКК.
	//
	// Синтаксис:
	// Процедура ПриВыполненииЗадачПериодическогоМониторинга() Экспорт
	//
	СерверныеСобытия.Добавить("ТехнологияСервиса.РаботаВМоделиСервиса.ПодсистемыЦККВМоделиСервиса\ПриВыполненииЗадачПериодическогоМониторинга");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	Если ТехнологияСервисаИнтеграцияСБСП.ПодсистемаСуществует("ТехнологияСервиса.РаботаВМоделиСервиса.ПодсистемыЦККВМоделиСервиса") Тогда
		
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриЗаполненииТаблицыПараметровИБ"]
		.Добавить("ИнцидентыЦККСлужебный");
		
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриУстановкеЗначенийПараметровИБ"]
		.Добавить("ИнцидентыЦККСлужебный");
		
		СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов"]
		.Добавить("ИнцидентыЦККСлужебный");
		
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриОпределенииИсключенийНеразделенныхДанных"]
		.Добавить("ИнцидентыЦККСлужебный");
		
		СерверныеОбработчики["ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки"]
		.Добавить("ИнцидентыЦККСлужебный");
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует список параметров ИБ.
//
// Параметры:
// ТаблицаПараметров - ТаблицаЗначений - таблица описания параметров.
// Описание состав колонок - см. РаботаВМоделиСервиса.ПолучитьТаблицуПараметровИБ().
//
Процедура ПриЗаполненииТаблицыПараметровИБ(Знач ТаблицаПараметров) Экспорт
	
	МодульРаботаВМоделиСервиса = ТехнологияСервисаИнтеграцияСБСП.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульРаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "АдресЦКК");
	
	// Это не константы. Значения хранятся в защищенном хранилище БСП
	СтрокаПараметра = ТаблицаПараметров.Добавить();
	СтрокаПараметра.Имя = "ЛогинЦКК";
	СтрокаПараметра.Описание = "ЛогинЦКК";
	СтрокаПараметра.Тип = Новый ОписаниеТипов("Строка");
	
	СтрокаПараметра = ТаблицаПараметров.Добавить();
	СтрокаПараметра.Имя = "ПарольЦКК";
	СтрокаПараметра.Описание = "ПарольЦКК";
	СтрокаПараметра.Тип = Новый ОписаниеТипов("Строка");
	
КонецПроцедуры

// Вызывается перед попыткой записи значений параметров ИБ в одноименные
// константы.
//
// Параметры:
// ЗначенияПараметров - Структура - значения параметров которые требуется установить.
// В случае если значение параметра устанавливается в данной процедуре из структуры
// необходимо удалить соответствующую пару КлючИЗначение.
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
	
	// Для интеграции с ЦКК
	Владелец = ТехнологияСервисаИнтеграцияСБСП.ИдентификаторОбъектаМетаданных("Константа.АдресЦКК");
	
	Если ЗначенияПараметров.Свойство("ЛогинЦКК") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ТехнологияСервисаИнтеграцияСБСП.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЗначенияПараметров.ЛогинЦКК, "Логин");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ЛогинЦКК");
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("ПарольЦКК") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ТехнологияСервисаИнтеграцияСБСП.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЗначенияПараметров.ПарольЦКК, "Пароль");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ПарольЦКК");
	КонецЕсли;
	
	ИнцидентыЦККСервер.ЗарегистрироватьТипыИнцидентовВЦКК();
	
КонецПроцедуры

// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию программных интерфейсов,
// используя в качестве ключей имена программных интерфейсов.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
// СтруктураПоддерживаемыхВерсий - Структура:
//  Ключ - Имя программного интерфейса,
//  Значение - Массив(Строка) - поддерживаемые версии программного интерфейса.
//
// Пример реализации:
//
//  // СервисПередачиФайлов
//  МассивВерсий = Новый Массив;
//  МассивВерсий.Добавить("1.0.1.1");
//  МассивВерсий.Добавить("1.0.2.1"); 
//  СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//  // Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(СтруктураПоддерживаемыхВерсий) Экспорт

	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.0.1");
	СтруктураПоддерживаемыхВерсий.Вставить("ДанныеЦКК", МассивВерсий);
	
КонецПроцедуры

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик                  = Обработчики.Добавить();
	Обработчик.Версия           = "*";
	Обработчик.МонопольныйРежим = Ложь;
	Обработчик.ОбщиеДанные      = Истина;
	Обработчик.РежимВыполнения	= "Оперативно";
	Обработчик.Процедура        = "ИнцидентыЦККСервер.ЗарегистрироватьТипыИнцидентовВЦКК";
	
КонецПроцедуры

// См. событие СтандартныеПодсистемы.РаботаВМоделиСервиса\ПриОпределенииИсключенийНеразделенныхДанных в РаботаВМоделиСервиса.
Процедура ПриОпределенииИсключенийНеразделенныхДанных(Исключения) Экспорт
	Исключения.Добавить(Метаданные.РегистрыСведений.ИнцидентыОграничениеСкоростиОтсылки);
	Исключения.Добавить(Метаданные.РегистрыСведений.ИнцидентыОткрытые);
	Исключения.Добавить(Метаданные.РегистрыСведений.ИнцидентыОтложенныеПроверки);
КонецПроцедуры

// См. событие ТехнологияСервиса.ВыгрузкаЗагрузкаДанных\ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки в ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	Типы.Добавить(Метаданные.РегистрыСведений.ИнцидентыОграничениеСкоростиОтсылки);
	Типы.Добавить(Метаданные.РегистрыСведений.ИнцидентыОткрытые);
	Типы.Добавить(Метаданные.РегистрыСведений.ИнцидентыОтложенныеПроверки);
КонецПроцедуры

#КонецОбласти

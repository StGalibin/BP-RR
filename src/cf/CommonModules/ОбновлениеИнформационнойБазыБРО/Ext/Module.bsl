﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки РегламентированнаяОтчетность (БРО).
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Объявление библиотеки.

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "РегламентированнаяОтчетность";
	Описание.Версия = "1.1.10.33";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий обновления информационной базы.

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ОтключитьВнешнийМодульДокументооборотаСФНС";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.УправлениеОбработчиками = Истина;
	Обработчик.Версия = "*";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыБРО.ЗаполнитьОбработчикиРазделенныхДанных";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ОчиститьВнешниеРеглОтчеты";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ОчиститьВнешниеРеглОтчеты";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
	Обработчик.НачальноеЗаполнение = Истина;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.НазначитьНомераПачекОтчетовПФР";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "0.0.0.1";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ОбработкаОбновленияПриПереходеС82";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.29";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиНаРегламентированныеОтчеты";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.41";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.ДобавитьСкрытыеОтчетыВРегистрСведений";
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.48";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаменитьСсылкиРазделенныйСпрУдалитьРеглОтчетыНаНеРазделенныйСпрРеглОтчеты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.0.1.52";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.58";
	Обработчик.Процедура = "РегламентированнаяОтчетность.ЗаполнитьПредставлениеПериодаИВидаРеглОтчета";
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.60";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.УдалитьСкрытыеОтчетыИзРегистраСведений";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.1.60";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.НазначитьНомераПачекОтчетовПФР";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.2";
	Обработчик.Процедура = "РегламентированнаяОтчетностьВызовСервера.ЗаполнитьРегистрЖурналОчетовСтатусы";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет обновление информации в форме 1С-Отчетность в разделе Отчеты. До завершения выполнения данные в форме 1С-Отчетность могут отображаться некорректно'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.3";
	Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.5.5";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ПереименоватьОтправкиНаПолучениеПатентаВЖурнале";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияБухгалтерскихРеглОтчетов";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований бухгалтерских регламентированных отчетов.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьПредставлениеПериода";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение представлений отчетного периода.'");
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.7.12";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьПредставлениеФинансовогоПериода";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение представлений отчетного периода.'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.5";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовСЗВ_МДоходыОтОбрМедДеятельностиНДФЛ";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.9";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьИменаОтчетов";
	Обработчик.НачальноеЗаполнение = Ложь;
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "1.1.9.11";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УдалитьПовторяющиесяГруппыИЭлементыВСправочникеРеглОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.12";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьВидыОтправляемыхДокументовОбъемВинограда";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияДекларацийПоАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияДекларацийПоАлкоголю";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований деклараций по алкоголю.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ИзменитьНаименованияРеестровПоНДС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований реестров по НДС.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.13";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИзменитьНаименованияРеестровПоНДС";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение наименований реестров по НДС.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.14";
	Обработчик.Процедура = "Справочники.ВидыОтправляемыхДокументов.ИсправитьНаименованияДекларацийПоАлкоголюРеестровПоНДС";
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.19";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ЗаполнитьИндексКартинкиРеглОтчетов";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет заполнение индекса картинки регламентированных отчетов.'");
			
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.9.22";
	Обработчик.Процедура = "РегистрыСведений.ЖурналОтчетовСтатусы.ИсправитьРеквизитыОтправкиСправокОРублевыхИВалютныхСчетах";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор();
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Комментарий = НСтр("ru = 'Выполняет изменение реквизитов отправки справок о рублевых и валютных счетах.'");
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.11";
	Обработчик.Процедура = "ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ВключитьМеханизмОнлайнСервисовРО";
	Обработчик.НачальноеЗаполнение = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.20";
	Обработчик.Процедура = "Документы.РегламентированныйОтчет.ПереименоватьРасчетПлатыВДекларациюНВОС";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.23";
	Обработчик.Процедура = "Документы.УведомлениеОСпецрежимахНалогообложения.ПеренестиФайлыИзРегистраВПрисоединенныеФайлы";
	Обработчик.НачальноеЗаполнение = Ложь;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.33";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ОчиститьВнешниеРеглОтчеты";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.33";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.ЗаполнитьСписокРегламентированныхОтчетов";
	Обработчик.ОбщиеДанные = Истина;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.33";
	Обработчик.Процедура = "РегистрыСведений.СкрытыеРегламентированныеОтчеты.СкрытьВосстановитьОтчеты";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.10.33";
	Обработчик.Процедура = "Справочники.РегламентированныеОтчеты.УстановитьСнятьПометкуНаУдаление";
	Обработчик.ОбщиеДанные = Истина;
		
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиОбновлениеИнформационнойБазы.ПриДобавленииОбработчиковОбновления(Обработчики);
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// Описание этой же процедуры смотрите в модуле ОбновлениеИнформационнойБазыБСП.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	// Не используется в БРО.
	
КонецПроцедуры

// Заполняет обработчик разделенных данных, зависимый от изменения неразделенных данных (Обработчик.Версия = "*" поддерживается).
//
// Параметры:
//   Параметры - ТаблицаЗначений, Неопределено - см. описание 
//    функции НоваяТаблицаОбработчиковОбновления общего модуля 
//    ОбновлениеИнформационнойБазы.
//    В случае прямого вызова (не через механизм обновления 
//    версии ИБ) передается Неопределено.
// 
Процедура ЗаполнитьОбработчикиРазделенныхДанных(Параметры = Неопределено) Экспорт
	
	Если Параметры <> Неопределено Тогда
		Обработчики = Параметры.РазделенныеОбработчики;
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.РежимВыполнения = "Оперативно";
		Обработчик.Процедура = "РегламентированнаяОтчетность.ВыполнитьОбновлениеИнформационнойБазы";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
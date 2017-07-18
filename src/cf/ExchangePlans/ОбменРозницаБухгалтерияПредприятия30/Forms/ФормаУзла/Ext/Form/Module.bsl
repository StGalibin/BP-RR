﻿//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("Запись_УзелПланаОбмена");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры // ИспользоватьОтборПоОрганизациямПриИзменении()

//////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Элементы.Организации.Видимость  = Объект.ИспользоватьОтборПоОрганизациям;
	Элементы.ПодразделенияОрганизаций.Видимость  = Объект.ИспользоватьОтборПоПодразделениямОрганизации;
	Элементы.ИспользоватьОтборПоПодразделениямОрганизации.Видимость = Объект.ЗарплатаВыплачиваетсяИзКассыВРозничнойОптовойСети;;
	
КонецПроцедуры // УстановитьВидимостьНаСервере()

&НаКлиенте
Процедура ИспользоватьОтборПоПодразделениямОрганизацииПриИзменении(Элемент)
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры // ИспользоватьОтборПоПодразделениямОрганизацииПриИзменении()

&НаКлиенте
Процедура ЗарплатаВыплачиваетсяИзКассыВРозничнойОптовойСетиПриИзменении(Элемент)
	
	Если Объект.ЗарплатаВыплачиваетсяИзКассыВРозничнойОптовойСети = Ложь Тогда
		Объект.ИспользоватьОтборПоПодразделениямОрганизации = Ложь;
	КонецЕсли;
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры // ЗарплатаВыплачиваетсяИзКассыВРозничнойОптовойСетиПриИзменении()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СтрокаОшибки = "";
	Если Объект.ИспользоватьОтборПоПодразделениямОрганизации И Объект.ПодразделенияОрганизаций.Количество() > 0 Тогда
		ПустыеПодразделенияМассив = Объект.ПодразделенияОрганизаций.НайтиСтроки(Новый Структура("ПодразделениеОрганизации", ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка")));
		Если ПустыеПодразделенияМассив.Количество() > 0 Тогда
			Отказ = Истина;
			СтрокаОшибки = "Не заполнено подразделение организации.";
		Иначе
			Для каждого ОрганизацияСтрока Из Объект.ПодразделенияОрганизаций Цикл
				Если (Объект.ИспользоватьОтборПоОрганизациям И Объект.Организации.Количество() > 0) Тогда
					НайденныеСтрокиОрганизации = Объект.Организации.НайтиСтроки(Новый Структура("Организация", ПолучитьРеквизитНаСервере(ОрганизацияСтрока.ПодразделениеОрганизации, "Владелец")));
					Если НайденныеСтрокиОрганизации.Количество() = 0 Тогда
						Отказ = Истина;
						СтрокаОшибки = "Организации отбора не соответствуют организациям подразделений организаций.";
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Если Отказ Тогда
		Сообщить(СтрокаОшибки);
		возврат;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

&НаСервереБезКонтекста
Функция ПолучитьРеквизитНаСервере(ОбъектДляЧтения, ИмяРеквизита) Экспорт
	МетаданныеОбъекта = ОбъектДляЧтения.Метаданные();
	Если (МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита) <> Неопределено) Или (ВРег(ИмяРеквизита)="ВЛАДЕЛЕЦ") Тогда 
		Возврат ОбъектДляЧтения[ИмяРеквизита];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

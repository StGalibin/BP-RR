﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики получения поставляемых данных внешних модулей документооборота
// с контролирующими органами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Регистрирует обработчики поставляемых данных за день и за все время
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ВидДанных = "ВнешнийМодульДокументооборотаСКО";
	Обработчик.КодОбработчика = "ВнешнийМодульДокументооборотаСКО";
	Обработчик.Обработчик = ВнешниеМодулиДокументооборотаСКОВМоделиСервиса;
	
КонецПроцедуры

// Вызывается при получении уведомления о новых данных.
// В теле следует проверить, необходимы ли эти данные приложению, 
// и если да - установить флажок Загружать
// 
// Параметры:
//   Дескриптор   - ОбъектXDTO Descriptor.
//   Загружать    - булево, возвращаемое
//
Процедура ДоступныНовыеДанные(Знач Дескриптор, Загружать) Экспорт
	
	Если Дескриптор.DataType = "ВнешнийМодульДокументооборотаСКО" Тогда
		
		Загружать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после вызова ДоступныНовыеДанные, позволяет разобрать данные.
//
// Параметры:
//   Дескриптор   - ОбъектXDTO Дескриптор.
//   ПутьКФайлу   - строка. Полное имя извлеченного файла. Файл будет автоматически удален 
//                  после завершения процедуры.
//
Процедура ОбработатьНовыеДанные(Знач Дескриптор, Знач ПутьКФайлу) Экспорт
	
	Если Дескриптор.DataType = "ВнешнийМодульДокументооборотаСКО" Тогда
		
		ОбработатьВнешнийМодульДокументооборотаСКО(Дескриптор, ПутьКФайлу);
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при отмене обработки данных в случае сбоя
//
Процедура ОбработкаДанныхОтменена(Знач Дескриптор) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьВнешнийМодульДокументооборотаСКО(Дескриптор, ПутьКФайлу)
	
	ИмяМетаданныхКонфигурацииМодуля = "";
	ИДКонфигурацииМодуля = "";
	ВерсияКонфигурацииМодуля = "";
	ВерсияВнешнегоМодуля = "";
	Для Каждого Характеристика Из Дескриптор.Properties.Property Цикл
		Если Характеристика.Code = "ИмяМетаданныхКонфигурации" Тогда
			ИмяМетаданныхКонфигурацииМодуля = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "ИДКонфигурации" Тогда
			ИДКонфигурацииМодуля = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "ВерсияКонфигурации" Тогда
			ВерсияКонфигурацииМодуля = Характеристика.Value;
		ИначеЕсли Характеристика.Code = "ВерсияВнешнегоМодуля" Тогда
			ВерсияВнешнегоМодуля = Характеристика.Value;
		КонецЕсли;
	КонецЦикла;
	
	ИмяМетаданныхКонфигурацииПрограммы = СокрЛП(Метаданные.Имя);
	ИДКонфигурацииПрограммы = РегламентированнаяОтчетностьПереопределяемый.ИДКонфигурации();
	ВерсияКонфигурацииПрограммы = СокрЛП(Метаданные.Версия);
	
	Если (ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ИДТекущейКонфигурацииСоответствуетШаблону(
	ИмяМетаданныхКонфигурацииМодуля, ИмяМетаданныхКонфигурацииПрограммы)
	ИЛИ ОнлайнСервисыРегламентированнойОтчетностиВызовСервера.ИДТекущейКонфигурацииСоответствуетШаблону(
	ИДКонфигурацииМодуля, ИДКонфигурацииПрограммы))
	И ВерсияКонфигурацииМодуля = ВерсияКонфигурацииПрограммы Тогда
		
		// получение архива внешнего модуля документооборота с контролирующими органами
		
		Попытка
			
			Если ЭтоАдресВременногоХранилища(ПутьКФайлу) Тогда
				ДанныеАрхиваВнешнегоМодуля = ПолучитьИзВременногоХранилища(ПутьКФайлу);
			Иначе
				ДанныеАрхиваВнешнегоМодуля = Новый ДвоичныеДанные(ПутьКФайлу)
			КонецЕсли;
			
			ФайлАрхиваВнешнегоМодуля = ПолучитьИмяВременногоФайла("zip");
			ДанныеАрхиваВнешнегоМодуля.Записать(ФайлАрхиваВнешнегоМодуля);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Получение архива внешнего модуля документооборота с контролирующими органами.
						   |Описание:
						   |""%1""'"),
				ПредставлениеОшибки);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Поставляемые данные. Загрузка внешнего модуля документооборота с контролирующими органами.'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ТекстОшибки);
			Возврат;
			
		КонецПопытки;
		
		// извлечение внешнего модуля документооборота с контролирующими органами из архива
		
		ПредставлениеОшибки = Неопределено;
		
		Попытка
			
			ВременныйКаталог = ПолучитьИмяВременногоФайла();
			СоздатьКаталог(ВременныйКаталог);
			
			ЧтениеЗИП = Новый ЧтениеZipФайла(ФайлАрхиваВнешнегоМодуля);
			ПервыйЭлементАрхива = ЧтениеЗИП.Элементы.Получить(0);
			ЧтениеЗИП.Извлечь(ПервыйЭлементАрхива, ВременныйКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
			ЧтениеЗИП.Закрыть();
			
			РезультатПоиска = НайтиФайлы(ВременныйКаталог, "*.*");
			
			Если РезультатПоиска.Количество() = 0 Тогда
				ПредставлениеОшибки = НСтр("ru = 'Ошибка при извлечении файла из архива.'");
				
			Иначе
				ПервыйФайл = РезультатПоиска.Получить(0);
				ДанныеВнешнегоМодуля = Новый ДвоичныеДанные(ПервыйФайл.ПолноеИмя);
				
				ОбъектВнешнийМодуль = Новый ХранилищеЗначения(ДанныеВнешнегоМодуля);
			КонецЕсли;
			
			ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлАрхиваВнешнегоМодуля);
			ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ВременныйКаталог);
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		КонецПопытки;
		
		Если ПредставлениеОшибки <> Неопределено Тогда
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Распаковка внешнего модуля документооборота с контролирующими органами.
						   |Описание:
						   |""%1""'"),
				ПредставлениеОшибки);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Поставляемые данные. Загрузка внешнего модуля документооборота с контролирующими органами.'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ТекстОшибки);
			Возврат;
		КонецЕсли;
		
		// сохранение внешнего модуля в базе
		
		УстановитьПривилегированныйРежим(Истина);
		Попытка
			
			КонстантыНабор = Константы.СоздатьНабор(
				"ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль, "
				+ "ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля, "
				+ "ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль");
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль 	= Истина;
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВерсияВнешнегоМодуля 		= ВерсияВнешнегоМодуля;
			КонстантыНабор.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль 				= ОбъектВнешнийМодуль;
			КонстантыНабор.Записать();
			
		Исключение
			
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Запись внешнего модуля документооборота с контролирующими органами.
						   |Описание:
						   |""%1""'"),
				ПредставлениеОшибки);
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Поставляемые данные. Загрузка внешнего модуля документооборота с контролирующими органами.'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ТекстОшибки);
			
		КонецПопытки;
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
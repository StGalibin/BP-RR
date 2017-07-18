﻿
// Обработчик события переопределяет произвольную команду формы списка Кассовая смена.
//
// Параметры:
//  Команда - команда формы
//
Процедура ФормаСпискаВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
КонецПроцедуры

// Обработчик события переопределяет произвольную команду формы документа Кассовая смена.
//
// Параметры:
//  Команда - команда формы
//
Процедура ФормаДокументаВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
КонецПроцедуры

// Обработчик события вызывается при получении имени кассира.
//
// Параметры:
//  Объект - Значение, которое используется как основание для заполнения,
//  ИмяКассира - Строка, Неопределено - Текст, используемый для заполнения документа
//  СтандартнаяОбработка - Булево
//
Процедура ОбработкаЗаполненияИмяКассира(Объект, ИмяКассира, СтандартнаяОбработка) Экспорт
	ТипыОборудования = Новый Массив;
	
	ТипыОборудования.Добавить("ККТ");
	ТипыОборудования.Добавить("ПринтерЧеков");
	ТипыОборудования.Добавить("ФискальныйРегистратор");
	
	Организация   = ОбщегоНазначенияБПВызовСервера.ОрганизацияПодключаемогоОборудованияПоУмолчанию(ТипыОборудования);
	ДанныеКассира = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛицаТекущегоПользователя(Организация);
	
	Если ДанныеКассира.Представление <> Неопределено Тогда
		ИмяКассира = СокрЛП(СтрШаблон("%1 %2", Строка(ДанныеКассира.Должность), ДанныеКассира.Представление));
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

Процедура УправлениеФУЗаполнитьДополнительныеПараметрыПередОткрытиемСмены(ФискальноеУстройство, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

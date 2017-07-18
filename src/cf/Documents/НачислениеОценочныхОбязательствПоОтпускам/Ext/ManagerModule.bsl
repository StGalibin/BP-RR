﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция ТребуетсяУтверждениеДокументаБухгалтером(Организация = Неопределено) Экспорт
	
	// Подтверждение требуется, если используется обмен с бухгалтерией.
	
	// ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3")
		И Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КонфигурацииЗарплатаКадры") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиЗарплата3Бухгалтерия3");
		Возврат Модуль.ОбменИспользуется(Организация);
		
	КонецЕсли;
	// Конец ЗарплатаКадрыПриложения.ОбменЗарплата3Бухгалтерия3
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнитьНачислениеОценочныхОбязательствПоОтпускам(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ЗаполнитьДокументНачислениеОценочныхОбязательствПоОтпускам(ЭтотОбъект);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект, ИмяТаблицы", Истина, ЭтотОбъект, ПараметрыЗаполнения.ИмяТаблицы);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ПеречитатьОценочныеОбязательства(ПараметрыЗаполнения, АдресХранилища) Экспорт
	
	ЭтотОбъект = ПараметрыЗаполнения.Объект;
	РезервОтпусков.ПеречитатьОценочныеОбязательства(ЭтотОбъект);
	
	Результат = Новый Структура("ЗаданиеВыполнено, Объект, ИмяТаблицы", Истина, ЭтотОбъект, ПараметрыЗаполнения.ИмяТаблицы);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
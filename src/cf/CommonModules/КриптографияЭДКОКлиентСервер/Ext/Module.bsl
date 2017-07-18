﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Криптография".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает список криптопровайдеров, поддерживаемых 1С-Отчетностью.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив с описаниями криптопровайдеров.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция ПоддерживаемыеКриптопровайдеры() Экспорт
	
	СписокКриптопровайдеров = Новый Массив;
	СписокКриптопровайдеров.Добавить(КриптопровайдерCryptoPro());
	СписокКриптопровайдеров.Добавить(КриптопровайдерViPNet());
	
	Возврат Новый ФиксированныйМассив(СписокКриптопровайдеров);
	
КонецФункции

// Возвращает описание криптопровайдера CryptoPro CSP.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерCryptoPro() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			75);
	Свойства.Вставить("Представление", 	"CryptoPro CSP");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера ViPNet CSP.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерViPNet() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"Infotecs Cryptographic Service Provider");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			2);
	Свойства.Вставить("Представление", 	"ViPNet CSP");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера Signal-COM CSP.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерSignalCOM() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"Signal-COM CPGOST Cryptographic Provider");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			75);
	Свойства.Вставить("Представление", 	"Signal-COM CSP");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера ЛИССИ-CSP.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерЛИССИ() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"LISSI-CSP");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			75);
	Свойства.Вставить("Представление", 	"ЛИССИ-CSP");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

// Возвращает описание криптопровайдера Microsoft Base Cryptographic Provider v1.0.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - описание криптопровайдера.
//  * Имя - Строка - имя криптопровайдера.
//  * Тип - Число  - тип криптопровайдера.
//  * Путь - Строка - путь к модулю криптопровайдера в *nix-системах.
//  * Представление - Строка - представление криптопровайдера для отображение в интерфейсе.
//
Функция КриптопровайдерMicrosoftBaseCryptographicProvider() Экспорт
	
	Свойства = Новый Структура();
	Свойства.Вставить("Имя", 			"Microsoft Base Cryptographic Provider v1.0");
	Свойства.Вставить("Путь", 			"");
	Свойства.Вставить("Тип", 			1);
	Свойства.Вставить("Представление", 	"Microsoft Base Cryptographic Provider v1.0");
	
	Возврат Новый ФиксированнаяСтруктура(Свойства);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПереместитьВоВременномХранилище(Знач ОткудаАдрес, Знач КудаАдрес, Знач ОчиститьИсходный = Ложь) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(ОткудаАдрес) Или 
		Не ЭтоАдресВременногоХранилища(КудаАдрес) Тогда 
		Возврат Ложь;
	КонецЕсли;
		
	ДанныеСодержимое = ПолучитьИзВременногоХранилища(ОткудаАдрес);
	ПоместитьВоВременноеХранилище(ДанныеСодержимое, КудаАдрес);
	
	Если ОчиститьИсходный Тогда 
		УдалитьИзВременногоХранилища(ОткудаАдрес);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаписатьСобытиеВЖурнал(Имя, Уровень = "Ошибка", Комментарий) Экспорт
	
	КриптографияЭДКОСлужебныйВызовСервера.ЗаписатьСобытиеВЖурнал(Имя, Уровень, Комментарий);
	
КонецПроцедуры

#КонецОбласти
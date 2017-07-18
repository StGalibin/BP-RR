﻿////////////////////////////////////////////////////////////////////////////////
// РАЗРЕЗЫ УЧЕТА

// Возвращает разрезы, в которых ведется бухгалтерский учет
//
// Возвращаемое значение:
//  Структура. Ключ - имя разреза, значение - его тип.
//
Функция РазрезыУчета() Экспорт
	
	ОписаниеТиповСубконто = Метаданные.ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Тип;
	
	РазрезыУчета = Новый Структура;
	РазрезыУчета.Вставить("Счет",          Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	РазрезыУчета.Вставить("Подразделение", БухгалтерскийУчетКлиентСерверПереопределяемый.ОписаниеТиповПодразделения());
	РазрезыУчета.Вставить("Субконто1",     ОписаниеТиповСубконто);
	РазрезыУчета.Вставить("Субконто2",     ОписаниеТиповСубконто);
	РазрезыУчета.Вставить("Субконто3",     ОписаниеТиповСубконто);
	
	Возврат РазрезыУчета;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СПИСКИ СЧЕТОВ УЧЕТА ЗАТРАТ

// Возвращает предопределенные счета учета запасов
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаЗапасов() Экспорт
	
	// Счета учета, образующие раздел учета Запасы
	СчетаЗапасов = Новый Массив;
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.ОборудованиеКУстановке);              // 07
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.ПриобретениеКомпонентовОсновныхСредств); // 08.04.1
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.Материалы);                           // 10.* (есть исключения)
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.Полуфабрикаты);                       // 21
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.Товары);                              // 41.* (есть исключения)
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.ГотоваяПродукция);                    // 43
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.ТоварыОтгруженные);                   // 45
	СчетаЗапасов.Добавить(ПланыСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья);    // 20.02
	
	Возврат СчетаЗапасов;
	
КонецФункции

// Возвращает предопределенные счета учета расходов на производство
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаРасходов() Экспорт
	
	СчетаРасходов = Новый Массив();
	
	СчетаПрямыхРасходов = ПредопределенныеСчетаПрямыхРасходов();
	Для Каждого Счет Из СчетаПрямыхРасходов Цикл
		СчетаРасходов.Добавить(Счет);
	КонецЦикла;
	
	СчетаКосвенныхРасходов = ПредопределенныеСчетаКосвенныхРасходов();
	Для Каждого Счет Из СчетаКосвенныхРасходов Цикл
		СчетаРасходов.Добавить(Счет);
	КонецЦикла;
	
	Возврат СчетаРасходов;

КонецФункции

// Возвращает предопределенные счета учета расходов основного и вспомогательного производства
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаПрямыхРасходов() Экспорт
	
	СчетаРасходов = Новый Массив();
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОсновноеПроизводство_); // 20.*, есть исключения
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ВспомогательныеПроизводства);
	
	Возврат СчетаРасходов;
	
КонецФункции

// Возвращает предопределенные счета учета общепроизводственных и общехозяйственных расходов
//
// Возвращаемое значение:
//  Массив значений типа ПланСчетовСсылка.Хозрасчетный
//
Функция ПредопределенныеСчетаКосвенныхРасходов() Экспорт
	
	СчетаРасходов = Новый Массив();
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходы);
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.ОбщехозяйственныеРасходы);
	
	Возврат СчетаРасходов;

КонецФункции

Функция ПредопределенныеСчетаРасходовНаПродажу() Экспорт
	
	СчетаРасходов = Новый Массив;
	СчетаРасходов.Добавить(ПланыСчетов.Хозрасчетный.РасходыНаПродажу);
	
	Возврат СчетаРасходов;
	
КонецФункции
	

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ТИПЫ

// Возвращает тип идентификатора, за которым можно скрыть набор значений аналитики учета
Функция ТипИдентификатораВершины() Экспорт
	
	Возврат ОбщегоНазначения.ОписаниеТипаЧисло(10, 0);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СПЕЦИАЛЬНЫЕ, СЛУЖЕБНЫЕ

Функция ОтладитьЗапрос(Запрос) Экспорт
	
	ИсходныйТекстЗапроса = "" + Запрос.Текст;
	
	МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	Если МенеджерВременныхТаблиц = Неопределено Тогда
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	КонецЕсли;
	
	// Разложим пакет на несколько запросов
	ПакетЗапросов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсходныйТекстЗапроса, ";");
	
	ОписаниеЗапросов = Новый Массив;
	Для Каждого ТекстЗапроса Из ПакетЗапросов Цикл
		
		СловаЗапроса = Новый Массив;
		// Разложим запрос на слова
		Для НомерСтроки = 1 По СтрЧислоСтрок(ТекстЗапроса) Цикл
			
			Строка = СокрЛП(СтрПолучитьСтроку(ТекстЗапроса, НомерСтроки));
			Если ПустаяСтрока(Строка) Тогда
				Продолжить;
			КонецЕсли;
			
			// Отсечем заведомые комментарии (но не все комментарии удастся так найти)
			Если Лев(Строка, 2) = "//" Тогда
				Продолжить;
			КонецЕсли;
			
			// Разложим строку на слова, разделенные пробелами
			Для Каждого Слово Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, " ") Цикл
				СловаЗапроса.Добавить(Слово);
			КонецЦикла;
			
		КонецЦикла;
		
		// Текст запроса должен начинаться с определенных ключевых слов
		Если СловаЗапроса.Количество() = 0 
			Или (СловаЗапроса[0] <> "ВЫБРАТЬ" И СловаЗапроса[0] <> "УНИЧТОЖИТЬ") Тогда
			Продолжить;
		КонецЕсли;
		
		// Определим тип запроса и имя временной таблицы.
		Уничтожить = СловаЗапроса.Найти("УНИЧТОЖИТЬ");
		Поместить  = СловаЗапроса.Найти("ПОМЕСТИТЬ");
		
		Если Уничтожить <> Неопределено Тогда
			
			ТипЗапроса = "УНИЧТОЖИТЬ";
			ИмяВременнойТаблицы = СловаЗапроса[Уничтожить + 1];
			
		ИначеЕсли Поместить <> Неопределено Тогда
			
			ТипЗапроса = "ПОМЕСТИТЬ";
			ИмяВременнойТаблицы = СловаЗапроса[Поместить + 1];
			
		Иначе
			
			ТипЗапроса = "ВЫБРАТЬ";
			ИмяВременнойТаблицы = "";
			
		КонецЕсли;
		
		ОписаниеЗапроса = Новый Структура;
		ОписаниеЗапроса.Вставить("Текст",               ТекстЗапроса);
		ОписаниеЗапроса.Вставить("Тип",                 ТипЗапроса);
		ОписаниеЗапроса.Вставить("ИмяВременнойТаблицы", ИмяВременнойТаблицы);
		
		ОписаниеЗапросов.Добавить(ОписаниеЗапроса);
		
	КонецЦикла;
	
	// Уничтожим временные таблицы, если они созданы (будут созданы) в этом пакете,
	// чтобы сохранить состав временных таблиц таким же, как до отладки
	ВременныеТаблицы = Новый Массив;
	Для Каждого ОписаниеЗапроса Из ОписаниеЗапросов Цикл
		Если ОписаниеЗапроса.Тип = "ПОМЕСТИТЬ" Тогда
			ВременныеТаблицы.Добавить(ОписаниеЗапроса.ИмяВременнойТаблицы);
		КонецЕсли;
	КонецЦикла;
	
	// Последовательно выполняем каждый пакет и складываем его результат в коллекцию.
	Для Каждого ОписаниеЗапроса Из ОписаниеЗапросов Цикл
		
		// Запросы разных типов выполняем по-разному
		Если ОписаниеЗапроса.Тип = "УНИЧТОЖИТЬ" Тогда
		
			// Для того, чтобы снизить влияние принципа неопределенности,
			// выполняем этот запрос, только если уничтожается таблица, созданная в этой процедуре.
			// Иначе после отладки выполнять код будет нельзя
			
			ВременнаяТаблица = ВременныеТаблицы.Найти(ОписаниеЗапроса.ИмяВременнойТаблицы);
			
			Если ВременнаяТаблица = Неопределено Тогда
				
				ОписаниеЗапроса.Вставить("Результат", Ложь);
				
			Иначе
				
				Запрос.Текст = ОписаниеЗапроса.Текст;
				Запрос.Выполнить();
				
				ВременныеТаблицы.Удалить(ВременнаяТаблица);
				
				ОписаниеЗапроса.Вставить("Результат", Истина);
				
			КонецЕсли;
			
		ИначеЕсли ОписаниеЗапроса.Тип = "ПОМЕСТИТЬ" Тогда
		
			Запрос.Текст = ОписаниеЗапроса.Текст;
			Запрос.Выполнить();
			
			// Выгрузим результат запроса в таблицу значений
			ТаблицаЗапроса = МенеджерВременныхТаблиц.Таблицы.Найти(ОписаниеЗапроса.ИмяВременнойТаблицы);
			ОписаниеЗапроса.Вставить("Результат", ТаблицаЗапроса.ПолучитьДанные().Выгрузить());
			
		Иначе // Выборка данных
			
			Запрос.Текст = ОписаниеЗапроса.Текст;
			ОписаниеЗапроса.Вставить("Результат", Запрос.Выполнить().Выгрузить());
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Убираем следы
	// 1. Уничтожаем созданные временные таблицы, которых не было до выполнения пакета
	Запрос.Текст = "";
	Для Каждого ИмяТаблицы Из ВременныеТаблицы Цикл
		Запрос.Текст = Запрос.Текст + "УНИЧТОЖИТЬ " + ИмяТаблицы + ";";
	КонецЦикла;
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		ОписаниеЗапросов.Добавить(Запрос.Текст);
		Запрос.Выполнить();
	КонецЕсли;
	
	// 2. Восстанавлиаем текст запроса
	Запрос.Текст = ИсходныйТекстЗапроса;
	
	Возврат ОписаниеЗапросов;
	
КонецФункции

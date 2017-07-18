﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Поступления денежных средств" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы);
	ВидыСубконтоКД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Субконто", ВидыСубконтоКД);
	
	
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ПараметрыОтчета.Периодичность, ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	ВыводитьДиаграмму = Неопределено;
	
	Если НЕ ПараметрыОтчета.Свойство("ВыводитьДиаграмму", ВыводитьДиаграмму) Тогда
		
		ВыводитьДиаграмму = Истина;
		
	КонецЕсли;
	
	Таблица   = Неопределено;
	Диаграмма = Неопределено;
	Для Каждого ЭлементСтруктуры Из КомпоновщикНастроек.Настройки.Структура Цикл		
		Если ЭлементСтруктуры.Имя = "Таблица" Тогда
			Таблица = ЭлементСтруктуры;
		ИначеЕсли ЭлементСтруктуры.Имя = "Диаграмма" Тогда
			Диаграмма = ЭлементСтруктуры;
		КонецЕсли;		
	КонецЦикла;
	
	Если Диаграмма <> Неопределено Тогда
		
		Если ВыводитьДиаграмму Тогда
			
			Диаграмма.Точки.Очистить();
			ГруппировкаПериод = Диаграмма.Точки.Добавить();
			ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование = Истина;
			ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
			ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
			ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
			ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
			
			ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			// Группировка
			Диаграмма.Серии.Очистить();
			Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
				Если ПолеВыбраннойГруппировки.Использование Тогда
					Группировка = Диаграмма.Серии.Добавить();
					БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);				
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			Диаграмма.Использование = ВыводитьДиаграмму;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Таблица <> Неопределено Тогда
		Таблица.Колонки.Очистить();
		ГруппировкаПериод = Таблица.Колонки.Добавить();
		ПолеГруппировки = ГруппировкаПериод.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование = Истина;
		ПолеГруппировки.Поле          = Новый ПолеКомпоновкиДанных("Период");
		ПолеГруппировки.ТипДополнения = БухгалтерскиеОтчетыВызовСервера.ПолучитьТипДополненияПоИнтервалу(Периодичность);
		ПолеГруппировки.НачалоПериода =	НачалоДня(ПараметрыОтчета.НачалоПериода);
		ПолеГруппировки.КонецПериода  = КонецДня(ПараметрыОтчета.КонецПериода);
		
		ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		ГруппировкаПериод.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		// Группировка
		Таблица.Строки.Очистить();
		Группировка = Таблица.Строки;
		Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
			Если ПолеВыбраннойГруппировки.Использование Тогда
				Если ТипЗнч(Группировка) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
					Группировка = Группировка.Добавить();
				Иначе
					Группировка = Группировка.Структура.Добавить();
				КонецЕсли;
				БухгалтерскиеОтчетыВызовСервера.ЗаполнитьГруппировку(ПолеВыбраннойГруппировки, Группировка);				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ПоступленияДенежныхСредств").Размещение.Вставить(Метаданные.Подсистемы.Руководителю82.Подсистемы.ДенежныеСредства, "");
	ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "ПоступленияДенежныхСредств").Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.ДенежныеСредства, "");
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
		
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
		
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Организация"     , ОтчетОбъект.Организация);

	Период        = Неопределено;
	Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(ОтчетОбъект.Периодичность, ОтчетОбъект.НачалоПериода, ОтчетОбъект.КонецПериода);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);

 	Для Каждого Отбор Из МассивПолей Цикл
		Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
			Если Отбор.Значение = NULL тогда
				Продолжить;
			КонецЕсли;
			
			Если Отбор.Поле = "Подразделение" Тогда
				Если ЗначениеЗаполнено(Отбор.Значение) Тогда
					ДополнительныеСвойства.Вставить("Подразделение", Отбор.Значение);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			ИначеЕсли Отбор.Поле = "Организация" Тогда
				ДополнительныеСвойства.Вставить("Организация", Отбор.Значение);
			ИначеЕсли Отбор.Поле = "Период" Тогда
				Период = Отбор.Значение;
			Иначе
				Если Отбор.Иерархия Тогда
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);
				Иначе
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.Поле, Отбор.Значение);
				КонецЕсли;
			КонецЕсли;	
		ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизацииСОП###" Тогда
				Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
					Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
						ДополнительныеСвойства.Вставить("Организация"                      , ЭлементОтбора.ПравоеЗначение);
						ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Истина);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
				ДополнительныеСвойства.Вставить("Организация"                      , Отбор.ПравоеЗначение);
				ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Ложь);
			ИначеЕсли Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Подразделение") 
				И Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				ДополнительныеСвойства.Вставить("Подразделение", Отбор.ПравоеЗначение);
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, Отбор.ЛевоеЗначение, Отбор.ПравоеЗначение, Отбор.ВидСравнения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Если Период <> Неопределено Тогда
		ДополнительныеСвойства.Вставить("НачалоПериода", Период);
		ДополнительныеСвойства.Вставить("КонецПериода" , БухгалтерскиеОтчетыКлиентСервер.КонецПериода(Период, Периодичность));
	Иначе
		ДополнительныеСвойства.Вставить("НачалоПериода", ОтчетОбъект.НачалоПериода);
		ДополнительныеСвойства.Вставить("КонецПериода" , ОтчетОбъект.КонецПериода);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПоказательРасход"     , Ложь);
	ДополнительныеСвойства.Вставить("ПоказательПоступление", Истина);
	
	ДополнительныеСвойства.Вставить("КлючВарианта", "АнализДвиженийДенежныхСредств");	
	
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("АнализДвиженийДенежныхСредств", "Анализ движений денежных средств");
	
	НастройкиРасшифровки = Новый Структура;
	НастройкиРасшифровки.Вставить("АнализДвиженийДенежныхСредств", ПользовательскиеНастройки);
		
	ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеОбъекта, Адрес);
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","ПоступленияДенежныхСредств", "Поступления денежных средств"));
	
	Возврат Массив;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


#КонецЕсли
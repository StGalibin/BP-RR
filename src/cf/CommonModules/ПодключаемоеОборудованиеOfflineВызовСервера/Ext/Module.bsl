﻿
#Область ПрограммныйИнтерфейс

// Функция получает параметры устройства.
//
Функция ПолучитьПараметрыУстройства(Устройство) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.УзелОбмена КАК УзелИнформационнойБазы,
	|	ОборудованиеПоОрганизациям.Организация,
	|	ОборудованиеПоОрганизациям.Склад
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &Устройство";
	
	Запрос.УстановитьПараметр("Устройство", Устройство);
	
	Выборка = Запрос.Выполнить().Выбрать();
		
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("УзелИнформационнойБазы",         Выборка.УзелИнформационнойБазы);
	ВозвращаемоеЗначение.Вставить("Склад",                          Выборка.Склад);
	ВозвращаемоеЗначение.Вставить("Организация",                    Выборка.Организация);
	ВозвращаемоеЗначение.Вставить("ТипЦен",                         ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Склад, "ТипЦенРозничнойТорговли"));
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Процедура вызывается при очистке товаров в устройстве.
// Выполняет запись информации в узел плана обмена.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Процедура ПриОчисткеТоваровВУстройстве(Устройство, ВыполненоУспешно = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.УзелОбмена КАК УзелИнформационнойБазы,
	|	ОборудованиеПоОрганизациям.Склад
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &Устройство");
	
	Запрос.УстановитьПараметр("Устройство", Устройство);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		УзелОбъект = Выборка.УзелИнформационнойБазы.ПолучитьОбъект();
		УзелОбъект.ДатаВыгрузки      = ТекущаяДатаСеанса();
		УзелОбъект.ВыгрузкаВыполнена = ВыполненоУспешно;
		УзелОбъект.Записать();
		
		ПараметрыОбъекта = Новый Структура("УзелОбмена, Склад", УзелОбъект.Ссылка, Выборка.Склад);
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор());
		
		ДлительныеОперации.ВыполнитьВФоне("ПланыОбмена.ОбменСПодключаемымОборудованиемOffline.ОбновитьРегистрКодовНоменклатуры",
				ПараметрыОбъекта, ПараметрыВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при выгрузке товаров в устройство.
// Выполняет запись информации в узел плана обмена.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Процедура ПриВыгрузкеТоваровВУстройство(Устройство, СтруктураДанные, ВыгружатьИзменения, ВыполненоУспешно = Истина, РасширеннаяВыгрузка = Ложь) Экспорт
	
	Если (НЕ ВыполненоУспешно) 
		ИЛИ СтруктураДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.УзелОбмена КАК УзелИнформационнойБазы,
	|	ОборудованиеПоОрганизациям.Склад
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &Устройство");
	
	Запрос.УстановитьПараметр("Устройство", Устройство);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если ВыгружатьИзменения Тогда
			
			Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
			Для Каждого СтрокаТЧ Из СтруктураДанные.Данные Цикл
				
				Набор.Отбор.Код.Значение = СтрокаТЧ.Код;
				Набор.Отбор.Код.Использование = Истина;
				
				ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.УзелИнформационнойБазы, Набор);
				
			КонецЦикла;
			
		Иначе
			
			ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.УзелИнформационнойБазы);
			
		КонецЕсли;
		
		УзелОбъект = Выборка.УзелИнформационнойБазы.ПолучитьОбъект();
		УзелОбъект.ДатаВыгрузки      = ТекущаяДата();
		УзелОбъект.ВыгрузкаВыполнена = ВыполненоУспешно;
		УзелОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при загрузке отчета о розничных продажах с устройства.
// Выполняет запись информации в узел плана обмена. Создает отчет о розничных продажах.
//
// Параметры:
//  Устройство       - <СправочникСсылка.ПодключаемоеОборудование>
//  ВыполненоУспешно - <Булево> Признак успешного выполнения операции.
//
// Возвращаемое значение:
//  Нет
//
Функция ПриЗагрузкеОтчетаОРозничныхПродажах(Устройство, МассивДанных, РасширеннаяЗагрузка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивСозданныхДокументов = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОборудованиеПоОрганизациям.УзелОбмена КАК УзелИнформационнойБазы,
	|	ОборудованиеПоОрганизациям.Склад,
	|	ОборудованиеПоОрганизациям.Организация,
	|	ОборудованиеПоОрганизациям.Оборудование КАК Устройство
	|ИЗ
	|	РегистрСведений.ОборудованиеПоОрганизациям КАК ОборудованиеПоОрганизациям
	|ГДЕ
	|	ОборудованиеПоОрганизациям.Оборудование = &Устройство");
	
	Запрос.УстановитьПараметр("Устройство", Устройство);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаТоваров   = НовыйТаблицаТоваров();
	ТаблицаВозвратов = НовыйТаблицаТоваров();
	
	Если РасширеннаяЗагрузка Тогда
		
		ТаблицаОплат = Новый ТаблицаЗначений;
		ТаблицаОплат.Колонки.Добавить("КодВидаОплаты", Новый ОписаниеТипов("Строка"));
		ТаблицаОплат.Колонки.Добавить("Сумма",         Новый ОписаниеТипов("Число"));
		ТаблицаОплат.Колонки.Добавить("ТипОплаты",     Новый ОписаниеТипов("Число"));
		
		Для Каждого ОтчетОПродажах Из МассивДанных Цикл
			
			ТаблицаТоваров.Очистить();
			
			Для Каждого СтрокаТЧ Из ОтчетОПродажах.Товары Цикл
				НоваяСтрока = ТаблицаТоваров.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			КонецЦикла;
			
			ТаблицаТоваров.Свернуть("Код, Цена, Скидка", "Количество, Сумма");
			
			Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
				Если СтрокаТЧ.Количество < 0 Тогда
					НоваяСтрокаВозврата = ТаблицаВозвратов.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаВозврата, СтрокаТЧ,,"Количество, Сумма");
					НоваяСтрокаВозврата.Количество = -СтрокаТЧ.Количество;
					НоваяСтрокаВозврата.Сумма = ?(СтрокаТЧ.Сумма > 0, СтрокаТЧ.Сумма, -СтрокаТЧ.Сумма);
				КонецЕсли;
			КонецЦикла;
			
			ТаблицаОплат.Очистить();
			Для Каждого СтрокаТЧ Из ОтчетОПродажах.Оплаты Цикл
				НоваяСтрока = ТаблицаОплат.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			КонецЦикла;
			
			ТаблицаОплат.Свернуть("КодВидаОплаты, ТипОплаты", "Сумма");
			
			Комментарий = СформироватьКомментарий(Устройство);
			
			ТаблицыДанных = Новый Структура("Товары, Оплаты, ВозвратыТоваров");
			ТаблицыДанных.Товары = ТаблицаТоваров;
			ТаблицыДанных.Оплаты = ТаблицаОплат;
			ТаблицыДанных.ВозвратыТоваров = ТаблицаВозвратов;
			
			СоздатьИЗаполнитьОтчетОПродажах(МассивСозданныхДокументов, Выборка, ТаблицыДанных, Комментарий);
			
		КонецЦикла;
		
	Иначе
		
		Для каждого СтрокаТЧ Из МассивДанных Цикл
			НоваяСтрока = ТаблицаТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ, "Код, Цена, Количество, Скидка, Сумма, ОтменаОплаты");
		КонецЦикла;
		ТаблицаТоваров.Свернуть("Код, Цена, Скидка", "Количество, Сумма");
		
		ТаблицыДанных = Новый Структура("Товары, Оплаты, ВозвратыТоваров");
		ТаблицыДанных.Товары = ТаблицаТоваров;
		
		Комментарий = СформироватьКомментарий(Устройство);
		СоздатьИЗаполнитьОтчетОПродажах(МассивСозданныхДокументов, Выборка, ТаблицыДанных, Комментарий);
		
	КонецЕсли;
	
	Возврат МассивСозданныхДокументов;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейсВыгрузкаТоваров

// Функция возвращает таблицу товаров с данными к выгрузке в устройство.
//
// Параметры:
//  Устройство - <СправочникСсылка.ПодключаемоеОборудование> - Устройство для которого необходимо получить данные.
//  ТолькоИзмененные - <Булево> - Флаг получения только измененных данных.
//  ОбновитьКодыТоваров - <Булево> - Флаг обновления кодов товаров перед получением данных.
//
// Возвращаемое значение:
//  <ТаблицаЗначений> товаров к выгрузке.
//
Функция ПолучитьТоварыКВыгрузке(Устройство, Параметры, ОбновитьКодыТоваров = Ложь) Экспорт
	
	ВыгружатьГруппыТоваров = ?(Параметры.Свойство("ВыгружатьГруппыТоваров"), Параметры.ВыгружатьГруппыТоваров, Ложь);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КодыТоваровПодключаемогоОборудованияOffline.Код КАК Код,
	|	СправочникНоменклатура.Наименование КАК Наименование,
	|	СправочникНоменклатура.НаименованиеПолное КАК НаименованиеПолное,
	|	СправочникНоменклатура.Артикул КАК Артикул,
	|	СправочникНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СправочникНоменклатура.СтавкаНДС КАК СтавкаНДС,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод,
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	СправочникНоменклатура.ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмеренияНаименование,
	|	КодыТоваровПодключаемогоОборудованияOffline.Используется КАК Используется
	|ИЗ
	|	РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = СправочникНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline.Изменения КАК КодыТоваровПодключаемогоОборудованияOfflineИзменения
	|		ПО (КодыТоваровПодключаемогоОборудованияOffline.Код = КодыТоваровПодключаемогоОборудованияOfflineИзменения.Код
	|			И КодыТоваровПодключаемогоОборудованияOfflineИзменения.Узел = &УзелИнформационнойБазы)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ШтрихкодыНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ПериодЦен, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО КодыТоваровПодключаемогоОборудованияOffline.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
	|ГДЕ
	|	ЦеныНоменклатурыСрезПоследних.Цена <> 0
	|	И НЕ СправочникНоменклатура.ЭтоГруппа
	|//ТолькоИзмененные И КодыТоваровПодключаемогоОборудованияOfflineИзменения.Узел = &УзелИнформационнойБазы
	|
	|ИТОГИ
	|	МАКСИМУМ(Штрихкод)
	|ПО
	|	Код"); 
	
	Если Параметры.ЧастичнаяВыгрузка Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"//ТолькоИзмененные","");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", Параметры.УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("ТипЦен",                	Параметры.ТипЦен);
	Запрос.УстановитьПараметр("ПериодЦен",            	КонецДня(ТекущаяДата()));
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Используется",       			Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить("Код", 							Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Артикул", 						Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Номенклатура", 				Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТоваров.Колонки.Добавить("ЕдиницаИзмерения", 			Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("ЕдиницаИзмеренияНаименование", Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Наименование", 				Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("НаименованиеПолное", 			Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Штрихкод", 					Новый ОписаниеТипов("Строка"));
	ТаблицаТоваров.Колонки.Добавить("Цена", 						Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
	ТаблицаТоваров.Колонки.Добавить("Весовой", 						Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить("ЕстьОшибки", 					Новый ОписаниеТипов("Булево"));
	ТаблицаТоваров.Колонки.Добавить("СтавкаНДС", 					Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС"));
	ТаблицаТоваров.Колонки.Добавить("УникальныйИдентификатор", 		Новый ОписаниеТипов("Строка"));
	
	ВыборкаПоКодам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоКодам.Следующий() Цикл
		
		НоваяСтрока = ТаблицаТоваров.Добавить();
		Выборка = ВыборкаПоКодам.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Штрихкод = СокрЛП(Выборка.Штрихкод);
			Если Не ЗначениеЗаполнено(НоваяСтрока.Код) Тогда
				
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка, , "Штрихкод");
				НоваяСтрока.Весовой                     = Ложь;
				НоваяСтрока.Штрихкод                    = Штрихкод;
				НоваяСтрока.УникальныйИдентификатор     = Выборка.Номенклатура.УникальныйИдентификатор();
				
			Иначе
				НоваяСтрока.Штрихкод = НоваяСтрока.Штрихкод + "," + Штрихкод;
			КонецЕсли;
		КонецЦикла;
		
		Если НоваяСтрока.Цена = 0 Тогда
			НоваяСтрока.ЕстьОшибки = Истина;
		КонецЕсли;		
	КонецЦикла;
	
	Возврат ТаблицаТоваров;
	
КонецФункции

// Функция возвращает структуру с данными в формате, необходимом для выгрузки списка товаров в ККМ Offline.
//
// Параметры:
//  Устройство - <СправочникСсылка.ПодключаемоеОборудование> - Устройство для которого необходимо получить данные.
//  ТолькоИзмененные - <Булево> - Флаг получения только измененных данных.
//
// Возвращаемое значение:
//  <Структура> с массивом структур для выгрузки и количеством не выгруженных строк.
//
Функция ПолучитьДанныеДляКассы(Устройство, ТолькоИзмененные = Истина, РасширеннаяВыгрузка = Ложь) Экспорт
	
	Параметры = ПолучитьПараметрыУстройства(Устройство);
	Если Параметры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Параметры.Вставить("ЧастичнаяВыгрузка"     , ТолькоИзмененные);
	Параметры.Вставить("ВыгружатьГруппыТоваров", Ложь);
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Данные", Новый Массив());
	ВозвращаемоеЗначение.Вставить("КоличествоНеВыгруженныхСтрокСОшибками", 0);
	ВозвращаемоеЗначение.Вставить("ЧастичнаяВыгрузка", ТолькоИзмененные);
	ВозвращаемоеЗначение.Вставить("Параметры", Параметры);
	ВозвращаемоеЗначение.Вставить("РасширеннаяВыгрузка", РасширеннаяВыгрузка);
	
	Таблица = ПолучитьТоварыКВыгрузке(Устройство, Параметры, Истина);
	
	Для Каждого СтрокаТЧ Из Таблица Цикл
		
		Если СтрокаТЧ.ЕстьОшибки Тогда
			ВозвращаемоеЗначение.КоличествоНеВыгруженныхСтрокСОшибками = ВозвращаемоеЗначение.КоличествоНеВыгруженныхСтрокСОшибками + 1;
			Продолжить;
		КонецЕсли;
		
		ЭлементМассива = Новый Структура;
		ЭлементМассива.Вставить("Код",					СтрокаТЧ.Код);
		ЭлементМассива.Вставить("Штрихкод",				СтрокаТЧ.Штрихкод);
		ЭлементМассива.Вставить("Наименование",			СтрокаТЧ.Наименование);
		ЭлементМассива.Вставить("НаименованиеПолное",	СтрокаТЧ.НаименованиеПолное);
		ЭлементМассива.Вставить("ЕдиницаИзмерения",		СтрокаТЧ.ЕдиницаИзмеренияНаименование);
		ЭлементМассива.Вставить("Артикул",				СтрокаТЧ.Артикул);
		ЭлементМассива.Вставить("Цена",					СтрокаТЧ.Цена);
		ЭлементМассива.Вставить("Остаток",				0);
		ЭлементМассива.Вставить("ВесовойТовар",			Ложь);
		ЭлементМассива.Вставить("СтавкаНДС",			УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(СтрокаТЧ.СтавкаНДС));
		
		ВозвращаемоеЗначение.Данные.Добавить(ЭлементМассива);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейсВыгрузкаНастроек

// Функция возвращает настройки для экземпляра оборудования.
//
Функция ПолучитьНастройкиДляККМОффлайн(Устройство) Экспорт
	
	СтруктураНастроек 	= МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруНастроек();
	
	Параметры = ПолучитьПараметрыУстройства(Устройство);
	Если Параметры = Неопределено Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат СтруктураНастроек;
	КонецЕсли;
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, ТекущаяДатаСеанса());
	СтруктураНастроек.НазваниеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	СтруктураНастроек.ИНН                 = СведенияОбОрганизации.ИНН;
		
	СистемаНалогообложения = УчетнаяПолитика.СистемаНалогообложения(Организация, ТекущаяДатаСеанса());
	
	Если СистемаНалогообложения = Перечисления.СистемыНалогообложения.ОсобыйПорядок Тогда
		СтруктураНастроек.Налогообложение = НСтр("ru = 'Патент или ЕНВД'");
	Иначе
		СтруктураНастроек.Налогообложение = Строка(СистемаНалогообложения);
	КонецЕсли;
	
	СтруктураНастроек.ИспользоватьСкидки          = Истина;
	СтруктураНастроек.ИспользоватьБанковскиеКарты = Ложь;
	
	ТаблицаВидовОплат = ПолучитьТаблицуВидовОплат(Устройство);
	ВидыОплаты = Новый Массив;
	
	Для Каждого СтрокаВидаОплаты Из ТаблицаВидовОплат Цикл
		
		ВидОплаты = Новый Структура("Код, ТипОплаты, Наименование");
		ЗаполнитьЗначенияСвойств(ВидОплаты, СтрокаВидаОплаты);
		ВидыОплаты.Добавить(ВидОплаты);
		
		Если СтрокаВидаОплаты.ТипОплаты = 1 Тогда
			СтруктураНастроек.ИспользоватьБанковскиеКарты = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураНастроек.Вставить("ВидыОплаты", ВидыОплаты);
	СформироватьСпискиНалоговИКомбинацийНалогов(СтруктураНастроек);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьИЗаполнитьОтчетОПродажах(МассивСозданныхДокументов, РеквизитыККМ, ТаблицыДанных, Комментарий = "")
	
	СтруктураПараметровДокумента = Новый Структура();
	СтруктураПараметровДокумента.Вставить("Организация", 	РеквизитыККМ.Организация);
	СтруктураПараметровДокумента.Вставить("Склад", 			РеквизитыККМ.Склад);
	СтруктураПараметровДокумента.Вставить("ВидОперации",	Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах);
	СтруктураПараметровДокумента.Вставить("Комментарий", 	Комментарий);
	СтруктураПараметровДокумента.Вставить("Ответственный", 	Пользователи.ТекущийПользователь());
	
	ОтчетОРозничныхПродажахОбъект = Документы.ОтчетОРозничныхПродажах.СоздатьДокумент();
	ОтчетОРозничныхПродажахОбъект.Заполнить(СтруктураПараметровДокумента);
	ОтчетОРозничныхПродажахОбъект.Дата = ТекущаяДатаСеанса();
	
	ВыборкаПоТоварам = ПолучитьВыборкуНоменклатурыПоКоду(ТаблицыДанных.Товары);
	
	Пока ВыборкаПоТоварам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТоварам.Количество > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ОтчетОРозничныхПродажахОбъект.Товары.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоТоварам, "Номенклатура, Количество, Сумма, СтавкаНДС");
		
		НоваяСтрока.Цена = ?(НоваяСтрока.Количество = 0, НоваяСтрока.Сумма, НоваяСтрока.Сумма / НоваяСтрока.Количество);
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ОтчетОРозничныхПродажахОбъект.СуммаВключаетНДС);
		
	КонецЦикла;
	
	Если (НЕ ТаблицыДанных.ВозвратыТоваров = Неопределено) 
		И (ТаблицыДанных.ВозвратыТоваров.Количество() > 0) Тогда
		
		СтруктураПараметровДокумента = Новый Структура();
		СтруктураПараметровДокумента.Вставить("Организация", 	РеквизитыККМ.Организация);
		СтруктураПараметровДокумента.Вставить("Склад", 			РеквизитыККМ.Склад);
		СтруктураПараметровДокумента.Вставить("ВидОперации",	Перечисления.ВидыОперацийВозвратТоваровОтПокупателя.ПродажаКомиссия);
		СтруктураПараметровДокумента.Вставить("Комментарий", 	Комментарий);
		СтруктураПараметровДокумента.Вставить("Ответственный", 	Пользователи.ТекущийПользователь());
		
		ВозвратТоваровОтПокупателя = Документы.ВозвратТоваровОтПокупателя.СоздатьДокумент();
		ВозвратТоваровОтПокупателя.Заполнить(СтруктураПараметровДокумента);
		ВозвратТоваровОтПокупателя.Дата = ТекущаяДатаСеанса();
		
		ВозвратТоваровОтПокупателя.СчетУчетаРасчетовПоАвансам = ПланыСчетов.Хозрасчетный.КассаОрганизации;
		
		ВыборкаПоВозвратам = ПолучитьВыборкуНоменклатурыПоКоду(ТаблицыДанных.ВозвратыТоваров);
		
		Пока ВыборкаПоВозвратам.Следующий() Цикл
			
			Если НЕ ВыборкаПоВозвратам.Количество > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ВозвратТоваровОтПокупателя.Товары.Добавить();
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоВозвратам, "Номенклатура, Количество, Сумма, СтавкаНДС");
		
			НоваяСтрока.Цена = ?(НоваяСтрока.Количество = 0, НоваяСтрока.Сумма, НоваяСтрока.Сумма / НоваяСтрока.Количество);
			ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ОтчетОРозничныхПродажахОбъект.СуммаВключаетНДС);
			
		КонецЦикла;
	Иначе
		ВозвратТоваровОтПокупателя = Неопределено;
	КонецЕсли;
	
	Если НЕ ТаблицыДанных.Оплаты = Неопределено Тогда
		
		ТаблицаВидовОплат = ПолучитьТаблицуВидовОплат(РеквизитыККМ.Устройство);
		
		Для Каждого Оплата ИЗ ТаблицыДанных.Оплаты Цикл
			
			ВидОплаты = ТаблицаВидовОплат.Найти(Оплата.КодВидаОплаты, "Код");
			
			Если ВидОплаты = Неопределено 
				ИЛИ ВидОплаты.ТипОплаты = 0 
				ИЛИ Оплата.Сумма = 0 Тогда
				
				Продолжить;
				
			ИначеЕсли ВидОплаты.ТипОплаты  > 0 Тогда
				
				ОплатаПлатежнойКартой = ОтчетОРозничныхПродажахОбъект.Оплата.Добавить();
				ОплатаПлатежнойКартой.СуммаОплаты = Оплата.Сумма;
				ОплатаПлатежнойКартой.ВидОплаты = ВидОплаты.Ссылка;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОтчетОРозничныхПродажахОбъект.ДополнительныеСвойства.Вставить("ЗаполнитьСчетаУчетаПередЗаписью", Истина);
	
	Попытка
		Если ОтчетОРозничныхПродажахОбъект.ПроверитьЗаполнение() Тогда
			ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	Исключение
		ОтчетОРозничныхПродажахОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
	
	Если НЕ ВозвратТоваровОтПокупателя = Неопределено Тогда
		ВозвратТоваровОтПокупателя.ДополнительныеСвойства.Вставить("ЗаполнитьСчетаУчетаПередЗаписью", Истина);
		Попытка
			Если ВозвратТоваровОтПокупателя.ПроверитьЗаполнение() Тогда
				ВозвратТоваровОтПокупателя.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				ВозвратТоваровОтПокупателя.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		Исключение
			ВозвратТоваровОтПокупателя.Записать(РежимЗаписиДокумента.Запись);
		КонецПопытки;
	КонецЕсли;
	
	УзелОбъект = РеквизитыККМ.УзелИнформационнойБазы.ПолучитьОбъект();
	УзелОбъект.ДатаЗагрузки = ТекущаяДатаСеанса();
	УзелОбъект.Записать();
	
	МассивСозданныхДокументов.Добавить(ОтчетОРозничныхПродажахОбъект.Ссылка);
	Если НЕ ВозвратТоваровОтПокупателя = Неопределено Тогда
		МассивСозданныхДокументов.Добавить(ВозвратТоваровОтПокупателя.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСпискиНалоговИКомбинацийНалогов(Настройки)
	
	// Один налог +
	НДС = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваНалоги();
	НДС.Код = "1";
	НДС.Наименование = "НДС";
	
	// 18%
	ШаблонСтавкиНалога = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваСтавкиНалогов();
	ШаблонСтавкиНалога.Код = 1;
	ШаблонСтавкиНалога.Текст = "НДС 18%";
	ШаблонСтавкиНалога.Значение = 18;
	НДС.Ставки.Добавить(ШаблонСтавкиНалога);
	// 10%
	ШаблонСтавкиНалога = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваСтавкиНалогов();
	ШаблонСтавкиНалога.Код = 2;
	ШаблонСтавкиНалога.Текст = "НДС 10%";
	ШаблонСтавкиНалога.Значение = 10;
	НДС.Ставки.Добавить(ШаблонСтавкиНалога);
	
	// Без НДС
	ШаблонСтавкиНалога = МенеджерОборудованияСервисыКлиентСервер.ПолучитьСтруктуруЗаписиМассиваСтавкиНалогов();
	ШаблонСтавкиНалога.Код = 3;
	ШаблонСтавкиНалога.Текст = "Без НДС";
	ШаблонСтавкиНалога.Значение = 0;
	НДС.Ставки.Добавить(ШаблонСтавкиНалога);
	
	Настройки.Налоги.Добавить(НДС);  // а НДС 0%
	// Один налог -
	
КонецПроцедуры

Функция СформироватьКомментарий(Устройство)
	
	Комментарий = СтрШаблон(НСтр("ru = 'Загружено из %1:%2'"), Устройство.ТипОборудования, Устройство);
	
	Возврат Комментарий;
	
КонецФункции

Функция ПолучитьВыборкуНоменклатурыПоКоду(ТаблицаТоваров)
	
	Запрос = Новый Запрос(
	
	"ВЫБРАТЬ
	|	Товары.Код КАК Код,
	|	Товары.Цена КАК Цена,
	|	Товары.Количество КАК Количество,
	|	Товары.Скидка КАК Скидка,
	|	Товары.Сумма КАК Сумма
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&ТаблицаЗначений КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(КодыТоваровПодключаемогоОборудованияOffline.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
	|	ЕСТЬNULL(КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.ЕдиницаИзмерения, ЗНАЧЕНИЕ(Справочник.КлассификаторЕдиницИзмерения.ПустаяСсылка)) КАК ЕдиницаИзмерения,
	|	Товары.Количество КАК Количество,
	|	Товары.Цена КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	Товары.Скидка КАК ПроцентРучнойСкидки,
	|	ЕСТЬNULL(КодыТоваровПодключаемогоОборудованияOffline.Номенклатура.СтавкаНДС, ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.БезНДС)) КАК СтавкаНДС
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline КАК КодыТоваровПодключаемогоОборудованияOffline
	|		ПО Товары.Код = КодыТоваровПодключаемогоОборудованияOffline.Код");
	
	Запрос.УстановитьПараметр("ТаблицаЗначений", ТаблицаТоваров);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция НовыйТаблицаТоваров()
	
	ТаблицаТоваров = Новый ТаблицаЗначений;
	ТаблицаТоваров.Колонки.Добавить("Код",        Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Цена",       Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Скидка",     Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("Сумма",      Новый ОписаниеТипов("Число"));
	ТаблицаТоваров.Колонки.Добавить("ШтрихкодАлкогольнойМарки", Новый ОписаниеТипов("Строка"));
	
	Возврат ТаблицаТоваров;
	
КонецФункции

Функция ПолучитьТаблицуВидовОплат(Устройство)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КодыВидовОплатыКММ.ВидОплаты.ТипОплаты.Порядок КАК ТипОплаты,
	|	КодыВидовОплатыКММ.ВидОплаты КАК Ссылка,
	|	КодыВидовОплатыКММ.ВидОплаты.Наименование КАК Наименование,
	|	КодыВидовОплатыКММ.Код КАК Код
	|ИЗ
	|	РегистрСведений.КодыВидовОплатыКММ КАК КодыВидовОплатыКММ
	|ГДЕ
	|	КодыВидовОплатыКММ.Оборудование = &Оборудование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код,
	|	ТипОплаты";
	
	Запрос.УстановитьПараметр("Оборудование", Устройство);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	ВидыОплаты = Новый ТаблицаЗначений;
	ВидыОплаты.Колонки.Добавить("Наименование",       			Новый ОписаниеТипов("Строка"));
	ВидыОплаты.Колонки.Добавить("ТипОплаты",					Новый ОписаниеТипов("Число"));
	ВидыОплаты.Колонки.Добавить("Ссылка",						Новый ОписаниеТипов("СправочникСсылка.ВидыОплатОрганизаций"));
	ВидыОплаты.Колонки.Добавить("Код", 							Новый ОписаниеТипов("Строка"));
	
	ВидОплаты 				= ВидыОплаты.Добавить();
	ВидОплаты.Код 			= Строка(1);
	ВидОплаты.ТипОплаты 	= 0; 
	ВидОплаты.Наименование 	= НСтр("ru = 'Наличные'");
	
	Пока Результат.Следующий() Цикл
		
		ВидОплаты 				= ВидыОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(ВидОплаты, Результат);
		
	КонецЦикла;
	
	Возврат ВидыОплаты;
	
КонецФункции

#КонецОбласти

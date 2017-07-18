﻿////////////////////////////////////////////////////////////////////////////////
// Обмен Управление небольшой фирмой 1.3 и Бухгалтерия предприятия 3.0 

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеНебольшойФирмойБухгалтерия30ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеНебольшойФирмойБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен 1С-КАМИН Зарплата 5.0 и Бухгалтерия предприятия 3.0 

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура Обмен1СКЗБухгалтерия30ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("Обмен1С_КАМИН_ЗарплатаБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура Обмен1СКЗБухгалтерия30ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Обмен1С_КАМИН_ЗарплатаБухгалтерия30", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура Обмен1СКЗБухгалтерия30ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("Обмен1С_КАМИН_ЗарплатаБухгалтерия30", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен Управление торговлей 10.3 и Бухгалтерия предприятия 3.0

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеТорговлей103БухгалтерияПредприятия30ЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеТорговлей103БухгалтерияПредприятия30", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменУправлениеТорговлей103БухгалтерияПредприятия30ЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеТорговлей103БухгалтерияПредприятия30", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеТорговлей103БухгалтерияПредприятия30ЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеТорговлей103БухгалтерияПредприятия30", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменУправлениеТорговлей103БухгалтерияПредприятия30ЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеТорговлей103БухгалтерияПредприятия30", Источник, Отказ);
	
КонецПроцедуры

// Добавляет к префиксу номера или кода подстроку
// Функция может быть использована в обработчиках событий, программный код 
// которых хранится в правила обмена данными. Вызывается методом Выполнить()
// Сообщение "Не обнаружено ссылок на функцию" при проверке конфигурации 
// не является ошибкой проверки конфигурации
//
// Параметры:
//  Стр          - Строка. Номер или код;
//  Добавок      - добавляемая к префиксу подстрока;
//  Длина        - требуемая результирующая длина строки;
//  Режим        - "Слева" - подстрока добавляется слева к префиксу, иначе - справа.
//
// Возвращаемое значение:
//  Строка       - номер или код, к префиксу которого добавлена указанная подстрока.
//
Функция ДобавитьКПрефиксу(Знач Стр, Добавок = "", Длина = "", Режим = "Слева",
	НеДобавлятьПрефиксЕслиСНегоНачинаетсяНомер = Ложь,
	ОбрезатьЧисловуюЧастьСлеваВСлучаеПревышенияНомера = Ложь) Экспорт

	Стр = СокрЛП(Формат(Стр,"ЧГ=0"));
	
	Если ПустаяСтрока(Длина) Тогда
		Длина = СтрДлина(Стр);
	КонецЕсли;

	ЧисловаяЧасть   = "";
	Префикс         = ПолучитьПрефиксЧислоНомера(Стр, ЧисловаяЧасть);
	ДополнениеКПрефиксу = СокрЛП(Добавок);
	
	Если НеДобавлятьПрефиксЕслиСНегоНачинаетсяНомер Тогда
		
		Если Найти(Префикс, ДополнениеКПрефиксу) = 1 Тогда
			Возврат Стр;
		КонецЕсли;
		
	КонецЕсли;

	Если Режим = "Слева" Тогда
		Результат = ДополнениеКПрефиксу + Префикс;
	Иначе
		Результат = Префикс + ДополнениеКПрефиксу;
	КонецЕсли;
	
	СтрокаЧисловойЧасти = Формат(ЧисловаяЧасть, "ЧГ=0");
	ДлинаЧисловойЧасти = СтрДлина(СтрокаЧисловойЧасти);
	ДлинаПрефикса = СтрДлина(Результат);
	
	Для НомерДобавления = 1 По Длина - ДлинаПрефикса - ДлинаЧисловойЧасти Цикл
	    Результат = Результат + "0";
	КонецЦикла;
	
	Если ОбрезатьЧисловуюЧастьСлеваВСлучаеПревышенияНомера 
		И ДлинаПрефикса + ДлинаЧисловойЧасти > Длина Тогда
		
		КоличествоСимволовУрезанияЧисловойЧасти = ДлинаЧисловойЧасти - Длина + ДлинаПрефикса;
		Если КоличествоСимволовУрезанияЧисловойЧасти > 0 Тогда
			СтрокаЧисловойЧасти = Сред(СтрокаЧисловойЧасти, КоличествоСимволовУрезанияЧисловойЧасти + 1);
		КонецЕсли;
		
	КонецЕсли;

	Результат = Результат + СтрокаЧисловойЧасти;

	Возврат Результат;

КонецФункции // ДобавитьКПрефиксу()

// Разбирает строку, выделяя из нее префикс и числовую часть.
//
// Параметры:
//  Стр            - Строка. Разбираемая строка;
//  ЧисловаяЧасть  - Число. Переменная, в которую возвратится числовая часть строки;
//  Режим          - Строка. Если "Число", то возвратит числовую часть, иначе - префикс.
//
// Возвращаемое значение:
//  Префикс строки
//
Функция ПолучитьПрефиксЧислоНомера(Знач Стр, ЧисловаяЧасть = "", Режим = "")

	ЧисловаяЧасть = 0;
	Префикс = "";
	Стр = СокрЛП(Стр);
	Длина   = СтрДлина(Стр);
	
	СтроковыйНомерБезПрефикса = ПолучитьСтроковыйНомерБезПрефиксов(Стр);
	ДлинаСтроковойЧасти = СтрДлина(СтроковыйНомерБезПрефикса);
	Если ДлинаСтроковойЧасти > 0 Тогда
		ЧисловаяЧасть = Число(СтроковыйНомерБезПрефикса);
		Префикс = Сред(Стр, 1, Длина - ДлинаСтроковойЧасти);
	Иначе
		Префикс = Стр;	
	КонецЕсли;

	Если Режим = "Число" Тогда
		Возврат(ЧисловаяЧасть);
	Иначе
		Возврат(Префикс);
	КонецЕсли;

КонецФункции // ПолучитьПрефиксЧислоНомера()

Функция ПолучитьСтроковыйНомерБезПрефиксов(Номер)
	
	НомерБезПрефиксов = "";
	Сч = СтрДлина(Номер);
	
	Пока Сч > 0 Цикл
		
		Символ = Сред(Номер, Сч, 1);
		
		Если (Символ >= "0" И Символ <= "9") Тогда
			
			НомерБезПрефиксов = Символ + НомерБезПрефиксов;
			
		Иначе
			
			Возврат НомерБезПрефиксов;
			
		КонецЕсли;
		
		Сч = Сч - 1;
		
	КонецЦикла;
	
	Возврат НомерБезПрефиксов;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обмен Зарплата и управление персоналом 3.0 и Бухгалтерия предприятия 3.0

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменЗарплата3Бухгалтерия3ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменЗарплата3Бухгалтерия3", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменЗарплата3Бухгалтерия3ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменЗарплата3Бухгалтерия3", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
// 
Процедура ОбменЗарплата3Бухгалтерия3ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменЗарплата3Бухгалтерия3", Источник, Отказ, Замещение);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
// 
Процедура ОбменЗарплата3Бухгалтерия3ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменЗарплата3Бухгалтерия3", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Выгрузка/загрузка данных в сервисе

// Процедура-обработчик события "ПередЗагрузкойОбъекта" для механизма выгрузки/загрузки данных в сервисе
// Описание параметров см. в комментарии к ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных
// 
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	Объект.ДополнительныеСвойства.Вставить("РегистрироватьДанныеПервичныхДокументов", Ложь);
	
КонецПроцедуры


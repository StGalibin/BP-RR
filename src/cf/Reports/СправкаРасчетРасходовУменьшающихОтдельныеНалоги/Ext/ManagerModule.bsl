﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",         Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",          Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",              Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",             Истина);
	Результат.Вставить("ИспользоватьПередВыводомЭлементаРезультата", Ложь);
	Результат.Вставить("ИспользоватьВнешниеНаборыДанных",            Истина);
	Результат.Вставить("ИспользоватьПривилегированныйРежим",         Истина);
	
	Возврат Результат;
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(
		ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения); 
		
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ТекстЗаголовка = Нстр("ru = 'Справка-расчет расходов, уменьшающих %1 %2'");
	
	ИмяНалога = ПараметрыОтчета.Налог;
	Если ПараметрыОтчета.Налог = "УСН" Тогда
		ИмяНалога = Нстр("ru = 'налог %1'");
		ИмяНалога = СтрШаблон(ИмяНалога, ПараметрыОтчета.Налог);
	КонецЕсли;
	
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоКвартала(ПараметрыОтчета.НачалоПериода), ПараметрыОтчета.КонецПериода);
	
	ТекстЗаголовка = СтрШаблон(ТекстЗаголовка, ИмяНалога, ПредставлениеПериода);
	Возврат ТекстЗаголовка;
	
КонецФункции

Функция ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки) Экспорт

	Возврат Новый Структура("КлассификацияРасходов", УчетРасходовУменьшающихОтдельныеНалоги.СчетаРасходовУменьшающихНалог());

КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	// Устанавливаем параметры отчета
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
			"НачалоПериода", НачалоКвартала(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
			"КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Налог", ПараметрыОтчета.Налог);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ЗаголовокДобровольноеСтрахование", Нстр("ru = 'Добровольное страхование'"));
	
	ГруппировкиСтраховыхВзносов = НайтиГруппировкуПоИмени(
		КомпоновщикНастроек.Настройки.Структура, "ТаблицаСтраховыхВзносов").Строки;
	Если ВыводитьУпрощенныйВариантПоСтраховымВзносам(ПараметрыОтчета) Тогда
		ГруппировкиСтраховыхВзносов[0].Использование = Ложь;
		ГруппировкиСтраховыхВзносов[1].Использование = Истина;
		
		КомпоновщикНастроек.Настройки.Структура[0].Структура[1].Использование = Ложь;
	Иначе
		ГруппировкиСтраховыхВзносов[0].Использование = Истина;
		ГруппировкиСтраховыхВзносов[1].Использование = Ложь;
		
		КомпоновщикНастроек.Настройки.Структура[0].Структура[1].Использование = Истина;
	КонецЕсли;
	
	ГруппировкиПрочихВзносов = НайтиГруппировкуПоИмени(
		КомпоновщикНастроек.Настройки.Структура, "ТаблицаПрочихВзносов").Строки;
	Если ВыводитьУпрощенныйВариантПоФиксированнымВзносам(ПараметрыОтчета) Тогда
		ГруппировкиПрочихВзносов[0].Использование = Ложь;
		ГруппировкиПрочихВзносов[1].Использование = Истина;
	Иначе
		ГруппировкиПрочихВзносов[0].Использование = Истина;
		ГруппировкиПрочихВзносов[1].Использование = Ложь;
	КонецЕсли;
	
	// Отбор по виду расходов
	Если ЗначениеЗаполнено(ПараметрыОтчета.ВидРасходов) Тогда
		Для каждого ГруппировкаРасходов Из КомпоновщикНастроек.Настройки.Структура Цикл
			ГруппировкаРасходов.Использование = (ГруппировкаРасходов.Имя = "Заголовок"+ПараметрыОтчета.ВидРасходов);
		КонецЦикла;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Удаляем дубли итогов группировок для больничных и взносов ИП.
	Если Не ЗначениеЗаполнено(ПараметрыОтчета.ВидРасходов) Тогда
		ТелоБольничные = МакетКомпоновки.Тело[2];
		ГруппировкаОтчета = ТелоБольничные.Тело[1].Строки[0].Тело[1];
		ТелоБольничные.Тело[1].Строки[0].Тело.Удалить(ГруппировкаОтчета);
		
		ТелоВзносыИП = МакетКомпоновки.Тело[4];
		ГруппировкаОтчета = ТелоВзносыИП.Тело[1].Строки[0].Тело[1];
		ТелоВзносыИП.Тело[1].Строки[0].Тело.Удалить(ГруппировкаОтчета);
		
		ТелоДобровольноеСтрахование = МакетКомпоновки.Тело[6];
		ГруппировкаОтчета = ТелоДобровольноеСтрахование.Тело[1].Строки[0].Тело[1];
		ТелоДобровольноеСтрахование.Тело[1].Строки[0].Тело.Удалить(ГруппировкаОтчета);
	ИначеЕсли Не ПараметрыОтчета.ВидРасходов = "СтраховыеВзносы" Тогда
		ТелоГруппа1 = МакетКомпоновки.Тело[0];
		ГруппировкаОтчета = ТелоГруппа1.Тело[1].Строки[0].Тело[1];
		ТелоГруппа1.Тело[1].Строки[0].Тело.Удалить(ГруппировкаОтчета);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСлева = 0;
	Результат.ФиксацияСверху = 0;
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.УчетНалогиОтчетность82.Подсистемы.ЗакрытиеПериода.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.УчетНалогиОтчетность82.Подсистемы.ЗакрытиеПериода.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.БухгалтерскийИНалоговыйУчет, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.ПростойИнтерфейс.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты, "");
	КонецЦикла;	
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый Структура("Имя, Представление","СправкаРасчетРасходовУменьшающихОтдельныеНалоги", "Расчет расходов, уменьшающих налог УСН и ЕНВД"));
	
	Возврат Массив;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыводитьУпрощенныйВариантПоСтраховымВзносам(ПараметрыОтчета)
	
	ПлательщикУСН  = УчетнаяПолитика.ПрименяетсяУСН(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ПлательщикЕНВД = УчетнаяПолитика.ПлательщикЕНВД(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	ПрименяетсяТолькоУСН  = ПлательщикУСН И Не ПлательщикЕНВД;
	ПрименяетсяТолькоЕНВД = ПлательщикЕНВД И УчетнаяПолитика.ПрименяетсяОсобыйПорядокНалогообложения(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	Возврат ПрименяетсяТолькоУСН Или ПрименяетсяТолькоЕНВД;
	
КонецФункции

Функция ВыводитьУпрощенныйВариантПоФиксированнымВзносам(ПараметрыОтчета)
	
	ПлательщикЕНВД        = УчетнаяПолитика.ПлательщикЕНВД(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	ПрименяетсяТолькоЕНВД = ПлательщикЕНВД
		И УчетнаяПолитика.ПрименяетсяОсобыйПорядокНалогообложения(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	ЕНВДУменьшаетсяНаВзносыИПРаботодателей = УчетЕНВД.НалогУменьшаетсяНаФиксированныеВзносыИПРаботодателей(ПараметрыОтчета.КонецПериода);
	
	Если ЕНВДУменьшаетсяНаВзносыИПРаботодателей Тогда
		// С 2017 года фиксированные взносы всегда распределяются при совмещении ЕНВД с иными режимами
		Возврат ПрименяетсяТолькоЕНВД ИЛИ Не ПлательщикЕНВД;
	Иначе
		// До 2017 года фиксированные взносы не распределялись
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Возвращает элемент структуры настроек компоновки данных содержащий поле группировки с указанным именем
// Поиск осуществляется по указанной структуре и все ее подчиненным структурам,
// В случае неудачи возвращает Неопределено
//
// Параметры:
// - Структура 	- (ГруппировкаТаблицыКомпоновкиДанных или ГруппировкаКомпоновкиДанных, КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных) 
// 					Элемент структуры компоновки данных,
// - ИмяПоля 	- (Строка) Имя поля группировки
//
// Возвращаемое значение:
// ГруппировкаТаблицыКомпоновкиДанных, ГруппировкаКомпоновкиДанных, Неопределено
//
Функция НайтиГруппировкуПоИмени(Структура, ИмяПоля) Экспорт
	
	Для каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппировкаКомпоновкиДанных") 
			Или ТипЗнч(Элемент) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			
			Если Элемент.Имя = ИмяПоля Тогда
				Возврат Элемент;
			КонецЕсли;
			
			Группировка = НайтиГруппировкуПоИмени(Элемент.Структура, ИмяПоля);
			Если Группировка <> Неопределено тогда
				Прервать;
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = ИмяПоля Тогда
				Возврат Элемент;
			КонецЕсли;
			
			Для каждого ГруппировкаТаблицы Из Элемент.Строки Цикл
				Если ГруппировкаТаблицы.Имя = ИмяПоля Тогда
					Возврат ГруппировкаТаблицы;
				КонецЕсли;
				
				Группировка = НайтиГруппировкуПоИмени(ГруппировкаТаблицы.Структура, ИмяПоля);
				Если Группировка <> Неопределено тогда
					Прервать;
				КонецЕсли;
			
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

#КонецОбласти

#КонецЕсли
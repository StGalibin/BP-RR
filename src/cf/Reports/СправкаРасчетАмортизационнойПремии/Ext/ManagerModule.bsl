﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Ложь);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",     Истина);
	
	Возврат Результат;
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
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

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Справка-расчет амортизационной премии" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоГода(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоГода", НачалоГода(ПараметрыОтчета.КонецПериода));
	Иначе
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоГода", НачалоГода(ТекущаяДатаСеанса));
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПериодОтчета",БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоДня(ПараметрыОтчета.НачалоПериода),КонецДня(ПараметрыОтчета.КонецПериода),Истина));	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НазваниеНабораПоказателейОтчета",ПараметрыОтчета.НазваниеНабораПоказателейОтчета);	
	
	ПараметрыОтчета.ПоказательНУ = Истина;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("НУ");
	
	МассивСумм = Новый Массив;
	МассивСумм.Добавить("СуммаКапВложений");
	МассивСумм.Добавить("Процент");
	МассивСумм.Добавить("Сумма");
	
	Таблица = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"АмортизационнаяПремия");
	Группировка 	= НайтиПоИмени(Таблица.Строки,"ГруппировкаОбъект");
	ГруппировкаПериод = НайтиПоИмени(Таблица.Строки,"ГруппировкаПериод");
	
	Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Объект");
	Для Каждого ИмяСумм Из МассивСумм Цикл
		ПодГруппа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "" + ИмяСумм);
		КонецЦикла;
	КонецЦикла;	
	
	Группа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Период");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ДокументОснование");
	
	Для Каждого ИмяСумм Из МассивСумм Цикл
		
		ПодГруппа = ГруппировкаПериод.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "" + ИмяСумм );
		КонецЦикла;
	КонецЦикла;	
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
// Удаление итоговых строк в группировке Перид	
	ИтогиГруппировкиТаблица =МакетКомпоновки.Тело[0].Строки[0].Тело[1].Тело[1];
	МакетКомпоновки.Тело[0].Строки[0].Тело[1].Тело.Удалить(ИтогиГруппировкиТаблица);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСверху = 0;
	
	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.УчетНалогиОтчетность82.Подсистемы.ЗакрытиеПериода.Подсистемы.СправкиРасчеты.Подсистемы.НалоговыйУчетПоНалогуНаПрибыль, "");
		ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, Вариант.Имя).Размещение.Вставить(Метаданные.Подсистемы.Отчеты.Подсистемы.СправкиРасчеты.Подсистемы.НалоговыйУчетПоНалогуНаПрибыль, "");
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
	
	Массив.Добавить(Новый Структура("Имя, Представление","ВариантНастройкиАмортизационнаяПремия", "Амортизационная премия"));
	
	Возврат Массив;
	
КонецФункции

#КонецЕсли
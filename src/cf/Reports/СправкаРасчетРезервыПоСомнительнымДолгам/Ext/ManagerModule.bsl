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
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета) + " (" + ПараметрыОтчета.НазваниеНабораПоказателейОтчета + ")";
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ВысотаШапки",Результат.ВысотаТаблицы);	
	
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
	
	Возврат "Справка-расчет резервов по сомнительным долгам" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),ПараметрыОтчета.НачалоПериода),
																										ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ПараметрыОтчета.СначалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),НачалоДня(ПараметрыОтчета.НачалоПериода)));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	ГруппировкаСтатьи = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ГруппировкаСтатьяЗатрат");
	
	Таблица = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"СомнительныеДолги");
	
	// До 2017 года не выводим колонки, связанные со встречной задолженностью
	// Для этого используем отдельный вариант настроек компоновщика, в котором в имена группировок добавлен суффикс "До2017"
	ВыводитьВстречнуюЗадолженность = (ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) И ПараметрыОтчета.КонецПериода >= '2017-01-01');
	Суффикс = ?(ВыводитьВстречнуюЗадолженность, "", "До2017");
	
	МассивНазванийГруппировок = Новый Массив;
	МассивНазванийГруппировок.Добавить("ГруппировкаКонтрагент"+Суффикс);
	МассивНазванийГруппировок.Добавить("ГруппировкаДоговор"+Суффикс);
	МассивНазванийГруппировок.Добавить("ГруппировкаДокументДолга"+Суффикс);
	МассивНазванийГруппировок.Добавить("ГруппировкаПериод"+Суффикс);
	
	МассивГруппировок = Новый Массив;
		
	МассивПоказателей = Новый Массив;
	Если ПараметрыОтчета.ПоказательНУ Тогда 
		МассивПоказателей.Добавить("НУ");
		Для Каждого ИмяГруппировки Из МассивНазванийГруппировок Цикл
			МассивГруппировок.Добавить(НайтиПоИмени(Таблица.Строки,ИмяГруппировки + "НУ"));
		КонецЦикла;
		
	ИначеЕсли ПараметрыОтчета.ПоказательВР Тогда					
		МассивПоказателей.Добавить("БУ");
		МассивПоказателей.Добавить("ПР");
		Для Каждого ИмяГруппировки Из МассивНазванийГруппировок Цикл
			МассивГруппировок.Добавить(НайтиПоИмени(Таблица.Строки,ИмяГруппировки + "СРазницами"));
		КонецЦикла;
	Иначе
		МассивПоказателей.Добавить("БУ");
		Для Каждого ИмяГруппировки Из МассивНазванийГруппировок Цикл
			МассивГруппировок.Добавить(НайтиПоИмени(Таблица.Строки,ИмяГруппировки + "БУ"));
		КонецЦикла;
	КонецЕсли;
	
	Показатель = МассивПоказателей[0];
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группировка.Использование = Истина;
	КонецЦикла;
	
	МассивСумм = Новый Массив;
	Если Показатель = "НУ" Тогда
		МассивСумм.Добавить("Доля");   
	КонецЕсли;
	МассивСумм.Добавить("НачисленоРанее");
	Если Показатель = "НУ" Тогда
		МассивСумм.Добавить("НачисленоСНачалаГода");   
	КонецЕсли;
	МассивСумм.Добавить("Начислено");
	МассивСумм.Добавить("Восстановлено");
	Если Показатель = "БУ" Тогда
		МассивСумм.Добавить("Присоединено");
	КонецЕсли;	
	МассивСумм.Добавить("Остаток");
	МассивСумм.Добавить("Контроль");
	
	МассивСуммПоДокументу = Новый Массив;
	МассивСуммПоДокументу.Добавить("НачисленоРанее");
	МассивСуммПоДокументу.Добавить("Контроль");
	МассивСуммПоДокументу.Добавить("Остаток");
	
	Номер = 0;
	
	Для Каждого Группировка Из МассивГруппировок Цикл
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		ИмяПоля = СтрЗаменить(МассивНазванийГруппировок[Номер], "Группировка", "");
		ИмяПоля = СтрЗаменить(ИмяПоля, "До2017", "");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ИмяПоля);
		Если Номер = 2 Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "ДатаВозникновенияЗадолженности");	
		КонецЕсли;
		Если Номер = 3 Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "СрокЗадолженности");	
		КонецЕсли;
		
		Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "СуммаДолга" + ?(СтрНайти(Группировка.Имя,"ГруппировкаПериод") = 0,"ПоДокументу",""));	
		
		Если ВыводитьВстречнуюЗадолженность Тогда
			// Выводим суммы встречного долга
			// На уровне документа и выше - на конец периода отчета в пределах суммы просроченного долга контрагента
			// На уровне детальных записей (период) - на указанный период в пределах суммы просроченного долга контрагента
			// Дополнительно выводим сумму сомнительного долга, по которой рассчитан резерв
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "СуммаВстречногоДолга" + ?(СтрНайти(Группировка.Имя,"ГруппировкаПериод") = 0,"ПоДокументу",""));	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, "СуммаСомнительногоДолга" + ?(СтрНайти(Группировка.Имя,"ГруппировкаПериод") = 0,"ПоДокументу",""));	
		КонецЕсли; 
		
		Если ПараметрыОтчета.ПоказательПР Тогда 
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "Показатели." + ИмяПоказателя);
			КонецЦикла;
			
		КонецЕсли;	
		
		Для Каждого ИмяСуммы Из МассивСумм Цикл
			Приставка = "";
			Если СтрНайти(Группировка.Имя,"ГруппировкаПериод") = 0 Тогда
				Приставка = ?(МассивСуммПоДокументу.Найти(ИмяСуммы) = Неопределено,"","ПоДокументу");	
			КонецЕсли;	
			
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			Если ПараметрыОтчета.ПоказательПР Тогда
				ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСуммы  + Приставка + "БУ");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяСуммы + Приставка + "ПР");
			Иначе 
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ИмяСуммы + Приставка + Показатель);
			КонецЕсли;	
		КонецЦикла;
		
		Номер = Номер + 1;
		
	КонецЦикла;
	
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
// Удаление итоговых строк в группировке по контрагентов	
	ИтогиГруппировкиТаблица = МакетКомпоновки.Тело[0].Строки[0].Тело[2];
	МакетКомпоновки.Тело[0].Строки[0].Тело.Удалить(ИтогиГруппировкиТаблица);
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		ВысотаШапки = ПараметрыОтчета.ВысотаШапки;
	Иначе
		ВысотаШапки = 0;
	КонецЕсли;
	
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество() + ВысотаШапки); 
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = 1;
	
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
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
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
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Для Каждого Вариант из Схема.ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;	
	
КонецПроцедуры

#КонецЕсли
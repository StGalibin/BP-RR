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
	
	Возврат "Справка-расчет амортизации" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),ПараметрыОтчета.НачалоПериода),
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
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"СпособНачисленияАмортизацииНУ",УчетнаяПолитика.МетодНачисленияАмортизацииНУ(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,"ПоддержкаПБУ18",УчетнаяПолитика.ПоддержкаПБУ18(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода));
	
	МассивСпособов = Новый Массив;
	
	Если ПараметрыОтчета.ПоказательНУ Тогда
		МассивСпособов.Добавить("ЛинейныйНУ");
		МассивСпособов.Добавить("НеЛинейныйНУ");
	Иначе
		МассивСпособов.Добавить("ЛинейныйБУ");
		МассивСпособов.Добавить("НеЛинейныйБУ");
		МассивСпособов.Добавить("ИныеБУ");
	КонецЕсли;
	
	НазваниеСпособа = ""; // линейный
	
	Для Каждого Способ Из МассивСпособов Цикл
	
	ТаблицаСпособа = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"СпособНачисленияАмортизации" + Способ);
	ТаблицаСпособа.Использование = Истина;
	
	Таблица = НайтиПоИмени(ТаблицаСпособа.Структура,"Амортизация" + Способ);
	
	МассивПоказателей = Новый Массив;
	
	Если ПараметрыОтчета.ПоказательНУ Тогда 
		СтрокаГруппировки = "НУ";
		МассивПоказателей.Добавить("НУ");
	ИначеЕсли ПараметрыОтчета.ПоказательВР Тогда
		СтрокаГруппировки = "СРазницами";
		МассивПоказателей.Добавить("БУ");
		МассивПоказателей.Добавить("ПР");
		МассивПоказателей.Добавить("ВР");
	Иначе
		СтрокаГруппировки = "БУ";
		МассивПоказателей.Добавить("БУ");
	КонецЕсли;
	
	Группировка 	    = НайтиПоИмени(Таблица.Строки,"Группировка" + НазваниеСпособа              + СтрокаГруппировки);
	ГруппировкаАмГруппа = НайтиПоИмени(Таблица.Строки,"Группировка" + НазваниеСпособа + "АмГруппа" + СтрокаГруппировки);
	ГруппировкаОбъект   = НайтиПоИмени(Таблица.Строки,"Группировка" + НазваниеСпособа + "Объект"   + СтрокаГруппировки);
	ГруппировкаПериод   = НайтиПоИмени(Таблица.Строки,"Группировка" + НазваниеСпособа + "Период"   + СтрокаГруппировки);
	
	Группировка.Использование = Истина;
	ГруппировкаАмГруппа.Использование = Истина;
	ГруппировкаОбъект.Использование = Истина;
	ГруппировкаПериод.Использование = Истина;
	
	МассивГруппировок = Новый Массив;
	МассивГруппировок.Добавить(Группировка);
	МассивГруппировок.Добавить(ГруппировкаАмГруппа);
	МассивГруппировок.Добавить(ГруппировкаОбъект);
	МассивГруппировок.Добавить(ГруппировкаПериод);
	
	Для Каждого ИмяГруппировки Из МассивГруппировок Цикл
		
		Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		Если ИмяГруппировки = Группировка Тогда	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ВидИмущества");
		ИначеЕсли ИмяГруппировки = ГруппировкаОбъект Тогда	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Объект");
	        БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ИнвНомер");
	        БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ДатаВводаВЭксплуатацию");
	        БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"НачислятьАмортизацию" + ?(ПараметрыОтчета.ПоказательНУ,"НУ","БУ"));
			Если НазваниеСпособа = "НеЛин" И ПараметрыОтчета.ПоказательНУ Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"НормаАмортизации");
			КонецЕсли;
		ИначеЕсли ИмяГруппировки = ГруппировкаАмГруппа Тогда	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"АмортизационнаяГруппа");
		Иначе	
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ПериодРасчета");
		КонецЕсли;
		
		// Вывод названий суммовых покателей
		Если ПараметрыОтчета.ПоказательВР Тогда 
			Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "Показатели." + ИмяПоказателя);
			КонецЦикла;
			
		КонецЕсли;
		
		// Вывод стоимости ОС
		Если ПараметрыОтчета.ПоказательВР Тогда 
			Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
		Иначе
			ПодГруппа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		КонецЕсли;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "Стоимость" + ИмяПоказателя);
			КонецЕсли;	
		КонецЦикла;
		
		// Вывод остаточной стоимости 
		Если ПараметрыОтчета.ПоказательВР Тогда 
			Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
		Иначе
			ПодГруппа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		КонецЕсли;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "ОстаточнаяСтоимость" + ИмяПоказателя);
			КонецЕсли;	
		КонецЦикла;
		
		// Вывод стоимости для начисления амортизации
		Если ПараметрыОтчета.ПоказательБУ Тогда 	
			Если ПараметрыОтчета.ПоказательВР Тогда 
				Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
				ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "СтоимостьДляАмортизацииБУ");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "СтоимостьДляАмортизацииПР");
				
			Иначе
				ПодГруппа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "СтоимостьДляАмортизацииБУ");
			КонецЕсли;
		КонецЕсли;
		
		
		// Вывод срока использования
		
		Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"СрокИспользования"+ ?(ПараметрыОтчета.ПоказательНУ,"НУ","БУ"));
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"ОстатокСрокаПолезногоИспользования"+ ?(ПараметрыОтчета.ПоказательНУ,"НУ","БУ"));
		
		// Вывод коэффициентов
		Если ПараметрыОтчета.ПоказательНУ Тогда
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"СпециальныйКоэффициентНУ");
			
		КонецЕсли;
		
		// Вывод амортизации
		Если ПараметрыОтчета.ПоказательВР Тогда 
			Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
		Иначе
			ПодГруппа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
		КонецЕсли;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "РасчетнаяАмортизация" + ИмяПоказателя);
			КонецЕсли;	
		КонецЦикла;
		
		// Вывод способа отражения расходов
		Если ИмяГруппировки = ГруппировкаПериод Тогда 
			Группа = ИмяГруппировки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"СпособыОтраженияРасходовПоАмортизации");
		КонецЕсли;
		
		ГруппаОтбор = ИмяГруппировки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбор.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ГруппаОтбор, "РасчетнаяАмортизация" + ИмяПоказателя, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	НазваниеСпособа = "НеЛин";  // не линейный
	
КонецЦикла;	

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
		
// Удаление итоговых строк в группировке по вид имущества	
	ИтогиГруппировкиТаблица = МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело[2];
	МакетКомпоновки.Тело[0].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиТаблица);
	
	ИтогиГруппировкиТаблица = МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело[2];
	МакетКомпоновки.Тело[2].Тело[1].Строки[0].Тело.Удалить(ИтогиГруппировкиТаблица);
	
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
	
	Область = Результат.НайтиТекст("###",Результат.Область("r1c1"));
	Пока НЕ Область = Неопределено Цикл
		
		Область.Текст = Формат(СтрЗаменить(Область.Текст,"###",""),"ЧДЦ=2");
		Область.Примечание.Текст = "Ожидается изменение результатов
		|регламентной операции ""Амортизация"",
		|рекомендуется выполнить ее повторно и
		|проверить проводки начисления амортизации";
		Область.Примечание.ЦветФона = WebЦвета.АкварельноСиний;
		Область.Примечание.Шрифт = Метаданные.ЭлементыСтиля.ШрифтВажнойНадписи.Значение;
		Область = Результат.НайтиТекст("###",Область);
		
	КонецЦикла;	
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Если ПараметрыОтчета.Свойство("ВысотаШапки") Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = 0;
	
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	
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
	
	Массив.Добавить(Новый Структура("Имя, Представление","Амортизация", "Амортизация"));
	
	Возврат Массив;
	
КонецФункции

#КонецЕсли
﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Для Каждого Стр Из ВладелецТС.ТаблицаСообщений Цикл
		ДокументВладелец = РегламентированнаяОтчетностьКлиентСервер.НайтиЭлементВДанныхФормыДерево(ТаблицаСообщений.ПолучитьЭлементы(), "ОтчетДок", Стр.ОтчетДок);
		Если ДокументВладелец = Неопределено Тогда
			ДокументВладелец = ТаблицаСообщений.ПолучитьЭлементы().Добавить();
			ДокументВладелец.Отчет = Стр.Отчет;
			ДокументВладелец.ОтчетДок = Стр.ОтчетДок;
			Элементы.ТаблицаСообщений.Развернуть(ДокументВладелец.ПолучитьИдентификатор(), Истина);
		КонецЕсли;
		НовСтр = ДокументВладелец.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
	КонецЦикла;
	
	Для Каждого Элемент Из ТаблицаСообщений.ПолучитьЭлементы() Цикл
		Если Элемент.ПолучитьРодителя() = Неопределено Тогда
			Элемент.Описание = "Ошибок в отчете: " + Элемент.ПолучитьЭлементы().Количество();
		КонецЕсли;
	КонецЦикла;
							
	Для Каждого Стр Из ТаблицаСообщений.ПолучитьЭлементы() Цикл
		Если Стр.ПолучитьЭлементы().Количество() <> 0 Тогда
			Элементы.ТаблицаСообщений.ТекущаяСтрока = Стр.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	НадписьВсегоОшибок = "Всего ошибок: " + Формат(ВладелецТС.ТаблицаСообщений.Количество(), "ЧГ=")
						+ " в " + Формат(ТаблицаСообщений.ПолучитьЭлементы().Количество(), "ЧГ=")
						+ ?(ТаблицаСообщений.ПолучитьЭлементы().Количество() = 1, " отчете", " отчетах");
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВладелецТС = Параметры.ВладелецТС;
	
	Для Каждого СтрТаблСообщений Из ВладелецТС.ТаблицаСообщений Цикл
		
		РегламентированнаяОтчетность.ОбработатьСобытие1СОтчетности(НСтр("ru = 'Регламентированный отчет. Проверка выгрузки'"), СтрТаблСообщений);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаСообщенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		АктивизироватьЯчейку(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьЯчейку(ВыбраннаяСтрока)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ТекДок = ВыбраннаяСтрока.ОтчетДок;
	Если ТекДок = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ячейка = Новый Структура;
	Ячейка.Вставить("Раздел", ВыбраннаяСтрока.Раздел);
	Ячейка.Вставить("Страница", ВыбраннаяСтрока.Страница);
	Ячейка.Вставить("Строка", ВыбраннаяСтрока.Строка);
	Ячейка.Вставить("Графа", ВыбраннаяСтрока.Графа);
	Ячейка.Вставить("СтрокаПП", ВыбраннаяСтрока.СтрокаПП);
	Ячейка.Вставить("ИмяЯчейки", ВыбраннаяСтрока.ИмяЯчейки);
	Ячейка.Вставить("Описание", ВыбраннаяСтрока.Описание);
					
	Попытка
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета");
		ПараметрыФормы.Вставить("мСохраненныйДок");
		ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета");
		ПараметрыФормы.Вставить("Организация");
		ПараметрыФормы.Вставить("мВыбраннаяФорма");
		ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
								РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
		
		ФормаРеглОтчета = РегламентированнаяОтчетностьВызовСервера.ПолучитьСсылкуНаФормуРеглОтчета(ТекДок, ПараметрыФормы);
		Если СтрНайти(ФормаРеглОтчета, "РегламентированныйОтчетСтатистикаПрочиеФормы") > 0 Тогда
			ФормаРеглОтчета = ?(СтрНайти(ФормаРеглОтчета, "_") = 0, ФормаРеглОтчета, Лев(ФормаРеглОтчета, СтрНайти(ФормаРеглОтчета, "_") - 1));
		КонецЕсли;
		
		Если СтрЧислоВхождений(ФормаРеглОтчета, "ОтчетМенеджер") > 0 Тогда
			ФормаРеглОтчета = СтрЗаменить(ФормаРеглОтчета, "ОтчетМенеджер.", "");
			ФормаРеглОтчета = ПолучитьФорму("Отчет." + ФормаРеглОтчета, ПараметрыФормы, , ПараметрыФормы.мСохраненныйДок);
		ИначеЕсли СтрЧислоВхождений(ФормаРеглОтчета, "ВнешнийОтчетОбъект") > 0 Тогда
			ФормаРеглОтчета = СтрЗаменить(ФормаРеглОтчета, "ВнешнийОтчетОбъект.", "");
			ФормаРеглОтчета = ПолучитьФорму("ВнешнийОтчет." + ФормаРеглОтчета, ПараметрыФормы, , ПараметрыФормы.мСохраненныйДок);
		КонецЕсли;
		
		ФормаРеглОтчета.Открыть();
		
		ФормаРеглОтчета.АктивизироватьЯчейку(Ячейка);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
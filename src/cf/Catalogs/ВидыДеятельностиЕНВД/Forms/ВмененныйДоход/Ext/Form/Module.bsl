﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация = Параметры.Организация;
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	
	Заголовок = СтрШаблон(
		НСтр("ru = 'Вмененный доход%1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода));
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененВидДеятельностиОрганизации" Тогда
		
		Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Организации") И Параметр = Организация Тогда
			ЗаполнитьСписок();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ИзменениеВидаДеятельностиЗавершение", ЭтотОбъект);
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Ключ", ТекущиеДанные.ВидДеятельности);
		
		ОткрытьФорму("Справочник.ВидыДеятельностиЕНВД.ФормаОбъекта",
			СтруктураПараметров,
			ЭтотОбъект,
			,
			,
			,
			ОписаниеОповещенияОЗакрытии)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеВидаДеятельностиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписок() Экспорт
	
	Если НачалоПериода > КонецПериода Тогда
		Список.Очистить();
		Возврат;
	КонецЕсли;
	
	ТаблицаСписка = Новый ТаблицаЗначений;
	ТаблицаСписка.Колонки.Добавить("ВидДеятельности", Новый ОписаниеТипов("СправочникСсылка.ВидыДеятельностиЕНВД"));
	ТаблицаСписка.Колонки.Добавить("Наименование", ОбщегоНазначения.ОписаниеТипаСтрока(50));
	ТаблицаСписка.Колонки.Добавить("Сумма", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
	
	Период = КонецКвартала(НачалоПериода);
	Пока Период <= КонецКвартала(КонецПериода) Цикл
		
		ТаблицаВидовДейтельностей = УчетЕНВД.ПоказателиВидовДеятельности(Период, Организация);
		
		ТаблицаВидовДейтельностей.Колонки.Добавить("Сумма", ОбщегоНазначения.ОписаниеТипаЧисло(15, 2));
		Для Каждого ВидДеятельности Из ТаблицаВидовДейтельностей Цикл
			
			ПараметрыРасчетаСуммыНалога = УчетЕНВДКлиентСервер.НовыеПараметрыРасчетаСуммыНалога();
			ЗаполнитьЗначенияСвойств(ПараметрыРасчетаСуммыНалога, ВидДеятельности);
			ПараметрыРасчетаСуммыНалога.Период = Период;
			
			НоваяСтрока = ТаблицаСписка.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВидДеятельности);
			НоваяСтрока.Сумма = УчетЕНВДКлиентСервер.ВмененныйДоходЗаКвартал(ПараметрыРасчетаСуммыНалога);
			
		КонецЦикла;
		
		Период = КонецКвартала(ДобавитьМесяц(Период, 3)); // Следующий квартал
		
	КонецЦикла;
	
	Если ТаблицаСписка <> Неопределено Тогда
		
		ТаблицаСписка.Свернуть("ВидДеятельности, Наименование", "Сумма");
		ТаблицаСписка.Сортировать("ВидДеятельности", Новый СравнениеЗначений);
		
		Список.Загрузить(ТаблицаСписка);
		
		СуммаИтог = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ТаблицаСписка.Итог("Сумма"));
		Элементы.СписокСумма.ТекстПодвала = ОбщегоНазначенияБПВызовСервера.ФорматСумм(СуммаИтог, , "0.00", " ");
		
	Иначе
		Элементы.СписокСумма.ТекстПодвала = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


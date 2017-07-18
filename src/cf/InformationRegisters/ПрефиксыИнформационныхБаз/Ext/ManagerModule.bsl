﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ЗаполнитьПрефиксТекущейИБ() Экспорт
	
	ПрефиксИБ = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
	
	Если ПустаяСтрока(ПрефиксИБ) Тогда
		Возврат;
	ИначеЕсли СтрДлина(ПрефиксИБ) =1 Тогда
		ПрефиксИБ = "0" + ПрефиксИБ;
	КонецЕсли;
	
	ЗаписьПрефикса = РегистрыСведений.ПрефиксыИнформационныхБаз.СоздатьМенеджерЗаписи();
	ЗаписьПрефикса.Префикс = ПрефиксИБ;
	ЗаписьПрефикса.Прочитать();
	
	Если НЕ ЗаписьПрефикса.Выбран() Тогда
		ЗаписьПрефикса.Префикс 		= ПрефиксИБ;
		ЗаписьПрефикса.ФорматБСП 	= Истина;
		ЗаписьПрефикса.РИБ 			= Истина;
		ЗаписьПрефикса.Записать();
	КонецЕсли;
	
КонецПроцедуры

//Процедура проверяет наличие префиксов в регистре и при необходимости добавляет их
//
//ПрефиксыИБ 		- Массив элементов типа Структура
//
//Префикс 			- префикс ИБ (текст)
//ПечататьПрефикс 	- печатать номер документа с префиксом (булево)
//ФорматБСП 		- префикс получен из номера в формате БСП (булево)
//
Процедура ЗагрузитьИнформациюОПрефиксах(ПрефиксыИБ) Экспорт
	
	Если ПрефиксыИБ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПрефиксов = Новый ТаблицаЗначений;
	ТаблицаПрефиксов.Колонки.Добавить("Префикс", 			Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(3)));
	ТаблицаПрефиксов.Колонки.Добавить("ПечататьПрефикс",    Новый ОписаниеТипов("Булево"));
	ТаблицаПрефиксов.Колонки.Добавить("ФорматБСП",    		Новый ОписаниеТипов("Булево"));
	
	Для каждого ЭлементПрефиксыИБ Из ПрефиксыИБ Цикл
		Если ПустаяСтрока(ЭлементПрефиксыИБ.Префикс) Тогда
			Продолжить;
		КонецЕсли;
		СтрокаПрефикс = ТаблицаПрефиксов.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПрефикс, ЭлементПрефиксыИБ);
		Если СтрокаПрефикс.ФорматБСП И СтрДлина(СтрокаПрефикс.Префикс) = 1 Тогда
			СтрокаПрефикс.Префикс = "0" + СтрокаПрефикс.Префикс;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаПрефиксов", ТаблицаПрефиксов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаПрефиксов.Префикс,
	|	ТаблицаПрефиксов.ПечататьПрефикс,
	|	ТаблицаПрефиксов.ФорматБСП
	|ПОМЕСТИТЬ ПрефиксыИБ
	|ИЗ
	|	&ТаблицаПрефиксов КАК ТаблицаПрефиксов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПрефиксыИБ.Префикс КАК Префикс,
	|	ПрефиксыИБ.ПечататьПрефикс,
	|	ПрефиксыИБ.ФорматБСП
	|ИЗ
	|	ПрефиксыИБ КАК ПрефиксыИБ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрефиксыИнформационныхБаз КАК ПрефиксыИнформационныхБаз
	|		ПО ПрефиксыИБ.Префикс = ПрефиксыИнформационныхБаз.Префикс
	|ГДЕ
	|	ПрефиксыИнформационныхБаз.Префикс ЕСТЬ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ПрефиксыИнформационныхБаз.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		Запись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Выборка);		
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

Функция НадоПерепровестиСчетаФактуры() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрефиксыИнформационныхБаз.Префикс
	|ИЗ
	|	РегистрСведений.ПрефиксыИнформационныхБаз КАК ПрефиксыИнформационныхБаз
	|ГДЕ
	|	(ПрефиксыИнформационныхБаз.ПечататьПрефикс
	|			ИЛИ НЕ ПрефиксыИнформационныхБаз.ФорматБСП
	|				И НЕ ПрефиксыИнформационныхБаз.РИБ)";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецЕсли
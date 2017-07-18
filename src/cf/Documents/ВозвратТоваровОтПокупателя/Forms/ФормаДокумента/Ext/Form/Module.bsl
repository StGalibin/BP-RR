﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ				= Параметры.Ключ;
	КонецЕсли;
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	
	ФормыДокумента = Новый ФиксированноеСоответствие(
		Документы.ВозвратТоваровОтПокупателя.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций();
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперацииПриОткрытии = Параметры.ВидОперации;
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(ВидОперацииПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
 
&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций()

	СписокВидовОпераций = Новый СписокЗначений;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ВидыОперацийВозвратТоваровОтПокупателя.ЗначенияПеречисления;
	Для Каждого ЗначениеПеречисления Из ЗначенияПеречисления Цикл
		ТекущийВидОперации = Перечисления.ВидыОперацийВозвратТоваровОтПокупателя[ЗначениеПеречисления.Имя];
		СписокВидовОпераций.Добавить(ТекущийВидОперации, Строка(ТекущийВидОперации));
	КонецЦикла;
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание", Основание);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ", Ключ);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> ВидОперацииПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	Если ЗначениеЗаполнено(Ключ) Тогда
		КлючеваяОперация = "ОткрытиеФормыВозвратТоваровОтПокупателя";
	Иначе
		КлючеваяОперация = "СозданиеФормыВозвратТоваровОтПокупателя";
	КонецЕсли;
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	ОткрытьФорму("Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокументаОбщая", СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

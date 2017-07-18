﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоРежимВыбора = Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора;
	
	Ссылка 			= Параметры.Ссылка;
	Наименование 	= Параметры.Наименование;
	СтраницаЖурнала = Параметры.СтраницаЖурнала;
	Заголовок 		= Параметры.ЗаголовокФормы + НСтр("ru = ': история отправки'");
	
	Элементы.ОтправкиПредставлениеВида.Видимость = 
		СтраницаЖурнала = Перечисления.СтраницыЖурналаОтчетность.Отчеты;
		
	СформироватьТаблицуОтправок();
	
	Элементы.ФормаВыбрать.Видимость = ЭтоРежимВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ОтправкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		Если ЭтоРежимВыбора Тогда
			
			ВернутьДанныеПоОтправкеИЗакрыть();
			
		ИначеЕсли Поле.Имя = "ОтправкиСтатус" Тогда
			
			// Переопределяем показ формы состояния отправки
			ОтображатьСтандартнуюФормуСостояния = Истина;
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьСостояниеОтправкиОтчетаПереопределяемый(Ссылка, ОтображатьСтандартнуюФормуСостояния);
				
			// Если показ формы был выполнен в переопределяемой процедуре, то стандартную форму не показываем
			Если ОтображатьСтандартнуюФормуСостояния Тогда
				ПоказатьФормуСтатусовОтправкиИзСписка(Элемент);
			КонецЕсли;
			
		ИначеЕсли Поле.Имя = "ОтправкиЕстьКритическиеОшибкиОтправки" И ТекущиеДанные.ЕстьКритическиеОшибки Тогда
			
			ПоказатьКритическиеОшибкиПоСсылке(Ссылка);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтправкиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВернутьДанныеПоОтправкеИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СведенияПоОтправкам(Отправка)

	ДополнительныеПараметры = Новый Структура("ДатаОтправки");
	Возврат СведенияПоОтправкам.СведенияПоОтправке(Ссылка, Отправка, ДополнительныеПараметры);

КонецФункции

&НаСервере
Процедура СформироватьТаблицуОтправок()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Если КонтекстЭДОСервер = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсеОтправки = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ВсеОтправки(Ссылка);
	
	ВсеОтправки.Колонки.Добавить("Ссылка");
	ВсеОтправки.Колонки.Добавить("Наименование");
	ВсеОтправки.Колонки.Добавить("ЕстьКритическиеОшибки");
	ВсеОтправки.Колонки.Добавить("Статус");
	ВсеОтправки.Колонки.Добавить("СостояниеСдачиОтчетности");
	ВсеОтправки.Колонки.Добавить("ПредставлениеКонтролирующегоОргана");
	ВсеОтправки.Колонки.Добавить("СтраницаЖурнала");
	ВсеОтправки.Колонки.Добавить("Пустой");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПолучатьДаты", 			Ложь);
	ДополнительныеПараметры.Вставить("ПолучатьОшибкиОтправки", 	Истина);
	
	Для каждого СтрокаОтправки Из ВсеОтправки Цикл
		
		// Получение параметров прорисовки
		ДополнительныеПараметры.Вставить("Отправка", 						СтрокаОтправки.Отправка);
		ДополнительныеПараметры.Вставить("ПоказыватьПомеченныеНаУдаление", 	Истина);
		
		СостояниеОтправки = КонтекстЭДОСервер.ТекущееСостояниеОтправки(
			Ссылка, 
			СтрокаОтправки.ВидКонтролирующегоОргана, 
			ДополнительныеПараметры);
			
		СтрокаОтправки.Ссылка 					= Ссылка;
		СтрокаОтправки.Наименование 			= Наименование;
		СтрокаОтправки.ЕстьКритическиеОшибки 	= СостояниеОтправки.ЕстьКритическиеОшибки;
		СтрокаОтправки.Статус					= СостояниеОтправки.ТекущийЭтапОтправки.ТекстСтатуса;
		СтрокаОтправки.СостояниеСдачиОтчетности	= СостояниеОтправки.ТекущийЭтапОтправки.СостояниеСдачиОтчетности; 
		СтрокаОтправки.СтраницаЖурнала			= СтраницаЖурнала; 
		
		Если СтраницаЖурнала = Перечисления.СтраницыЖурналаОтчетность.Отчеты
			И Не ЗначениеЗаполнено(СтрокаОтправки.ПредставлениеВида) Тогда
			СтрокаОтправки.ПредставлениеВида = "П";
		КонецЕсли;
			
		СтрокаОтправки.ПредставлениеКонтролирующегоОргана
			= СтрокаОтправки.ВидКонтролирующегоОргана + " " + СтрокаОтправки.КодКонтролирующегоОргана; 
	
	КонецЦикла;
		
	ЗначениеВРеквизитФормы(ВсеОтправки, "Отправки");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуСтатусовОтправкиИзСписка(Элемент)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.ПоказатьФормуСтатусовОтправкиИзСписка(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКритическиеОшибкиПоСсылке(Ссылка)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиИнициализацииКонтекстаЭДО);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Отправка", Элементы.Отправки.ТекущиеДанные.Отправка);
	
	КонтекстЭДОКлиент.ПоказатьКритическиеОшибкиПоСсылке(Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент 						= Результат.КонтекстЭДО;
	ТекстОшибкиИнициализацииКонтекстаЭДО 	= Результат.ТекстОшибки;
	
	Элементы.Отправки.ТекущаяСтрока = Отправки.Количество() - 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьДанныеПоОтправкеИЗакрыть()
	
	ТекущиеДанные = Элементы.Отправки.ТекущиеДанные;
	Если Элементы.Отправки.ТекущиеДанные <> Неопределено Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Сообщение) Тогда
			ДанныеОтправки = СведенияПоОтправкам(ТекущиеДанные.Сообщение);
			Закрыть(ДанныеОтправки);
		Иначе
			Закрыть(Неопределено);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
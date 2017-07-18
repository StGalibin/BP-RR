﻿#Область ПрограммныйИнтерфейс

// Обновляет список команд в зависимости от текущего контекста.
//
// Параметры:
//   Форма - УправляемаяФорма - форма, для которой требуется обновление команд.
//   Источник - ДанныеФормыСтруктура, ТаблицаФормы - контекст для проверки условий (Форма.Объект или Форма.Элементы.Список).
//
Процедура ОбновитьКоманды(Форма, Источник) Экспорт
	Структура = Новый Структура("ПараметрыПодключаемыхКоманд", Null);
	ЗаполнитьЗначенияСвойств(Структура, Форма);
	ПараметрыКлиента = Структура.ПараметрыПодключаемыхКоманд;
	Если ТипЗнч(ПараметрыКлиента) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ДоступностьКоманд = (Источник.ТекущаяСтрока <> Неопределено);
	Иначе
		ДоступностьКоманд = Истина;
	КонецЕсли;
	Если ДоступностьКоманд <> ПараметрыКлиента.ДоступностьКоманд Тогда
		ПараметрыКлиента.ДоступностьКоманд = ДоступностьКоманд;
		Для Каждого ИмяКнопкиИлиПодменю Из ПараметрыКлиента.КорневыеПодменюИКоманды Цикл
			КнопкаИлиПодменю = Форма.Элементы[ИмяКнопкиИлиПодменю];
			КнопкаИлиПодменю.Доступность = ДоступностьКоманд;
			Если ТипЗнч(КнопкаИлиПодменю) = Тип("ГруппаФормы") И КнопкаИлиПодменю.Вид = ВидГруппыФормы.Подменю Тогда
				СкрытьПоказатьВсеПодчиненныеКнопки(КнопкаИлиПодменю, ДоступностьКоманд);
				КомандаЗаглушка = Форма.Элементы.Найти(ИмяКнопкиИлиПодменю + "Заглушка");
				Если КомандаЗаглушка <> Неопределено Тогда
					КомандаЗаглушка.Видимость = Не ДоступностьКоманд;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ДоступностьКоманд Или Не ПараметрыКлиента.ЕстьУсловияВидимости Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеОбъекты = Новый Массив;
	ПроверятьОписаниеТипов = Ложь;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		#Если Клиент Тогда
			ВыделенныеСтроки = Источник.ВыделенныеСтроки;
			Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
				Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
					Продолжить;
				КонецЕсли;
				ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
				Если ТекущаяСтрока <> Неопределено Тогда
					ВыбранныеОбъекты.Добавить(ТекущаяСтрока);
				КонецЕсли;
			КонецЦикла;
			ПроверятьОписаниеТипов = Истина;
		#Иначе
			Возврат;
		#КонецЕсли
	Иначе
		ВыбранныеОбъекты.Добавить(Источник);
	КонецЕсли;
	
	Для Каждого КраткиеСведенияОПодменю Из ПараметрыКлиента.ПодменюСУсловиямиВидимости Цикл
		ЕстьВидимыеКоманды = Ложь;
		Подменю = Форма.Элементы.Найти(КраткиеСведенияОПодменю.Имя);
		ИзменятьВидимость = (ТипЗнч(Подменю) = Тип("ГруппаФормы") И Подменю.Вид = ВидГруппыФормы.Подменю);
		
		Для Каждого Команда Из КраткиеСведенияОПодменю.КомандыСУсловиямиВидимости Цикл
			КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
			Видимость = Истина;
			Для Каждого Объект Из ВыбранныеОбъекты Цикл
				Если ПроверятьОписаниеТипов
					И ТипЗнч(Команда.ТипПараметра) = Тип("ОписаниеТипов")
					И Не Команда.ТипПараметра.СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
					Видимость = Ложь;
					Прервать;
				КонецЕсли;
				Если ТипЗнч(Команда.УсловияВидимости) = Тип("Массив")
					И Не УсловияВыполняются(Команда.УсловияВидимости, Объект) Тогда
					Видимость = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ИзменятьВидимость Тогда
				КомандаЭлемент.Видимость = Видимость;
			Иначе
				КомандаЭлемент.Доступность = Видимость;
			КонецЕсли;
			ЕстьВидимыеКоманды = ЕстьВидимыеКоманды Или Видимость;
		КонецЦикла;
		
		Если Не КраткиеСведенияОПодменю.ЕстьКомандыБезУсловийВидимости Тогда
			КомандаЗаглушка = Форма.Элементы.Найти(КраткиеСведенияОПодменю.Имя + "Заглушка");
			Если КомандаЗаглушка <> Неопределено Тогда
				КомандаЗаглушка.Видимость = Не ЕстьВидимыеКоманды;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Шаблон второго параметра обработчика команды.
//
// Возвращаемое значение:
//   Структура - Вспомогательные параметры.
//       * ОписаниеКоманды - Структура - Описание команды.
//           Структура аналогична таблице ПодключаемыеКоманды.ТаблицаКоманд().
//           ** Идентификатор - Строка - Идентификатор команды.
//           ** Представление - Строка - Представление команды в форме.
//           ** ДополнительныеПараметры - Структура - Дополнительные параметры команды.
//       * Форма - УправляемаяФорма - Форма, из которой вызвана команда.
//       * ЭтоФормаОбъекта - Булево - Истина, если команда вызвана из формы объекта.
//       * Источник - ТаблицаФормы, ДанныеФормыСтруктура - Объект или список формы с полем "Ссылка".
//
Функция ШаблонПараметровВыполненияКоманды() Экспорт
	Структура = Новый Структура("ОписаниеКоманды, Форма, Источник");
	Структура.Вставить("ЭтоФормаОбъекта", Ложь);
	Возврат Структура;
КонецФункции

Функция УсловияВыполняются(Условия, ЗначенияРеквизитов)
	Перем Значение;
	Для Каждого Условие Из Условия Цикл
		ИмяРеквизита = Условие.Реквизит;
		Если Не ЗначенияРеквизитов.Свойство(ИмяРеквизита, Значение) Тогда
			Продолжить;
		КонецЕсли;
		ПроверяемоеЗначение = Условие.Значение;
		Если Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			Если Не (Значение = ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
			Если Не (Значение <> ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			Если Не (ПроверяемоеЗначение.Найти(Значение) <> Неопределено) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
			Если Не (ПроверяемоеЗначение.Найти(Значение) = Неопределено) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
			Если Не (Заполнено(Значение)) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
			Если Не (Не Заполнено(Значение)) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда
			Если Не (Значение > ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда
			Если Не (Значение < ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
			Если Не (Значение >= ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли Условие.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
			Если Не (Значение <= ПроверяемоеЗначение) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Истина;
КонецФункции

Функция Заполнено(Значение, ВСлучаеНевозможностиПроверки = Истина)
	Попытка
		Возврат ЗначениеЗаполнено(Значение);
	Исключение
		Возврат ВСлучаеНевозможностиПроверки;
	КонецПопытки;
КонецФункции

Процедура СкрытьПоказатьВсеПодчиненныеКнопки(ГруппаФормы, Видимость)
	Для Каждого ПодчиненныйЭлемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Тогда
			СкрытьПоказатьВсеПодчиненныеКнопки(ПодчиненныйЭлемент, Видимость);
		ИначеЕсли ТипЗнч(ПодчиненныйЭлемент) = Тип("КнопкаФормы") Тогда
			ПодчиненныйЭлемент.Видимость = Видимость;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
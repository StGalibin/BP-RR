﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ОбменДаннымиСервер.ФормаНастройкиЗначенийПоУмолчаниюБазыКорреспондентаПриСозданииНаСервере(ЭтаФорма, Метаданные.ПланыОбмена.ОбменУправлениеТорговлейБухгалтерияПредприятия30.Имя);
	
	Результат = ОбменДаннымиПовтИсп.УстановитьВнешнееСоединениеСБазой(ПараметрыВнешнегоСоединения);
	
	Если Результат.Соединение = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ПодробноеОписаниеОшибки,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ВнешнееСоединение = Результат.Соединение;
	
	СтруктураФункциональныхОпций = Новый Структура();
	СтруктураФункциональныхОпций.Вставить("ИспользоватьПартнеровИКонтрагентов", ВнешнееСоединение.ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов"));
	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ОбменДаннымиСервер.ОпределитьПроверяемыеРеквизитыСУчетомНастроекВидимостиПолейФормы(ПроверяемыеРеквизиты, Элементы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолеПодразделениеПоУмолчаниюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора("ПодразделениеПоУмолчанию", "Справочник.СтруктураПредприятия", ЭтаФорма, СтандартнаяОбработка, ПараметрыВнешнегоСоединения);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	ОбменДаннымиКлиент.ФормаНастройкиЗначенийПоУмолчаниюКомандаЗакрытьФорму(ЭтаФорма);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	Элементы.ФлагСоздаватьПартнеровДляНовыхКонтрагентов.Видимость = СтруктураФункциональныхОпций.ИспользоватьПартнеровИКонтрагентов;
	
КонецПроцедуры

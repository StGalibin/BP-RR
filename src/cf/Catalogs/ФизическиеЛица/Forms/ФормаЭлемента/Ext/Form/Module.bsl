﻿&НаКлиенте
Перем ОткрытыеФормы Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформациейЗарплатаКадры.ПриСозданииНаСервере(ЭтаФорма, ФизическоеЛицо, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", ФизическоеЛицо);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, "ФизическоеЛицо");	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(
		ЭтотОбъект, "ФизическоеЛицо.ГруппаДоступа", , Тип("СправочникСсылка.ФизическиеЛица"), Параметры.Ключ.Пустая());
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СотрудникиФормы.ФизическиеЛицаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПослеОткрытияФормы", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если СозданиеНового И НЕ Параметры.Ключ.Пустая() Тогда
		
		Оповестить("СозданоФизическоеЛицо", ФизическоеЛицоСсылка, ВладелецФормы);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	СотрудникиКлиент.ФизическиеЛицаОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СотрудникиФормы.ФизическиеЛицаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	Если Модифицированность Тогда
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	Иначе
		СотрудникиКлиент.ПроверитьНеобходимостьЗаписи(ЭтаФорма, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ Отказ И НЕ ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		ЗаписатьНаКлиенте(Ложь, , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	СотрудникиФормы.ФизическиеЛицаПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект, ФизическоеЛицо.ФИО, ТекущийОбъект.Ссылка, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = Перечисления.ПолФизическогоЛица.Мужской, 1, 2), Неопределено));	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	СотрудникиФормы.ФизическиеЛицаПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	СотрудникиФормы.ФизическиеЛицаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СотрудникиКлиент.ФизическиеЛицаПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, ФизическоеЛицо, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты, ФизическоеЛицо);
	// Конец СтандартныеПодсистемы.Свойства
	
	СотрудникиФормы.ФизическиеЛицаОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

//////////////////////////////////////////////////////////////////////////////////
// Сервисные процедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "СВОЙСТВ"

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, ФизическоеЛицо.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("ФизическоеЛицо"));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ "КОНТАКТНАЯ ИНФОРМАЦИЯ"

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(
		ЭтотОбъект, Элемент, , СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.Очистка(
		ЭтотОбъект, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	МодульУправлениеКонтактнойИнформациейКлиент =
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
	
	МодульУправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(
		ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаСервере
Функция Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	
	РезультатОбновления = УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, ФизическоеЛицо, Результат);
	УправлениеКонтактнойИнформациейЗарплатаКадры.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Результат, СотрудникиКлиентСервер.ЗависимостиВидовАдресов());
	
	Возврат РезультатОбновления;
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////////
// Редактирование данных ФизическогоЛица.

&НаКлиенте
Процедура ФизлицоИННПриИзменении(Элемент)
	СотрудникиКлиент.ФизическиеЛицаИННПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоСтраховойНомерПФРПриИзменении(Элемент)
	СотрудникиКлиент.ФизическиеЛицаСтраховойНомерПФРПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоМестоРожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ФизическиеЛицаМестоРожденияНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка, ФизическоеЛицо.МестоРождения);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизлицоДатаРожденияПриИзменении(Элемент)
	СотрудникиКлиентСервер.УстановитьПодсказкуКДатеРождения(ЭтаФорма);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование ФИО

&НаКлиенте
Процедура ФИОФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ФИОФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	
	СотрудникиКлиент.ПриИзмененииФИОФизическогоЛица(ЭтаФорма);
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов	
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникИзменилФИОНажатие(Элемент)
	СотрудникиКлиент.ФизическоеЛицоИзменилФИОНажатие(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УточнениеНаименованияПриИзменении(Элемент)
	 СотрудникиКлиент.СформироватьНаименованиеФизическогоЛица(ЭтаФорма);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование гражданства

&НаКлиенте
Процедура ГражданствоФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ГражданствоФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицЛицоБезГражданстваПриИзменении(Элемент)
	
	Если ГражданствоФизическихЛицЛицоБезГражданства = 0 Тогда
		
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна)
			И ЗначениеЗаполнено(ГражданствоФизическихЛицПрежняя.Страна) Тогда
		КонецЕсли;
		
		ГражданствоФизическихЛиц.Страна = ГражданствоФизическихЛицПрежняя.Страна;
		Если НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна) Тогда
			ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
		КонецЕсли; 
		
	Иначе
		
		ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка");
		
	КонецЕсли;
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицСтранаПриИзменении(Элемент)
	
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицПериодПриИзменении(Элемент)
	
	ГражданствоФизическихЛиц.Период = ГражданствоФизическихЛицПериод;
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицСтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицИННПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(ЭтаФорма, ОбщегоНазначенияКлиент.ДатаСеанса());
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование удостоверения личности.

&НаКлиенте
Процедура ДокументыФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ДокументыФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСерияПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицСерияПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицНомерПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицНомерПриИзменении(ЭтаФорма, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицДатаВыдачиПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицСрокДействияПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКемВыданПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицКодПодразделенияПриИзменении(Элемент)
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВсеДокументыЭтогоЧеловека(Команда)
	
	СотрудникиКлиент.ОткрытьСписокВсехДокументовФизическогоЛица(ЭтаФорма, ФизическоеЛицоСсылка);
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Работа с Сотрудником

&НаКлиенте
Процедура ДополнитьПредставлениеПриИзменении(Элемент)
	СотрудникиКлиент.ДополнитьПредставлениеФизическогоЛицаПриИзменении(ЭтаФорма);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, ФизическоеЛицо);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Работа(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьЭлемент", Истина);
	
	Если СозданиеНового И Параметры.Ключ.Пустая() Тогда
		
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
				|Переход к сведениям о рабочих местах возможен только после записи данных.
				|Записать данные?'");
				
		Оповещение = Новый ОписаниеОповещения("КомандаРаботаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);	
		
	Иначе 
		
		ДополнительныеПараметры.ЗаписатьЭлемент = Ложь;
		КомандаРаботаЗавершение(Неопределено, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРаботаЗавершение(Знач Ответ, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Ответ) И Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьЭлемент И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Работа"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
	    			
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Страхование(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Страхование"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НалогНаДоходы(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.Сотрудники.Форма.НалогНаДоходы"), ЭтаФорма);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПослеОткрытияФормы()
	
	СотрудникиКлиент.ФизическиеЛицаПриОткрытии(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами.

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы) Экспорт
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтаФорма);
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр) Экспорт
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
		ЭтаФорма,
		СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
		Параметр.АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДанныеДополнительнойФормы(ИмяФормы, Отказ) Экспорт
	
	СотрудникиФормы.СохранитьДанныеДополнительнойФормы(ЭтаФорма, ИмяФормы, Отказ);
	
КонецПроцедуры

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект, ФизическоеЛицо.ФИО, Истина, 
		?(ЗначениеЗаполнено(ФизическоеЛицо.Пол), ?(ФизическоеЛицо.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти


#Область ЗаписьЭлемента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено, Отказ = Ложь) Экспорт 
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЗаписьЭлементаСправочникаФизическиеЛица");

	СотрудникиКлиент.СохранитьДанныеФорм(ЭтаФорма, Отказ, ЗакрытьПослеЗаписи);
	Если НЕ ПроверяютсяОднофамильцы Тогда
		ОчиститьСообщения();
		
		ПараметрыЗаписи = Новый Структура;
		СотрудникиКлиент.ФизическиеЛицаПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

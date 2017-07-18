﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВозможенОбменНаСервере = НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И (НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ОбщегоНазначенияКлиентСервер.КлиентПодключенЧерезВебСервер());
	
	Элементы.ОбменНаСервере.Видимость            = ВозможенОбменНаСервере;
	Элементы.ГруппаНастройкаРасписания.Видимость = ВозможенОбменНаСервере;
	
	ИндексЭлементаУсловногоОформления = -1;
	УстановитьТекущееРабочееМесто();
	
	РасписаниеСтруктура = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента().РасписаниеОбработкиОтветов;
	РасписаниеПроверкиОтветов = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(РасписаниеСтруктура);
	Элементы.НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(РасписаниеПроверкиОтветов);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ЗначениеЗаполнено(РабочееМесто) Тогда
		МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
		УстановитьТекущееРабочееМесто();
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НадписьОткрытьРасписаниеНажатие(Элемент)
	
	Если РасписаниеПроверкиОтветов = Неопределено Тогда
		РасписаниеПроверкиОтветов = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеПроверкиОтветов);
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("НадписьОткрытьРасписаниеНажатиеЗавершение", ЭтотОбъект);
	Диалог.Показать(ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьВсеРабочиеМеста(Команда)
	
	ПоказатьВсеРабочиеМеста = НЕ ПоказатьВсеРабочиеМеста;
	
	Элементы.ФормаПоказатьВсеРабочиеМеста.Пометка = ПоказатьВсеРабочиеМеста;
	
	Если ПоказатьВсеРабочиеМеста Тогда
		УдалитьОтборПоРабочемуМесту();
	Иначе
		УстановитьОтборПоРабочемуМесту();
	КонецЕсли;
	
	УстановитьЗаголовокФормы();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьЗаголовокФормы()
	
	Если ПоказатьВсеРабочиеМеста Тогда
		АвтоЗаголовок = Истина;
		Заголовок = "";
	Иначе
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Настройки обмена с ЕГАИС:'") + " " + Строка(РабочееМесто);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьОтборПоРабочемуМесту()
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.КомпоновщикНастроек.Настройки.Отбор, "РабочееМесто");
	
	ДобавитьУсловноеОформлениеПоТекущемуРабочемуМесту();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоРабочемуМесту()
	
	РабочиеМеста = Новый Массив;
	РабочиеМеста.Добавить(РабочееМесто);
	РабочиеМеста.Добавить(Справочники.РабочиеМеста.ПустаяСсылка());
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор,
		"РабочееМесто",
		РабочиеМеста,
		ВидСравненияКомпоновкиДанных.ВСписке,
		НСтр("ru = 'Доступная настройка обмена'"),
		Истина);
		
	Если ИндексЭлементаУсловногоОформления >= 0 Тогда
		УсловноеОформление.Элементы.Удалить(УсловноеОформление.Элементы.Получить(ИндексЭлементаУсловногоОформления));
		ИндексЭлементаУсловногоОформления = -1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьУсловноеОформлениеПоТекущемуРабочемуМесту()
	
	ПредставлениеЭлемента = НСтр("ru = 'Доступная настройка обмена'");
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = ПредставлениеЭлемента;
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Список");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		"Список.РабочееМесто",
		Новый ПолеКомпоновкиДанных("Список.ТекущееРабочееМесто"),
		ВидСравненияКомпоновкиДанных.Равно,
		ПредставлениеЭлемента,
		Истина);
		
	ИндексЭлементаУсловногоОформления = УсловноеОформление.Элементы.Индекс(ЭлементУсловногоОформления);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОткрытьРасписаниеНажатиеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		РасписаниеПроверкиОтветов = Расписание;
		Элементы.НадписьОткрытьРасписание.Заголовок = ТекстНадписиОткрытьРасписание(РасписаниеПроверкиОтветов);
		ЗаписатьРасписаниеОбработкиОтветов(РасписаниеПроверкиОтветов);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьРасписаниеОбработкиОтветов(РасписаниеПроверкиОтветов)
	
	Отбор = Новый Структура();
	Отбор.Вставить("Метаданные", "ОбработкаОтветовЕГАИС");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Если Задания.Количество() = 1 Тогда
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Расписание", РасписаниеПроверкиОтветов);
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задания[0].УникальныйИдентификатор, ПараметрыЗадания);
	Иначе
		ПоместитьВоВременноеХранилище(РасписаниеПроверкиОтветов, ПараметрыСеанса.ИдентификаторСеансаЕГАИС);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстНадписиОткрытьРасписание(Расписание)
	
	СтроковоеПредставлениеРасписания = Строка(Расписание);
	Возврат ?(Не ПустаяСтрока(СтроковоеПредставлениеРасписания),
		СтроковоеПредставлениеРасписания, НСтр("ru = 'Не задано'"));
		
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Представление = НСтр("ru='Представление рабочего места'");
	ЭлементУсловногоОформления.Использование = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='<Все>'"));
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("РабочееМесто");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭлементУсловногоОформления.Отбор,
		"Список.РабочееМесто",
		,
		ВидСравненияКомпоновкиДанных.НеЗаполнено,
		НСтр("ru='Пустое рабочее место'"),
		Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущееРабочееМесто()
	
	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	Список.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	
	УстановитьОтборПоРабочемуМесту();
	
КонецПроцедуры

#КонецОбласти
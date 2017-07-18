﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда	
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбработанаТабличнаяЧастьТовары" И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.Свойство("ИдентификаторВызывающейФормы")
		И Параметр.ИдентификаторВызывающейФормы = УникальныйИдентификатор Тогда
		
		ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "ПроведениеУстановкаЦенНоменклатуры";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПроводитьНулевыеЗначенияПриИзменении(Элемент)
	
	Объект.НеПроводитьНулевыеЗначения = НЕ ПроводитьНулевыеЗначения;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Товары

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Элементы.Товары.ТекущиеДанные, ПриИзмененииНоменклатуры(
		ТекущиеДанные.Номенклатура, Объект.Дата, Объект.ТипЦен));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ДобавитьПоПоступлению(Команда)

	// Теперь нужно выбрать документ, по которому будем заполнять
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДобавитьПоПоступлениюЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПоступлениюЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ДокументПоступление = РезультатЗакрытия;
	
	Если НЕ ЗначениеЗаполнено(ДокументПоступление) Тогда 
		Возврат; // ничего не выбрали.
	КонецЕсли;

	ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоЦенамНоменклатуры(Команда)
	
	ЗаполнитьТовары(Ложь, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеНоменклатуры(Команда)

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоГруппеНоменклатурыЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораГруппы",,,,,, ОповещениеОЗакрытии);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГруппеНоменклатурыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Группа = РезультатЗакрытия;	
	
	Если ЗначениеЗаполнено(Группа) Тогда
		ЗаполнитьТовары(Истина, Ложь, Истина, Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНоменклатуре(Команда)
	
	ЗаполнитьТовары(Истина, Ложь, Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоПоступлению(Команда)

	// Если заполняем, то почистим ТЧ
	Если Объект.Товары.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиПоПоступлениюЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		ОткрытьФормуВыбораПоступления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоПоступлениюЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ДокументПоступление = РезультатЗакрытия;
	
	Если НЕ ЗначениеЗаполнено(ДокументПоступление) Тогда 
		Возврат; // ничего не выбрали.
	КонецЕсли;

	ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоЦенамНоменклатуры(Команда)

	ЗаполнитьТовары(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПоЦенамНоменклатуры(Команда)

	ЗаполнитьТовары(Ложь, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТовары(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора, 
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТовары(Команда)

	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧастиТовары();
	
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ИзменениеТаблицыТоваров.Форма.Форма", ПараметрыФормы,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ПроводитьНулевыеЗначения = НЕ Объект.НеПроводитьНулевыеЗначения;
	
	УстановитьСостояниеДокумента();

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиОбщаяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТоварыСервер(
			ДополнительныеПараметры.Очистить,
			ДополнительныеПараметры.Обновить,
			ДополнительныеПараметры.ПоНоменклатуре,
			ДополнительныеПараметры.Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТовары(Очистить, Обновить, ПоНоменклатуре = Ложь, Группа = Неопределено)
	
	Если Объект.Товары.Количество() <> 0 
		И Очистить Тогда
		ТекстВопроса = НСтр("ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Очистить", Очистить);
		ДополнительныеПараметры.Вставить("Обновить", Обновить);
		ДополнительныеПараметры.Вставить("ПоНоменклатуре", ПоНоменклатуре);
		ДополнительныеПараметры.Вставить("Группа", Группа);
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗаполнениемТабличнойЧастиОбщаяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	Иначе
		ЗаполнитьТоварыСервер(Очистить, Обновить, ПоНоменклатуре, Группа);
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыСервер(Очистить, Обновить, ПоНоменклатуре = Ложь, Группа = Неопределено)
	
	Если Очистить Тогда
		Объект.Товары.Очистить();
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним все требуемые реквизиты
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен", Объект.Дата);
	Запрос.УстановитьПараметр("ТипЦен",  Объект.ТипЦен);
	Запрос.УстановитьПараметр("Ложь",    Ложь);
	Запрос.УстановитьПараметр("Группа",  Группа);
	Текст =
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.ТипЦен,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	|	ЦеныНоменклатурыСрезПоследних.Валюта,
	|	ЦеныНоменклатурыСрезПоследних.Цена
	|ПОМЕСТИТЬ ВТЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦен, ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатуры.Цена ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ ЦеныНоменклатуры.Цена
	|	КОНЕЦ КАК Цена,
	|	ВЫБОР
	|		КОГДА ЦеныНоменклатуры.Валюта ЕСТЬ NULL 
	|			ТОГДА ТипыЦенСправочник.ВалютаЦены
	|		ИНАЧЕ ЦеныНоменклатуры.Валюта
	|	КОНЕЦ КАК Валюта
	|ИЗ
	|	Справочник.Номенклатура КАК СправочникНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ПО СправочникНоменклатура.Ссылка = ЦеныНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатуры КАК ТипыЦенСправочник
	|		ПО (ЦеныНоменклатуры.ТипЦен = ТипыЦенСправочник.Ссылка)
	|ГДЕ
	|	СправочникНоменклатура.ЭтоГруппа = &Ложь";
	Если НЕ ПоНоменклатуре Тогда
		Текст = Текст + 
		" И
		|	ТипыЦенСправочник.Ссылка = &ТипЦен	
		|";
	КонецЕсли;
	Если ЗначениеЗаполнено(Группа) Тогда
		Текст = Текст + 
		" И
		|	СправочникНоменклатура.Ссылка В ИЕРАРХИИ (&Группа)
		|";
	КонецЕсли;
	Запрос.Текст = Текст;
	Выборка = Запрос.Выполнить().Выбрать();
	
	ВалютаПоТипуЦен = ВалютаЦены(Объект.ТипЦен);
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);
		
		СтрокиТабличнойЧасти = Объект.Товары.НайтиСтроки(СтруктураОтбора);
		Если СтрокиТабличнойЧасти.Количество() = 0 Тогда
			Если Обновить Тогда
				Продолжить;
			Иначе
				СтрокаТабличнойЧасти = Объект.Товары.Добавить();
				СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;
			КонецЕсли;
		Иначе
			СтрокаТабличнойЧасти = СтрокиТабличнойЧасти[0];
		КонецЕсли;
		СтрокаТабличнойЧасти.Цена   = Выборка.Цена;
		СтрокаТабличнойЧасти.Валюта = Выборка.Валюта;
		
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Валюта) Тогда
			СтрокаТабличнойЧасти.Валюта = ВалютаПоТипуЦен;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПриИзмененииНоменклатуры(Номенклатура, Дата, ТипЦен)
	
	ВыходныеПараметры = новый Структура("Цена,Валюта");
	
	Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда

		// Ничего делать не надо
		Возврат ВыходныеПараметры;

	КонецЕсли;

	// Заполним все требуемые реквизиты
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЦен", Дата);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатуры.Цена КАК Цена,
	|	ЦеныНоменклатуры.Валюта КАК Валюта
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			&ДатаЦен,
	|			ТипЦен = &ТипЦен
	|				И Номенклатура = &Номенклатура) КАК ЦеныНоменклатуры";

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ВыходныеПараметры.Цена   = 0;
		ВыходныеПараметры.Валюта = ВалютаЦены(ТипЦен);
	Иначе
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ВыходныеПараметры.Цена   = Выборка.Цена;
			ВыходныеПараметры.Валюта = Выборка.Валюта;
		КонецЦикла;
	КонецЕсли;

	Возврат ВыходныеПараметры;
	
КонецФункции

&НаСервере
// Процедура выполняет заполнение табличной части 
// копированием из выбранного пользователем документа Поступления.
//
// Параметры:
//  ДокументПоступление - Документ поступления, данными которого надо заполнить табличную часть.
//  ЧиститьТипыЦен      - Признак необходимости очистки типов цен перед заполнением.
//
Процедура ЗаполнитьТабличнуюЧастьПоПоступлению(ДокументПоступление, ЧиститьТипыЦен = Истина)

	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("ДокументОснование", ДокументПоступление);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	Док.ВалютаДокумента КАК ВалютаДокумента,
	|	Док.ТипЦен КАК ТипЦен,
	|	ЕСТЬNULL(Док.ТипЦен.ЦенаВключаетНДС, Док.СуммаВключаетНДС) КАК ТипЦенЦенаВключаетНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК Док
	|ГДЕ
	|	Док.Ссылка = &ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Цена КАК Цена,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	МИНИМУМ(Товары.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &ДокументОснование
	|	И Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура,
	|	Товары.Цена,
	|	Товары.СтавкаНДС
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Результаты = Запрос.ВыполнитьПакет();
	
	Шапка = Результаты[0].Выбрать();
	Шапка.Следующий();
	
	Выборка = Результаты[1].Выбрать();

	Пока Выборка.Следующий() Цикл

		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("Номенклатура", Выборка.Номенклатура);

		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, "Товары", СтруктураОтбора);

		Если СтрокаТабличнойЧасти = Неопределено Тогда

			СтрокаТабличнойЧасти = Объект.Товары.Добавить();
			СтрокаТабличнойЧасти.Номенклатура = Выборка.Номенклатура;

		КонецЕсли;
		СтрокаТабличнойЧасти.Цена  = УчетНДСКлиентСервер.ПересчитатьЦенуПриИзмененииФлаговНалогов(
		                                        Выборка.Цена,
		                                        Шапка.СуммаВключаетНДС,
		                                        Шапка.ТипЦенЦенаВключаетНДС,
		                                        УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(Выборка.СтавкаНДС));

		СтрокаТабличнойЧасти.Валюта =  Шапка.ВалютаДокумента;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабличнуюЧастьПоПоступлению()

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ПараметрыФормы = Новый Структура;
	
	ДатаРасчетов 	 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	ЗаголовокПодбора = НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		Параметрыформы.Вставить("ПоказыватьЦены", Истина);
	КонецЕсли;
	
	Если ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Товары'");
		
		ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	КонецЕсли;
	
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	ВалютаЦены = ВалютаЦены(Объект.ТипЦен);

	ПараметрыФормы.Вставить("ЕстьЦена"		, Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Ложь);
	ПараметрыФормы.Вставить("ДатаРасчетов"	, ДатаРасчетов);
	ПараметрыФормы.Вставить("ТипЦен"		, Объект.ТипЦен);
	ПараметрыФормы.Вставить("Валюта"		, ВалютаЦены);
	ПараметрыФормы.Вставить("Заголовок"		, ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"	, ПолучитьВидПодбора(ИмяТаблицы));
	ПараметрыФормы.Вставить("ИмяТаблицы"	, ИмяТаблицы);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаКлиенте
Функция ПолучитьВидПодбора(ИмяТаблицы)
	
	ВидПодбора = "";
	
	Возврат ВидПодбора;	

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
	
	Для Каждого СтрокаТовара Из ТаблицаТоваров Цикл
		НоваяСтрока = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		МетаданныеДокумента = Объект.Ссылка.Метаданные();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВалютаЦены(ТипЦены)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипЦены, "ВалютаЦены");
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыОбработкиТабличнойЧастиТовары()

	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТовары", 		ПоместитьТоварыВоВременноеХранилищеНаСервере());
	ПараметрыОбработки.Вставить("ЗаполнятьЦеныПоПокупке", 		Ложь);
	
	ПараметрыОбработки.Вставить("ДокументСсылка", 				Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата", 				Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументТипЦен", 				Объект.ТипЦен);
	
	ИменаТаблицИсточников = Новый СписокЗначений();
	ИменаТаблицИсточников.Добавить("Товары");
	ИменаТаблицИсточников.Добавить("Услуги");

	ПараметрыОбработки.Вставить("ИмяТаблицы", 					"Товары");
	ПараметрыОбработки.Вставить("РазрешитьУслуги", 				Истина);
	ПараметрыОбработки.Вставить("ИменаТаблицИсточников",		ИменаТаблицИсточников);
	
	Возврат ПараметрыОбработки;
	
КонецФункции 

&НаСервере
Процедура ОбработкаОповещенияОбработкиТабличнойЧастиТоварыНаСервере(Параметры)
	
	ТаблицаОбработки = ПолучитьИзВременногоХранилища(Параметры.АдресОбработаннойТабличнойЧастиТоварыВХранилище);
	Объект.Товары.Загрузить(ТаблицаОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗаполнениемТабличнойЧастиПоПоступлениюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Товары.Очистить();
		ОткрытьФормуВыбораПоступления();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПоступления()
	
	// Теперь нужно выбрать документ, по которому будем заполнять
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ЗаполнитьПоПоступлениюЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаВыбора",,,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать


﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ТТНВходящаяЕГАИС", ТТНВходящаяЕГАИС) Тогда
		ВызватьИсключение НСтр("ru='Непосредственное открытие этой формы не предусмотрено.'");
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект.Товары.Количество() = 0 Тогда
		Отказ = Истина;
		Если ЭтотОбъект.ОписаниеОповещенияОЗакрытии <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ЭтотОбъект.ОписаниеОповещенияОЗакрытии, Истина);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьСсылкиУстановкиРеквизитовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыУстановкиЗначенийРеквизитов", ЭтотОбъект);
	
	ЗначенияРеквизитов = Новый Структура;
	ЗначенияРеквизитов.Вставить("Родитель", Родитель);
	ЗначенияРеквизитов.Вставить("ВидНоменклатуры", ВидНоменклатуры);
	ЗначенияРеквизитов.Вставить("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	ЗначенияРеквизитов.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	ЗначенияРеквизитов.Вставить("СтавкаНДС", СтавкаНДС);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияРеквизитов", ЗначенияРеквизитов);
	
	ОткрытьФорму("ОбщаяФорма.ФормаУстановкиЗначенийРеквизитовНоменклатуры", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары
&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	ДанныеТекущейСтроки = Элементы.Товары.ТекущиеДанные;
	ДанныеТекущейСтроки.Статус = ?(ЗначениеЗаполнено(ДанныеТекущейСтроки.Номенклатура), 0, 2);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Отбор = Новый Структура;
	СтандартнаяОбработка = Ложь;
	ДанныеТекущейСтроки = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьОтборыДляНоменклатуры(Отбор, ДанныеТекущейСтроки.Производитель,
										ДанныеТекущейСтроки.Импортер,
										ДанныеТекущейСтроки.АлкогольнаяПродукция);
	
	ПараметрыФормы = Новый Структура("СведенияОбАлкогольнойПродукции", Отбор);
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораАлкогольнойПродукции", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ДанныеТекущейСтроки = Элементы.Товары.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки.Статус = 2 Тогда // будет создана новая номенклатура
		СтандартнаяОбработка = Ложь;
		ТекстПодбора = НСтр(СтрШаблон("ru = 'Создать: %1'", ДанныеТекущейСтроки.АлкогольнаяПродукция));
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(ТекстПодбора);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") И СтрНайти(ВыбранноеЗначение, НСтр("ru = 'Создать:'")) > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеОбъекта = Новый Структура("ВидНоменклатуры, Родитель, НоменклатурнаяГруппа, СтавкаНДС, ЕдиницаИзмерения");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтаФорма);
		
		ДанныеСтроки = Новый Структура("АлкогольнаяПродукция, Производитель, Импортер");
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, Элементы.Товары.ТекущиеДанные);
		
		ДанныеЗаполнения = ДанныеЗаполненияНоменклатуры(ДанныеСтроки, ДанныеОбъекта);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("ТекстЗаполнения", ДанныеЗаполнения.Наименование);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ДанныеЗаполнения);
		
		ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Элемент);
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	АдресХранилища = ПеренестиВДокументНаСервере();
	Если АдресХранилища <> Неопределено Тогда
		Закрыть(АдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗагрузкаТоваровИзТТНЕГАИС

&НаСервереБезКонтекста
Функция ТаблицаТоварыЕГАИС(ТТНВходящаяЕГАИС)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТТНВходящаяЕГАИС", ТТНВходящаяЕГАИС);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТТНВходящаяЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТТНВходящаяЕГАИС.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
	|	ТТНВходящаяЕГАИС.НомерСтроки
	|ПОМЕСТИТЬ ВТ_АлкогольнаяПродукцияЕГАИС
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК ТТНВходящаяЕГАИС
	|ГДЕ
	|	ТТНВходящаяЕГАИС.Ссылка = &ТТНВходящаяЕГАИС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АлкогольнаяПродукция,
	|	ИдентификаторУпаковки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АлкогольнаяПродукцияЕГАИС.АлкогольнаяПродукция,
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Наименование КАК НаименованиеЕГАИС,
	|	КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции,
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Производитель,
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Импортер,
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Объем,
	|	АлкогольнаяПродукцияЕГАИС.ИдентификаторУпаковки,
	|	АлкогольнаяПродукцияЕГАИС.НомерСтроки
	|ПОМЕСТИТЬ ВТ_НоменклатураБезСоответствия
	|ИЗ
	|	ВТ_АлкогольнаяПродукцияЕГАИС КАК АлкогольнаяПродукцияЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО АлкогольнаяПродукцияЕГАИС.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО АлкогольнаяПродукцияЕГАИС.АлкогольнаяПродукция = СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция
	|			И АлкогольнаяПродукцияЕГАИС.ИдентификаторУпаковки = СоответствиеНоменклатурыЕГАИС.ИдентификаторУпаковки
	|ГДЕ
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура ЕСТЬ NULL
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НаименованиеЕГАИС
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_НоменклатураБезСоответствия.АлкогольнаяПродукция,
	|	СправочникНоменклатура.Ссылка КАК Номенклатура,
	|	НЕ СведенияОбАлкогольнойПродукции.Номенклатура ЕСТЬ NULL КАК ЕстьСведенияОбАлкогольнойПродукции
	|ПОМЕСТИТЬ ВТ_СоответствиеНоменклатуры
	|ИЗ
	|	ВТ_НоменклатураБезСоответствия КАК ВТ_НоменклатураБезСоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СправочникНоменклатура
	|		ПО ВТ_НоменклатураБезСоответствия.НаименованиеЕГАИС = СправочникНоменклатура.НаименованиеПолное
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК СправочникПроизводитель
	|		ПО (СправочникНоменклатура.Производитель = СправочникПроизводитель.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК СправочникИмпортер
	|		ПО (СправочникНоменклатура.Импортер = СправочникИмпортер.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбАлкогольнойПродукции КАК СведенияОбАлкогольнойПродукции
	|		ПО (СправочникНоменклатура.Ссылка = СведенияОбАлкогольнойПродукции.Номенклатура)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК СправочникПроизводительЕГАИС
	|		ПО ВТ_НоменклатураБезСоответствия.Производитель = СправочникПроизводительЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторОрганизацийЕГАИС КАК СправочникИмпортерЕГАИС
	|		ПО ВТ_НоменклатураБезСоответствия.Импортер = СправочникИмпортерЕГАИС.Ссылка
	|ГДЕ
	|	НЕ СправочникНоменклатура.ПометкаУдаления
	|	И ЕСТЬNULL(СведенияОбАлкогольнойПродукции.КоэффПересчетаДал * 10, ВТ_НоменклатураБезСоответствия.Объем) = ВТ_НоменклатураБезСоответствия.Объем
	|	И ЕСТЬNULL(СправочникИмпортер.ИНН, СправочникИмпортерЕГАИС.ИНН) = СправочникИмпортерЕГАИС.ИНН
	|	И ЕСТЬNULL(СправочникИмпортер.КПП, СправочникИмпортерЕГАИС.КПП) = СправочникИмпортерЕГАИС.КПП
	|	И ЕСТЬNULL(СправочникПроизводитель.ИНН, СправочникПроизводительЕГАИС.ИНН) = СправочникПроизводительЕГАИС.ИНН
	|	И ЕСТЬNULL(СправочникПроизводитель.КПП, СправочникПроизводительЕГАИС.КПП) = СправочникПроизводительЕГАИС.КПП
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция,
	|	МАКСИМУМ(ВТ_СоответствиеНоменклатуры.ЕстьСведенияОбАлкогольнойПродукции) КАК ЕстьСведенияОбАлкогольнойПродукции
	|ПОМЕСТИТЬ АлкогольнаяПродукцияПоТипам
	|ИЗ
	|	ВТ_СоответствиеНоменклатуры КАК ВТ_СоответствиеНоменклатуры
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция,
	|	МАКСИМУМ(ВТ_СоответствиеНоменклатуры.Номенклатура) КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_СоответствиеНоменклатурыБезДублей
	|ИЗ
	|	ВТ_СоответствиеНоменклатуры КАК ВТ_СоответствиеНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ АлкогольнаяПродукцияПоТипам КАК АлкогольнаяПродукцияПоТипам
	|		ПО ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция = АлкогольнаяПродукцияПоТипам.АлкогольнаяПродукция
	|			И ВТ_СоответствиеНоменклатуры.ЕстьСведенияОбАлкогольнойПродукции = АлкогольнаяПродукцияПоТипам.ЕстьСведенияОбАлкогольнойПродукции
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НоменклатураБезСоответствия.АлкогольнаяПродукция,
	|	НоменклатураБезСоответствия.ИдентификаторУпаковки,
	|	НоменклатураБезСоответствия.ВидПродукции,
	|	НоменклатураБезСоответствия.Производитель,
	|	НоменклатураБезСоответствия.Импортер,
	|	НоменклатураБезСоответствия.Объем,
	|	1 КАК КоэффициентПересчетаУпаковки,
	|	ВЫБОР
	|		КОГДА ВТ_СоответствиеНоменклатуры.Номенклатура ЕСТЬ NULL
	|			ТОГДА 2
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Статус,
	|	""Новый:"" + НоменклатураБезСоответствия.НаименованиеЕГАИС КАК ПредставлениеНовойНоменклатуры,
	|	ВТ_СоответствиеНоменклатуры.Номенклатура КАК Номенклатура,
	|	НоменклатураБезСоответствия.НомерСтроки КАК НомерСтроки_ЕГАИС
	|ИЗ
	|	ВТ_НоменклатураБезСоответствия КАК НоменклатураБезСоответствия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеНоменклатурыБезДублей КАК ВТ_СоответствиеНоменклатуры
	|		ПО НоменклатураБезСоответствия.АлкогольнаяПродукция = ВТ_СоответствиеНоменклатуры.АлкогольнаяПродукция";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаСервере
Процедура ЗагрузитьТаблицуТовары()
	ТаблицаТоварыЕГАИС = ТаблицаТоварыЕГАИС(Параметры.ТТНВходящаяЕГАИС);
	Объект.Товары.Загрузить(ТаблицаТоварыЕГАИС);
КонецПроцедуры

#КонецОбласти 

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Серый текст для новой номенклатуры
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыНоменклатура");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.Товары.ПредставлениеНовойНоменклатуры"));
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКоэффициентПересчетаУпаковки");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.Номенклатура", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", "1,000");
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	// Установка значений реквизитов для новой номенклатуры по умолчанию
	СтавкаНДС					 = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС, Перечисления.СтавкиНДС.НДС18);
	ЕдиницаИзмерения			 = ?(ЗначениеЗаполнено(ЕдиницаИзмерения), ЕдиницаИзмерения,
		Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду("796")); // единица измерения по умолчанию - штука
	ВидНоменклатуры				 = ?(ЗначениеЗаполнено(ВидНоменклатуры), ВидНоменклатуры, Справочники.ВидыНоменклатуры.НайтиСоздатьЭлементыТовар());
	НоменклатурнаяГруппа		 = ?(ЗначениеЗаполнено(НоменклатурнаяГруппа), НоменклатурнаяГруппа,
		БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа());
		
	ЗагрузитьТаблицуТовары();
	УстановитьУсловноеОформление();
	ЗаголовокСсылкиУстановкиРеквизитов();
	
КонецПроцедуры

#Область УстановкаРеквизитовПоУмолчанию

&НаСервере
Процедура ЗаголовокСсылкиУстановкиРеквизитов()
	
	МассивРеквизитов = СтрРазделить("Родитель,ВидНоменклатуры,НоменклатурнаяГруппа,ЕдиницаИзмерения,СтавкаНДС", ",", Ложь);
	МассивЗначений = Новый Массив;
	Для Каждого ЭлементМассива Из МассивРеквизитов Цикл
		
		ЗначениеРеквизитаСтр = Строка(ЭтотОбъект[ЭлементМассива]);
		Если Не ПустаяСтрока(ЗначениеРеквизитаСтр) Тогда
			
			Если ЭлементМассива = "СтавкаНДС" Тогда
				
				МассивЗначений.Добавить("НДС " + Строка(ЗначениеРеквизитаСтр));
				
			Иначе
			
				МассивЗначений.Добавить(Строка(ЗначениеРеквизитаСтр));
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	ЗаголовокСсылки = НСтр("ru = 'Реквизиты новой номенклатуры: '");
	ПерваяИтерация = Истина;
	Для Каждого ЭлементМассива Из МассивЗначений Цикл
		
		ЗаголовокСсылки = ЗаголовокСсылки + ?(ПерваяИтерация, "", ", ") + ЭлементМассива;
		ПерваяИтерация = Ложь;
		
	КонецЦикла;
	НадписьСсылкиУстановкиРеквизитов = ЗаголовокСсылки;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыУстановкиЗначенийРеквизитов(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено ИЛИ РезультатЗакрытия = КодВозвратаДиалога.Отмена Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатЗакрытия);
	ЗаголовокСсылкиУстановкиРеквизитов();
	
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Процедура ЗаполнитьОтборыДляНоменклатуры(Отбор, Производитель, Импортер, АлкогольнаяПродукция)
	
	КонтрагентыЕГАИС = Новый Массив;
	КонтрагентыЕГАИС.Добавить(Производитель);
	КонтрагентыЕГАИС.Добавить(Импортер);
	
	СоответствиеКонтрагентовЕГАИС = Обработки.СопоставлениеДанныхЕГАИС.СоответствиеКонтрагентовЕГАИС(КонтрагентыЕГАИС);
	
	Если ЗначениеЗаполнено(Производитель) Тогда
		Отбор.Вставить("Производитель", СоответствиеКонтрагентовЕГАИС[Производитель]);
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Импортер) Тогда
		Отбор.Вставить("Импортер", СоответствиеКонтрагентовЕГАИС[Импортер]);
	КонецЕсли;
	
	СвойстваАлкогольнойПродукции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АлкогольнаяПродукция, "ВидПродукции.Код, Объем");
	
	Отбор.Вставить("КодАлкогольнойПродукции", СвойстваАлкогольнойПродукции.ВидПродукцииКод);
	Отбор.Вставить("Объем", СвойстваАлкогольнойПродукции.Объем);
	
КонецПроцедуры

&НаСервере
Функция ВидыАлкогольнойПродукции()
	Результат = Новый Соответствие;

	Макет169 = РегистрыСведений.СведенияОбАлкогольнойПродукции.ПолучитьМакет("Макет169");
	
	Область = Макет169.Области.ВидыПродукции;
	Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Строки Тогда
		ВерхОбласти = Область.Верх;
		НизОбласти = Область.Низ;
		Для НомСтр = ВерхОбласти По НизОбласти Цикл
			КодПоказателя = СокрП(Макет169.Область(НомСтр, 1).Текст);
			Если НЕ ПустаяСтрока(КодПоказателя) И КодПоказателя <> "###" Тогда
				Наименование = СокрП(Макет169.Область(НомСтр, 2).Текст);
				Результат.Вставить(КодПоказателя, Наименование);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеЗаполненияНоменклатуры(ДанныеСтроки, ДанныеОбъекта)
	
	КонтрагентыЕГАИС = Новый Массив;
	КонтрагентыЕГАИС.Добавить(ДанныеСтроки.Производитель);
	КонтрагентыЕГАИС.Добавить(ДанныеСтроки.Импортер);
	
	СоответствиеКонтрагентовЕГАИС = Обработки.СопоставлениеДанныхЕГАИС.СоответствиеКонтрагентовЕГАИС(КонтрагентыЕГАИС);
	
	ДанныеАлкогольнойПродукции = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеСтроки.АлкогольнаяПродукция, "Наименование, НаименованиеПолное");
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Наименование",         СокрЛП(ДанныеАлкогольнойПродукции.Наименование));
	ДанныеЗаполнения.Вставить("НаименованиеПолное",   СокрЛП(ДанныеАлкогольнойПродукции.НаименованиеПолное));
	ДанныеЗаполнения.Вставить("ВидНоменклатуры",      ДанныеОбъекта.ВидНоменклатуры);
	ДанныеЗаполнения.Вставить("Родитель",             ДанныеОбъекта.Родитель);
	ДанныеЗаполнения.Вставить("НоменклатурнаяГруппа", ДанныеОбъекта.НоменклатурнаяГруппа);
	ДанныеЗаполнения.Вставить("СтавкаНДС",            ДанныеОбъекта.СтавкаНДС);
	ДанныеЗаполнения.Вставить("ЕдиницаИзмерения",     ДанныеОбъекта.ЕдиницаИзмерения);
	ДанныеЗаполнения.Вставить("Производитель",        СоответствиеКонтрагентовЕГАИС[ДанныеСтроки.Производитель]);
	ДанныеЗаполнения.Вставить("Импортер",             СоответствиеКонтрагентовЕГАИС[ДанныеСтроки.Импортер]);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

&НаСервере
Процедура СоздатьНовыеЭлементыСправочникаНоменклатуры()
	ДанныеОбъекта = Новый Структура("ВидНоменклатуры, Родитель, НоменклатурнаяГруппа, СтавкаНДС, ЕдиницаИзмерения");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтаФорма);
	
	СозданныеЭлементы = Новый Соответствие;
	
	ДанныеСтроки = Новый Структура("АлкогольнаяПродукция, Производитель, Импортер");
		
	Для каждого СтрокаТовары Из Объект.Товары Цикл
		
		Если СтрокаТовары.Статус = 2 Тогда
			Если СозданныеЭлементы[СтрокаТовары.АлкогольнаяПродукция] = Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТовары);
				
				ДанныеЗаполнения = ДанныеЗаполненияНоменклатуры(ДанныеСтроки, ДанныеОбъекта);
				
				ЭлементНоменклатуры = Справочники.Номенклатура.СоздатьЭлемент();
				ЭлементНоменклатуры.Наименование = ДанныеЗаполнения.Наименование;
				ЭлементНоменклатуры.Заполнить(ДанныеЗаполнения);
				ЭлементНоменклатуры.Записать();
				
				СозданныеЭлементы.Вставить(СтрокаТовары.АлкогольнаяПродукция, ЭлементНоменклатуры.Ссылка);
			КонецЕсли; 
		
			СтрокаТовары.Номенклатура = СозданныеЭлементы[СтрокаТовары.АлкогольнаяПродукция];
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОбАлкогольнойПродукции()
	// Заполняем сведения об алкогольной продукции только для тех элементов, для которых такой записи нет
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТовары", Объект.Товары.Выгрузить(,"АлкогольнаяПродукция, Номенклатура, Объем"));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.АлкогольнаяПродукция,
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Объем
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ВидыАлкогольнойПродукцииЕГАИС.Код КАК КодВида169,
	|	ВидыАлкогольнойПродукцииЕГАИС.ВидЛицензии КАК ВидЛицензии,
	|	ТаблицаТовары.Объем / 10 КАК КоэффПересчетаДал
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукцииЕГАИС КАК ВидыАлкогольнойПродукцииЕГАИС
	|			ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукцииЕГАИС.Ссылка
	|		ПО ТаблицаТовары.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбАлкогольнойПродукции КАК СведенияОбАлкогольнойПродукции
	|		ПО ТаблицаТовары.Номенклатура = СведенияОбАлкогольнойПродукции.Номенклатура
	|ГДЕ
	|	СведенияОбАлкогольнойПродукции.Номенклатура ЕСТЬ NULL ";
	
	СоответствиеВидовЛицензийЕГАИС = Обработки.СопоставлениеДанныхЕГАИС.СоответствиеВидовЛицензийЕГАИС();
	ВидыАлкогольнойПродукции = ВидыАлкогольнойПродукции();
	
	ТаблицаТоваров = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТовары Из ТаблицаТоваров Цикл
		ЗаписьСведений = РегистрыСведений.СведенияОбАлкогольнойПродукции.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ЗаписьСведений, СтрокаТовары);
		
		ЗаписьСведений.ВидЛицензии         = СоответствиеВидовЛицензийЕГАИС[СтрокаТовары.ВидЛицензии];
		ЗаписьСведений.НаименованиеВида169 = ВидыАлкогольнойПродукции[СтрокаТовары.КодВида169];
		
		ЗаписьСведений.Записать(Истина);
	КонецЦикла; 

КонецПроцедуры 

&НаСервере
Функция ТаблицаСопоставленияНоменклатуры()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаТовары", Объект.Товары.Выгрузить(,"НомерСтроки_ЕГАИС, АлкогольнаяПродукция, ИдентификаторУпаковки, Номенклатура, КоэффициентПересчетаУпаковки"));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки_ЕГАИС КАК НомерСтроки,
	|	ТаблицаТовары.АлкогольнаяПродукция,
	|	ТаблицаТовары.ИдентификаторУпаковки,
	|	ТаблицаТовары.КоэффициентПересчетаУпаковки,
	|	ТаблицаТовары.Номенклатура
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	&ТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки,
	|	ТаблицаТовары.АлкогольнаяПродукция,
	|	ТаблицаТовары.ИдентификаторУпаковки,
	|	ТаблицаТовары.КоэффициентПересчетаУпаковки,
	|	ТаблицаТовары.Номенклатура
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции 

&НаСервере
Процедура ЗаполнитьРегистрСоответствиеНоменклатурыЕГАИС(ТаблицаСопоставленияНоменклатуры)
	РегистрСоотвествия = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьНаборЗаписей();
	ТаблицаСопоставленияНоменклатуры.Свернуть("АлкогольнаяПродукция, ИдентификаторУпаковки, Номенклатура, КоэффициентПересчетаУпаковки");
	
	Для каждого Строка Из ТаблицаСопоставленияНоменклатуры Цикл
		ЗаполнитьЗначенияСвойств(РегистрСоотвествия.Добавить(), Строка);
	КонецЦикла; 
	
	РегистрСоотвествия.Записать(Ложь);
КонецПроцедуры

&НаСервере
Функция ПеренестиВДокументНаСервере()
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	СоздатьНовыеЭлементыСправочникаНоменклатуры();
	ЗаполнитьСведенияОбАлкогольнойПродукции();
	
	ТаблицаСопоставленияНоменклатуры = ТаблицаСопоставленияНоменклатуры();
	ЗаполнитьРегистрСоответствиеНоменклатурыЕГАИС(ТаблицаСопоставленияНоменклатуры.Скопировать());
	
	ЗафиксироватьТранзакцию();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаСопоставленияНоменклатуры);

КонецФункции

#КонецОбласти




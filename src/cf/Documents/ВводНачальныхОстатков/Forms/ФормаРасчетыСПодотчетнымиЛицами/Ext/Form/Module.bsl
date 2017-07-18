﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();


	// РасчетыСПодотчетнымиЛицамиВалюта, РасчетыСПодотчетнымиЛицамиВалютнаяСумма

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "РасчетыСПодотчетнымиЛицамиВалюта");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "РасчетыСПодотчетнымиЛицамиВалютнаяСумма");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.РасчетыСПодотчетнымиЛицами.СчетУчетаВалютный", ВидСравненияКомпоновкиДанных.Равно, Ложь);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// РасчетыСПодотчетнымиЛицамиСумма

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "РасчетыСПодотчетнымиЛицамиСумма");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.РасчетыСПодотчетнымиЛицами.СуммаТолькоПросмотр", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);


	// РасчетыСПодотчетнымиЛицамиСуммаКт

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "РасчетыСПодотчетнымиЛицамиСуммаКт");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.РасчетыСПодотчетнымиЛицами.СуммаКтТолькоПросмотр", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	
	ТекущаяДатаДокумента			= Объект.Дата;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();

	// Ограничение выбора счета учета:
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами_);
	УсловияОтбораСубсчетов = БухгалтерскийУчет.НовыеУсловияОтбораСубсчетов();
	УсловияОтбораСубсчетов.ИспользоватьВПроводках = Истина;
	СчетаДляОтбора = БухгалтерскийУчет.СформироватьМассивСубсчетовПоОтбору(МассивСчетов, УсловияОтбораСубсчетов);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.РасчетыСПодотчетнымиЛицамиСчетУчета, СчетаДляОтбора);

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
	Элементы.ПодразделениеОрганизации.Видимость = ПолучитьФункциональнуюОпцию("ВестиУчетПоПодразделениям");

	Если ТипЗнч(Параметры) = Тип("ДанныеФормыСтруктура") Тогда
		Параметры.Свойство("ОткрытиеИзОбработкиВводаНачальныхОстатков", ОткрытиеИзОбработкиВводаНачальныхОстатков);
	КонецЕсли;
	
	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УстановитьСостояниеДокумента();
	УправлениеФормой();

КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()

	// Установка режима "Только просмотр" для поля "Дата"
	Элементы.Дата.ТолькоПросмотр =
		ЗначениеЗаполнено(Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация))
		И Объект.ОтражатьВБухгалтерскомУчете
		И объект.ОтражатьВНалоговомУчете
		И Объект.ОтражатьПоСпециальнымРегистрам;

	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	ЭтаФорма.Элементы,
	"ФормаОткрытьФормуНастройкиРежима",
	"Видимость",
	НЕ ОткрытиеИзОбработкиВводаНачальныхОстатков);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для каждого СтрокаТаблицы Из Объект.РасчетыСПодотчетнымиЛицами Цикл

		Если ЗначениеЗаполнено(СтрокаТаблицы.СчетУчета) Тогда
			СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);
			СтрокаТаблицы.СчетУчетаВалютный = СвойстваСчета.Валютный;
			СтрокаТаблицы.СуммаТолькоПросмотр = СвойстваСчета.Вид = ВидСчета.Пассивный;
			СтрокаТаблицы.СуммаКтТолькоПросмотр = СвойстваСчета.Вид = ВидСчета.Активный;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	ДатаВводаОстатков = Документы.ВводНачальныхОстатков.ПолучитьДатуВводаОстатков(Объект.Организация);
	Если ЗначениеЗаполнено(ДатаВводаОстатков) Тогда
		Объект.Дата = ДатаВводаОстатков;
	КонецЕсли;

	ДатаПриИзмененииСервер();

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()

	Документы.ВводНачальныхОстатков.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	УправлениеФормой();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежима(Команда)

	ПараметрыНастройкиРежима	= Новый Структура;
	ПараметрыНастройкиРежима.Вставить("ОтражатьВБухгалтерскомУчете",	Объект.ОтражатьВБухгалтерскомУчете);
	ПараметрыНастройкиРежима.Вставить("ОтражатьВНалоговомУчете",		Объект.ОтражатьВНалоговомУчете);
	ПараметрыНастройкиРежима.Вставить("ОтражатьПоСпециальнымРегистрам",	Объект.ОтражатьПоСпециальнымРегистрам);
	ПараметрыНастройкиРежима.Вставить("Организация",					Объект.Организация);
	ПараметрыНастройкиРежима.Вставить("ТолькоПросмотр",					Этаформа.ТолькоПросмотр);

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОткрытьФормуНастройкиРежимаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаНастройкиРежима",
		ПараметрыНастройкиРежима,,,,,ОповещениеОЗакрытии);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиРежимаЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	РезультатНастройкиРежима = РезультатЗакрытия;
	
	Если ТипЗнч(РезультатНастройкиРежима) = Тип("Структура") Тогда
		
		Модифицированность	= Истина;
		
		ЗаполнитьЗначенияСвойств(Объект, РезультатНастройкиРежима);
		
		Если Объект.ОтражатьВБухгалтерскомУчете И Объект.ОтражатьВНалоговомУчете И Объект.ОтражатьПоСпециальнымРегистрам Тогда
			Объект.Дата	= РезультатНастройкиРежима.ДатаВводаОстатков;
			ДатаПриИзмененииСервер();
		Иначе
			УправлениеФормой();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОписаниеРаздела(Команда)

	ДанныеЗаполнения	= Новый Структура;
	ДанныеЗаполнения.Вставить("Дата",		 Объект.Дата);
	ДанныеЗаполнения.Вставить("Организация", Объект.Организация);
	ДанныеЗаполнения.Вставить("РазделУчета", Объект.РазделУчета);

	ОткрытьФорму("Документ.ВводНачальныхОстатков.Форма.ФормаСправки", Новый Структура("ДанныеЗаполнения", ДанныеЗаполнения), ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);

	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;

	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ РасчетыСПодотчетнымиЛицами

&НаКлиенте
Процедура РасчетыСПодотчетнымиЛицамиСчетУчетаПриИзменении(Элемент)

	СтрокаТаблицы = Элементы.РасчетыСПодотчетнымиЛицами.ТекущиеДанные;

	Если ЗначениеЗаполнено(СтрокаТаблицы.СчетУчета) Тогда

		СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаТаблицы.СчетУчета);

		СтрокаТаблицы.СуммаТолькоПросмотр = СвойстваСчета.Вид = ВидСчета.Пассивный;
		СтрокаТаблицы.СуммаКтТолькоПросмотр = СвойстваСчета.Вид = ВидСчета.Активный;
		Если СвойстваСчета.Вид = ВидСчета.Активный Тогда
			Если СтрокаТаблицы.Сумма = 0 Тогда
				СтрокаТаблицы.Сумма = СтрокаТаблицы.СуммаКт;
			КонецЕсли;
			СтрокаТаблицы.СуммаКт = 0;
		КонецЕсли;
		Если СвойстваСчета.Вид = ВидСчета.Пассивный Тогда
			Если СтрокаТаблицы.СуммаКт = 0 Тогда
				СтрокаТаблицы.СуммаКт = СтрокаТаблицы.Сумма;
			КонецЕсли;
			СтрокаТаблицы.Сумма = 0;
		КонецЕсли;

		СтрокаТаблицы.СчетУчетаВалютный = СвойстваСчета.Валютный;
		Если НЕ СтрокаТаблицы.СчетУчетаВалютный Тогда
			СтрокаТаблицы.Валюта = Неопределено;
			СтрокаТаблицы.ВалютнаяСумма = 0;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСПодотчетнымиЛицамиСуммаПриИзменении(Элемент)

	СтрокаТаблицы = Элементы.РасчетыСПодотчетнымиЛицами.ТекущиеДанные;
	Если СтрокаТаблицы.Сумма <> 0 Тогда
		СтрокаТаблицы.СуммаКт = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСПодотчетнымиЛицамиСуммаКтПриИзменении(Элемент)

	СтрокаТаблицы = Элементы.РасчетыСПодотчетнымиЛицами.ТекущиеДанные;
	Если СтрокаТаблицы.СуммаКт <> 0 Тогда
		СтрокаТаблицы.Сумма = 0;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РасчетыСПодотчетнымиЛицамиРасчетныйДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	СтрокаТаблицы = Элементы.РасчетыСПодотчетнымиЛицами.ТекущиеДанные;

	ПараметрыОбъекта = Новый Структура;
	ПараметрыОбъекта.Вставить("КонецПериода"         , КонецДня(Объект.Дата));
	ПараметрыОбъекта.Вставить("СчетУчета"            , СтрокаТаблицы.СчетУчета);
	ПараметрыОбъекта.Вставить("Организация"          , Объект.Организация);
	ПараметрыОбъекта.Вставить("НачалоПериода"        , '00010101');
	ПараметрыОбъекта.Вставить("ОстаткиОбороты"       , "Дт");
	ПараметрыОбъекта.Вставить("ТипыДокументов"       , "Метаданные.Документы.ВводНачальныхОстатков.ТабличныеЧасти.РасчетыСПодотчетнымиЛицами.Реквизиты.РасчетныйДокумент.Тип");
	ПараметрыОбъекта.Вставить("РежимОтбораДокументов", ПредопределенноеЗначение("Перечисление.РежимОтбораДокументов.ПоРеквизитам"));

	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыОбъекта());
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПодготовитьФормуНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьДобавленныеКолонкиТаблиц();

	Документы.ВводНачальныхОстатков.УстановитьЗаголовокФормы(ЭтаФорма);
	УстановитьСостояниеДокумента();
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ОбновитьФормуПомощникаВводаОстатков", Объект.Организация, "ВводНачальныхОстатков");

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбщегоНазначенияБПКлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

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

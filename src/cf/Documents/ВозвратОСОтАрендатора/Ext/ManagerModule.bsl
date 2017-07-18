﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 12, 0);
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;
	НомераТаблиц = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаМестонахождениеОСБУ(НомераТаблиц)
		+ ТекстЗапросаТаблицаОС(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт о приеме-передаче ОС (ОС-1)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОС1";
	КомандаПечати.Представление = НСтр("ru = 'Акт о приеме-передаче ОС (ОС-1)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Подготовка к передаче ОС""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС1") Тогда

		ИмяМакета = "";
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОС1", НСтр("ru = 'ОС-1 (Акт о приеме-передаче ОС)'"),
			ПечатьОС1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета), , ИмяМакета);

	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты",       НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты",                       НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата,
	|	Реквизиты.Номер,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации,
	|	Реквизиты.Контрагент,
	|	Реквизиты.СобытиеОС,
	|	Реквизиты.СчетУчета,
	|	Реквизиты.МОЛ
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ВозвратОСОтАрендатора КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	Реквизиты.ПодразделениеОрганизации КАК ПодразделениеПолучатель,
	|	Реквизиты.Контрагент КАК Контрагент,
	|	""ОС"" КАК ИмяСписка,
	|	НЕОПРЕДЕЛЕНО КАК МОЛ,
	|	Реквизиты.СобытиеОС КАК СобытиеОС,
	|	Реквизиты.СчетУчета КАК СчетУчета
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаТаблицаОС(НомераТаблиц)

	НомераТаблиц.Вставить("ОсновныеСредства", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка КАК Регистратор,
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
	|	0 КАК СуммаЗатратБУ,
	|	0 КАК СуммаЗатратНУ,
	|	0 КАК СуммаЗатратУСН
	|ИЗ
	|	Документ.ВозвратОСОтАрендатора.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаМестонахождениеОСБУ(НомераТаблиц)
	
	НомераТаблиц.Вставить("МестонахождениеОСБУ", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Местонахождение,
	|	Реквизиты.МОЛ КАК МОЛ,
	|	НЕОПРЕДЕЛЕНО КАК Контрагент
	|ИЗ
	|	Реквизиты КАК Реквизиты";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции


Функция ПечатьОС1(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)

	УстановитьПривилегированныйРежим(Истина);

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВозвратОСОтАрендатора_ОС1";

	КоличествоОС1 = 0;
	КоличествоОС1а = 0;
	КоличествоОС1б = 0;
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ОС1");
	МакетОС1а = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ОС1а");
	МакетОС1б = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ОС1б");

	// Области
	ОбластьМакетаЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакетаЗаголовок_а = МакетОС1а.ПолучитьОбласть("Заголовок");

	Шапка1ОС1б     = МакетОС1б.ПолучитьОбласть("Шапка1");
	Шапка2ОС1б     = МакетОС1б.ПолучитьОбласть("Шапка2");
	Строка2ОС1б    = МакетОС1б.ПолучитьОбласть("Строка2");
	Строка2ПОС1б   = МакетОС1б.ПолучитьОбласть("Строка2П");
	Подвал2        = МакетОС1б.ПолучитьОбласть("Подвал2");
	Шапка3ОС1б     = МакетОС1б.ПолучитьОбласть("Шапка3");
	Строка3ОС1б    = МакетОС1б.ПолучитьОбласть("Строка3");
	Строка3ПОС1б   = МакетОС1б.ПолучитьОбласть("Строка3П");
	Подвал3        = МакетОС1б.ПолучитьОбласть("Подвал3");
	Шапка4ОС1б     = МакетОС1б.ПолучитьОбласть("Шапка4");

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратОСОтАрендатора.Ссылка КАК Ссылка,
	|	ВозвратОСОтАрендатора.Дата КАК Дата,
	|	ВозвратОСОтАрендатора.Номер КАК НомерАкта,
	|	ВозвратОСОтАрендатора.Ответственный,
	|	ВозвратОСОтАрендатора.Контрагент КАК Сдатчик,
	|	ВозвратОСОтАрендатора.Организация КАК Получатель,
	|	ВозвратОСОтАрендатора.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ВозвратОСОтАрендатора.ПодразделениеОрганизации КАК ПодрПолучателя,
	|	ПРЕДСТАВЛЕНИЕ(ВозвратОСОтАрендатора.ДоговорКонтрагента) КАК ДоговорПередачи,
	|	ВозвратОСОтАрендатора.ДоговорКонтрагента.Дата КАК ДатаДоговора,
	|	ВозвратОСОтАрендатора.ДоговорКонтрагента.Номер КАК НомерДоговора,
	|	ВозвратОСОтАрендатора.Организация КАК Организация,
	|	ВозвратОСОтАрендатора.МоментВремени КАК СсылкаМоментВремени,
	|	ВозвратОСОтАрендатора.СчетУчета
	|ИЗ
	|	Документ.ВозвратОСОтАрендатора КАК ВозвратОСОтАрендатора
	|ГДЕ
	|	ВозвратОСОтАрендатора.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";

	Шапка = Запрос.Выполнить().Выбрать();

	Запрос = Новый Запрос();

	СписокВидовМодернизации = Новый Массив;
	СписокВидовМодернизации.Добавить(Перечисления.ВидыСобытийОС.Модернизация);
	СписокВидовМодернизации.Добавить(Перечисления.ВидыСобытийОС.Достройка);
	СписокВидовМодернизации.Добавить(Перечисления.ВидыСобытийОС.Реконструкция);

	Запрос.УстановитьПараметр("СписокВидовМодернизации", СписокВидовМодернизации);

	Запрос.УстановитьПараметр("КапитальныйРемонт", Перечисления.ВидыСобытийОС.КапитальныйРемонт);

	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ СписокОС
	|ИЗ
	|	Документ.ВозвратОСОтАрендатора.ОС КАК ВозвратОСОтАрендатораОС
	|ГДЕ
	|	ВозвратОСОтАрендатораОС.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.СпособНачисленияАмортизации
	|ПОМЕСТИТЬ ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.ОсновноеСредство,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета,
	|	СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации
	|ПОМЕСТИТЬ СчетаБухгалтерскогоУчетаОССрезПоследних
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК СчетаБухгалтерскогоУчетаОССрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет,
	|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
	|	ХозрасчетныйОстатки.СуммаОстатокДт КАК Сумма
	|ПОМЕСТИТЬ СтоимостьОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					СчетаБухгалтерскогоУчетаОССрезПоследних.СчетУчета
	|				ИЗ
	|					СчетаБухгалтерскогоУчетаОССрезПоследних),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК ХозрасчетныйОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет,
	|	ХозрасчетныйОстатки.Субконто1 КАК ОсновноеСредство,
	|	ХозрасчетныйОстатки.СуммаОстатокКт КАК Сумма
	|ПОМЕСТИТЬ АмортизацияОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&ПериодАмортизация,
	|			Счет В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					СчетаБухгалтерскогоУчетаОССрезПоследних.СчетНачисленияАмортизации
	|				ИЗ
	|					СчетаБухгалтерскогоУчетаОССрезПоследних),
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|			Организация = &Организация
	|				И Субконто1 В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК ХозрасчетныйОстатки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МестонахождениеОС.ОсновноеСредство,
	|	МестонахождениеОС.Местонахождение
	|ПОМЕСТИТЬ МестонахождениеОС
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК МестонахождениеОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	МестонахождениеОС.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПараметрыАмортизации.ОсновноеСредство,
	|	ПараметрыАмортизации.СрокПолезногоИспользования
	|ПОМЕСТИТЬ ПараметрыАмортизации
	|ИЗ
	|	РегистрСведений.ПараметрыАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)) КАК ПараметрыАмортизации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПараметрыАмортизации.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследнийКапитальныйРемонт.ОсновноеСредство,
	|	ПоследнийКапитальныйРемонт.Период
	|ПОМЕСТИТЬ ПоследнийКапитальныйРемонт
	|ИЗ
	|	РегистрСведений.СобытияОСОрганизаций.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)
	|				И Событие.ВидСобытияОС = &КапитальныйРемонт) КАК ПоследнийКапитальныйРемонт
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПоследнийКапитальныйРемонт.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследняяМодернизация.ОсновноеСредство,
	|	ПоследняяМодернизация.Период
	|ПОМЕСТИТЬ ПоследняяМодернизация
	|ИЗ
	|	РегистрСведений.СобытияОСОрганизаций.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						СписокОС)
	|				И Событие.ВидСобытияОС В (&СписокВидовМодернизации)) КАК ПоследняяМодернизация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПоследняяМодернизация.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВозвратОСОтАрендатораОС.НомерСтроки КАК НомерСтроки,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство,
	|	ЕСТЬNULL(СтоимостьОС.Сумма, 0) - ЕСТЬNULL(АмортизацияОС.Сумма, 0) КАК ОстСтоимость,
	|	ЕСТЬNULL(АмортизацияОС.Сумма, 0) КАК НачАмортизация,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК ЦенаПродажи,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.ГруппаОС КАК ГруппаОС,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОс,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.АмортизационнаяГруппа.Порядок + 1 КАК НомерГруппы,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.Изготовитель КАК Изготовитель,
	|	ВозвратОСОтАрендатораОС.ОсновноеСредство.КодПоОКОФ.Код КАК КодОКОФ,
	|	МестонахождениеОС.Местонахождение,
	|	ПараметрыАмортизации.СрокПолезногоИспользования КАК СрокПолезнИспПриПеред,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер КАК ИнвНомер,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ПервоначальнаяСтоимость КАК НачСтоимость,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.СпособНачисленияАмортизации КАК СпособАмортизации,
	|	ПараметрыАмортизации.СрокПолезногоИспользования КАК СрокПолезнИспПриПост,
	|	ПоследнийКапитальныйРемонт.Период КАК ДатаПоследнегоКапитальногоРемонта,
	|	ПоследняяМодернизация.Период КАК ДатаПоследнейМодернизации
	|ИЗ
	|	Документ.ВозвратОСОтАрендатора.ОС КАК ВозвратОСОтАрендатораОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ МестонахождениеОС КАК МестонахождениеОС
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = МестонахождениеОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыАмортизации КАК ПараметрыАмортизации
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = ПараметрыАмортизации.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследнийКапитальныйРемонт КАК ПоследнийКапитальныйРемонт
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = ПоследнийКапитальныйРемонт.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследняяМодернизация КАК ПоследняяМодернизация
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = ПоследняяМодернизация.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ СтоимостьОС КАК СтоимостьОС
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ АмортизацияОС КАК АмортизацияОС
	|		ПО ВозвратОСОтАрендатораОС.ОсновноеСредство = АмортизацияОС.ОсновноеСредство
	|ГДЕ
	|	ВозвратОСОтАрендатораОС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	ПервыйДокумент = Истина;

	ИспользоваласьОС1б = Ложь;
	Пока Шапка.Следующий() Цикл

		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		Запрос.УстановитьПараметр("Ссылка",            Шапка.Ссылка);
		Запрос.УстановитьПараметр("Организация",       Шапка.Организация);
		Запрос.УстановитьПараметр("Период",            Новый Граница(Шапка.СсылкаМоментВремени, ВидГраницы.Исключая));
		Запрос.УстановитьПараметр("ПериодАмортизация", Новый Граница(Шапка.СсылкаМоментВремени, ВидГраницы.Включая));

		ВыборкаПоОС = Запрос.Выполнить().Выбрать();

		ДокВвода  = Неопределено;
		ДатаВвода = '00000000';

		Если ВыборкаПоОС.Количество() <= 1 Тогда

			ВыборкаПоОС.Следующий();

			Если НЕ(ВыборкаПоОС.ГруппаОС = Перечисления.ГруппыОС.Здания ИЛИ
				ВыборкаПоОС.ГруппаОС = Перечисления.ГруппыОС.Сооружения) Тогда

				ОбластьМакетаЗаголовок.Параметры.Заполнить(Шапка);
				ОбластьМакетаЗаголовок.Параметры.Заполнить(ВыборкаПоОС);
				КоличествоОС1 = КоличествоОС1 + 1;

				УчетОС.ПолучитьДокументБухСостоянияОС(ВыборкаПоОС.ОсновноеСредство, Шапка.Получатель,
					Перечисления.СостоянияОС.ПринятоКУчету, ДокВвода, ДатаВвода);

				Если ЗначениеЗаполнено(ДатаВвода) Тогда
					СрокЭкспл = УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ДатаВвода, Шапка.Дата);
				Иначе
					СрокЭкспл = 0;
				КонецЕсли;

				ОбластьМакетаЗаголовок.Параметры.ГодВыпуска = ВыборкаПоОС.ГодВыпуска;
				ОбластьМакетаЗаголовок.Параметры.ДатаВвода  = ДатаВвода;
				ОбластьМакетаЗаголовок.Параметры.ДатаВводаПриПередаче  = ДатаВвода;
				ОбластьМакетаЗаголовок.Параметры.СрокЭкспл  = ?(НЕ ЗначениеЗаполнено(СрокЭкспл), "-", Строка(СрокЭкспл) + " мес.");

				Если ПустаяСтрока(ВыборкаПоОС.НаименованиеОС) Тогда
					ОбластьМакетаЗаголовок.Параметры.НаименованиеОС = СокрЛП(ВыборкаПоОС.ОсновноеСредство);
				КонецЕсли;

				ЗаполнитьДанныеОрганизацииПолучателя(Шапка, ОбластьМакетаЗаголовок);
				ЗаполнитьДанныеОрганизацииСдатчика(Шапка, ОбластьМакетаЗаголовок);

				ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);

			Иначе

				ОбластьМакетаЗаголовок_а.Параметры.Заполнить(Шапка);
				ОбластьМакетаЗаголовок_а.Параметры.Заполнить(ВыборкаПоОС);
				КоличествоОС1а = КоличествоОС1а + 1;

				УчетОС.ПолучитьДокументБухСостоянияОС(ВыборкаПоОС.ОсновноеСредство, Шапка.Организация,
					Перечисления.СостоянияОС.ПринятоКУчету, ДокВвода, ДатаВвода);

				СрокЭкспл = УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ДатаВвода, Шапка.Дата);

				ОбластьМакетаЗаголовок_а.Параметры.ГодВыпуска = ВыборкаПоОС.ГодВыпуска;
				ОбластьМакетаЗаголовок_а.Параметры.ДатаВводаПриПередаче  = ДатаВвода;
				ОбластьМакетаЗаголовок_а.Параметры.СрокЭкспл  = ?(НЕ ЗначениеЗаполнено(СрокЭкспл), "-", Строка(СрокЭкспл) + " мес.");

				Если ПустаяСтрока(ВыборкаПоОС.НаименованиеОС) Тогда
					ОбластьМакетаЗаголовок_а.Параметры.НаименованиеОС = СокрЛП(ВыборкаПоОС.ОсновноеСредство);
				КонецЕсли;

				ЗаполнитьДанныеОрганизацииПолучателя(Шапка, ОбластьМакетаЗаголовок_а);
				ЗаполнитьДанныеОрганизацииСдатчика(Шапка, ОбластьМакетаЗаголовок_а);

				ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок_а);

			КонецЕсли;

		Иначе // Объектов много - групповая печать.

			ИспользоваласьОС1б = Истина;
			КоличествоОС1б = КоличествоОС1б + 1;

			ОС1б_Страница1 = Новый ТабличныйДокумент();
			ОС1б_Страница2 = Новый ТабличныйДокумент();
			ОС1б_Страница3 = Новый ТабличныйДокумент();
			ОС1б_Страница4 = Новый ТабличныйДокумент();

			Шапка1ОС1б.Параметры.Заполнить(Шапка);
			Шапка1ОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ЗаполнитьДанныеОрганизацииПолучателя(Шапка, Шапка1ОС1б);
			ЗаполнитьДанныеОрганизацииСдатчика(Шапка, Шапка1ОС1б);
			ОС1б_Страница1.Вывести(Шапка1ОС1б);

			Шапка2ОС1б.Параметры.Заполнить(Шапка);
			Шапка2ОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница2.Вывести(Шапка2ОС1б);

			Шапка3ОС1б.Параметры.Заполнить(Шапка);
			Шапка3ОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница3.Вывести(Шапка3ОС1б);

			Шапка4ОС1б.Параметры.Заполнить(Шапка);
			Шапка4ОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница4.Вывести(Шапка4ОС1б);

			НомПП = 0;
			ИтогЦенаПродажи = 0;

			Пока ВыборкаПоОС.Следующий() Цикл

				ИтогЦенаПродажи = ИтогЦенаПродажи + ВыборкаПоОС.ЦенаПродажи;

				УчетОС.ПолучитьДокументБухСостоянияОС(ВыборкаПоОС.ОсновноеСредство, Шапка.Получатель,
					Перечисления.СостоянияОС.ПринятоКУчету, ДокВвода, ДатаВвода);

				СрокЭкспл = УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ДатаВвода, Шапка.Дата);

				НомПП = НомПП + 1;
				Строка2ОС1б.Параметры.Нс = НомПП;

				Строка2ОС1б.Параметры.Заполнить(Шапка);
				Строка2ОС1б.Параметры.Заполнить(ВыборкаПоОС);
				Если ПустаяСтрока(ВыборкаПоОС.НаименованиеОС) Тогда
					Строка2ОС1б.Параметры.НаименованиеОС = СокрЛП(ВыборкаПоОС.ОсновноеСредство);
				КонецЕсли;
				Строка2ОС1б.Параметры.ДатаВвода = ДатаВвода;
				ОС1б_Страница2.Вывести(Строка2ОС1б);

				Строка3ОС1б.Параметры.Заполнить(Шапка);
				Строка3ОС1б.Параметры.Заполнить(ВыборкаПоОС);
				Строка3ОС1б.Параметры.СрокЭкспл = ?(НЕ ЗначениеЗаполнено(СрокЭкспл), "-", Строка(СрокЭкспл) + " мес.");
				ОС1б_Страница3.Вывести(Строка3ОС1б);

			КонецЦикла;

			Строка2ПОС1б.Параметры.Заполнить(Шапка);
			Строка2ПОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница2.Вывести(Строка2ПОС1б);

			Подвал2.Параметры.Заполнить(Шапка);
			Подвал2.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница2.Вывести(Подвал2);

			Строка3ПОС1б.Параметры.Заполнить(Шапка);
			Строка3ПОС1б.Параметры.Заполнить(ВыборкаПоОС);
			ОС1б_Страница3.Вывести(Строка3ПОС1б);

			Подвал3.Параметры.Заполнить(Шапка);
			Подвал3.Параметры.Заполнить(ВыборкаПоОС);
			Подвал3.Параметры.ИтогЦенаПродажи = ИтогЦенаПродажи;
			ЗаполнитьДанныеОрганизацииСдатчика(Шапка, Подвал3);
			ОС1б_Страница3.Вывести(Подвал3);

			ТабличныйДокумент.Вывести(ОС1б_Страница1);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОС1б_Страница2);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОС1б_Страница3);
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОС1б_Страница4);
		КонецЕсли;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;
	
	Если КоличествоОС1 = 0 И КоличествоОС1а = 0 Тогда 
		ИмяМакета = "ОбщийМакет.ПФ_MXL_ОС1б";
	ИначеЕсли КоличествоОС1 = 0 И КоличествоОС1б = 0 Тогда 
		ИмяМакета = "ОбщийМакет.ПФ_MXL_ОС1а";
	ИначеЕсли КоличествоОС1а = 0 И КоличествоОС1б = 0 Тогда 
		ИмяМакета = "ОбщийМакет.ПФ_MXL_ОС1";
	КонецЕсли;

	Возврат ТабличныйДокумент;

КонецФункции

Процедура ЗаполнитьДанныеОрганизацииПолучателя(ПараметрыДокумента, ОбластьМакета)

	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДокумента.Получатель, ПараметрыДокумента.Дата);

	ПараметрыОрганизации = Новый Структура("ОрганизацияПолучатель, АдресПолучателя, РеквПолучателя, ДолжРукПолуч, РукПолучателя, КодПоОКПОПолучателя");

	ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	ПараметрыОрганизации.ОрганизацияПолучатель = ПредставлениеОрганизации;
	ПараметрыОрганизации.АдресПолучателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ЮридическийАдрес,Телефоны,");
	ПараметрыОрганизации.РеквПолучателя = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НомерСчета,Банк,БИК,КоррСчет,");
	ПараметрыОрганизации.КодПоОКПОПолучателя = СведенияОбОрганизации.КодПоОКПО;

	ОтветственныеЛицаОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыДокумента.Получатель, ПараметрыДокумента.Дата);
	ПараметрыОрганизации.РукПолучателя = ОтветственныеЛицаОрганизации.РуководительПредставление;
	ПараметрыОрганизации.ДолжРукПолуч = ОтветственныеЛицаОрганизации.РуководительДолжностьПредставление;

	ОбластьМакета.Параметры.Заполнить(ПараметрыОрганизации);

КонецПроцедуры

// Процедура заполняет параметры организации-сдатчика формы ОС1
//
Процедура ЗаполнитьДанныеОрганизацииСдатчика(ПараметрыДокумента, ОбластьМакета)

	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ПараметрыДокумента.Сдатчик, ПараметрыДокумента.Дата);
	ОтветственныеЛицаОрганизации = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыДокумента.Сдатчик, ПараметрыДокумента.Дата,
		ПараметрыДокумента.ПодразделениеОрганизации);

	ПараметрыОрганизации = Новый Структура("НаимСдатчика, АдресСдатчика, РеквСдатчика, ДолжРукСдатчика, РукСдатчика, "
		+ "КодПоОКПОСдатчика, ГлавБухСдатчика");

	ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,");
	ПараметрыОрганизации.НаимСдатчика = ПредставлениеОрганизации;
	ПараметрыОрганизации.АдресСдатчика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "ЮридическийАдрес,Телефоны,");
	ПараметрыОрганизации.РеквСдатчика = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НомерСчета,Банк,БИК,КоррСчет,");
	ПараметрыОрганизации.КодПоОКПОСдатчика = СведенияОбОрганизации.КодПоОКПО;

	ПараметрыОрганизации.РукСдатчика = ОтветственныеЛицаОрганизации.РуководительПредставление;
	ПараметрыОрганизации.ДолжРукСдатчика = ОтветственныеЛицаОрганизации.РуководительДолжностьПредставление;
	ПараметрыОрганизации.ГлавБухСдатчика = ОтветственныеЛицаОрганизации.ГлавныйБухгалтерПредставление;

	ОбластьМакета.Параметры.Заполнить(ПараметрыОрганизации);

КонецПроцедуры

#Область ОбработчикиОбновления

Процедура ВключитьИспользованиеДополнительныхРеквизитовИСведений() Экспорт

	НаборДополнительныхРеквизитовИСведенийСсылка = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.НаборыДополнительныхРеквизитовИСведений.Документ_ВозвратОСОтАрендатора");
	Если НаборДополнительныхРеквизитовИСведенийСсылка <> Неопределено Тогда
	
		НаборДополнительныхРеквизитовИСведенийОбъект = НаборДополнительныхРеквизитовИСведенийСсылка.ПолучитьОбъект();
		НаборДополнительныхРеквизитовИСведенийОбъект.Используется = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НаборДополнительныхРеквизитовИСведенийОбъект);
	
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
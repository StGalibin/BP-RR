﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 12, 0);
	
КонецФункции

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Результат = Запрос.Выполнить();
	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);

	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СинонимНМА", НСтр("ru = 'Нематериальные активы'"));
	Запрос.УстановитьПараметр("ПлательщикНалогаНаПрибыль", УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Период));
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст =
	ТекстЗапросаПринятиеКУчетуНМА(НомераТаблиц)
	+ ТекстЗапросаСостоянияНМА(НомераТаблиц)
	+ ТекстЗапросаПервоначальныеСведенияНМАБУ(НомераТаблиц)
	+ ТекстЗапросаСчетаБухгалтерскогоУчетаНМА(НомераТаблиц)
	+ ТекстЗапросаСпособыОтраженияРасходовПоАмортизацииНМАБУ(НомераТаблиц)
	+ ТекстЗапросаПервоначальныеСведенияНМАНУ(НомераТаблиц)
	+ ТекстЗапросаПервоначальныеСведенияНМАУСН(НомераТаблиц)
	+ ТекстЗапросаНачислениеАмортизацииНМАСпециальныйКоэффициентНУ(НомераТаблиц)
	+ ТекстЗапросаВключениеВРасходыПриПринятииКУчетуНУ(НомераТаблиц)
	+ ТекстЗапросаНДС(НомераТаблиц)
	+ ТекстЗапросаПервоначальныеСведенияНМАИП(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();
	
	Для Каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ПодготовитьТаблицыПараметровПринятиеКУчетуНМА(ТаблицаПринятияКУчетуНМА, ТаблицаСписания) Экспорт
	Параметры = ПодготовитьПараметрыТаблицПринятиеКУчетуНМА(ТаблицаПринятияКУчетуНМА, ТаблицаСписания);
	
	ПринятиеКУчетуНМА = Параметры.ТаблицаПринятияКУчетуНМА[0];
	
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаНУ",     ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаНУДт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаПРДт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаВРДт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаНУКт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаПРКт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаВРКт", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаПРКорректировка", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	Параметры.ТаблицаСписания.Колонки.Добавить("СуммаВРКорректировка", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	
	ОтражатьВНалоговомУчете = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(ПринятиеКУчетуНМА.Организация, ПринятиеКУчетуНМА.Период);
	
	Если НЕ (ОтражатьВНалоговомУчете 
		И ПринятиеКУчетуНМА.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР
		И ПринятиеКУчетуНМА.ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету)
		ИЛИ ПринятиеКУчетуНМА.СтоимостьНУ = 0 Тогда
		
		Параметры.ТаблицаСписания.Очистить();
		Возврат Параметры;
	КонецЕсли;
	
	ОбщегоНазначенияБПВызовСервера.РаспределитьСуммуПоКолонкеТаблицы(
		ПринятиеКУчетуНМА.СтоимостьНУ, Параметры.ТаблицаСписания, "СуммаНУ", "Коэффициент");

	Для Каждого СтрокаСписания Из Параметры.ТаблицаСписания Цикл
		ЭтоНепринимаемйРасход = НалоговыйУчет.ЭтоНепринимаемыйРасходНУ(СтрокаСписания.Субконто1, СтрокаСписания.Субконто2, СтрокаСписания.Субконто3);
		
		Если ЭтоНепринимаемйРасход Тогда
			СтрокаСписания.СуммаНУДт = 0;
			СтрокаСписания.СуммаНУКт = СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаПРДт = 0;
			СтрокаСписания.СуммаПРКт = - СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаВРДт = 0;
			СтрокаСписания.СуммаВРКт = 0;
			СтрокаСписания.СуммаВРКорректировка = 0;
			СтрокаСписания.СуммаПРКорректировка = СтрокаСписания.СуммаНУ;
		Иначе

			КоэффициентРасходов = ?(СтрокаСписания.ВидРасходовНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ, 1.5, 1);
			
			СтрокаСписания.СуммаНУДт = СтрокаСписания.СуммаНУ * КоэффициентРасходов;
			СтрокаСписания.СуммаНУКт = СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаПРДт = СтрокаСписания.СуммаНУ * (1 - КоэффициентРасходов);
			СтрокаСписания.СуммаПРКт = 0;
			СтрокаСписания.СуммаВРДт = - СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаВРКт = - СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаВРКорректировка = СтрокаСписания.СуммаНУ;
			СтрокаСписания.СуммаПРКорректировка = 0;

		 КонецЕсли;
	КонецЦикла;
		
	СуммаПРКорректировка = Параметры.ТаблицаСписания.Итог("СуммаПРКорректировка");
	СуммаВРКорректировка = Параметры.ТаблицаСписания.Итог("СуммаВРКорректировка");
	
	ПринятиеКУчетуНМА.СтоимостьНУ = ПринятиеКУчетуНМА.СтоимостьНУ - СуммаПРКорректировка - СуммаВРКорректировка;
	ПринятиеКУчетуНМА.СтоимостьПР = ПринятиеКУчетуНМА.СтоимостьПР + СуммаПРКорректировка;
	ПринятиеКУчетуНМА.СтоимостьВР = ПринятиеКУчетуНМА.СтоимостьВР + СуммаВРКорректировка;
	
	Возврат Параметры;
	
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
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Принятие к учету НМА""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "НематериальныйАктив");
	
	Возврат Результат;
	
КонецФункции

//Процедуры обновления
Процедура ЗаполнитьПорядокВключенияСтоимостиВСоставРасходовНУ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПорядокВключенияСтоимостиВСоставРасходовНУ",
		Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ПустаяСсылка());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПринятиеКУчетуНМА.Ссылка
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК ПринятиеКУчетуНМА
	|ГДЕ
	|	ПринятиеКУчетуНМА.ПорядокВключенияСтоимостиВСоставРасходовНУ = &ПорядокВключенияСтоимостиВСоставРасходовНУ";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПринятиеКУчетуНМА = Выборка.Ссылка.ПолучитьОбъект();
		ПринятиеКУчетуНМА.ПорядокВключенияСтоимостиВСоставРасходовНУ = 
			Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации;
			
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПринятиеКУчетуНМА, Истина);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаПринятиеКУчетуНМА(НомераТаблиц)

	НомераТаблиц.Вставить("ПринятиеКУчетуНМА", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СпособОтраженияРасходов", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК ПодразделениеКт,
	|	Реквизиты.ПодразделениеОрганизации КАК ПодразделениеДт,
	|	Реквизиты.СчетУчета,
	|	Реквизиты.СчетУчетаВнеоборотногоАктива,
	|	Реквизиты.НематериальныйАктив,
	|	Реквизиты.СтоимостьБУ КАК СтоимостьБУ,
	|	Реквизиты.СтоимостьНУ КАК СтоимостьНУ,
	|	Реквизиты.СтоимостьПР КАК СтоимостьПР,
	|	Реквизиты.СтоимостьВР КАК СтоимостьВР,
	|	Реквизиты.ВидОбъектаУчета,
	|	Реквизиты.ПорядокСписанияНИОКРНаРасходыНУ,
	|	Реквизиты.ПорядокВключенияСтоимостиВСоставРасходовНУ
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Направления.НомерСтроки КАК НомерСтроки,
	|	Направления.СчетЗатрат,
	|	Направления.ПодразделениеОрганизации КАК Подразделение,
	|	Направления.Субконто1,
	|	Направления.Субконто2,
	|	Направления.Субконто3,
	|	Направления.Коэффициент,
	|	ВЫБОР
	|		КОГДА Направления.Субконто1 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(Направления.Субконто1 КАК Справочник.СтатьиЗатрат).ВидРасходовНУ
	|		КОГДА Направления.Субконто2 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(Направления.Субконто2 КАК Справочник.СтатьиЗатрат).ВидРасходовНУ
	|		КОГДА Направления.Субконто3 ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(Направления.Субконто3 КАК Справочник.СтатьиЗатрат).ВидРасходовНУ
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыРасходовНУ.ПустаяСсылка)
	|	КОНЕЦ КАК ВидРасходовНУ
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОтраженияРасходовПоАмортизации.Способы КАК Направления
	|		ПО (Направления.Ссылка = Реквизиты.СпособОтраженияРасходов)
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСостоянияНМА(НомераТаблиц)

	НомераТаблиц.Вставить("СостоянияНМА", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Номер,
	|	Реквизиты.Организация,
	|	Реквизиты.НематериальныйАктив,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК Состояние,
	|	""НМА"" КАК ИмяСписка
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСчетаБухгалтерскогоУчетаНМА(НомераТаблиц)

	НомераТаблиц.Вставить("СчетаБухгалтерскогоУчетаНМА", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.НематериальныйАктив,
	|	Реквизиты.СчетУчета,
	|	Реквизиты.СчетНачисленияАмортизации
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСпособыОтраженияРасходовПоАмортизацииНМАБУ(НомераТаблиц)

	НомераТаблиц.Вставить("СпособыОтраженияРасходовПоАмортизацииНМАБУ", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.НематериальныйАктив,
	|	Реквизиты.СпособОтраженияРасходов
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПервоначальныеСведенияНМАБУ(НомераТаблиц)

	НомераТаблиц.Вставить("ПервоначальныеСведенияНМАБУ", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.НематериальныйАктив КАК НематериальныйАктив,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтоимостьБУ КАК СтоимостьБУ,
	|	Реквизиты.НачислятьАмортизациюБУ КАК НачислятьАмортизациюБУ,
	|	Реквизиты.СпособНачисленияАмортизацииБУ КАК СпособНачисленияАмортизацииБУ,
	|	Реквизиты.СпособПоступления КАК СпособПоступления,
	|	Реквизиты.СрокПолезногоИспользованияБУ КАК СрокПолезногоИспользованияБУ,
	|	Реквизиты.КоэффициентБУ КАК КоэффициентБУ,
	|	Реквизиты.ОбъемПродукцииРаботДляВычисленияАмортизации КАК ОбъемПродукцииРаботДляВычисленияАмортизации
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПервоначальныеСведенияНМАНУ(НомераТаблиц)
	
	НомераТаблиц.Вставить("ПервоначальныеСведенияНМАНУ", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	&ПлательщикНалогаНаПрибыль КАК ПлательщикНалогаНаПрибыль,
	|	Реквизиты.СрокПолезногоИспользованияНУ КАК СрокПолезногоИспользованияНУ,
	|	Реквизиты.НематериальныйАктив КАК НематериальныйАктив,
	|	Реквизиты.СтоимостьНУ КАК СтоимостьНУ,
	|	Реквизиты.ПорядокВключенияСтоимостиВСоставРасходовНУ КАК ПорядокВключенияСтоимостиВСоставРасходов,
	|	ВЫБОР
	|		КОГДА Реквизиты.ВидОбъектаУчета = ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив)
	|			ТОГДА Реквизиты.НачислятьАмортизациюНУ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Реквизиты.ПорядокСписанияНИОКРНаРасходыНУ = ЗНАЧЕНИЕ(Перечисление.ПорядокСписанияНИОКРНУ.Равномерно)
	|					ТОГДА Реквизиты.НачислятьАмортизациюНУ
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|	КОНЕЦ КАК НачислятьАмортизациюНУ
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПервоначальныеСведенияНМАУСН(НомераТаблиц)

	НомераТаблиц.Вставить("ПервоначальныеСведенияНМАУСН", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ТаблицаОплатНМАУСН", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.НематериальныйАктив,
	|	Реквизиты.СтоимостьУСН,
	|	Реквизиты.СрокПолезногоИспользованияУСН,
	|	Реквизиты.ПорядокВключенияСтоимостиВСоставРасходовУСН,
	|	Реквизиты.ДатаПриобретения
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОплатНМАУСН.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОплатНМАУСН.ДатаОплаты,
	|	ТаблицаОплатНМАУСН.СуммаОплаты
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА.ОплатаНМА КАК ТаблицаОплатНМАУСН
	|ГДЕ
	|	ТаблицаОплатНМАУСН.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаНачислениеАмортизацииНМАСпециальныйКоэффициентНУ(НомераТаблиц)
	
	НомераТаблиц.Вставить("НачислениеАмортизацииНМАСпециальныйКоэффициентНУ", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка                   КАК Регистратор,
	|	Реквизиты.Дата                     КАК Период,
	|	Реквизиты.Организация              КАК Организация,
	|	&ПлательщикНалогаНаПрибыль         КАК ПлательщикНалогаНаПрибыль,
	|	Реквизиты.НематериальныйАктив      КАК НематериальныйАктив,
	|	Реквизиты.СпециальныйКоэффициентНУ КАК СпециальныйКоэффициентНУ
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаВключениеВРасходыПриПринятииКУчетуНУ(НомераТаблиц)

	НомераТаблиц.Вставить("ВключениеВРасходыПриПринятииКУчетуНУ", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка                                        КАК Регистратор,
	|	Реквизиты.Дата                                          КАК Период,
	|	Реквизиты.Организация                                   КАК Организация,
	|	&ПлательщикНалогаНаПрибыль                              КАК ПлательщикНалогаНаПрибыль,
	|	Реквизиты.ПорядокВключенияСтоимостиВСоставРасходовНУ    КАК ПорядокВключенияСтоимостиВСоставРасходов,
	|	Реквизиты.СпособОтраженияРасходовПриВключенииВСтоимость КАК СпособыОтраженияРасходовПоАмортизации,
	|	Реквизиты.СчетУчета                                     КАК СчетУчета,
	|	Реквизиты.ПодразделениеОрганизации                      КАК Подразделение,
	|	""Включение стоимости в состав расходов (НУ)""          КАК Содержание,
	|	""НМА""                                                 КАК ИмяСписка
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаНДС(НомераТаблиц)

	НомераТаблиц.Вставить("РеквизитыНДС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НМАНДС",    НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СписанныеНМАНДС",    НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РеквизитыНДС.Ссылка КАК Регистратор,
	|	РеквизитыНДС.Дата КАК Период,
	|	РеквизитыНДС.Организация КАК Организация,
	|	РеквизитыНДС.НематериальныйАктив КАК НематериальныйАктив,
	|	ЗНАЧЕНИЕ(Перечисление.НДССостоянияОСНМА.ОжидаетсяВводВЭксплуатацию) КАК СостояниеНМА,
	|	1 КАК КоэффициентРаспределения
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК РеквизитыНДС
	|ГДЕ
	|	РеквизитыНДС.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""НМА"" КАК ИмяСписка,
	|	1 КАК НомерСтрокиДокумента,
	|	НМАНДС.НематериальныйАктив КАК Номенклатура,
	|	1 КАК Количество,
	|	НМАНДС.СчетУчетаВнеоборотногоАктива КАК СчетУчета,
	|	НМАНДС.СпособУчетаНДС КАК НовыйСпособУчетаНДС,
	|	НМАНДС.ПодразделениеОрганизации КАК Подразделение
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК НМАНДС
	|ГДЕ
	|	НМАНДС.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""НМА"" КАК ИмяСписка,
	|	""Нематериальные активы"" КАК СинонимСписка,
	|	1 КАК НомерСтроки,
	|	СписанныеНМАНДС.СчетУчетаВнеоборотногоАктива КАК СчетУчета,
	|	СписанныеНМАНДС.НематериальныйАктив КАК Номенклатура,
	|	НЕОПРЕДЕЛЕНО КАК Склад,
	|	НЕОПРЕДЕЛЕНО КАК Партия,
	|	1 КАК Количество,
	|	СписанныеНМАНДС.СчетУчета КАК КорСчетСписания,
	|	1 КАК ВидКорСубконто1,
	|	НЕОПРЕДЕЛЕНО КАК ВидКорСубконто2,
	|	НЕОПРЕДЕЛЕНО КАК ВидКорСубконто3,
	|	СписанныеНМАНДС.НематериальныйАктив КАК КорСубконто1,
	|	НЕОПРЕДЕЛЕНО КАК КорСубконто2,
	|	НЕОПРЕДЕЛЕНО КАК КорСубконто3,
	|	СписанныеНМАНДС.ПодразделениеОрганизации КАК КорПодразделение,
	|	СписанныеНМАНДС.ПодразделениеОрганизации КАК Подразделение
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК СписанныеНМАНДС
	|ГДЕ
	|	СписанныеНМАНДС.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПервоначальныеСведенияНМАИП(НомераТаблиц)

	НомераТаблиц.Вставить("ПервоначальныеСведенияНМАИП",	НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.НематериальныйАктив КАК НематериальныйАктив,
	|	Реквизиты.СчетУчета КАК СчетУчета,
	|	Реквизиты.СтоимостьНУ КАК ПервоначальнаяСтоимостьНУ,
	|	Реквизиты.ПорядокВключенияСтоимостиВСоставРасходовНУ КАК ПорядокВключенияСтоимостиВСоставРасходовНУ,
	|	Реквизиты.ДатаПриобретения КАК ДатаПриобретения,
	|	Реквизиты.СрокПолезногоИспользованияНУ КАК СрокПолезногоИспользования,
	|	Реквизиты.НачислятьАмортизациюНУ КАК НачислятьАмортизацию,
	|	ЗНАЧЕНИЕ(Перечисление.МетодыНачисленияАмортизации.Линейный) КАК МетодНачисленияАмортизации,
	|	Реквизиты.СпециальныйКоэффициентНУ КАК СпециальныйКоэффициент,
	|	Реквизиты.РеквизитыДокументаОплаты КАК РеквизитыДокументаОплаты,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеРасходы) КАК СчетЗатрат,
	|	Реквизиты.СтатьяПрочихРасходов КАК СтатьяЗатрат,
	|	Реквизиты.СтатьяПрочихРасходов.ПринятиеКналоговомуУчету КАК ПринятиеКналоговомуУчету,
	|	Реквизиты.СтатьяПрочихРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат КАК ВидДеятельностиДляНалоговогоУчетаЗатрат
	|ИЗ
	|	Документ.ПринятиеКУчетуНМА КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|	И Реквизиты.СтоимостьНУ > 0";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ПодготовитьПараметрыТаблицПринятиеКУчетуНМА(ТаблицаПринятияКУчетуНМА, ТаблицаСписания)
	
	Параметры = Новый Структура;
	// Подготовка таблицы Параметры.ТаблицаПринятияКУчетуНМА

	СписокОбязательныхКолонок = ""
	+ "Период,"                       // <Дата>
	+ "НематериальныйАктив,"          // <СправочникСсылка.НематериальныеАктивы>
	+ "Организация,"                  // <СправочникСсылка.Организации>
	+ "ПодразделениеДт,"              // <Ссылка на справочник подразделений>
	+ "ПодразделениеКт,"              // <Ссылка на справочник подразделений>
	+ "Регистратор,"                  // <ДокументСсылка.*>
	+ "СчетУчета,"                    // <ПланСчетовСсылка.Хозрасчетный> - счет на который принимается к учету НМА
	+ "СчетУчетаВнеоборотногоАктива," // <ПланСчетовСсылка.Хозрасчетный> - счет учета нематериального актива
	+ "СтоимостьБУ,"
	+ "СтоимостьНУ,"
	+ "СтоимостьПР,"
	+ "СтоимостьВР,"
	+ "ВидОбъектаУчета,"
	+ "ПорядокСписанияНИОКРНаРасходыНУ"
	;

	Параметры.Вставить("ТаблицаПринятияКУчетуНМА",
		ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаПринятияКУчетуНМА, СписокОбязательныхКолонок));

	СписокОбязательныхКолонок = ""
	+ "НомерСтроки,"                  // <Число>
	+ "СчетЗатрат,"                   // <ПланСчетовСсылка.Хозрасчетный>
	+ "Подразделение,"                // <Ссылка на справочник подразделений>
	+ "Субконто1,"                    //
	+ "Субконто2,"                    //
	+ "Субконто3,"                    //
	+ "Коэффициент,"                  // <Число>
	+ "ВидРасходовНУ"                 // <ПеречислениеСсылка.ВидыРасходовНУ>
	;

	Параметры.Вставить("ТаблицаСписания",
		ОбщегоНазначенияБПВызовСервера.ПолучитьТаблицуПараметровПроведения(ТаблицаСписания, СписокОбязательныхКолонок));
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецЕсли
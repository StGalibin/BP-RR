﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 13, 0);
	
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
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Результат = Запрос.Выполнить();
	Реквизиты = ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(Результат);

	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СинонимОС",	НСтр("ru='Основные средства'"));
	
	Запрос.УстановитьПараметр("ВестиУчетПоВидамДеятельностиИП",	УчетнаяПолитика.ВестиУчетПоВидамДеятельностиИП(Реквизиты.Организация, Реквизиты.Период));
	Запрос.УстановитьПараметр("ОсновнаяНоменклатурнаяГруппа",	УчетнаяПолитика.ОсновнаяНоменклатурнаяГруппа(Реквизиты.Организация, Реквизиты.Период));

	НомераТаблиц = Новый Структура;

	Запрос.Текст =
		ТекстЗапросаТаблицаОС(НомераТаблиц)
		+ ТекстЗапросаВыбытиеОС(НомераТаблиц)
		+ ТекстЗапросаСостоянияОС(НомераТаблиц)
		+ ТекстЗапросаСписаниеОстаточнойСтоимости(НомераТаблиц)
		+ ТекстЗапросаПроверкиПоОС(НомераТаблиц)
		+ ТекстЗапросаСписаниеОСиНМАИП(НомераТаблиц);

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
	
	// Акт о списании ОС (ОС-4)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОС4";
	КомандаПечати.Представление = НСтр("ru = 'Акт о списании ОС (ОС-4)'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Списание ОС""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	// Проверяем, нужно ли для макета СчетЗаказа формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС4") Тогда

		ИмяМакета = "";
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОС4", НСтр("ru = 'ОС-4 (Акт о списании ОС)'"), 
			ПечатьОС4(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета),, ИмяМакета);

	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	

КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "СобытиеОС");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаТаблицаОС(НомераТаблиц)

	НомераТаблиц.Вставить("ОсновныеСредства", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка           КАК Регистратор,
	|	ТаблицаОС.НомерСтроки      КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.СписаниеОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции // ТекстЗапросаТаблицыДокумента()

Функция ТекстЗапросаВыбытиеОС(НомераТаблиц)

	НомераТаблиц.Вставить("ВыбытиеОС", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка                   КАК Регистратор,
	|	Реквизиты.Дата                     КАК Период,
	|	Реквизиты.Номер                    КАК Номер,
	|	Реквизиты.Организация              КАК Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	""ОС""                             КАК ИмяСписка,
	|	Реквизиты.СобытиеОС                КАК СобытиеОС,
	|	ИСТИНА                             КАК СписыватьТолькоЛинейныйНУ,
	|	""Списание ОС: "" + Реквизиты.ПричинаСписания.Наименование КАК Содержание
	|ИЗ
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСостоянияОС(НомераТаблиц)

	НомераТаблиц.Вставить("СостоянияОС", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Номер,
	|	Реквизиты.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета) КАК СостояниеОС,
	|	""ОС"" КАК ИмяСписка
	|ИЗ
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСписаниеОстаточнойСтоимости(НомераТаблиц)

	НомераТаблиц.Вставить("СписаниеОстаточнойСтоимости", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СписаниеОстаточнойСтоимостиТаблица", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Номер,
	|	Реквизиты.Организация,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	""ОС"" КАК ИмяСписка,
	|	Реквизиты.СобытиеОС,
	|	""Списание ОС: "" + Реквизиты.ПричинаСписания.Наименование КАК Содержание,
	|	ИСТИНА КАК СписыватьТолькоЛинейныйНУ
	|ИЗ
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.Ссылка              КАК Регистратор,
	|	ТаблицаОС.НомерСтроки         КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство    КАК ОсновноеСредство,
	|	ЛОЖЬ                          КАК Арендованное,
	|	ТаблицаОС.Ссылка.Субконто     КАК Субконто,
	|	ТаблицаОС.Ссылка.СчетСписания КАК СчетСписания,
	|	ТаблицаОС.Ссылка.Субконто     КАК СубконтоНУ,
	|	ТаблицаОС.Ссылка.СчетСписания КАК СчетСписанияНУ
	|ИЗ
	|	Документ.СписаниеОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаПроверкиПоОС(НомераТаблиц)

	НомераТаблиц.Вставить("ПроверкиПоОС", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	""ОС"" КАК ИмяСписка,
	|	Реквизиты.ПодразделениеОрганизации КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК МОЛ
	|ИЗ
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаСписаниеОСиНМАИП(НомераТаблиц)

	НомераТаблиц.Вставить("СписаниеОСиНМАИПРеквизиты",	НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СписаниеОСиНМАИПТаблица",	НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	""СписаниеОС"" КАК ВидОперации
	|ИЗ
	|	Документ.СписаниеОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""ОС"" КАК ИмяСписка,
	|	&СинонимОС КАК СинонимСписка,
	|	ТаблицаОС.НомерСтроки,
	|	ВЫБОР
	|		КОГДА НЕ &ВестиУчетПоВидамДеятельностиИП
	|			ТОГДА &ОсновнаяНоменклатурнаяГруппа
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.НоменклатурныеГруппы
	|			ТОГДА Реквизиты.Субконто
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НоменклатурнаяГруппа,
	|	ТаблицаОС.ОсновноеСредство КАК Номенклатура,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновныеСредства) КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.СтатьиЗатрат
	|				ИЛИ Реквизиты.Субконто ССЫЛКА Справочник.ПрочиеДоходыИРасходы
	|				ИЛИ Реквизиты.Субконто ССЫЛКА Справочник.РасходыБудущихПериодов
	|			ТОГДА Реквизиты.Субконто
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК СтатьяЗатрат,
	|	ВЫБОР
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(Реквизиты.Субконто КАК Справочник.СтатьиЗатрат).ВидРасходовНУ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВидРасходовНУ,
	|	ВЫБОР
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.ПрочиеДоходыИРасходы
	|			ТОГДА ВЫРАЗИТЬ(Реквизиты.Субконто КАК Справочник.ПрочиеДоходыИРасходы).ПринятиеКналоговомуУчету
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПринятиеКналоговомуУчету,
	|	ВЫБОР
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.СтатьиЗатрат
	|			ТОГДА ВЫРАЗИТЬ(Реквизиты.Субконто КАК Справочник.СтатьиЗатрат).ВидДеятельностиДляНалоговогоУчетаЗатрат
	|		КОГДА Реквизиты.Субконто ССЫЛКА Справочник.ПрочиеДоходыИРасходы
	|			ТОГДА ВЫРАЗИТЬ(Реквизиты.Субконто КАК Справочник.ПрочиеДоходыИРасходы).ВидДеятельностиДляНалоговогоУчетаЗатрат
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ВидДеятельностиДляНалоговогоУчетаЗатрат,
	|	Реквизиты.СчетСписания КАК СчетДоходов,
	|	0 КАК Выручка,
	|	0 КАК НДСНачисленный
	|ИЗ
	|	Документ.СписаниеОС.ОС КАК ТаблицаОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеОС КАК Реквизиты
	|		ПО ТаблицаОС.Ссылка = Реквизиты.Ссылка
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ПечатьОС4(МассивОбъектов, ОбъектыПечати, ПараметрыПечати, ИмяМакета)

	Перем ПодразделениеОтветственныхЛиц;

	Если МассивОбъектов.Количество() = 0 Тогда
		Возврат Новый ТабличныйДокумент;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеОС_ОС4";

	КоличествоОС4 = 0;
	КоличествоОС4а = 0;
	КоличествоОС4б = 0;
	МакетОС4  = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеОС.ПФ_MXL_ОС4");
	МакетОС4а = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеОС.ПФ_MXL_ОС4а");
	МакетОС4б = УправлениеПечатью.МакетПечатнойФормы("Документ.СписаниеОС.ПФ_MXL_ОС4б");

	// Области макетов
	ОбластьЗаголовок = МакетОС4.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок4а = МакетОС4а.ПолучитьОбласть("Заголовок");

	Шапка0 = МакетОС4б.ПолучитьОбласть("Шапка0");
	Шапка1 = МакетОС4б.ПолучитьОбласть("Шапка1");
	Шапка2 = МакетОС4б.ПолучитьОбласть("Шапка2");
	Строка1 = МакетОС4б.ПолучитьОбласть("Строка1");

	// Дополняет регистры сведений колонками ДатаНачала и ДатаОкончания
	//  для более удобного объединения в общем запросе
	МВТ = Новый МенеджерВременныхТаблиц;
	СоздатьВременныеТаблицыРегистров(МВТ, МассивОбъектов);

	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МВТ;

	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаОС.Ссылка КАК Ссылка,
	               |	ТаблицаОС.Ссылка.Номер КАК Номер,
	               |	ТаблицаОС.Ссылка.Дата КАК Дата,
	               |	ТаблицаОС.Ссылка.СобытиеОС КАК Состояние,
	               |	ТаблицаОС.Ссылка.ПричинаСписания КАК ПричинаСписания,
	               |	ТаблицаОС.Ссылка.Организация КАК Организация,
	               |	ТаблицаОС.Ссылка.Организация.КодПоОКПО КАК КодОКПО,
	               |	ТаблицаОС.Ссылка.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	               |	ТаблицаОС.Ссылка.МоментВремени КАК МоментВремени,
	               |	ТаблицаОС.НомерСтроки КАК Нп,
	               |	ТаблицаОС.ОсновноеСредство КАК ОС,
	               |	ТаблицаОС.ОсновноеСредство.ЗаводскойНомер КАК ЗаводскойНомер,
	               |	ТаблицаОС.ОсновноеСредство.Автотранспорт КАК Автотранспорт,
	               |	ТаблицаОС.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
	               |	ТаблицаОС.ОсновноеСредство.НаименованиеПолное КАК НаимОС,
	               |	ТаблицаОС.ОсновноеСредство.ГруппаОС КАК Группа,
	               |	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ПервоначальнаяСтоимость КАК НачСтоимость,
	               |	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ИнвентарныйНомер КАК ИнвНомер,
	               |	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ПорядокПогашенияСтоимости КАК ПорядокПогашенияСтоимости,
	               |	ВТ_МестонахождениеОСБухгалтерскийУчет.Местонахождение КАК Подразделение,
	               |	ВТ_МестонахождениеОСБухгалтерскийУчет.МОЛ КАК МОЛ,
	               |	ЕСТЬNULL(ВТ_СтоимостьОС.СуммаОборот, 0) КАК Стоимость,
	               |	ВЫБОР
	               |		КОГДА ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ПорядокПогашенияСтоимости = ЗНАЧЕНИЕ(Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ)
	               |				ИЛИ ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ПорядокПогашенияСтоимости = ЗНАЧЕНИЕ(Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзноса)
	               |			ТОГДА ЕСТЬNULL(ВТ_ИзносОС.СуммаОборот, 0)
	               |		ИНАЧЕ ЕСТЬNULL(ВТ_АмортизацияОС.СуммаОборот, 0)
	               |	КОНЕЦ КАК НачАмортизация
	               |ИЗ
	               |	Документ.СписаниеОС.ОС КАК ТаблицаОС
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет КАК ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет
	               |		ПО (ТаблицаОС.Ссылка.Дата МЕЖДУ ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ДатаНачала И ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ДатаОкончания)
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.ОсновноеСредство
	               |			И ТаблицаОС.Ссылка.Организация = ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет.Организация
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СчетаБухгалтерскогоУчетаОС КАК ВТ_СчетаБухгалтерскогоУчетаОС
	               |		ПО (ТаблицаОС.Ссылка.Дата МЕЖДУ ВТ_СчетаБухгалтерскогоУчетаОС.ДатаНачала И ВТ_СчетаБухгалтерскогоУчетаОС.ДатаОкончания)
	               |			И ТаблицаОС.Ссылка.Организация = ВТ_СчетаБухгалтерскогоУчетаОС.Организация
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_СчетаБухгалтерскогоУчетаОС.ОсновноеСредство
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МестонахождениеОСБухгалтерскийУчет КАК ВТ_МестонахождениеОСБухгалтерскийУчет
	               |		ПО (ТаблицаОС.Ссылка.Дата МЕЖДУ ВТ_МестонахождениеОСБухгалтерскийУчет.ДатаНачала И ВТ_МестонахождениеОСБухгалтерскийУчет.ДатаОкончания)
	               |			И ТаблицаОС.Ссылка.Организация = ВТ_МестонахождениеОСБухгалтерскийУчет.Организация
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_МестонахождениеОСБухгалтерскийУчет.ОсновноеСредство
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СтоимостьОС КАК ВТ_СтоимостьОС
	               |		ПО ТаблицаОС.Ссылка = ВТ_СтоимостьОС.Регистратор
	               |			И (ВТ_СчетаБухгалтерскогоУчетаОС.СчетУчета = ВТ_СтоимостьОС.СчетКт)
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_СтоимостьОС.СубконтоКт1
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_АмортизацияОС КАК ВТ_АмортизацияОС
	               |		ПО ТаблицаОС.Ссылка = ВТ_АмортизацияОС.Регистратор
	               |			И (ВТ_СчетаБухгалтерскогоУчетаОС.СчетНачисленияАмортизации = ВТ_АмортизацияОС.СчетДт)
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_АмортизацияОС.СубконтоДт1
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИзносОС КАК ВТ_ИзносОС
	               |		ПО ТаблицаОС.Ссылка = ВТ_ИзносОС.Регистратор
	               |			И (ВТ_СчетаБухгалтерскогоУчетаОС.СчетНачисленияИзносаАмортизации = ВТ_ИзносОС.СчетКт)
	               |			И ТаблицаОС.ОсновноеСредство = ВТ_ИзносОС.СубконтоКт1
	               |ГДЕ
	               |	ТаблицаОС.Ссылка В(&МассивОбъектов)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТаблицаОС.Ссылка.Дата,
	               |	ТаблицаОС.Ссылка,
	               |	Нп
	               |ИТОГИ ПО
	               |	Ссылка";

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда

		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		ТабличныйДокумент.АвтоМасштаб = Истина;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		Возврат ТабличныйДокумент;

	КонецЕсли;

	ВыборкаДокументов = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ПервыйДокумент = Истина;

	// Цикл по документам
	Пока ВыборкаДокументов.Следующий() Цикл

		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		СведенияОбОрганизации    = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаДокументов.Организация, ВыборкаДокументов.Дата);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");

		ПодразделениеОтветственныхЛиц = ВыборкаДокументов.ПодразделениеОрганизации;

		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаДокументов.Организация, ВыборкаДокументов.Дата, ПодразделениеОтветственныхЛиц);

		// Выборка по табличной части
		ВыборкаСтрок = ВыборкаДокументов.Выбрать(ОбходРезультатаЗапроса.Прямой);

		Если ВыборкаСтрок.Количество() = 1 Тогда

			ВыборкаСтрок.Следующий();
			
			Если Не ЗначениеЗаполнено(ВыборкаСтрок.Автотранспорт) Тогда
				ТабличныйДокумент.Вывести(ОбластьЗаголовок);
				Продолжить;
			КонецЕсли;

			Если ВыборкаСтрок.Автотранспорт Тогда
				КоличествоОС4а = КоличествоОС4 + 1;
				Область = ОбластьЗаголовок4а;
			Иначе
				КоличествоОС4 = КоличествоОС4 + 1;
				Область = ОбластьЗаголовок;
			КонецЕсли;

			ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ВыборкаДокументов.Организация, ВыборкаСтрок.МОЛ, ВыборкаДокументов.Дата, Истина);

			Область.Параметры.Заполнить(ВыборкаСтрок);
			Область.Параметры.Организация = ПредставлениеОрганизации;
			Область.Параметры.ТабНомерМОЛ = ДанныеФизЛица.ТабельныйНомер;

			Если НЕ ЗначениеЗаполнено(ВыборкаСтрок.НаимОС) Тогда
				Область.Параметры["НаимОС"] = ВыборкаСтрок.ОС;
			КонецЕслИ;

			ДокументПринятияКУчету     = "";
			ДокументВводаВЭксплуатацию = "";
			ПринятоКУчету              = "";
			ВведеноВЭксплуатацию       = "";

			УчетОС.ПолучитьДокументБухСостоянияОС(
				ВыборкаСтрок.ОС,
				ВыборкаСтрок.Организация,
				Перечисления.СостоянияОС.ПринятоКУчету,
				ДокументВводаВЭксплуатацию,
				ВведеноВЭксплуатацию);
			УчетОС.ПолучитьДокументБухСостоянияОС(
				ВыборкаСтрок.ОС,
				ВыборкаСтрок.Организация,
				Перечисления.СостоянияОС.ПринятоКУчету,
				ДокументПринятияКУчету,
				ПринятоКУчету);

			Если ВыборкаСтрок.Автотранспорт Тогда
				Область.Параметры.ВведеноВЭксплуатацию = ВведеноВЭксплуатацию;
				Если ДокументВводаВЭксплуатацию = Неопределено Тогда
					Область.Параметры.Пробег = ПолучитьПробегАвто(ВыборкаСтрок.ОС, ВыборкаСтрок.Дата, ВыборкаСтрок.Дата, ВыборкаСтрок.Организация);
				Иначе
					Область.Параметры.Пробег = ПолучитьПробегАвто(ВыборкаСтрок.ОС, ДокументВводаВЭксплуатацию.Дата, ВыборкаСтрок.Дата, ВыборкаСтрок.Организация);
				КонецЕсли;
			Иначе
				Область.Параметры.СрокЭкспл = ?(ЗначениеЗаполнено(ВведеноВЭксплуатацию),
				УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ВведеноВЭксплуатацию, ВыборкаСтрок.Дата), 0);
			КонецЕсли;

			СтоимостьОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				ВыборкаСтрок.НачСтоимость,
				ВыборкаСтрок.Стоимость);

			АмортизацияОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				0,
				ВыборкаСтрок.НачАмортизация);

			Область.Параметры.ГодВыпуска     = ?(ЗначениеЗаполнено(ВыборкаСтрок.ГодВыпуска), Год(ВыборкаСтрок.ГодВыпуска), 0);
			Область.Параметры.ПринятоКУчету  = ПринятоКУчету;
			Область.Параметры.НачСтоимость   = СтоимостьОС;
			Область.Параметры.НачАмортизация = АмортизацияОС;

			Область.Параметры.ОстСтоимость = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				0,
				СтоимостьОС - АмортизацияОС);

			Область.Параметры.ГлавБух               = ОтветственныеЛица.ГлавныйБухгалтерПредставление;
			Область.Параметры.Руководитель          = ОтветственныеЛица.РуководительПредставление;
			Область.Параметры.ДолжностьРуководителя = ОтветственныеЛица.РуководительДолжностьПредставление;

			ТабличныйДокумент.Вывести(Область);

		Иначе // Табличная часть состоит их нескольких строк

			ПерваяИтерация = Истина;
			Пока ВыборкаСтрок.Следующий() Цикл
				
				Если ПерваяИтерация Тогда 
					
					ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ВыборкаДокументов.Организация, ВыборкаСтрок.МОЛ, ВыборкаДокументов.Дата, Истина);
					
					Шапка0.Параметры.Заполнить(ВыборкаСтрок);
					Шапка0.Параметры.Организация           = ПредставлениеОрганизации;
					Шапка0.Параметры.Руководитель          = ОтветственныеЛица.РуководительПредставление;
					Шапка0.Параметры.ДолжностьРуководителя = ОтветственныеЛица.РуководительДолжностьПредставление;
					Шапка0.Параметры.ТабНомерМОЛ           = ДанныеФизЛица.ТабельныйНомер;

					ТабличныйДокумент.Вывести(Шапка0);

					Шапка1.Параметры.Заполнить(ВыборкаСтрок);
					ТабличныйДокумент.Вывести(Шапка1);
					ПерваяИтерация = Ложь;
					
				КонецЕсли;

				Строка1.Параметры.Заполнить(ВыборкаСтрок);
				Если НЕ ЗначениеЗаполнено(ВыборкаСтрок.НаимОС) Тогда
					Строка1.Параметры["НаимОС"] = ВыборкаСтрок.ОС;
				КонецЕсли;

				СтоимостьОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					ВыборкаСтрок.НачСтоимость,
					ВыборкаСтрок.Стоимость);

				АмортизацияОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					0,
					ВыборкаСтрок.НачАмортизация);

				Строка1.Параметры.Заполнить(ВыборкаСтрок);
				Строка1.Параметры.НачСтоимость = СтоимостьОС;
				Строка1.Параметры.НачАмортизация = АмортизацияОС;
				Строка1.Параметры.ОстСтоимость = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					0,
					СтоимостьОС - АмортизацияОС);

				Строка1.Параметры.Причина = ВыборкаСтрок.ПричинаСписания;

				ДокументПринятияКУчету     = "";
				ДокументВводаВЭксплуатацию = "";
				ПринятоКУчету              = "";
				ВведеноВЭксплуатацию       = "";

				УчетОС.ПолучитьДокументБухСостоянияОС(
					ВыборкаСтрок.ОС,
					ВыборкаСтрок.Организация,
					Перечисления.СостоянияОС.ПринятоКУчету,
					ДокументВводаВЭксплуатацию,
					ВведеноВЭксплуатацию);

				Строка1.Параметры.СрокЭкспл = ?(ЗначениеЗаполнено(ВведеноВЭксплуатацию),
					УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ВведеноВЭксплуатацию, ВыборкаСтрок.Дата), 0);

				ТабличныйДокумент.Вывести(Строка1);

			КонецЦикла;

			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			Шапка2.Параметры.Заполнить(ВыборкаСтрок);
			Шапка2.Параметры.ГлавБух = ОтветственныеЛица.ГлавныйБухгалтерПредставление;
			ТабличныйДокумент.Вывести(Шапка2);
			
			Если Не ПерваяИтерация Тогда 
				КоличествоОС4б = КоличествоОС4б + 1;
			КонецЕсли;

		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);

	КонецЦикла;
	
	Если КоличествоОС4 = 0 И КоличествоОС4а = 0 Тогда 
		ИмяМакета = "Документ.СписаниеОС.ПФ_MXL_ОС4б";
	ИначеЕсли КоличествоОС4 = 0 И КоличествоОС4б = 0 Тогда 
		ИмяМакета = "Документ.СписаниеОС.ПФ_MXL_ОС4а";
	ИначеЕсли КоличествоОС4а = 0 И КоличествоОС4б = 0 Тогда 
		ИмяМакета = "Документ.СписаниеОС.ПФ_MXL_ОС4";
	КонецЕсли;

	Возврат ТабличныйДокумент;

КонецФункции

// Процедура создает временные "виртуальные" таблицы регистров сведений для дальнейшей работы с ними
//
// Параметры:
//  МВТ            - МенеджерВременныхТаблиц, где будут храниться временные таблицы
//  МассивОбъектов - Массив документов
//
Процедура СоздатьВременныеТаблицыРегистров(МВТ, МассивОбъектов)

	// 1. Определим "границы" регистров сведений - список организаций, ОС, период, ...
	//    чтобы ограничить выборку из регистров сведений
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|// 1. Период дат
	|ВЫБРАТЬ
	|	МИНИМУМ(Док.Дата)  КАК ДатаОТ,
	|	МАКСИМУМ(Док.Дата) КАК ДатаДО
	|ИЗ
	|	Документ.СписаниеОС КАК Док
	|ГДЕ
	|	Док.Ссылка В (&МассивОбъектов)
	|;
	|
	|// 2. Список организаций
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Док.Организация КАК Организация
	|ИЗ
	|	Документ.СписаниеОС КАК Док
	|ГДЕ
	|	Док.Ссылка В (&МассивОбъектов)
	|;
	|
	|// 3. Список ОС
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Док.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.СписаниеОС.ОС КАК Док
	|ГДЕ
	|	Док.Ссылка В (&МассивОбъектов)
	|
	|";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);

	Результат = Запрос.ВыполнитьПакет();
	// 1.1. Интервал дат
	Выборка = Результат[0].Выбрать(ОбходРезультатаЗапроса.Прямой);
	Выборка.Следующий();
	ДатаОТ = Выборка.ДатаОТ;
	ДатаДО = Выборка.ДатаДО;

	// 1.2. Список организаций
	МассивОрганизаций = Результат[1].Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("Организация");

	// 1.3. Список ОС
	МассивОС = Результат[2].Выгрузить(ОбходРезультатаЗапроса.Прямой).ВыгрузитьКолонку("ОсновноеСредство");

	// 2. Создание временных таблиц
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.УстановитьПараметр("ДатаОТ",            ДатаОТ);
	Запрос.УстановитьПараметр("ДатаДО",            ДатаДО);
	Запрос.УстановитьПараметр("МассивОбъектов",    МассивОбъектов);
	Запрос.УстановитьПараметр("МассивОрганизаций", МассивОрганизаций);
	Запрос.УстановитьПараметр("МассивОС",          МассивОС);
	Запрос.Текст = "
	|////////////////////////////////////////////////////////////////////////////////
	|// 1. Список ОС
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаОС.Ссылка           КАК Ссылка,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ
	|	ВТ_ВсеОС
	|ИЗ
	|	Документ.СписаниеОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка В (&МассивОбъектов)
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 2. Первоначальные сведения ОС
	|
	|// 2.1. Временный подзапрос, получение интервалов дат
	|ВЫБРАТЬ
	|	Рег1.Период           КАК Период,
	|	Рег1.Организация      КАК Организация,
	|	МИНИМУМ(Рег2.Период)  КАК ПервыйПериод,
	|	Рег1.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ
	|	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет_Рег2
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Период         < Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|	И Рег2.Период <= &ДатаДО
	|	И Рег2.ОсновноеСредство В (&МассивОС)
	|СГРУППИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|ИНДЕКСИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|;
	|
	|// 2.2. Запрос к первоначальным сведениям ОС
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Рег2.ПервыйПериод ЕСТЬ NULL ТОГДА
	|			ДАТАВРЕМЯ(3999,12,31)
	|		ИНАЧЕ
	|			ДОБАВИТЬКДАТЕ(Рег2.ПервыйПериод, СЕКУНДА, -1)
	|	КОНЕЦ                            КАК ДатаОкончания,
	|	Рег1.Период                      КАК ДатаНачала,
	|	Рег1.ОсновноеСредство            КАК ОсновноеСредство,
	|	Рег1.Организация                 КАК Организация,
	|	Рег1.ИнвентарныйНомер            КАК ИнвентарныйНомер,
	|	Рег1.СпособПоступления           КАК СпособПоступления,
	|	Рег1.ПервоначальнаяСтоимость     КАК ПервоначальнаяСтоимость,
	|	Рег1.СпособНачисленияАмортизации КАК СпособНачисленияАмортизации,
	|	Рег1.ПараметрВыработки           КАК ПараметрВыработки,
	|	Рег1.ПорядокПогашенияСтоимости   КАК ПорядокПогашенияСтоимости
	|ПОМЕСТИТЬ
	|	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет
	|ИЗ
	|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТ_ПервоначальныеСведенияОСБухгалтерскийУчет_Рег2 КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Период         = Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаНачала,
	|	ДатаОкончания,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 3. Счета бухгалтерского учета ОС
	|
	|// 3.1. Временный подзапрос, получение интервалов дат
	|ВЫБРАТЬ
	|	Рег1.Период           КАК Период,
	|	МИНИМУМ(Рег2.Период)  КАК ПервыйПериод,
	|	Рег1.Организация      КАК Организация,
	|	Рег1.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ
	|	ВТ_СчетаБухгалтерскогоУчетаОС_Рег2
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Организация    = Рег2.Организация
	|		И Рег1.Период         < Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.Организация В (&МассивОрганизаций)
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|	И Рег2.Период <= &ДатаДО
	|	И Рег2.Организация В (&МассивОрганизаций)
	|	И Рег2.ОсновноеСредство В (&МассивОС)
	|СГРУППИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|ИНДЕКСИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|;
	|
	|// 3.2. Запрос к счетам бухгалтерского учета ОС
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Рег2.ПервыйПериод ЕСТЬ NULL ТОГДА
	|			ДАТАВРЕМЯ(3999,12,31)
	|		ИНАЧЕ
	|			ДОБАВИТЬКДАТЕ(Рег2.ПервыйПериод, СЕКУНДА, -1)
	|	КОНЕЦ                          КАК ДатаОкончания,
	|	Рег1.Период                    КАК ДатаНачала,
	|	Рег1.Организация               КАК Организация,
	|	Рег1.ОсновноеСредство          КАК ОсновноеСредство,
	|	Рег1.СчетУчета                 КАК СчетУчета,
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетНачисленияИзноса,
	|	Рег1.СчетНачисленияАмортизации КАК СчетНачисленияАмортизации,
	|	Рег1.СчетНачисленияАмортизации КАК СчетНачисленияИзносаАмортизации
	|ПОМЕСТИТЬ
	|	ВТ_СчетаБухгалтерскогоУчетаОС
	|ИЗ
	|	РегистрСведений.СчетаБухгалтерскогоУчетаОС КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТ_СчетаБухгалтерскогоУчетаОС_Рег2 КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Организация    = Рег2.Организация
	|		И Рег1.Период         = Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.Организация В (&МассивОрганизаций)
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаНачала,
	|	ДатаОкончания,
	|	Организация,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 4. Местонахождение ОС
	|
	|// 4.1. Временный подзапрос, получение интервалов дат
	|ВЫБРАТЬ
	|	Рег1.Период           КАК Период,
	|	МИНИМУМ(Рег2.Период)  КАК ПервыйПериод,
	|	Рег1.Организация      КАК Организация,
	|	Рег1.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ
	|	ВТ_МестонахождениеОСБухгалтерскийУчет_Рег2
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Организация    = Рег2.Организация
	|		И Рег1.Период         < Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.Организация В (&МассивОрганизаций)
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|	И Рег2.Период <= &ДатаДО
	|	И Рег2.Организация В (&МассивОрганизаций)
	|	И Рег2.ОсновноеСредство В (&МассивОС)
	|СГРУППИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|ИНДЕКСИРОВАТЬ ПО
	|	Рег1.Период,
	|	Рег1.Организация,
	|	Рег1.ОсновноеСредство
	|;
	|
	|// 4.2. Запрос к Местонахождение ОС
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Рег2.ПервыйПериод ЕСТЬ NULL ТОГДА
	|			ДАТАВРЕМЯ(3999,12,31)
	|		ИНАЧЕ
	|			ДОБАВИТЬКДАТЕ(Рег2.ПервыйПериод, СЕКУНДА, -1)
	|	КОНЕЦ                          КАК ДатаОкончания,
	|	Рег1.Период                    КАК ДатаНачала,
	|	Рег1.Организация               КАК Организация,
	|	Рег1.ОсновноеСредство          КАК ОсновноеСредство,
	|	Рег1.МОЛ                       КАК МОЛ,
	|	Рег1.Местонахождение           КАК Местонахождение
	|ПОМЕСТИТЬ
	|	ВТ_МестонахождениеОСБухгалтерскийУчет
	|ИЗ
	|	РегистрСведений.МестонахождениеОСБухгалтерскийУчет КАК Рег1
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	ВТ_МестонахождениеОСБухгалтерскийУчет_Рег2 КАК Рег2
	|	ПО
	|		Рег1.ОсновноеСредство = Рег2.ОсновноеСредство
	|		И Рег1.Организация    = Рег2.Организация
	|		И Рег1.Период         = Рег2.Период
	|ГДЕ
	|	Рег1.Период <= &ДатаДО
	|	И Рег1.Организация В (&МассивОрганизаций)
	|	И Рег1.ОсновноеСредство В (&МассивОС)
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаНачала,
	|	ДатаОкончания,
	|	Организация,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 5. СтоимостьОС, итоги по каждому документу
	|
	|ВЫБРАТЬ
	|	ХозрасчетныйОборотыДтКт.Регистратор КАК Регистратор,
	|	ХозрасчетныйОборотыДтКт.СчетКт      КАК СчетКт,
	|	ХозрасчетныйОборотыДтКт.СубконтоКт1 КАК СубконтоКт1,
	|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК СуммаОборот
	|ПОМЕСТИТЬ
	|	ВТ_СтоимостьОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
	|		ДОБАВИТЬКДАТЕ(&ДатаОТ, СЕКУНДА, -1),
	|		ДОБАВИТЬКДАТЕ(&ДатаДО, СЕКУНДА, 1),
	|		Регистратор,
	|		СчетДт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВыбытиеОС),
	|		,
	|		,
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|		Организация В (&МассивОрганизаций)
	|	) КАК ХозрасчетныйОборотыДтКт
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор В (&МассивОбъектов)
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	СчетКт,
	|	СубконтоКт1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 6. АмортизацияОС, итоги по каждому документу
	|
	|ВЫБРАТЬ
	|	ХозрасчетныйОборотыДтКт.Регистратор КАК Регистратор,
	|	ХозрасчетныйОборотыДтКт.СчетДт      КАК СчетДт,
	|	ХозрасчетныйОборотыДтКт.СубконтоДт1 КАК СубконтоДт1,
	|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК СуммаОборот
	|ПОМЕСТИТЬ
	|	ВТ_АмортизацияОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
	|		ДОБАВИТЬКДАТЕ(&ДатаОТ, СЕКУНДА, -1),
	|		ДОБАВИТЬКДАТЕ(&ДатаДО, СЕКУНДА, 1),
	|		Регистратор,
	|		,
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
	|		СчетКт = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ВыбытиеОС),
	|		,
	|		Организация В (&МассивОрганизаций)
	|	) КАК ХозрасчетныйОборотыДтКт
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор В (&МассивОбъектов)
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	СчетДт,
	|	СубконтоДт1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// 7. Износ или Амортизация ОС (в зависимости от конфигурации), итоги по каждому документу
	|
	|ВЫБРАТЬ
	|	ХозрасчетныйОборотыДтКт.Регистратор КАК Регистратор,
	|	ХозрасчетныйОборотыДтКт.СчетКт      КАК СчетКт,
	|	ХозрасчетныйОборотыДтКт.СубконтоКт1 КАК СубконтоКт1,
	|	ХозрасчетныйОборотыДтКт.Сумма       КАК СуммаОборот
	|ПОМЕСТИТЬ
	|	ВТ_ИзносОС
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(
	|		ДОБАВИТЬКДАТЕ(&ДатаОТ, СЕКУНДА, -1),
	|		ДОБАВИТЬКДАТЕ(&ДатаДО, СЕКУНДА, 1),
	|		Организация В (&МассивОрганизаций)
	|			И СубконтоКт1 В (&МассивОС)
	|			И СчетКт В (ВЫБРАТЬ ВТ_СчетаБухгалтерскогоУчетаОС.СчетНачисленияИзносаАмортизации ИЗ ВТ_СчетаБухгалтерскогоУчетаОС)
	|	) КАК ХозрасчетныйОборотыДтКт
	|ГДЕ
	|	ХозрасчетныйОборотыДтКт.Регистратор В (&МассивОбъектов)
	|ИНДЕКСИРОВАТЬ ПО
	|	Регистратор,
	|	СчетКт,
	|	СубконтоКт1
	|;
	|
	|";
	Запрос.Выполнить();

КонецПроцедуры

// Функция возвращает параметры ОС
//
Функция ПолучитьПробегАвто(ОбъектОС, НачДата, КонДата, Организация)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонДата", КонДата);
	Запрос.УстановитьПараметр("НачГраница", Новый Граница(НачДата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КонГраница", Новый Граница(КонДата, ВидГраницы.Включая));
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ВыработкаОС.КоличествоОборот КАК Пробег
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
		|		&КонДата,
		|		ОсновноеСредство = &ОС
		|			И Организация = &Организация
		|	) КАК РегСведенияОС
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|
		|	РегистрНакопления.ВыработкаОС.Обороты(
		|		&НачГраница,
		|		&КонГраница,
		|		,
		|		ОсновноеСредство = &ОС
		|	) КАК ВыработкаОС
		|
		|	ПО
		|		РегСведенияОС.ОсновноеСредство = ВыработкаОС.ОсновноеСредство
		|		И РегСведенияОС.ПараметрВыработки = ВыработкаОС.ПараметрВыработки
		|";

	Запрос.УстановитьПараметр("ОС", ОбъектОС);
	Запрос.УстановитьПараметр("Организация", Организация);

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	Возврат Выборка.Пробег;

КонецФункции

#КонецОбласти

#КонецЕсли
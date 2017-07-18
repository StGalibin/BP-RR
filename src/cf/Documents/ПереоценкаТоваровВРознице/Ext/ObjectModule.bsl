﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ТипСклада");

	Если ТипСклада = Перечисления.ТипыСкладов.НеавтоматизированнаяТорговаяТочка Тогда

		МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ЦенаВРозницеСтарая");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ЦенаВРознице");

		СчетУчетаТоваровВНТТ = ПланыСчетов.Хозрасчетный.ТоварыВРозничнойТорговлеВПродажныхЦенахНТТ;
		СубконтоСтавкиНДС = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтавкиНДС;
		РазделятьПоСтавкамНДС = СчетУчетаТоваровВНТТ.ВидыСубконто.Найти(СубконтоСтавкиНДС, "ВидСубконто") <> Неопределено;

		Если НЕ РазделятьПоСтавкамНДС Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДСВРознице");
		КонецЕсли;

	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СуммаПереоценки");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.СтавкаНДСВРознице");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ПереоценкаТоваровВРознице.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	Документы.ПереоценкаТоваровВРознице.СформироватьДвиженияПереоценкаТоваровНТТ(ПараметрыПроведения.ТаблицаТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	Документы.ПереоценкаТоваровВРознице.СформироватьДвиженияПереоценкаТоваровАТТ(ПараметрыПроведения.ТаблицаТовары,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры
#КонецЕсли
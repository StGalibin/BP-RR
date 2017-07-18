﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура производит инициализацию параметров устройства.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Параметры = Новый ХранилищеЗначения(Новый Структура());
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура проверяет уникальность наименования элемента справочника
// для данного компьютера.
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Не ПустаяСтрока(Наименование) Тогда
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|    1
		|ИЗ
		|    Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|    ПодключаемоеОборудование.Наименование = &Наименование
		|    И ПодключаемоеОборудование.РабочееМесто = &РабочееМесто
		|    И ПодключаемоеОборудование.Ссылка <> &Ссылка
		|");

		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		Запрос.УстановитьПараметр("Ссылка"      , Ссылка);

		Если Не Запрос.Выполнить().Пустой() Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Указано неуникальное наименование элемента. Укажите уникальное наименование.'"), ЭтотОбъект, , , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипОборудования <> Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		ИндексЭлемента = ПроверяемыеРеквизиты.Найти("Организация");
		Если ИндексЭлемента <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексЭлемента);
		КонецЕсли;
		ИндексЭлемента = ПроверяемыеРеквизиты.Найти("СпособФорматоЛогическогоКонтроля");
		Если ИндексЭлемента <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексЭлемента);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.WebСервисОборудование Тогда
		
		Если ЗначениеЗаполнено(ИдентификаторWebСервисОборудования) Тогда
			Запрос = Новый Запрос("
			|ВЫБРАТЬ
			|    1
			|ИЗ
			|    Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
			|ГДЕ
			|    ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторWebСервисОборудования
			|    И ПодключаемоеОборудование.Ссылка <> &Ссылка
			|");
			
			Запрос.УстановитьПараметр("ИдентификаторWebСервисОборудования", ИдентификаторWebСервисОборудования);
			Запрос.УстановитьПараметр("Ссылка"      , Ссылка);
			
			Если Не Запрос.Выполнить().Пустой() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Указан неуникальный идентификатор активного оборудования элемента. Укажите уникальный идентификатор.'"), ЭтотОбъект, , , Отказ);
			КонецЕсли;
		КонецЕсли;
		
		ИндексЭлемента = ПроверяемыеРеквизиты.Найти("РабочееМесто");
		
		Если Не ИндексЭлемента = Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексЭлемента);
		КонецЕсли;
		
	Иначе
		ИндексЭлемента = ПроверяемыеРеквизиты.Найти("ИдентификаторWebСервисОборудования");
		Если Не ИндексЭлемента = Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(ИндексЭлемента);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура производит очистку реквизитов, которые не должны копироваться.
// Следующие реквизиты очищаются при копировании:
// "Параметры"      - параметры устройства сбрасываются в Неопределено;
// "Наименование"   - устанавливается отличное от исходного наименования;
Процедура ПриКопировании(ОбъектКопирования)
	
	УстройствоИспользуется = Истина;
	Параметры = Неопределено;

	Наименование = НСтр("ru='%Наименование% (копия)'");
	Наименование = СтрЗаменить(Наименование, "%Наименование%", ОбъектКопирования.Наименование);
	
КонецПроцедуры

// При записи
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ТипОборудования")
			И ДанныеЗаполнения.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.WebСервисОборудование Тогда
			
			ДрайверОборудования = Справочники.ДрайверыОборудования.Драйвер1СWebСервисОборудование;
			
			Если ДанныеЗаполнения.Свойство("РабочееМесто") Тогда
				РабочееМесто = Неопределено;
				ДанныеЗаполнения.РабочееМесто = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СпособФорматоЛогическогоКонтроля) Тогда
		СпособФорматоЛогическогоКонтроля = Перечисления.СпособыФорматоЛогическогоКонтроля.НеКонтролировать;
		ДопустимоеРасхождениеФорматоЛогическогоКонтроля = 0.01;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
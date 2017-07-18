﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интерфейсы сообщений в модели сервиса", переопределяемые
//  процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ЗаполнитьОбработчикиПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	// СтатистикаПоПоказателям
	СтатистикаПоПоказателямСлужебный.РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков);
	// СтатистикаПоПоказателям
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  отправляемых сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ЗаполнитьОбработчикиОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	// СтатистикаПоПоказателям
	СтатистикаПоПоказателямСлужебный.РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков);
	// СтатистикаПоПоказателям
	
КонецПроцедуры

// Процедура вызывается при определении версии интерфейса сообщений, поддерживаемой как ИБ-корреспондентом,
//  так и текущей ИБ. В данной процедуре предполагается реализовывать механизмы поддержки обратной совместимости
//  со старыми версиями ИБ-корреспондентов.
//
// Параметры:
//  ИнтерфейсСообщения - строка, название программного интерфейса сообщения, для которого определяется версия.
//  ПараметрыПодключения - структура, параметры подключения к ИБ-корреспонденту.
//  ПредставлениеПолучателя - строка, представление ИБ-корреспондента.
//  Результат - строка, определяемая версия. Значение данного параметра может быть изменено в данной процедуре.
//
Процедура ПриОпределенииВерсииИнтерфейсаКорреспондента(Знач ИнтерфейсСообщения, Знач ПараметрыПодключения, Знач ПредставлениеПолучателя, Результат) Экспорт
	
КонецПроцедуры

#КонецОбласти

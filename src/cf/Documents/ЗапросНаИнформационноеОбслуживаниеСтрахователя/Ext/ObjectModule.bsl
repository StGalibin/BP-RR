﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОС.СверкаФИОиСНИЛС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаДату");
	ИначеЕсли ВидУслуги = Перечисления.ВидыУслугПриИОС.СправкаОСостоянииРасчетов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗастрахованныеЛица");
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
        Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;

	НаДату = ТекущаяДатаСеанса();
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОбработкаЗаполненияОбъекта(ЭтотОбъект, СообщениеОснование);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


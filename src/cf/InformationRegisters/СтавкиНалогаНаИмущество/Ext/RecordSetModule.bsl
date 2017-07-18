﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Для каждого Запись Из ЭтотОбъект Цикл
			РегистрыСведений.СтавкиНалогаНаИмущество.УстановкаНастроекПоУмолчанию(Запись, Новый Структура);
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Для каждого Запись Из ЭтотОбъект Цикл
			РегистрыСведений.СтавкиНалогаНаИмущество.УстановкаНастроекПоУмолчанию(Запись, ДанныеЗаполнения);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	ПроверятьКодНалоговойЛьготыОсвобождениеОтНалогообложения = Ложь;
	ПроверятьСниженнаяНалоговаяСтавка = Ложь;
	ПроверятьПроцентУменьшения = Ложь;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.ОсвобождениеОтНалогообложения Тогда
			ПроверятьКодНалоговойЛьготыОсвобождениеОтНалогообложения = Истина;
		КонецЕсли;
		
		Если Запись.СнижениеНалоговойСтавки Тогда
			ПроверятьСниженнаяНалоговаяСтавка = Истина;
		КонецЕсли;
		
		Если Запись.УменьшениеСуммыНалогаВПроцентах Тогда
			ПроверятьПроцентУменьшения = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ПроверятьКодНалоговойЛьготыОсвобождениеОтНалогообложения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КодНалоговойЛьготыОсвобождениеОтНалогообложения");
	КонецЕсли;
	
	Если Не ПроверятьСниженнаяНалоговаяСтавка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СниженнаяНалоговаяСтавка");
	КонецЕсли;
	
	Если Не ПроверятьПроцентУменьшения Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПроцентУменьшения");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли
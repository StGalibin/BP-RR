﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РеестрПолучателейСтраховогоОбеспечения");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Реестр пособий, оплаченных за счет ФСС'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
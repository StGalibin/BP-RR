﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаПроверкиЗаполненияОтборов(ЭтотОбъект, Отказ);
	
КонецПроцедуры
#КонецЕсли
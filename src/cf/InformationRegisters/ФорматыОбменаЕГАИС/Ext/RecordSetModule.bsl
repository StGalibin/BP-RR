﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ИнтеграцияЕГАИС.ОбновитьФорматОбменаОрганизацииЕГАИС(Запись.ИдентификаторФСРАР, Запись.ФорматОбмена);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

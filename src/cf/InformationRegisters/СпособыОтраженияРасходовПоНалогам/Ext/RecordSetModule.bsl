﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		
		ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		
		Для каждого Запись Из ЭтотОбъект Цикл
			Если ЗначениеЗаполнено(Запись.ОсновноеСредство) И НЕ ЗначениеЗаполнено(запись.Организация) Тогда
				Запись.Организация = ОсновнаяОрганизация;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
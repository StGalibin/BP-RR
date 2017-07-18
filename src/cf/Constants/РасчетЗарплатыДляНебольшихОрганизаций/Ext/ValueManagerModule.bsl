﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
		
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	Если ЭтотОбъект.Значение Тогда
		
		Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
			
			Если НЕ РасчетЗарплатыДляНебольшихОрганизаций.РасчетЗарплатыДляНебольшихОрганизацийВозможен() Тогда
				
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников(),
					РасчетЗарплатыДляНебольшихОрганизаций.ПорогЗапрета());
					
				ВызватьИсключение ТекстИсключения;
				
			КонецЕсли;
			
		КонецЕсли; 
			
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли

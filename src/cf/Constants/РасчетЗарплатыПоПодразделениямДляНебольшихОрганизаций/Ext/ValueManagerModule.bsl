﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;		
	
	Если ЭтотОбъект.Значение Тогда
		Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
			Если НЕ РасчетЗарплатыДляНебольшихОрганизаций.РасчетЗарплатыДляНебольшихОрганизацийВозможен() Тогда
				ТекстИсключения = СтрШаблон(
					ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников(),
					РасчетЗарплатыДляНебольшихОрганизаций.ПорогЗапрета());
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Функция ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников()
	
	Возврат НСтр("ru='Для расчета зарплаты по обособленным подразделениям количество работающих сотрудников не может превышать %1.'");
	
КонецФункции

#КонецЕсли


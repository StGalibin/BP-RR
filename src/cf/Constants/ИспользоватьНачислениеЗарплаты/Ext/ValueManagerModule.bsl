﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение = Ложь Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетЗарплатыДляНебольшихОрганизаций") Тогда
			МодульРасчетЗарплатыДляНебольшихОрганизаций = ОбщегоНазначения.ОбщийМодуль("РасчетЗарплатыДляНебольшихОрганизацийСобытия");
			МодульРасчетЗарплатыДляНебольшихОрганизаций.ПриОтключенииНачисленияЗарплаты();
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли

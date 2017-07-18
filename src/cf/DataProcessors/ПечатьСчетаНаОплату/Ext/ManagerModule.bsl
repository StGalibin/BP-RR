﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетПокупателю") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетПокупателю", "Счет покупателю",
			ОбъектыПечати, ОбъектыПечати);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказ") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказ", "Счет на оплату",
			ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказСПечатью") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказСПечатью", "Счет на оплату (с печатью и подписями)",
			ОбъектыПечати, ПараметрыВывода, Истина);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказКомплект") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказКомплект", "Счет на оплату",
			ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказСПечатьюКомплект") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказСПечатьюКомплект", "Счет на оплату (с печатью и подписями)",
			ОбъектыПечати, ПараметрыВывода, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, ОбъектыПечати, ПараметрыВывода, СПечатью = Ложь)
	
	ТипыОбъектов = ОбщегоНазначенияБП.РазложитьСписокПоТипамОбъектов(МассивОбъектов);
	
	Для каждого ОбъектыТипа Из ТипыОбъектов Цикл
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыТипа.Значение[0]);
		
		ДокументыБезСчетовНаОплату = Неопределено;
		ТаблицаСведенийСчетНаОплату = МенеджерОбъекта.ПолучитьТаблицуСведенийСчетаНаОплату(ОбъектыТипа.Значение, ДокументыБезСчетовНаОплату);
		
		Если ЗначениеЗаполнено(ДокументыБезСчетовНаОплату) Тогда 
			Если ПараметрыПечати.Свойство("СокращенноеСообщениеОбОшибке") Тогда
				ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетовНаОплату, ПараметрыПечати.СокращенноеСообщениеОбОшибке);
			Иначе
				ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетовНаОплату);
			КонецЕсли;
		КонецЕсли;
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, 
			ПечатьТорговыхДокументов.ПечатьСчетаНаОплату(ТаблицаСведенийСчетНаОплату, ОбъектыПечати, СПечатью),,"ОбщийМакет.ПФ_MXL_СчетЗаказ");
		
	КонецЦикла;
	
	ПараметрыВывода.Вставить("ФормироватьЭД", Истина);
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов,
		КоллекцияПечатныхФорм,
		ОбъектыПечати,
		ПараметрыВывода);
	
КонецПроцедуры

Процедура ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетов, СокращенноеСообщениеОбОшибке = Ложь) Экспорт
	
	Если СокращенноеСообщениеОбОшибке Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "ЗАПОЛНЕНИЕ", НСтр("ru = 'Счет на оплату'"));
		Для каждого Реализация Из ДокументыБезСчетов Цикл 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, 
				Реализация,
				"СчетНаОплатуПокупателю",
				"Объект");
		КонецЦикла;
	Иначе
		Для каждого Реализация Из ДокументыБезСчетов Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 не указан счет на оплату'"), Реализация); 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, 
				Реализация);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
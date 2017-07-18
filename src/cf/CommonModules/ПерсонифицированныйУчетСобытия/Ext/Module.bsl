﻿
#Область СлужебныеПроцедурыИФункции

// Обработчики событий документов перс. учета.

Процедура ДокументыПерсУчетаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДанныхДокумента = Новый Структура;
	СтруктураДанныхДокумента.Вставить("Номер", Источник.Номер);
	
	Источник.ОкончаниеОтчетногоПериода = Источник.ОкончаниеОтчетногоПериода();
	РегистрационныйНомерПФР = ПерсонифицированныйУчет.РегистрационныйНомерПФР(Источник.Организация, Источник.ОкончаниеОтчетногоПериода);
	СтруктураДанныхДокумента.Вставить("РегистрационныйНомерПФР", РегистрационныйНомерПФР);
	
	Если Не Источник.ПометкаУдаления Тогда
		ПерсонифицированныйУчет.ПроставитьНомерПачки(Источник);
	КонецЕсли;
	СтруктураДанныхДокумента.Вставить("НомерПачки", Источник.НомерПачки);
	
	ГодДокумента = Год(Источник.ОкончаниеОтчетногоПериода);
	
	Источник.ИмяФайлаДляПФР =  ПерсонифицированныйУчет.ПолучитьИмяФайлаПФ(Источник.Ссылка, ГодДокумента, СтруктураДанныхДокумента);
	
	СтруктураОбъекта = Новый Структура("ОтчетныйПериод");
	ЗаполнитьЗначенияСвойств(СтруктураОбъекта, Источник);
	
	Если СтруктураОбъекта.ОтчетныйПериод <> Неопределено И (Не ЗначениеЗаполнено(СтруктураОбъекта.ОтчетныйПериод)) И (Не Источник.ПометкаУдаления) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено значение поля отчетный период'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Источник, , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДокументыПерсУчетаПриКопировании(Источник, ОбъектКопирования) Экспорт
	
	Источник.НомерПачки = 0;
	Источник.ИмяФайлаДляПФР = "";
	Источник.ДокументПринятВПФР = Ложь;
	Источник.ФайлСформирован = Ложь;
	
КонецПроцедуры

Процедура ДокументыПерсУчетаПриЗаписи(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяДокумента = Источник.Метаданные().Имя;
	
	Если Не Источник.ПометкаУдаления Тогда
		Документы[ИмяДокумента].ОбработкаФормированияФайла(Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

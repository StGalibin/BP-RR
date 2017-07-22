﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		ВалютаДокумента = ДанныеЗаполнения.ВалютаВзаиморасчетов;
		Грузополучатель = ДанныеЗаполнения.Владелец;
		Контрагент = ДанныеЗаполнения.Владелец;
		ДолжностьРуководителя = ДанныеЗаполнения.ДолжностьРуководителя;
		ДолжностьРуководителяКонтрагента = ДанныеЗаполнения.ДолжностьРуководителяКонтрагента;
		ЗаРуководителяКонтрагентаПоПриказу = ДанныеЗаполнения.ЗаРуководителяКонтрагентаПоПриказу;
		ЗаРуководителяПоПриказу = ДанныеЗаполнения.ЗаРуководителяПоПриказу;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Организация = ДанныеЗаполнения.Организация;
		ПолРуководителяКонтрагента = ДанныеЗаполнения.ПолРуководителяКонтрагента;
		Руководитель = ДанныеЗаполнения.Руководитель;
		РуководительКонтрагента = ДанныеЗаполнения.РуководительКонтрагента;
		ДоговорКонтрагента = ДанныеЗаполнения.Ссылка;
		ТипЦен = ДанныеЗаполнения.ТипЦен;
		СуммаВключаетНДС = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.СпецификацииДоговоров.Записывать = Истина;
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.СпецификацииДоговоров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номеклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Спецификация = Ссылка;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Цена = ТекСтрокаТовары.Цена;
	КонецЦикла;

	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)


	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
СуммаДокумента = Товары.Итог("Сумма");

Если не ЗначениеЗаполнено(ВалютаДокумента) Тогда
	ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
КонецЕсли;

ЭтоНоваяСпецификация = ЭтоНовый();

Если ЭтоНоваяСпецификация Тогда

НоваяСпецификацияСсылка = Документы.СпецификацияКДоговору.ПолучитьСсылку(Новый УникальныйИдентификатор);
ЭтотОбъект.УстановитьСсылкуНового(НоваяСпецификацияСсылка);
КонецЕсли;

РегистрыСведений.НумерацияСпецификацийДоговоров.УстановитьНомерСпецификации (ЭтотОбъект, ЭтоНоваяСпецификация, Отказ);


КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
РегистрыСведений.СтатусыСпецификаций.УдалитьЗапись (Ссылка, Отказ);
РегистрыСведений.НумерацияСпецификацийДоговоров.УдалитьЗапись (Ссылка, Отказ);
	
КонецПроцедуры







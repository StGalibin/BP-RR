﻿#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьНавигационнуюСсылку(НавигационнаяСсылка, СтандартнаяОбработка) Экспорт
	
	ЭтоПереходКШагу = Ложь;
	Для НомерТекущегоШага = 1 По 5 Цикл
		Если НавигационнаяСсылка = ИмяШага(НомерТекущегоШага) Тогда
			ЭтоПереходКШагу = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЭтоПереходКШагу Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьЭтап(НомерТекущегоШага);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьЭтап(НомерТекущегоШага) Экспорт
	
	СтруктураШага = РегистрацияОрганизацииВызовСервера.СтруктураШага(НомерТекущегоШага);
	Если СтруктураШага = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ПолучитьФорму(
		СтруктураШага.ИмяФормы,
		СтруктураШага.СтруктураПараметровФормы,
		,
		Ложь);
		
	Если Форма.Открыта() Тогда
		// Если форма уже открыта, то передадим ей новый параметр навигации.
		Оповестить("ИзменитьПараметрНавигации", СтруктураШага.СтруктураПараметровФормы.НавигацияПараметрФормы);
		Форма.Активизировать();
	Иначе
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОповеститьОбОткрытии(Форма, ИмяПомощника, НомерШага) Экспорт
	
	Оповестить("ОткрытШагПомощника_РегистрацияОрганизации",
		Новый Структура("ИмяПомощника, НомерШага", ИмяПомощника, НомерШага),
		Форма);
	
КонецПроцедуры

Функция ИмяШага(НомерШага)

	Возврат "Шаг" + НомерШага;

КонецФункции

Функция ОткрытьФормуУчредителя(Элемент, ТекущиеДанные) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Ссылка);
	Иначе
		ПараметрыФормы.Вставить("ТекстЗаполнения", ТекущиеДанные.Наименование);
	КонецЕсли;
	
	Если ТекущиеДанные.ТипУчредителя = ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ЮридическоеФизическоеЛицо", ПредопределенноеЗначение("Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо"));
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ИмяФормы = "Обработка.РегистрацияОрганизации.Форма.ФормаЮридическогоЛица";
	Иначе
		ИмяФормы = "Обработка.РегистрацияОрганизации.Форма.ФормаФизическогоЛица";
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, Элемент);
	
КонецФункции

#КонецОбласти

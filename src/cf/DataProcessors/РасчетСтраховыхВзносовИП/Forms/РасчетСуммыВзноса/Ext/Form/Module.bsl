﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяВзноса = Параметры.ИмяВзноса;
	Всего     = Параметры.Всего;
	Уплачено  = Параметры.Уплачено;
	Сумма     = Параметры.Сумма;
	
	ТаблицаПлатежей = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыПлатежей);
	Если ТипЗнч(ТаблицаПлатежей) = Тип("ТаблицаЗначений") Тогда
		Платежи.Загрузить(ТаблицаПлатежей);
	КонецЕсли;
	
	РасчетСтраховыхВзносовИПФормы.ОтобразитьПлатежи(ЭтотОбъект, Платежи, "ДекорацияПлатеж");
	
	Заголовок = Параметры.Заголовок;
	
	Элементы.Сумма.Заголовок   = ?(Параметры.ЧастичнаяОплата,
		НСтр("ru = 'К уплате сейчас'"),
		НСтр("ru = 'Сумма к уплате'"));
	
	Элементы.Остаток.Видимость = Параметры.ЧастичнаяОплата;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОповеститьОВыбореИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ДекорацияПлатежНажатие(Элемент)
	
	РасчетСтраховыхВзносовИПФормыКлиент.ПлатежНажатие(Элемент.Имя, Платежи, "ДекорацияПлатеж");
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыбореИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Остаток = Форма.Всего - Форма.Уплачено - Форма.Сумма;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореИЗакрыть()
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(Новый Структура(ИмяВзноса, Сумма));
	
КонецПроцедуры

#КонецОбласти
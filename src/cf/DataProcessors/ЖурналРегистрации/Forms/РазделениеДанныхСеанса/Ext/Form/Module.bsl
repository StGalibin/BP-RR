﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТесты") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановленныйОтбор = Параметры.УстановленныйОтбор;
	РазделениеДанныхСоответствие = Новый Соответствие;
	Если УстановленныйОтбор.Количество() > 0 Тогда
		
		Для Каждого РазделительСеанса Из УстановленныйОтбор Цикл
			РазделениеДанныхМассив = СтрРазделить(РазделительСеанса.Значение, "=", Ложь);
			РазделениеДанныхСоответствие.Вставить(РазделениеДанныхМассив[0], РазделениеДанныхМассив[1]);
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
		СтрокаТаблицы = РазделениеДанныхСеанса.Добавить();
		СтрокаТаблицы.Разделитель = ОбщийРеквизит.Имя;
		СтрокаТаблицы.ПредставлениеРазделителя = ОбщийРеквизит.Синоним;
		ЗначениеРазделителя = РазделениеДанныхСоответствие[ОбщийРеквизит.Имя];
		Если ЗначениеРазделителя <> Неопределено Тогда
			СтрокаТаблицы.Флажок = Истина;
			СтрокаТаблицы.ЗначениеРазделителя = РазделениеДанныхСоответствие[ОбщийРеквизит.Имя];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОк(Команда)
	Результат = Новый СписокЗначений;
	Для Каждого СтрокаТаблицы Из РазделениеДанныхСеанса Цикл
		Если СтрокаТаблицы.Флажок Тогда
			ЗначениеРазделителя = СтрокаТаблицы.Разделитель + "=" + СтрокаТаблицы.ЗначениеРазделителя;
			ПредставлениеРазделителя = СтрокаТаблицы.ПредставлениеРазделителя + " = " + СтрокаТаблицы.ЗначениеРазделителя;
			Результат.Добавить(ЗначениеРазделителя, ПредставлениеРазделителя);
		КонецЕсли;
	КонецЦикла;
	
	Оповестить("ВыборЗначенийЭлементовОтбораЖурналаРегистрации",
		Результат,
		ВладелецФормы);
	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	Для Каждого ЭлементСписка Из РазделениеДанныхСеанса Цикл
		ЭлементСписка.Флажок = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого ЭлементСписка Из РазделениеДанныхСеанса Цикл
		ЭлементСписка.Флажок = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти
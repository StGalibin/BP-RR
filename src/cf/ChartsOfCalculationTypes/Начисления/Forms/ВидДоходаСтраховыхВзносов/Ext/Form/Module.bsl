﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "КодДоходаСтраховыеВзносы2017,КодДоходаСтраховыеВзносы");
	ЭтаФорма.Элементы.КодДоходаСтраховыеВзносы2017.ПараметрыВыбора = Параметры.ПараметрыВыбора;
	ЭтаФорма.Элементы.КодДоходаСтраховыеВзносы.ПараметрыВыбора = Параметры.ПараметрыВыбора;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Если Модифицированность Тогда
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("КодДоходаСтраховыеВзносы2017", КодДоходаСтраховыеВзносы2017);
		ПараметрыОповещения.Вставить("КодДоходаСтраховыеВзносы", КодДоходаСтраховыеВзносы);
		
		Оповестить("ИзмененыВидыДоходаСтраховыхВзносов", ПараметрыОповещения, ВладелецФормы);
		
	КонецЕсли;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти



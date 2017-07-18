﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ДанныеЭЛН);
	
	АвтоЗаголовок = Ложь;
	УстановитьЗаголовок();
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод1);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод2);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод3);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЛистокНетрудоспособностиПриИзменении(Элемент)
	ЗаполнитьДанныеЛисткаНетрудоспособности(ЛистокНетрудоспособности);
КонецПроцедуры

&НаКлиенте
Процедура НомерЛисткаНетрудоспособностиПриИзменении(Элемент)
	УстановитьЗаголовок();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Закрыть(РезультатВыбора());
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	Если Не ЗначениеЗаполнено(ЛистокНетрудоспособности) Тогда
		Заголовок = НСтр("ru = 'Выберите листок нетрудоспособности'");
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИнформацияОДокументе.Номер) Тогда
		ШаблонЗаголовка = НСтр("ru = 'Сведения о листке нетрудоспособности %1 из реестра %2 от %3'");
	Иначе
		ШаблонЗаголовка = НСтр("ru = 'Сведения о листке нетрудоспособности %1 из реестра от %3'");
	КонецЕсли;
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонЗаголовка,
		НомерЛисткаНетрудоспособности,
		Параметры.ИнформацияОДокументе.Номер,
		Формат(Параметры.ИнформацияОДокументе.Дата, "ДЛФ=D"));
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	ЗначенияРеквизитов = Новый Структура;
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = "Объект" Тогда
			Продолжить;
		КонецЕсли;
		ЗначенияРеквизитов.Вставить(РеквизитФормы.Имя, ЭтотОбъект[РеквизитФормы.Имя]);
	КонецЦикла;
	
	Возврат ЗначенияРеквизитов;
КонецФункции

&НаСервере
Процедура ЗаполнитьДанныеЛисткаНетрудоспособности(ЛистокНетрудоспособности)
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для каждого РеквизитФормы Из РеквизитыФормы Цикл
		Если РеквизитФормы.Имя = "Объект"
			Или РеквизитФормы.Имя = "НомерСтроки" Тогда
			Продолжить;
		КонецЕсли;
		ЭтотОбъект[РеквизитФормы.Имя] = Неопределено;
	КонецЦикла;
	
	ТаблицаЗначений = Документы.БольничныйЛист.ДанныеДляРеестраЭЛН(ЛистокНетрудоспособности);
	Если ТаблицаЗначений.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТаблицаЗначений[0]);
	КонецЕсли;
	
	УстановитьЗаголовок();
КонецПроцедуры

#КонецОбласти

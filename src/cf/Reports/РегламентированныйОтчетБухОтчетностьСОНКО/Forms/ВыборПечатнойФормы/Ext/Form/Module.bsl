﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыПечати = Параметры.ПараметрыПечати;
	
	// Настройки по умолчанию.
	НастройкиВФорме = Новый Структура;
	НастройкиВФорме.Вставить("АктивныйПункт", 1);
	НастройкиВФорме.Вставить("ДоступенПункт1", Истина);
	НастройкиВФорме.Вставить("ДоступенПункт2", Истина);
	НастройкиВФорме.Вставить("ДоступенПункт3", Истина);
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", Истина);
	
	Если ТипЗнч(ПараметрыПечати) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(НастройкиВФорме, ПараметрыПечати);
	КонецЕсли;
	
	ДоступныеПункты = Новый Массив;
	Если НастройкиВФорме.ДоступенПункт1 Тогда
		ДоступныеПункты.Добавить(1);
	КонецЕсли;
	Если НастройкиВФорме.ДоступенПункт2 Тогда
		ДоступныеПункты.Добавить(2);
	КонецЕсли;
	Если НастройкиВФорме.ДоступенПункт3 Тогда
		ДоступныеПункты.Добавить(3);
	КонецЕсли;
	
	ИндексДоступногоПункта = ДоступныеПункты.Найти(НастройкиВФорме.АктивныйПункт);
	Если ИндексДоступногоПункта = Неопределено Тогда
		ИндексДоступногоПункта = 0;
	КонецЕсли;
	Переключатель1 = ДоступныеПункты[ИндексДоступногоПункта];
	
	Элементы.Переключатель1.Доступность = НастройкиВФорме.ДоступенПункт1;
	Элементы.Переключатель2.Доступность = НастройкиВФорме.ДоступенПункт2;
	Элементы.Переключатель3.Доступность = НастройкиВФорме.ДоступенПункт3;
	
	ВыводитьКолонкуСКодамиСтрок = НастройкиВФорме.ВключатьКодыСтрок;
	УстановитьДоступностьВключенияКодов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьВключенияКодов(Форма)
	
	Форма.Элементы.ВыводитьКолонкуСКодамиСтрок.Доступность = (Форма.Переключатель1 = 2);
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель1ПриИзменении(Элемент)
	
	УстановитьДоступностьВключенияКодов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель2ПриИзменении(Элемент)
	
	УстановитьДоступностьВключенияКодов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Переключатель3ПриИзменении(Элемент)
	
	УстановитьДоступностьВключенияКодов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБланк(Команда)
	
	НастройкиВФорме.Вставить("ВключатьКодыСтрок", ВыводитьКолонкуСКодамиСтрок);
	НастройкиВФорме.Вставить("АктивныйПункт", Переключатель1);
	НастройкиВФорме.Вставить("Команда", Команда.Имя);
	ЭтаФорма.Закрыть(НастройкиВФорме);
	
КонецПроцедуры

#КонецОбласти
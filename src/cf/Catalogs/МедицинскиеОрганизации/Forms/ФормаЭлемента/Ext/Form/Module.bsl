﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("АдресТолькоРоссийский",        Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных.
		// Сбрасываем как представления, 
		// так и внутренние значения полей
		Объект.Адрес = "";
		Объект.АдресВнутреннееПредставление = "";
		Возврат;
	КонецЕсли;

	// Формируем внутренние значения полей по тексту 
	// и параметрам
	Объект.Адрес = Текст;
	Объект.АдресВнутреннееПредставление = ЗначенияПолейКонтактнойИнформацииСервер(Текст, ВидКонтактнойИнформацииАдреса);
	
	ЗаполнитьКодКЛАДРНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата
	// кнопка выбора, то необходимо привести данные в соответствие
	// и сбросить внутренние поля для повторного репарсинга
	Если Элемент.ТекстРедактирования <> Объект.Адрес Тогда
		Объект.Адрес = Элемент.ТекстРедактирования;
		Объект.АдресВнутреннееПредставление = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", Объект.АдресВнутреннееПредставление);
	ПараметрыОткрытия.Вставить("Представление", Объект.Адрес);
		
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес медицинской организации'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура АдресОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.Адрес = "";
	Объект.АдресВнутреннееПредставление = "";
	Объект.АдресКодПоКЛАДР = "";

КонецПроцедуры

&НаКлиенте
Процедура АдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны
		Возврат;
	КонецЕсли;
	
	Объект.Адрес = ВыбранноеЗначение.Представление;
	Объект.АдресВнутреннееПредставление = ВыбранноеЗначение.КонтактнаяИнформация;
	
	ЗаполнитьКодКЛАДРНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьКодКЛАДРНаСервере()

	ОписаниеАдреса = УчетПособийСоциальногоСтрахования.ОписаниеАдреса(Объект.АдресВнутреннееПредставление, ВидКонтактнойИнформацииАдреса);
		
	Объект.АдресКодПоКЛАДР = Формат(ОписаниеАдреса.КодКЛАДР, "ЧГ=0");
	
КонецПроцедуры
	
#КонецОбласти





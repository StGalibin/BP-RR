﻿&НаКлиенте
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ОрганизацияСсылка) Тогда
		
		ЗаписьПоОрганизации = РегистрыСведений.НастройкиОбменаФСРАР.СоздатьМенеджерЗаписи();
		ЗаписьПоОрганизации.Организация = Параметры.ОрганизацияСсылка;
		ЗаписьПоОрганизации.Прочитать();
		
		Если ЗначениеЗаполнено(ЗаписьПоОрганизации.Организация) Тогда
			ЗначениеВДанныеФормы(ЗаписьПоОрганизации, Запись);
		Иначе
			Запись.Организация = Параметры.ОрганизацияСсылка;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораРегионовРФ();
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = ЭлектроннаяПодписьВМоделиСервисаБРОВызовСервера.ЭтоЭлектроннаяПодписьВМоделиСервиса(Запись.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "НадписьОрганизация");
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатАбонентаОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
		
КонецПроцедуры

&НаКлиенте
Процедура СертификатСубъектаРФПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатСубъектаРФОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФСРАРПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КриптографияЭДКОКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		Запись.СертификатФСРАРОтпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатАбонентаОтпечаток = "";
	СертификатАбонентаПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатАбонентаОтпечаток,
		ЭтотОбъект,
		"СертификатАбонентаПредставление");
		
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФСРАРПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатФСРАРОтпечаток = "";
	СертификатФСРАРПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатФСРАРОтпечаток,
		ЭтотОбъект,
		"СертификатФСРАРПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСубъектаРФПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Запись.СертификатСубъектаРФОтпечаток = "";
	СертификатСубъектаРФПредставление = "";
	
	КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
		ЭтоЭлектроннаяПодписьВМоделиСервиса,
		Элемент,
		Запись.СертификатСубъектаРФОтпечаток,
		ЭтотОбъект,
		"СертификатСубъектаРФПредставление");
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатАбонентаПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатАбонентаОтпечаток, "My");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСубъектаРФПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатСубъектаРФПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатСубъектаРФОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФСРАРПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения(
		"СертификатФСРАРПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	КриптографияЭДКОКлиент.ВыбратьСертификат(
		Оповещение, ЭтоЭлектроннаяПодписьВМоделиСервиса, Запись.СертификатФСРАРОтпечаток, "AddressBook");
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменПриИзменении(Элемент)
	
	ОбновитьДоступностьИАвтоОтметкуЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	ОбновитьДоступностьИАвтоОтметкуЭлементов();
	
	КонтекстЭДО.УправлениеОтображениемОрганизации(ЭтаФорма, Запись.Организация);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатАбонентаПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатАбонентаОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатАбонентаПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатСубъектаРФПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатСубъектаРФОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатСубъектаРФПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатФСРАРПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								Запись.СертификатФСРАРОтпечаток);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатФСРАРПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	КриптографияЭДКОКлиент.ОтобразитьПредставленияСертификатов(ПараметрыОтображенияСертификатов, ЭтотОбъект, ЭтоЭлектроннаяПодписьВМоделиСервиса);
	
КонецПроцедуры
	
&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатАбонентаОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатАбонентаПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатСубъектаРФПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатСубъектаРФОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса, 
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатСубъектаРФПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатФСРАРПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		Запись.СертификатФСРАРОтпечаток = Результат.ВыбранноеЗначение.Отпечаток;
		
		КриптографияЭДКОКлиент.ОтобразитьПредставлениеСертификата(
			ЭтоЭлектроннаяПодписьВМоделиСервиса,
			Элемент, 
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект, 
			"СертификатФСРАРПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьИАвтоОтметкуЭлементов()
	
	Элементы.НадписьСертификатАбонента.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатАбонентаПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатСубъектаРФ.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатСубъектаРФПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьСертификатФСРАР.Доступность = Запись.ИспользоватьОбмен;
	Элементы.СертификатФСРАРПредставление.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьКодРегиона.Доступность = Запись.ИспользоватьОбмен;
	Элементы.КодРегиона.Доступность = Запись.ИспользоватьОбмен;
	Элементы.НадписьАвтонастройка.Доступность = Запись.ИспользоватьОбмен;
	Элементы.ИспользоватьАвтонастройку.Доступность = Запись.ИспользоватьОбмен;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораРегионовРФ()
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	МакетРегионов = КонтекстЭДО.ПолучитьМакет("ФСРАРПорталыРегионов");
	
	Для НомСтр = 1 По МакетРегионов.ВысотаТаблицы Цикл
		
		КодРегиона = СокрЛП(МакетРегионов.Область(НомСтр, 1, НомСтр, 1).Текст);
		НазваниеРегиона = СокрЛП(МакетРегионов.Область(НомСтр, 2, НомСтр, 2).Текст);
		
		Если ЗначениеЗаполнено(КодРегиона) Тогда
			Элементы.КодРегиона.СписокВыбора.Добавить(КодРегиона, КодРегиона + " - " + НазваниеРегиона);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ИзменениеНастроекЭДООрганизации", Запись.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Элементы.ГруппаАвтонастройка.Видимость = (КонтекстЭДОСервер <> Неопределено И КонтекстЭДОСервер.ЕстьВозможностьАвтонастройкиВУниверсальномФормате(Запись.Организация));
	
КонецПроцедуры

#КонецОбласти


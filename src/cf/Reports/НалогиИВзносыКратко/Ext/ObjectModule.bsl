﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ложь;
	ДокументРезультат.Очистить();
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, , , Тип("ГенераторМакетаКомпоновкиДанных"));
		
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
КонецПроцедуры

Процедура УстановитьПараметрыВыводаТабличногоДокумента(ДокументРезультат)
	ДокументРезультат.Автомасштаб 			= 	Истина;
	ДокументРезультат.ОриентацияСтраницы 	= 	ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ТолькоПросмотр		= 	Истина;
	ДокументРезультат.ПолеСверху			= 	5;
	ДокументРезультат.ПолеСнизу				= 	0;
	ДокументРезультат.ПолеСлева				= 	10;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
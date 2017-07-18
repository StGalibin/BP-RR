﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак нужно ли при получение данных,
// дополнять код классификатора символами слева.
// Возвращаемое значение:
// Булево - Истина - Дополнять; ложь - не дополнять.
//
Функция ДополнятьКодПриЧтенииДанныхКлассификатора() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Заполняет свойства предопределенных даных справочника.
//
Процедура ЗаполнитьПредопределенныеДанные() Экспорт
	
	// Получим у БРО данные заполнения
	ПараметрыКлассификатора = ИнтерфейсыВзаимодействияБРО.ПолучитьРасположениеКлассификатораСтатистики("КлассификаторПродукцииПоВидамДеятельности");
	ОбластьИсточникДанных 	= ПараметрыКлассификатора.ОбластьИсточникДанных;
	ОтчетИсточникДанных 	= ПараметрыКлассификатора.ОтчетИсточникДанных;
	СписокВерсий 			= ИнтерфейсыВзаимодействияБРО.ПолучитьВерсииСписковОтчета(ОтчетИсточникДанных);
	Если СписокВерсий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМакетаСписков = СписокВерсий[СписокВерсий.Количество() - 1].Значение;
	
	//Получаем полную таблицу элементов классификатора
	// в таблице содержатся Код и Наименование, элементов классификатора.
	ДанныеКлассификатора = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
		ОтчетИсточникДанных, 
		ИмяМакетаСписков, 
		ОбластьИсточникДанных,
		ДополнятьКодПриЧтенииДанныхКлассификатора(),
		Метаданные.Справочники.КлассификаторПродукцииПоВидамДеятельности.ДлинаКода);
		
	// Для разных назначений разные наборы единиц измерения.
	ОбластьЕдиницаИзмерения = Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяОбластиЕдиницаИзмерения(Перечисления.ВидыСвободныхСтрокФормСтатистики.ВидыПродукцииРозница);
	Если ОбластьЕдиницаИзмерения <> Неопределено Тогда 
		
		ЕдиницыИзмеренияРозница = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
			ОтчетИсточникДанных, 
			ИмяМакетаСписков, 
			ОбластьЕдиницаИзмерения);
			
		Если ЕдиницыИзмеренияРозница.Колонки.Найти("okp") = Неопределено Тогда
			ЕдиницыИзмеренияРозница = Неопределено;
		КонецЕсли;
			
	Иначе
		
		ЕдиницыИзмеренияРозница = Неопределено;
			
	КонецЕсли;
		
	// Заполним реквизиты предопределенного элемента данными классификатора.
	Объект = РозницаВсего.ПолучитьОбъект();
	Объект.ВидСвободныхСтрокФормСтатистики = Перечисления.ВидыСвободныхСтрокФормСтатистики.ВидыПродукцииРозница;
	
	ДанныеЭлементаКлассификатора = ДанныеКлассификатора.Найти(Объект.Код, "Код");
	Если ДанныеЭлементаКлассификатора = Неопределено Тогда
		Возврат;
	КонецЕслИ;
	
	ОписаниеЕдиницыИзмерения = ЕдиницыИзмеренияРозница.Найти(ДанныеЭлементаКлассификатора.Код, "okp");
	Если ОписаниеЕдиницыИзмерения <> Неопределено Тогда
		
		КодЕдиницыИзмерения          = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(ОписаниеЕдиницыИзмерения.Код, 3);
		НаименованиеЕдиницыИзмерения = ОписаниеЕдиницыИзмерения.Наименование;
		
		Объект.ЕдиницаСтатистическогоУчета = ЗаполнениеФормСтатистикиПереопределяемый.ЕдиницаИзмеренияПоКоду(
			КодЕдиницыИзмерения, 
			НаименованиеЕдиницыИзмерения);
		
	КонецЕсли;
	
	Объект.НаименованиеПолное = ДанныеЭлементаКлассификатора.Наименование;
	Объект.Наименование       = ДанныеЭлементаКлассификатора.Наименование;
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДанныеКлассификатора") И Параметры.ДанныеКлассификатора Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяФорма = "ОбщаяФорма.ДобавлениеЭлементовВКлассификатор";
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
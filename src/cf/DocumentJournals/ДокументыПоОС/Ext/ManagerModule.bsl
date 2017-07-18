﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов ""Документы по ОС""'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура;
	
	Если Метаданные.Документы.Найти("АвизоОСИсходящее") = Неопределено 
		ИЛИ Метаданные.Документы.Найти("АвизоОСВходящее") = Неопределено Тогда
		
		ПолеЗапросаИнфо =
		"	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ИнвентаризацияОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ИнвентаризацияОС).ПричинаПроведенияИнвентаризации
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПередачаОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ПередачаОС).Контрагент
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПринятиеКУчетуОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ПринятиеКУчетуОС).ВидОперации
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.МодернизацияОС) ИЛИ ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПередачаОборудованияВМонтаж)
		|			ТОГДА Таб.ОбъектСтроительства
		|		ИНАЧЕ Таб.СобытиеОС
		|	КОНЕЦ";
		
	Иначе
		
		ПолеЗапросаИнфо =
		"	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.АвизоОСИсходящее)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.АвизоОСИсходящее).ОрганизацияПолучатель
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.АвизоОСВходящее)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.АвизоОСВходящее).ОрганизацияОтправитель
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ИнвентаризацияОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ИнвентаризацияОС).ПричинаПроведенияИнвентаризации
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПередачаОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ПередачаОС).Контрагент
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПринятиеКУчетуОС)
		|			ТОГДА ВЫРАЗИТЬ(Таб.Ссылка КАК Документ.ПринятиеКУчетуОС).ВидОперации
		|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.МодернизацияОС) ИЛИ ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПередачаОборудованияВМонтаж)
		|			ТОГДА Таб.ОбъектСтроительства
		|		ИНАЧЕ Таб.СобытиеОС
		|	КОНЕЦ";
		
	КонецЕсли;
	
	ПолеЗапросаСумма =
	"	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Таб.Ссылка) = ТИП(Документ.ПередачаОС)
	|			ТОГДА Таб.Ссылка.СуммаДокумента
	|		ИНАЧЕ """"
	|	КОНЕЦ";
	
	Результат.Вставить("Информация",     ПолеЗапросаИнфо);
	Результат.Вставить("СуммаДокумента", ПолеЗапросаСумма);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
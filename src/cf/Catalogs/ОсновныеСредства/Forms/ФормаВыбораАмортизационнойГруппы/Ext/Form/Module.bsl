﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапросПустогоОКОФ = Новый Запрос;
	ЗапросПустогоОКОФ.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОКОФ.Ссылка
		|ИЗ
		|	Справочник.ОбщероссийскийКлассификаторОсновныхФондов КАК ОКОФ";
		
		
	Если ЗапросПустогоОКОФ.Выполнить().Пустой() Тогда
		Элементы.ПеренестиВСправочник.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ИерархияОКОФ.ТекущаяСтрока = Параметры.КодПоОКОФ;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияОКОФ

&НаКлиенте
Процедура ИерархияОКОФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗакрытьСВыбраннымРезультатом();
	СтандартнаяОбработка = Ложь; 

КонецПроцедуры

&НаКлиенте
Процедура ИерархияОКОФПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ИерархияОКОФ.ТекущиеДанные;
	АмортизационныеГруппы.Очистить();
	
	Если ТекущиеДанные <> Неопределено Тогда
		ЗаполнитьАмортизационныеГруппы(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАмортизационныеГруппы

&НаКлиенте
Процедура АмортизационныеГруппыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗакрытьСВыбраннымРезультатом();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиОКОФиАмортизационнуюГруппу(Команда)

	ЗакрытьСВыбраннымРезультатом();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьСВыбраннымРезультатом()
	
	ТекущийКодПоОКОФ = Элементы.ИерархияОКОФ.ТекущиеДанные;
	Если ТекущийКодПоОКОФ <> Неопределено Тогда
		ОКОФ = ТекущийКодПоОКОФ.Ссылка;
	Иначе
		ОКОФ = ПредопределенноеЗначение("Справочник.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка");
	КонецЕсли;
	
	ТекущаяАмортизационнаяГруппа = Элементы.АмортизационныеГруппы.ТекущиеДанные;
	Если ТекущаяАмортизационнаяГруппа <> Неопределено Тогда
		АмортизационнаяГруппа = ТекущаяАмортизационнаяГруппа.АмортизационнаяГруппа;
	Иначе
		АмортизационнаяГруппа = ПредопределенноеЗначение("Перечисление.АмортизационныеГруппы.ПустаяСсылка");
	КонецЕсли;
	
	ПараметрЗакрытия = Новый Структура("ОКОФ, АмортизационнаяГруппа", ОКОФ, АмортизационнаяГруппа);
										
	Оповестить("ВыборАмортизационнойГруппыОС", ПараметрЗакрытия, ВладелецФормы.УникальныйИдентификатор);
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАмортизационныеГруппы(ОКОФ)
	
	Если Не ЗначениеЗаполнено(ОКОФ) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОбщероссийскийКлассификаторОсновныхФондов.Ссылка КАК Ссылка,
	|	0 КАК УровеньГруппировки
	|ИЗ
	|	Справочник.ОбщероссийскийКлассификаторОсновныхФондов КАК ОбщероссийскийКлассификаторОсновныхФондов
	|ГДЕ
	|	ОбщероссийскийКлассификаторОсновныхФондов.Ссылка = &ОКОФ
	|ИТОГИ
	|	СУММА(УровеньГруппировки)
	|ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ");
	
	Запрос.УстановитьПараметр("ОКОФ", ОКОФ);
	
	Родители = Запрос.Выполнить().Выгрузить();
	
	Для Инд = 0 По Родители.Количество() - 1 Цикл
		
		Родители[Инд].УровеньГруппировки = Родители.Количество() - Инд;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("СписокОКОФ", Родители);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокОКОФ.Ссылка КАК Ссылка,
	|	СписокОКОФ.УровеньГруппировки
	|ПОМЕСТИТЬ СписокОКОФ
	|ИЗ
	|	&СписокОКОФ КАК СписокОКОФ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АмортизационныеГруппыОКОФ.ОКОФ,
	|	АмортизационныеГруппыОКОФ.АмортизационнаяГруппа КАК АмортизационнаяГруппа,
	|	АмортизационныеГруппыОКОФ.Примечание КАК Комментарий,
	|	СписокОКОФ.УровеньГруппировки КАК УровеньГруппировки
	|ИЗ
	|	РегистрСведений.АмортизационныеГруппыОКОФ КАК АмортизационныеГруппыОКОФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ СписокОКОФ КАК СписокОКОФ
	|		ПО АмортизационныеГруппыОКОФ.ОКОФ = СписокОКОФ.Ссылка
	|ГДЕ
	|	АмортизационныеГруппыОКОФ.ОКОФ В
	|			(ВЫБРАТЬ
	|				СписокОКОФ.Ссылка
	|			ИЗ
	|				СписокОКОФ КАК СписокОКОФ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	УровеньГруппировки,
	|	АмортизационныеГруппыОКОФ.АмортизационнаяГруппа.Порядок
	|ИТОГИ ПО
	|	УровеньГруппировки" ;
		
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
	Пока Выборка.Следующий() Цикл
		
		ВыборкаАмортизационныхГрупп = Выборка.Выбрать();
		
		Если ВыборкаАмортизационныхГрупп.Количество() > 0 Тогда
			
			Пока ВыборкаАмортизационныхГрупп.Следующий() Цикл
				
				НоваяСтрока = АмортизационныеГруппы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаАмортизационныхГрупп);
				
			КонецЦикла;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если АмортизационныеГруппы.Количество() = 0 Тогда
		
		Для Каждого АмортизационнаяГруппа Из Перечисления.АмортизационныеГруппы Цикл
			НоваяСтрока = АмортизационныеГруппы.Добавить();
			НоваяСтрока.АмортизационнаяГруппа = АмортизационнаяГруппа;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

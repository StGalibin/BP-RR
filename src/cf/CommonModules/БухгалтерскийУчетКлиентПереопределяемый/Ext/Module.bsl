﻿
///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ВЫБОРА ЗНАЧЕНИЙ ПЕРЕОПРЕДЕЛЯЕМЫХ ТИПОВ

//Открывает форму для выбора значения договора с установленными отборами
//
Процедура ОткрытьФормуВыбораДоговора(ПараметрыФормы, Элемент, ФормаВыбора = "ФормаВыбора") Экспорт
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов." + ФормаВыбора, ПараметрыФормы, Элемент);
	
КонецПроцедуры

//Открывает форму для выбора значения банковского счета с установленными отборами
//
Процедура ОткрытьФормуВыбораБанковскогоСчетОрганизации(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

//Открывает форму для выбора значения подразделениям с установленными отборами
//
Процедура ОткрытьФормуВыбораПодразделения(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

Процедура ОткрытьСчетФактуру(Форма, СчетФактура, ВидСчетаФактуры) Экспорт

	УчетНДСКлиент.ОткрытьСчетФактуру(Форма, СчетФактура, ВидСчетаФактуры);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// АКТУАЛИЗАЦИЯ ДАННЫХ

// Формирует список имен реквизитов формы отчета, содержащих идентификаторы фоновых заданий,
// которые нужно отменить при закрытии отчета.
//
Функция ЗаданияОтменяемыеПриЗакрытииОтчета() Экспорт
	
	ОтменяемыеЗадания = Новый Массив;
	ОтменяемыеЗадания.Добавить("ИдентификаторЗадания");
	ОтменяемыеЗадания.Добавить("ИдентификаторЗаданияАктуализации");
	
	Возврат ОтменяемыеЗадания;
	
КонецФункции

Процедура ПодключитьПроверкуАктуальности(Форма) Экспорт

	ЗакрытиеМесяцаКлиент.ПодключитьПроверкуАктуальности(Форма);
	
КонецПроцедуры

Процедура ПроверитьАктуальность(Форма, Организация, Период = Неопределено) Экспорт

	ЗакрытиеМесяцаКлиент.ПроверитьАктуальность(Форма, Организация, Период);
	
КонецПроцедуры

Процедура ПроверитьВыполнениеПроверкиАктуальностиОтчета(Форма) Экспорт

	ЗакрытиеМесяцаКлиент.ПроверитьВыполнениеПроверкиАктуальностиОтчета(Форма);	

КонецПроцедуры

Процедура Актуализировать(Форма, Организация, Период = Неопределено) Экспорт
	
	ЗакрытиеМесяцаКлиент.Актуализировать(Форма, Организация, Период);
	
КонецПроцедуры

Процедура ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период = Неопределено) Экспорт
	
	ЗакрытиеМесяцаКлиент.ПроверитьВыполнениеАктуализацииОтчета(Форма, Организация, Период);

КонецПроцедуры

Процедура ОтменитьАктуализацию(Форма, Организация, Период = Неопределено) Экспорт
	
	ЗакрытиеМесяцаКлиент.ОтменитьАктуализацию(Форма, Организация, Период);
	
КонецПроцедуры

Процедура ПроверитьЗавершениеАктуализации(Форма, Организация, Период = Неопределено) Экспорт
	
	ЗакрытиеМесяцаКлиент.ПроверитьЗавершениеАктуализации(Форма, Организация, Период);
	
КонецПроцедуры

Процедура ОбработкаОповещенияАктуализации(Форма, Организация, Период = Неопределено, ИмяСобытия, Параметр, Источник) Экспорт
	
	ЗакрытиеМесяцаКлиент.ОбработкаОповещенияАктуализации(Форма, Организация, Период, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

Процедура СкрытьПанельАктуализацииАвтоматически(Форма) Экспорт
	
	ЗакрытиеМесяцаКлиент.СкрытьПанельАктуализацииАвтоматически(Форма);
	
КонецПроцедуры

Процедура СкрытьПанельАктуализации(Форма) Экспорт
	
	ЗакрытиеМесяцаКлиент.СкрытьПанельАктуализации(Форма);
	
КонецПроцедуры
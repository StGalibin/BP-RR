﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверяет что для формы статистики уже выполнялась настройка.
// Параметры:
//	ФормаСтатистики - СправочникСсылка.ФормыСтатистики - Форма для которой нужно выполнить проверку.
//	Организация - СправочникСсылка.Организации - Организация для которой нужно определить наличие настроек.
// Возвращаемое значение:
// Булево - Истина - Настройки для этой формы уже выполнялись, в противном случае Ложь.
//
Функция ВыполнялисьНастройкиФормы(ФормаСтатистики, Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",     Организация);
	Запрос.УстановитьПараметр("ФормаСтатистики", ФормаСтатистики);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА КАК Выполнялись
	|ИЗ
	|	РегистрСведений.СостояниеНастройкиЗаполненияФормСтатистики КАК Настройки
	|ГДЕ
	|	Настройки.Организация = &Организация
	|	И Настройки.ФормаСтатистики = &ФормаСтатистики
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.НастройкаЗаполненияФормСтатистики КАК Настройки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПоляФормСтатистики КАК ПоляФормСтатистики
	|		ПО Настройки.ОбъектНаблюдения = ПоляФормСтатистики.СтатистическийПоказатель.Владелец
	|ГДЕ
	|	Настройки.Организация = &Организация
	|	И ПоляФормСтатистики.Владелец = &ФормаСтатистики
	|	И НЕ ПоляФормСтатистики.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.НастройкаЗаполненияСвободныхСтрокФормСтатистики КАК Настройки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПоляФормСтатистики КАК ПоляФормСтатистики
	|		ПО Настройки.ОбъектНаблюдения = ПоляФормСтатистики.СтатистическийПоказатель.Владелец
	|ГДЕ
	|	Настройки.Организация = &Организация
	|	И ПоляФормСтатистики.Владелец = &ФормаСтатистики
	|	И НЕ ПоляФормСтатистики.ПометкаУдаления";
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Устанавливает признак того что для формы статистики выполнялась настройка.
// Параметры:
//	ФормаСтатистики - СправочникСсылка.ФормыСтатистики - Форма для которой нужно записать признак.
//	Организация - СправочникСсылка.Организации - Организация для которой нужно записать признак.
//
Процедура ЗаписатьНастройкиВыполнены(ФормаСтатистики, Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.СостояниеНастройкиЗаполненияФормСтатистики.СоздатьМенеджерЗаписи();
	Запись.Организация     = Организация;
	Запись.ФормаСтатистики = ФормаСтатистики;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Запись.Организация     = Организация;
		Запись.ФормаСтатистики = ФормаСтатистики;
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
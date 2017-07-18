﻿#Область ПрограммныйИнтерфейс

// Возвращает идентификатор подсистемы в справочнике объектов
// метаданных.
//
Функция ИдентификаторПодсистемы() Экспорт
	
	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		"Подсистема.ОбменСИнтернетМагазином");
	
КонецФункции

// Возвращает логотип указанной CMS
//
// Параметры:
//  ЗначениеCMS - Перечислениессылка.CMSИнтернетМагазина - CMS, для которой необходимо получить логотип
//
// Возвращаемое значение:
//   Картинка - логотип выбранной CMS.
Функция ЛоготипCMS(ЗначениеCMS) Экспорт
	
	Если ЗначениеCMS = Перечисления.CMSИнтернетМагазина.Bitrix Тогда
		Картинка = БиблиотекаКартинок.ЛогоBitrix;
	ИначеЕсли ЗначениеCMS = Перечисления.CMSИнтернетМагазина.UMI Тогда
		Картинка = БиблиотекаКартинок.ЛогоUMI;
	Иначе
		Картинка = БиблиотекаКартинок.Пустая;
	КонецЕсли;
	
	Возврат Картинка;
КонецФункции

Функция ЕстьПравоНастройкиОбменаСИнтернетМагазином() Экспорт
	
	Возврат ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НастройкиОбменаСИнтернетМагазином);
	
КонецФункции

// Возвращает соответствие CMS - логотип
//
// Параметры:
//  ЗначениеCMS - Перечислениессылка.CMSИнтернетМагазина - CMS, для которой необходимо получить логотип
//
// Возвращаемое значение:
//   Картинка - логотип CMS из текущей настройки.
Функция ЛоготипТекущейCMS() Экспорт
	
	CMSИнтернетМагазина = Неопределено;
	
	Если ЕстьПравоНастройкиОбменаСИнтернетМагазином() Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ Первые 1
		|	НастройкиОбменаСИнтернетМагазином.CMSИнтернетМагазина
		|ИЗ
		|	РегистрСведений.НастройкиОбменаСИнтернетМагазином КАК НастройкиОбменаСИнтернетМагазином";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			CMSИнтернетМагазина = Выборка.CMSИнтернетМагазина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЛоготипCMS(CMSИнтернетМагазина);
	
КонецФункции

// Определяет необходимость сопоставления данных документа, загруженного из интернет-магазина.
//
// Возвращаемое значение:
//   Булево - признак наличия несопоставленых данных
//
Функция ТребуетсяСопоставлениеНовыхОбъектов(Документ) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменСИнтернетМагазином")
		ИЛИ НЕ ЕстьПравоНастройкиОбменаСИнтернетМагазином() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НесопоставленныеОбъектыИнтернетМагазина.Документ
	|ИЗ
	|	РегистрСведений.НесопоставленныеОбъектыИнтернетМагазина КАК НесопоставленныеОбъектыИнтернетМагазина
	|ГДЕ
	|	НесопоставленныеОбъектыИнтернетМагазина.Документ = &Документ";
	Запрос.УстановитьПараметр("Документ", Документ);
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Возвращает настройки обмена с интернет-магазином.
//
// Возвращаемое значение:
//   Структура, Неопределено - см. состав ресурсов РегистраСведений.НастройкиОбменаСИнтернетМагазином
//								Если настройка не задана возвращает Неопределено
Функция ПолучитьНастройкиОбмена() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиОбменаСИнтернетМагазином.CMSИнтернетМагазина,
	|	НастройкиОбменаСИнтернетМагазином.АдресСайта,
	|	НастройкиОбменаСИнтернетМагазином.Пользователь,
	|	НастройкиОбменаСИнтернетМагазином.ЗапрещенныеСтатусы,
	|	НастройкиОбменаСИнтернетМагазином.ГруппаНоменклатуры,
	|	НастройкиОбменаСИнтернетМагазином.ГруппаКонтрагентов,
	|	НастройкиОбменаСИнтернетМагазином.ВидНоменклатуры,
	|	НастройкиОбменаСИнтернетМагазином.НоменклатурнаяГруппа,
	|	НастройкиОбменаСИнтернетМагазином.Организация,
	|	НастройкиОбменаСИнтернетМагазином.Склад,
	|	НастройкиОбменаСИнтернетМагазином.Префикс,
	|	НастройкиОбменаСИнтернетМагазином.СоздаватьНовыхКонтрагентов,
	|	НастройкиОбменаСИнтернетМагазином.СоздаватьНовуюНоменклатуру,
	|	НастройкиОбменаСИнтернетМагазином.ИспользоватьОтборПоСтатусам,
	|	НастройкиОбменаСИнтернетМагазином.ДатаНачалаОбмена
	|ИЗ
	|	РегистрСведений.НастройкиОбменаСИнтернетМагазином КАК НастройкиОбменаСИнтернетМагазином";
	Настройки = Запрос.Выполнить().Выгрузить();
	Если Настройки.Количество() = 0 Тогда
		Возврат Неопределено;
	Иначе
		Настройки = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Настройки[0]);
		Возврат Настройки;
	КонецЕсли;
	
КонецФункции

// Создает и заполняет документы СчетНаОплатуПокупателю по данным заказов интернет-магазина,
// используется в фоновых заданиях.
Процедура ЗагрузитьЗаказыИнтернетМагазина(Параметры, АдресХранилища) Экспорт
	
	Результат = Новый Структура;
	
	СтатистикаЗагрузки = Новый Структура;
	СтатистикаЗагрузки.Вставить("Обработано", 0);
	СтатистикаЗагрузки.Вставить("Создано"   , Новый Массив);
	СтатистикаЗагрузки.Вставить("Пропущено" , Новый Массив);
	СтатистикаЗагрузки.Вставить("Обновлено" , Новый Массив);
	
	ОписаниеОшибки = "";
	
	УспешноЗагружено = Обработки.ОбменСИнтернетМагазином.ЗагрузитьЗаказыИнтернетМагазина(СтатистикаЗагрузки, ОписаниеОшибки);
	
	Результат.Вставить("Успешно",            УспешноЗагружено);
	Результат.Вставить("СтатистикаЗагрузки", СтатистикаЗагрузки);
	Результат.Вставить("ОписаниеОшибки",     ОписаниеОшибки);
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);

КонецПроцедуры

Процедура ПроверитьУстановитьИспользоватьОбменСИнтернетМагазином() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменСИнтернетМагазином") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	НастройкиОбменаСИнтернетМагазином.CMSИнтернетМагазина
		|ИЗ
		|	РегистрСведений.НастройкиОбменаСИнтернетМагазином КАК НастройкиОбменаСИнтернетМагазином";
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Константы.ИспользоватьОбменСИнтернетМагазином.Установить(Истина);
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

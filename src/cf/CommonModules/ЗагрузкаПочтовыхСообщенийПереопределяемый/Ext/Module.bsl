﻿
#Область ПрограммныйИнтерфейс

// Позволяет отметить загруженные в информационную базу письма по заголовкам почтовых сообщений.
// Заголовки писем с установленным свойством ПисьмоЗагружено = Истина не будут получены с почтового сервера.
//
// Параметры:
//  ЗаголовкиПисем - ТаблицаЗначений - состав колонок таблицы значений см. ЗагрузкаПочтовыхСообщений.СоздатьАдаптированноеОписаниеПисьма().
//  ВидОперации    - Строка - Наименование операции. Например: "ЗагрузкаСчетовФактур", "ЗагрузкаСчетовНаОплату".
//  УчетнаяЗапись  - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Используемая учетная запись электронной почты.
//
// Возвращаемое значение:
//  Булево - Истина если в переопределяемой функции были отмечены заголовки.
//
Функция ОтметитьЗаголовкиЗагруженныхПисем(ЗаголовкиПисем, ВидОперации, УчетнаяЗапись) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Позволяет дополнить таблицу писем, загруженных с почтового сервера, данными информационной базы.
//
// Параметры:
//  Письма - ТаблицаЗначений - состав колонок таблицы значений см. ЗагрузкаПочтовыхСообщений.СоздатьАдаптированноеОписаниеПисьма().
//  ВидОперации    - Строка - Наименование операции. Например: "ЗагрузкаСчетовФактур", "ЗагрузкаСчетовНаОплату".
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - Используемая учетная запись электронной почты.
//  ПараметрыОтбораЗаголовков - Структура, содержащая поля:
//    * ПослеДатыОтправления - ДатаВремя - Дата и время, начиная с которых обрабатывать почтовые сообщения.
//
Процедура ДополнитьТаблицуПочтовыхСообщений(Письма, ВидОперации, УчетнаяЗапись, ПараметрыОтбораЗаголовков) Экспорт
	
	
	
КонецПроцедуры

// Возвращает учетную запись настроенную на получения почтовых сообщений, пустую ссылку
// если учетной записи настроенной на получение почты нет или Неопределено или в конфигурации
// отсутствует справочник УчетныеЗаписиЭлектроннойПочты.
//
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиЭлектроннойПочты, Неопределено - учетная запись электронной почты.
//
Функция УчетнаяЗаписьПользователяДляЗагрузкиСообщений() Экспорт
	
	УчетнаяЗаписьПользователя = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("УчетнаяЗаписьЭлектроннойПочты");
	СистемнаяУчетнаяЗапись    = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	Если ЗначениеЗаполнено(УчетнаяЗаписьПользователя)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗаписьПользователя, "ИспользоватьДляПолучения") Тогда
		
		УчетнаяЗапись = УчетнаяЗаписьПользователя;
		
	ИначеЕсли ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СистемнаяУчетнаяЗапись, "ИспользоватьДляПолучения") Тогда
		
		УчетнаяЗапись = СистемнаяУчетнаяЗапись;
		
	Иначе
		
		УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();
		
	КонецЕсли;
	
	Возврат УчетнаяЗапись;
	
КонецФункции

#КонецОбласти

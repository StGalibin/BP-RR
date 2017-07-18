﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Если РежимРаботы.ЭтоАдминистраторПрограммы Тогда
			ЕстьПочта = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
			РегламентноеЗадание = НайтиРегламентноеЗадание("МониторингЗадач");
			Если ЕстьПочта И РегламентноеЗадание <> Неопределено Тогда
				МониторингЗадачИспользование = РегламентноеЗадание.Использование;
				МониторингЗадачРасписание    = РегламентноеЗадание.Расписание;
			Иначе
				Элементы.ГруппаМониторингЗадач.Видимость = Ложь;
			КонецЕсли;
			РегламентноеЗадание = НайтиРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах");
			Если ЕстьПочта И РегламентноеЗадание <> Неопределено Тогда
				УведомлениеИсполнителейОНовыхЗадачахИспользование = РегламентноеЗадание.Использование;
				УведомлениеИсполнителейОНовыхЗадачахРасписание    = РегламентноеЗадание.Расписание;
			Иначе
				Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость = Ложь;
			КонецЕсли;
		Иначе
			Элементы.ГруппаМониторингЗадач.Видимость = Ложь;
			Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость = Ложь;
		КонецЕсли;
		
		Если РежимРаботы.МодельСервиса Тогда
			Элементы.МониторингЗадачНастроитьРасписание.Видимость = Ложь;
			Элементы.УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаБизнесПроцессыИЗадачи.Видимость = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьПочтовыйКлиентПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПрочиеВзаимодействияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьПисьмаВФорматеHTMLПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПризнакРассмотреноПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗаметкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНапоминанияПользователяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАнкетированиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьШаблоныСообщенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьБизнесПроцессыИЗадачиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодчиненныеБизнесПроцессыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИзменятьЗаданияЗаднимЧисломПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуНачалаЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуИВремяВСрокахЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура МониторингЗадачНастроитьРасписание(Команда)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(МониторингЗадачРасписание);
	Диалог.Показать(Новый ОписаниеОповещения("МониторингЗадачПослеИзмененияРасписания", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание(Команда)
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(УведомлениеИсполнителейОНовыхЗадачахРасписание);
	Диалог.Показать(Новый ОписаниеОповещения("УведомлениеИсполнителейОНовыхЗадачахПослеИзмененияРасписания", ЭтотОбъект));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МониторингЗадачРасписание = Расписание;
	МониторингЗадачИспользование = Истина;
	ЗаписатьРегламентноеЗадание("МониторингЗадач", МониторингЗадачИспользование, 
		МониторингЗадачРасписание, "МониторингЗадачРасписание");
КонецПроцедуры

&НаКлиенте
Процедура МониторингЗадачИспользованиеПриИзменении(Элемент)
	ЗаписатьРегламентноеЗадание("МониторингЗадач", МониторингЗадачИспользование, 
		МониторингЗадачРасписание, "МониторингЗадачРасписание");
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УведомлениеИсполнителейОНовыхЗадачахРасписание = Расписание;
	УведомлениеИсполнителейОНовыхЗадачахИспользование = Истина;
	ЗаписатьРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах", УведомлениеИсполнителейОНовыхЗадачахИспользование, 
		УведомлениеИсполнителейОНовыхЗадачахРасписание, "УведомлениеИсполнителейОНовыхЗадачахРасписание");
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеИсполнителейОНовыхЗадачахИспользованиеПриИзменении(Элемент)
	ЗаписатьРегламентноеЗадание("УведомлениеИсполнителейОНовыхЗадачах", УведомлениеИсполнителейОНовыхЗадачахИспользование, 
		УведомлениеИсполнителейОНовыхЗадачахРасписание, "УведомлениеИсполнителейОНовыхЗадачахРасписание");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если (КонстантаИмя = "ИспользоватьПочтовыйКлиент" ИЛИ КонстантаИмя = "ИспользоватьБизнесПроцессыИЗадачи") И КонстантаЗначение = Ложь Тогда
			ЭтотОбъект.Прочитать();
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПочтовыйКлиент" ИЛИ РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		
		Элементы.ИспользоватьПрочиеВзаимодействия.Доступность             = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ИспользоватьПризнакРассмотрено.Доступность               = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ОтправлятьПисьмаВФорматеHTML.Доступность                 = НаборКонстант.ИспользоватьПочтовыйКлиент;
		
	КонецЕсли;
	
	Если (РеквизитПутьКДанным = "НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи" ИЛИ РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		
		Элементы.ОткрытьРолиИИсполнителиБизнесПроцессов.Доступность = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьПодчиненныеБизнесПроцессы.Доступность  = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИзменятьЗаданияЗаднимЧислом.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуНачалаЗадач.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуИВремяВСрокахЗадач.Доступность     = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ГруппаМониторингЗадач.Доступность					= НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Доступность = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		
	КонецЕсли;
	
	Если Элементы.ГруппаМониторингЗадач.Видимость
		И (РеквизитПутьКДанным = "МониторингЗадачРасписание" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Элементы.МониторингЗадачНастроитьРасписание.Доступность	= МониторингЗадачИспользование;
		Если МониторингЗадачИспользование Тогда
			РасписаниеПредставление = Строка(МониторингЗадачРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = "";
		КонецЕсли;
		Элементы.МониторингЗадачПояснение.Заголовок = Представление;
	КонецЕсли;
	
	Если Элементы.ГруппаУведомлениеИсполнителейОНовыхЗадачах.Видимость
		И (РеквизитПутьКДанным = "УведомлениеИсполнителейОНовыхЗадачахРасписание" Или РеквизитПутьКДанным = "")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.БизнесПроцессыИЗадачи") Тогда
		Элементы.УведомлениеИсполнителейОНовыхЗадачахНастроитьРасписание.Доступность	= УведомлениеИсполнителейОНовыхЗадачахИспользование;
		Если УведомлениеИсполнителейОНовыхЗадачахИспользование Тогда
			РасписаниеПредставление = Строка(УведомлениеИсполнителейОНовыхЗадачахРасписание);
			Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
		Иначе
			Представление = "";
		КонецЕсли;
		Элементы.УведомлениеИсполнителейОНовыхЗадачахПояснение.Заголовок = Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегламентноеЗадание(ИмяПредопределенного, Использование, Расписание, РеквизитПутьКДанным)
	РегламентноеЗадание = НайтиРегламентноеЗадание(ИмяПредопределенного);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Использование);
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегламентноеЗадание, ПараметрыЗадания);
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиРегламентноеЗадание(ИмяПредопределенного)
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", ИмяПредопределенного);
	
	РезультатПоиска = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	Возврат ?(РезультатПоиска.Количество() = 0, Неопределено, РезультатПоиска[0]);
КонецФункции

#КонецОбласти

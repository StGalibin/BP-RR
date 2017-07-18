﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий
 
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Увольнение") Тогда	
		
		СтрокаДанныеУвольнения = "Организация, Сотрудник, ДатаУвольнения";
		ДанныеУвольнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, СтрокаДанныеУвольнения);
		
		Если ЭтоВнутреннийСовместитель(ДанныеУвольнения["Сотрудник"]) Тогда
		    ВызватьИсключение ТекстОшибкиПроверкиВидаЗанятости();
		КонецЕсли;
		
		Организация = ДанныеУвольнения["Организация"];
		Сотрудник = ДанныеУвольнения["Сотрудник"];
		ГодС = Год(ДанныеУвольнения["ДатаУвольнения"])-2;
		ГодПо = Год(ДанныеУвольнения["ДатаУвольнения"]);
		УдалитьПериодРаботыПо = ДанныеУвольнения["ДатаУвольнения"];
		Дата = ТекущаяДатаСеанса();
		
		ОбновитьВторичныеДанныеДокумента(Истина, Истина, Ложь);
		ЗаполнитьДанныеСправки();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ФиксацияВторичныхДанныхВДокументах.ЗафиксироватьВторичныеДанныеДокумента(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	УточнитьПроверяемыеРеквизиты(ПроверяемыеРеквизиты);
	ПроверитьВидЗанятостиСотрудника(Отказ);
	ПроверитьПериодЗаполненияДокумента(Отказ);
	ПроверитьЗаполнениеПериодовРаботы(Отказ);
	ПроверитьЗаполнениеЗаработка(Отказ);
	ПроверитьЗаполнениеДнейОтсутствия(Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
      
// Функция возвращает признак завершенности работы с объектом.
Функция ОбъектЗафиксирован() Экспорт
	
	Возврат Проведен;
	
КонецФункции 

// Процедура заполнения данных справки по данным учета.
Процедура ЗаполнитьДанныеСправки() Экспорт
	
	Если ГодС = 0 Или ГодПо = 0 Или ГодС > ГодПо Или Сотрудник.Пустая() Или Организация.Пустая() Тогда
		Возврат
	КонецЕсли;
	
	ЗаполнитьДанныеОЗаработкеИДняхОтсутствия(); 
	
	ЗаполнитьДанныеОПериодахРаботы();
	
КонецПроцедуры
 
// Процедура обновляет данные табличной части с учетом фиксации. 
// Если передан год - заполняется только строка с этим годом.
Функция ОбновитьДанныеОЗаработкеИДняхОтсутствия(Год = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Год) Тогда
		ГодНачала = Год;
		ГодОкончания = Год;
		РасчетныеГоды = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Год);
	Иначе
		ГодНачала = 0;
		ГодОкончания = 0;
		РасчетныеГоды = Новый Массив;
		Для каждого СтрокаГода Из ДанныеОЗаработке Цикл
			Если СтрокаГода.РасчетныйГод <> 0 Тогда
				ГодНачала =  ?(ГодНачала = 0, СтрокаГода.РасчетныйГод, Мин(СтрокаГода.РасчетныйГод, ГодНачала));
				ГодОкончания =  Макс(ГодОкончания, СтрокаГода.РасчетныйГод);
				РасчетныеГоды.Добавить(СтрокаГода.РасчетныйГод);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ГодНачала = 0 ИЛИ ГодОкончания = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Сотрудник.Пустая() Или Организация.Пустая() Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Возврат ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(ГодНачала, ГодОкончания, Истина, РасчетныеГоды);
	
КонецФункции

// Процедура обновляет вторичные данные в документе с учетом фиксации. 
Функция ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина, ДанныеОЗаработке = Истина, ОбновлятьБезусловно = Истина) Экспорт
	
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() И НЕ ОбновлятьБезусловно Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	Если ДанныеОрганизации И ОбновитьДанныеСтрахователя() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеСотрудника И ОбновитьДанныеСотрудника() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеОЗаработке И ОбновитьДанныеОЗаработкеИДняхОтсутствия() Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован
	
КонецФункции

Функция ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(ГодНачала, ГодОкончания, Обновление = Ложь,  РасчетныеГоды = Неопределено)
	ПараметрыЗаполнения = УчетПособийСоциальногоСтрахования.ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия(ЭтотОбъект);
	ПараметрыЗаполнения.Сотрудник = ЭтотОбъект.Сотрудник;
	ПараметрыЗаполнения.Организация = ЭтотОбъект.Организация;
	ПараметрыЗаполнения.ГодНачала = ГодНачала;
	ПараметрыЗаполнения.ГодОкончания = ГодОкончания;
	ПараметрыЗаполнения.Обновление = Обновление;
	ПараметрыЗаполнения.РасчетныеГоды = РасчетныеГоды;
	
	Возврат УчетПособийСоциальногоСтрахования.ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(ЭтотОбъект, ПараметрыЗаполнения);
КонецФункции

Функция ЗапросПоСтрокеПолей(СтрокаПолей)
	
	Запрос = Новый Запрос;  
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	ШаблонПоля = " ЕстьNULL(&#Парам#, """") КАК #Парам#,";

	Текст = "ВЫБРАТЬ #Поля#
	|	ПОМЕСТИТЬ ВТВторичныеДанные";
	
	Поля = "";
	
	МассивПолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаПолей);
	Для каждого Поле Из МассивПолей Цикл
		Поля = Поля + Символы.ПС + СтрЗаменить(ШаблонПоля, "#Парам#", Поле);
		Запрос.Параметры.Вставить(Поле);
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Поля, 1);
	Запрос.Текст = СтрЗаменить(Текст, "#Поля#", Поля);
	
	Возврат Запрос
	
КонецФункции 

Процедура ПроверитьПериодЗаполненияДокумента(Отказ)
	Если ЗначениеЗаполнено(ГодС) 
		И ЗначениеЗаполнено(ГодПо)
		И ГодС > ГодПо Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Неправильно задан период заполнения документа: начало периода не может быть позже окончания.'"),,,,Отказ);
	КонецЕсли; 
КонецПроцедуры

Процедура УточнитьПроверяемыеРеквизиты(ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(Организация) Тогда 
		Если НЕ ЗарплатаКадрыПовтИсп.ЭтоЮридическоеЛицо(Организация) Тогда
			ИсключаемыеРеквизиты = Новый Массив;
			ИсключаемыеРеквизиты.Добавить("ДолжностьРуководителя");
			ИсключаемыеРеквизиты.Добавить("ГлавныйБухгалтер");
			ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьВидЗанятостиСотрудника(Отказ)
	
	Если ЗначениеЗаполнено(Сотрудник) 
		И ЭтоВнутреннийСовместитель(Сотрудник) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибкиПроверкиВидаЗанятости(),,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоВнутреннийСовместитель(ПроверяемыйСотрудник)
	
	ЭтоВнутреннийСовместитель = Ложь;
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПроверяемыйСотрудник), "ВидЗанятости");
	Если КадровыеДанные.Количество() <> 0 Тогда
		КадровыеДанныеСотрудника = КадровыеДанные[0];
		ЭтоВнутреннийСовместитель = КадровыеДанныеСотрудника.ВидЗанятости = Перечисления.ВидыЗанятости.ВнутреннееСовместительство 
		Или КадровыеДанныеСотрудника.ВидЗанятости = Перечисления.ВидыЗанятости.ПустаяСсылка(); 
	КонецЕсли;	
	
	Возврат ЭтоВнутреннийСовместитель;
	
КонецФункции

Функция ТекстОшибкиПроверкиВидаЗанятости()
	Возврат Нстр("ru = 'Справки выдаются сотрудникам, имевшим основное место работы или работавшим по внешнему совместительству.'");
КонецФункции

Процедура ПроверитьЗаполнениеЗаработка(Отказ) 
	
	СтрокаНачалаСообщенияОбОшибке = Нстр("ru = 'В строке номер %1 табл. части ""Данные о заработке""'") + ": ";
	
	Отбор = Новый Структура;
	Для каждого СтрокаЗаработка Из ДанныеОЗаработке Цикл
		Отбор.Вставить("РасчетныйГод", СтрокаЗаработка.РасчетныйГод);
		ПовторяющиесяСтроки = ДанныеОЗаработке.НайтиСтроки(Отбор);
		Для каждого ПовторяющаясяСтрока Из ПовторяющиесяСтроки Цикл
			Если СтрокаЗаработка.НомерСтроки < ПовторяющаясяСтрока.НомерСтроки Тогда
				СообщениеТекст = СтрокаНачалаСообщенияОбОшибке + Нстр("ru = 'указанный расчетный год повторяется в строке %2.'");
				СообщениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеТекст, СтрокаЗаработка.НомерСтроки, ПовторяющаясяСтрока.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , , , Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПериодовРаботы(Отказ) 
	
	СтрокаНачалаСообщенияОбОшибке = Нстр("ru = 'В строке номер %1 табл. части ""Периоды работы""'") + ": ";
	
	Для каждого ПериодРаботы Из ПериодыРаботы Цикл
		
		Если ЗначениеЗаполнено(ПериодРаботы.ПериодРаботыС) 
			И ЗначениеЗаполнено(ПериодРаботы.ПериодРаботыПо) 
			И ПериодРаботы.ПериодРаботыС > ПериодРаботы.ПериодРаботыПо Тогда
			СообщениеТекст = СтрокаНачалаСообщенияОбОшибке + Нстр("ru = 'неверно указан период работы: начало периода должно предшествовать окончанию периода.'");
			СообщениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеТекст, ПериодРаботы.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , , , Отказ);
		КонецЕсли;
		
		Для каждого ПовторяющаясяСтрока Из ПериодыРаботы Цикл
			
			Если  ПериодРаботы.НомерСтроки >=  ПовторяющаясяСтрока.НомерСтроки 
				Или ((ПериодРаботы.ПериодРаботыС > ПовторяющаясяСтрока.ПериодРаботыПо) 
				Или	(ПериодРаботы.ПериодРаботыПо < ПовторяющаясяСтрока.ПериодРаботыС)) Тогда
				// Периоды не пересекаются
				Продолжить;
			КонецЕсли;	
			
			СообщениеТекст = СтрокаНачалаСообщенияОбОшибке + Нстр("ru = 'указанный период работы пересекается с периодом из строки %2.'");
			СообщениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеТекст, ПериодРаботы.НомерСтроки, ПовторяющаясяСтрока.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , , , Отказ);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры 

Процедура ПроверитьЗаполнениеДнейОтсутствия(Отказ) 
	
	СтрокаНачалаСообщенияОбОшибке =
		Нстр("ru = 'В строке номер %1 табл. части ""Дни болезни, ухода за детьми""'") + ": ";
		
	Для каждого ПериодОтсутствия Из ДниБолезниУходаЗаДетьми Цикл
		
		Если ЗначениеЗаполнено(ПериодОтсутствия.ПериодС) 
			И ЗначениеЗаполнено(ПериодОтсутствия.ПериодПо) 
			И ПериодОтсутствия.ПериодС > ПериодОтсутствия.ПериодПо Тогда
			СообщениеТекст = СтрокаНачалаСообщенияОбОшибке + Нстр("ru = 'неверно указан период отсутствия: начало периода должно предшествовать окончанию периода.'");
			СообщениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеТекст, ПериодОтсутствия.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , , , Отказ);
		КонецЕсли;
		
		Для каждого ПовторяющаясяСтрока Из ДниБолезниУходаЗаДетьми Цикл
			Если ПериодОтсутствия.НомерСтроки >=  ПовторяющаясяСтрока.НомерСтроки 
				Или	((ПериодОтсутствия.ПериодС > ПовторяющаясяСтрока.ПериодПо) 
				Или (ПериодОтсутствия.ПериодПо < ПовторяющаясяСтрока.ПериодС)) Тогда 
				// Периоды не пересекаются
				Продолжить;
			КонецЕсли;	
			
			СообщениеТекст = СтрокаНачалаСообщенияОбОшибке + Нстр("ru = 'указанный период отсутствия пересекается с периодом из строки %2.'");
			СообщениеТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеТекст, ПериодОтсутствия.НомерСтроки, ПовторяющаясяСтрока.НомерСтроки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеТекст, , , , Отказ);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеОЗаработкеИДняхОтсутствия()
	ДанныеОЗаработке.Очистить();
	ФиксацияВторичныхДанныхВДокументах.СброситьФиксациюИзмененийТабличнойЧасти(ЭтотОбъект, "ДанныеОЗаработке");
	ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(ГодС,ГодПо);
КонецПроцедуры

Процедура ЗаполнитьДанныеОПериодахРаботы()
	
	МассивЛет = Новый Массив;
	Если ГодС = 0 Тогда
		МассивЛет.Добавить(ГодПо);
	ИначеЕсли ГодПо = 0 Тогда 	
		МассивЛет.Добавить(ГодС);
	Иначе 	
		ГодМежду = Мин(ГодС, ГодПо);
		Пока ГодМежду <= Макс(ГодС, ГодПо) Цикл
			МассивЛет.Добавить(ГодМежду);
			ГодМежду = ГодМежду + 1;	
		КонецЦикла;
	КонецЕсли;
	
	РаннийГод = 10000;
	ПозднийГод = 0;
	Для каждого Значение Из МассивЛет Цикл
		РаннийГод = Мин(Значение, РаннийГод);
		ПозднийГод = Макс(Значение, ПозднийГод);
	КонецЦикла;
	
	ДатаНачала = Дата(РаннийГод, 1, 1);
	ДатаОкончания = КонецДня(Дата(ПозднийГод, 12, 31));
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	// Отбор сотрудников подразделения организации.
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 			= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.СписокФизическихЛиц 	= ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	ПараметрыПолученияСотрудниковОрганизаций.КадровыеДанные 		= "ДатаПриема,ДатаУвольнения,ВидЗанятости";
	ПараметрыПолученияСотрудниковОрганизаций.ОтбиратьПоГоловнойОрганизации 	= Истина;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода		= ДатаОкончания;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияСотрудниковОрганизаций);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТСотрудникиОрганизации.ФизическоеЛицо КАК ФизическоеЛицо,
	|	&ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	МИНИМУМ(ВТСотрудникиОрганизации.ДатаПриема) КАК ДатаНачала,
	|	МИНИМУМ(ВТСотрудникиОрганизации.ДатаПриема) КАК Период,
	|	&ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТФизическиеЛицаОрганизаций
	|ИЗ
	|	ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|ГДЕ
	|	ВТСотрудникиОрганизации.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ВнутреннееСовместительство)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТСотрудникиОрганизации.ФизическоеЛицо";
	Запрос.Выполнить();
	
	УчетСтраховыхВзносов.СформироватьВТИзменениеПраваНаСтрахованиеОтБолезни(МенеджерВременныхТаблиц, Истина);

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТСотрудникиОрганизации.ДатаПриема КАК ПериодРаботыС,
	|	ВЫБОР
	|		КОГДА ВТСотрудникиОрганизации.ДатаУвольнения < &ДатаОкончания
	|				И ВТСотрудникиОрганизации.ДатаУвольнения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ВТСотрудникиОрганизации.ДатаУвольнения
	|		ИНАЧЕ &ДатаОкончания
	|	КОНЕЦ КАК ПериодРаботыПо
	|ПОМЕСТИТЬ ВТПериодыРаботы
	|ИЗ
	|	ВТСотрудникиОрганизации КАК ВТСотрудникиОрганизации
	|ГДЕ
	|	ВТСотрудникиОрганизации.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ВнутреннееСовместительство)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачалоПериодовСтрахования.Период КАК ДатаНачала,
	|	НачалоПериодовСтрахования.ИмеетПравоНаСтрахование КАК ИмеетПравоНаСтрахование,
	|	МИНИМУМ(ЕСТЬNULL(ОкончаниеПериодовСтрахования.Период, &ДатаОкончания)) КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТПериодыПраваНаСтрахование
	|ИЗ
	|	ВТИзменениеПраваНаСтрахование КАК НачалоПериодовСтрахования
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИзменениеПраваНаСтрахование КАК ОкончаниеПериодовСтрахования
	|		ПО НачалоПериодовСтрахования.Период < ОкончаниеПериодовСтрахования.Период
	|			И НачалоПериодовСтрахования.ИмеетПравоНаСтрахование <> ОкончаниеПериодовСтрахования.ИмеетПравоНаСтрахование
	|
	|СГРУППИРОВАТЬ ПО
	|	НачалоПериодовСтрахования.Период,
	|	НачалоПериодовСтрахования.ИмеетПравоНаСтрахование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТПериодыПраваНаСтрахование.ДатаНачала КАК ДатаНачала,
	|	ВТПериодыПраваНаСтрахование.ИмеетПравоНаСтрахование КАК ИмеетПравоНаСтрахование
	|ПОМЕСТИТЬ ВТДатыНачалаУникальныхПериодовСтрахования
	|ИЗ
	|	ВТПериодыПраваНаСтрахование КАК ВТПериодыПраваНаСтрахование
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПериодыПраваНаСтрахование КАК ВТПериодыПраваНаСтрахованиеФильтр
	|		ПО (ВТПериодыПраваНаСтрахование.ДатаНачала >= ВТПериодыПраваНаСтрахованиеФильтр.ДатаНачала
	|					И ВТПериодыПраваНаСтрахование.ДатаОкончания < ВТПериодыПраваНаСтрахованиеФильтр.ДатаОкончания
	|				ИЛИ ВТПериодыПраваНаСтрахование.ДатаОкончания <= ВТПериодыПраваНаСтрахованиеФильтр.ДатаОкончания
	|					И ВТПериодыПраваНаСтрахование.ДатаНачала > ВТПериодыПраваНаСтрахованиеФильтр.ДатаНачала)
	|			И ВТПериодыПраваНаСтрахование.ИмеетПравоНаСтрахование = ВТПериодыПраваНаСтрахованиеФильтр.ИмеетПравоНаСтрахование
	|ГДЕ
	|	ВТПериодыПраваНаСтрахованиеФильтр.ИмеетПравоНаСтрахование ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТПериодыПраваНаСтрахование.ДатаНачала КАК ДатаНачала,
	|	ВТПериодыПраваНаСтрахование.ДатаОкончания КАК ДатаОкончания
	|ПОМЕСТИТЬ ВТПериодыСтрахования
	|ИЗ
	|	ВТПериодыПраваНаСтрахование КАК ВТПериодыПраваНаСтрахование
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДатыНачалаУникальныхПериодовСтрахования КАК ВТДатыНачалаУникальныхПериодовСтрахования
	|		ПО ВТПериодыПраваНаСтрахование.ДатаНачала = ВТДатыНачалаУникальныхПериодовСтрахования.ДатаНачала
	|ГДЕ
	|	ВТПериодыПраваНаСтрахование.ИмеетПравоНаСтрахование = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ПериодыСтрахования.ДатаНачала < ПериодыРаботы.ПериодРаботыС
	|			ТОГДА ПериодыРаботы.ПериодРаботыС
	|		ИНАЧЕ ПериодыСтрахования.ДатаНачала
	|	КОНЕЦ КАК ПериодРаботыС,
	|	ВЫБОР
	|		КОГДА ПериодыСтрахования.ДатаОкончания > ПериодыРаботы.ПериодРаботыПо
	|			ТОГДА ПериодыРаботы.ПериодРаботыПо
	|		ИНАЧЕ ПериодыСтрахования.ДатаОкончания
	|	КОНЕЦ КАК ПериодРаботыПо
	|ИЗ
	|	ВТПериодыРаботы КАК ПериодыРаботы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыСтрахования КАК ПериодыСтрахования
	|		ПО (ПериодыРаботы.ПериодРаботыС >= ПериодыСтрахования.ДатаНачала
	|					И ПериодыРаботы.ПериодРаботыС < ПериодыСтрахования.ДатаОкончания
	|				ИЛИ ПериодыСтрахования.ДатаНачала >= ПериодыРаботы.ПериодРаботыС
	|					И ПериодыСтрахования.ДатаНачала < ПериодыРаботы.ПериодРаботыПо)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПериодРаботыС,
	|	ПериодРаботыПо";
	
	Запрос.Текст = ТекстЗапроса;
	
	ПериодыРаботы.Загрузить(Запрос.Выполнить().Выгрузить())

КонецПроцедуры

Функция ОбновитьДанныеСтрахователя()
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаРеквизиты = "РегистрационныйНомерФСС,ДополнительныйКодФСС,КодПодчиненностиФСС,НаименованиеТерриториальногоОрганаФСС,Руководитель,ГлавныйБухгалтер,ДолжностьРуководителя,ТелефонОрганизации";
	
	РеквизитыДокумента = Новый Структура(СтрокаРеквизиты);
	
	СтрокаРеквизитыОрганизации = "РегистрационныйНомерФСС, КодПодчиненностиФСС, ДополнительныйКодФСС, НаименованиеТерриториальногоОрганаФСС";									
	РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, СтрокаРеквизитыОрганизации);
	
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, РеквизитыОрганизации, СтрокаРеквизитыОрганизации);
	
	ЗаполняемыеЗначения = Новый Структура("Организация,Руководитель,ДолжностьРуководителя,ГлавныйБухгалтер", Организация);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполняемыеЗначения.Свойство("Руководитель", РеквизитыДокумента.Руководитель);
	ЗаполняемыеЗначения.Свойство("ДолжностьРуководителя", РеквизитыДокумента.ДолжностьРуководителя);
	ЗаполняемыеЗначения.Свойство("ГлавныйБухгалтер", РеквизитыДокумента.ГлавныйБухгалтер);
	
	Сведения = Новый СписокЗначений;
	Сведения.Добавить("", "ТелОрганизации");
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, Дата, Сведения);
	ОргСведения.Свойство("ТелОрганизации", РеквизитыДокумента.ТелефонОрганизации);
	
	Запрос = ЗапросПоСтрокеПолей(СтрокаРеквизиты);
	
	ЗаполнитьЗначенияСвойств(Запрос.Параметры, РеквизитыДокумента); 
	
	Запрос.Выполнить();
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект);
	
КонецФункции

Функция ОбновитьДанныеСотрудника()
	
	КадровыеДанные = Новый Массив;
	
	КадровыеДанные.Добавить("ФизическоеЛицо");
	КадровыеДанные.Добавить("Фамилия");
	КадровыеДанные.Добавить("Имя");
	КадровыеДанные.Добавить("Отчество");
	КадровыеДанные.Добавить("СтраховойНомерПФР");
	КадровыеДанные.Добавить("ДокументВид");
	КадровыеДанные.Добавить("ДокументСерия");
	КадровыеДанные.Добавить("ДокументНомер");
	КадровыеДанные.Добавить("ДокументКемВыдан");
	КадровыеДанные.Добавить("ДокументДатаВыдачи");
	КадровыеДанные.Добавить("АдресПоПрописке");
	КадровыеДанные.Добавить("АдресПоПропискеПредставление");
	КадровыеДанные.Добавить("ДатаПриема");
	КадровыеДанные.Добавить("ДатаУвольнения");
	
	КадровыеДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), КадровыеДанные, Дата);
	
	Если КадровыеДанныеФизическогоЛица.Количество() = 0 Тогда
		Возврат Ложь;	
	КонецЕсли;
	
	СтрокаРеквизиты = "ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,ВидДокумента,СерияДокумента,НомерДокумента,КемВыданДокумент,ДатаВыдачиДокумента,УдалитьПериодРаботыС,УдалитьПериодРаботыПо,АдресПоПрописке";
	
	РеквизитыДокумента = Новый Структура(СтрокаРеквизиты);
	
	Данные =  КадровыеДанныеФизическогоЛица[0];
	
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, Данные, "ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,АдресПоПрописке");
	
	РеквизитыДокумента["УдалитьПериодРаботыС"] 	= Данные["ДатаПриема"];
	РеквизитыДокумента["УдалитьПериодРаботыПо"] = Данные["ДатаУвольнения"];
	РеквизитыДокумента["ВидДокумента"] 			= Данные["ДокументВид"];
	РеквизитыДокумента["СерияДокумента"] 		= Данные["ДокументСерия"];
	РеквизитыДокумента["НомерДокумента"] 		= Данные["ДокументНомер"];
	РеквизитыДокумента["КемВыданДокумент"]		= Данные["ДокументКемВыдан"];
	РеквизитыДокумента["ДатаВыдачиДокумента"] 	= Данные["ДокументДатаВыдачи"];
	
	Запрос = ЗапросПоСтрокеПолей(СтрокаРеквизиты);
	
	ЗаполнитьЗначенияСвойств(Запрос.Параметры, РеквизитыДокумента); 
	
	Запрос.Выполнить();
	
	ФизическоеЛицо = Данные["ФизическоеЛицо"];
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект);
	
КонецФункции

#КонецОбласти

#КонецЕсли

﻿#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет содержание услуги в табличной части документа.
// Устанавливает содержание с учетом периодичности.
//
// Параметры:
//    ТабличнаяЧасть - Табличная часть - Табличная часть документа, например - Товары, Услуги или АгентскиеУслуги.
//                                       В таблице обязательно наличие колонок "Номенклатура" и "Содержание".
//    ТекущаяДата    - Дата - Текущая дата документа. Используется для формирования нового содержания услуг. 
//    ПредыдущаяДата - Дата - Предыдущая дата документа. Если дата заполнена,
//                            то будет выполнена проверка на изменение содержания.
//                            В случае, если содержание услуги изменено пользователем,
//                            то новое содержание не будет установлено.
//
Процедура ОбновитьСодержаниеУслуг(ТабличнаяЧасть, Знач ТекущаяДата, Знач ПредыдущаяДата = Неопределено) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПериодичностьУслуг") Тогда
		Возврат;
	КонецЕсли;
	
	// Получим реквизиты используемой номенклатуры в таблице.
	МассивНоменклатуры = ТабличнаяЧасть.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	РеквизитыНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
		МассивНоменклатуры,
		"НаименованиеПолное, ПериодичностьУслуги, Услуга");
		
	Для Каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
		
		РеквизитыТекущейНоменклатуры = РеквизитыНоменклатуры[СтрокаТаблицы.Номенклатура];
		Если РеквизитыТекущейНоменклатуры = Неопределено
			ИЛИ НЕ РеквизитыТекущейНоменклатуры.Услуга
			ИЛИ НЕ ЗначениеЗаполнено(РеквизитыТекущейНоменклатуры.ПериодичностьУслуги) Тогда
			// Обрабатываем только услуги с установленной периодичностью.
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПредыдущаяДата) Тогда
			// Если есть предыдущая дата, 
			// то проверим изменялось ли содержание услуги пользователем.
			ПредыдущееСодержаниеУслуги = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
				РеквизитыТекущейНоменклатуры.НаименованиеПолное,
				РеквизитыТекущейНоменклатуры.ПериодичностьУслуги,
				ПредыдущаяДата);
			СодержаниеУслугиИзменено = (СтрокаТаблицы.Содержание <> ПредыдущееСодержаниеУслуги);
		Иначе
			СодержаниеУслугиИзменено = Ложь;
		КонецЕсли;
		
		Если СодержаниеУслугиИзменено Тогда
			Продолжить;
		КонецЕсли;
		
		// Установим новое содержание услуги.
		СтрокаТаблицы.Содержание = РаботаСНоменклатуройКлиентСервер.СодержаниеУслуги(
			РеквизитыТекущейНоменклатуры.НаименованиеПолное,
			РеквизитыТекущейНоменклатуры.ПериодичностьУслуги,
			ТекущаяДата);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
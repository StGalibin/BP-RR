﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает сумму расходов, уменьшающих налог по ЕНВД.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - головная организация.
//   Период - Дата - период рассчета ЕНВД.
//   РегистрацияВНалоговомОргане - Массив - массив с регистрациями по которым необходимо получить расходы.
//                               - СправочникСсылка.РегистрацияВНалоговомОргане - регистрация по которой необходимо получить расходы.
//
// Возвращаемое значение:
//   Структура - описание см. в НоваяСтруктураРасходовЕНВД()
//
Функция РасходыЕНВДЗаКвартал(Организация, Период, РегистрацияВНалоговомОргане = Неопределено) Экспорт
	
	СтруктураРасходов = НоваяСтруктураРасходовЕНВД();
	
	НачалоПериода = НачалоКвартала(Период);
	КонецПериода  = КонецКвартала(Период);
	
	Если Не УчетнаяПолитика.ПлательщикЕНВДЗаПериод(Организация, НачалоПериода, КонецПериода) Тогда
		Возврат СтруктураРасходов;
	КонецЕсли;
	
	Запрос = Новый Запрос;

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РасходыУменьшающиеНалогПоОтдельнымРежимамОбороты.СчетУчета,
	|	РасходыУменьшающиеНалогПоОтдельнымРежимамОбороты.СуммаРасходаЕНВДОборот КАК СуммаРасходаЕНВД
	|ИЗ
	|	РегистрНакопления.РасходыУменьшающиеНалогПоОтдельнымРежимам.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			Организация = &Организация
	|				И &УсловиеПоРегистрацииВНалоговомОргане) КАК РасходыУменьшающиеНалогПоОтдельнымРежимамОбороты";
		
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
	
		Если ТипЗнч(РегистрацияВНалоговомОргане) = Тип("Массив") Тогда
			РегистрацииВНалоговыхОрганах = РегистрацияВНалоговомОргане;
		Иначе
			РегистрацииВНалоговыхОрганах = Новый Массив;
			РегистрацииВНалоговыхОрганах.Добавить(РегистрацияВНалоговомОргане);
		КонецЕсли;
	
		Запрос.УстановитьПараметр("РегистрацииВНалоговыхОрганах", РегистрацииВНалоговыхОрганах);
		
		УсловиеПоРегистрацииВНалоговомОргане = "РегистрацияВНалоговомОргане В(&РегистрацииВНалоговыхОрганах)";
		
	Иначе
		
		УсловиеПоРегистрацииВНалоговомОргане = "ИСТИНА";
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоРегистрацииВНалоговомОргане", УсловиеПоРегистрацииВНалоговомОргане);

	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат СтруктураРасходов;
	КонецЕсли;
	
	ТаблицаСчетов = УчетРасходовУменьшающихОтдельныеНалоги.СчетаРасходовУменьшающихНалог();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокиТаблицыСчетов = ТаблицаСчетов.НайтиСтроки(Новый Структура("СчетУчета", Выборка.СчетУчета));
		Если СтрокиТаблицыСчетов.Количество() <> 0 Тогда
			ВидРасхода = СтрокиТаблицыСчетов[0].ВидРасходов;
			Если СтруктураРасходов.Свойство(ВидРасхода) Тогда
				СтруктураРасходов[ВидРасхода]= СтруктураРасходов[ВидРасхода] + Выборка.СуммаРасходаЕНВД;
			КонецЕсли;
		Иначе
			СтруктураРасходов["ДобровольноеСтрахование"]= СтруктураРасходов["ДобровольноеСтрахование"] + Выборка.СуммаРасходаЕНВД;
		КонецЕсли;
		
	КонецЦикла;
		
	Возврат СтруктураРасходов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НоваяСтруктураРасходовЕНВД()
	
	СтруктураРасходов = Новый Структура;
	СтруктураРасходов.Вставить("СтраховыеВзносы", 0);
	СтруктураРасходов.Вставить("ФиксированныеВзносыИП", 0);
	СтруктураРасходов.Вставить("Больничные", 0);
	СтруктураРасходов.Вставить("ДобровольноеСтрахование", 0);
	
	Возврат СтруктураРасходов;
	
КонецФункции

#КонецОбласти

#КонецЕсли
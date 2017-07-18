﻿////////////////////////////////////////////////////////////////////////////////
// СписаниеСРасчетногоСчетаФормыВызовСервера: серверные процедуры и функции, 
// вызываемые из форм документа "Списание с расчетного счета".
//  
////////////////////////////////////////////////////////////////////////////////

Функция СвойстваСтрокРасшифровкиПлатежаСервер(Знач ПараметрыПлатежа, Знач ПолучатьДоговор) Экспорт
	
	Возврат ПоступлениеНаРасчетныйСчетФормы.СвойстваСтрокРасшифровкиПлатежаСервер(ПараметрыПлатежа, ПолучатьДоговор);
	
КонецФункции

Процедура ЗаполнитьОтражениеСтрокиВУСННаСервере(СтрокаПлатеж, Знач ПараметрыУСН) Экспорт
	
	НалоговыйУчетУСН.ЗаполнитьОтражениеВУСНСтрокиРасшифровкиПлатежа(СтрокаПлатеж, ПараметрыУСН);
	
КонецПроцедуры

Процедура УстановитьДоговорКонтрагента(ДоговорКонтрагента, Знач Контрагент, Знач Организация, Знач СписокВидовДоговоров, Знач Отбор = Неопределено) Экспорт
	
	РаботаСДоговорамиКонтрагентовБП.УстановитьДоговорКонтрагента(
		ДоговорКонтрагента, Контрагент, Организация, СписокВидовДоговоров, Отбор);
	
КонецПроцедуры

Процедура ОбработатьИзмененияВОрганизации(Знач Организация, ИспользоватьНесколькоБанковскихСчетовОрганизации, ОсновнойБанковскийСчетОрганизацииЗаполнен, СчетОрганизации) Экспорт
	
	ИспользоватьНесколькоБанковскихСчетовОрганизации =
		Справочники.БанковскиеСчета.ИспользуетсяНесколькоБанковскихСчетовОрганизации(Организация);
	
	ОсновнойБанковскийСчетОрганизацииЗаполнен =
		ПроверкаРеквизитовОрганизации.ОсновнойБанковскийСчетОрганизацииЗаполнен(Организация);
	
	Если
		НЕ ИспользоватьНесколькоБанковскихСчетовОрганизации
		И ОсновнойБанковскийСчетОрганизацииЗаполнен
		И НЕ ЗначениеЗаполнено(СчетОрганизации) Тогда
		СчетОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ОсновнойБанковскийСчет");
	КонецЕсли;
	
КонецПроцедуры
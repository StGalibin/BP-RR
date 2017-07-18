﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередОткрытиемФормыУведомленияТС(Организация, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПриВыбореВидаУведомления(Форма, ПараметрыУведомления) Экспорт
	
	ПараметрыУведомления.Вставить("ФормаВладелец", Форма);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииФормыПредложения",
		ЭтотОбъект, ПараметрыУведомления);
	
	УИД = Новый УникальныйИдентификатор("fbf0df61-5188-4ad6-9b8f-3ab01347ed31");
	ОткрытьФорму("Справочник.ТорговыеТочки.Форма.ФормаПредложенияСозданияТорговойТочки",,
		Форма, УИД,,, ОписаниеОповещения);
		
КонецПроцедуры

Процедура ПриЗакрытииФормыПредложения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия = "ОткрытьТорговыеТочки" Тогда
		
		Отбор = Новый Структура("Организация", ДополнительныеПараметры.Организация);
		ОткрытьФорму("Справочник.ТорговыеТочки.ФормаСписка", Новый Структура("Отбор", Отбор));
			
	ИначеЕсли РезультатЗакрытия = "ОткрытьУведомление" Тогда
		
		ФормаВладелец = ДополнительныеПараметры.ФормаВладелец;
		ДополнительныеПараметры.Удалить("ФормаВладелец");
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.ФормаОбъекта",
			ДополнительныеПараметры, ФормаВладелец);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

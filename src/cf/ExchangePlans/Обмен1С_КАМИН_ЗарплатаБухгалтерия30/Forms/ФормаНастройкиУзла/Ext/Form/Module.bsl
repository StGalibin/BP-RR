﻿//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтаФорма, "Обмен1С_КАМИН_ЗарплатаБухгалтерия30");
	
	РежимСинхронизацииСправочников = ?(ЗагружатьСправочникиИзБухгалтерииПредприятия, "СинхронизироватьДанные", "НеСинхронизироватьДанные");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗагружатьСправочникиИзБухгалтерииПредприятия = (РежимСинхронизацииСправочников = "СинхронизироватьДанные");
	
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры


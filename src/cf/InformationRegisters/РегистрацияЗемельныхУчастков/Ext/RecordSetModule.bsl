﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если Количество() = 1 Тогда
		Запись = Получить(0);
		
		Если Запись.ВидЗаписи = Перечисления.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("КодКатегорииЗемель");
			МассивНепроверяемыхРеквизитов.Добавить("КадастроваяСтоимость");
			МассивНепроверяемыхРеквизитов.Добавить("КБК");
			МассивНепроверяемыхРеквизитов.Добавить("НалоговаяСтавка");
			МассивНепроверяемыхРеквизитов.Добавить("ВидЗаписи");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
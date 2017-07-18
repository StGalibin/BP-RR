﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		Строки = Новый Массив;
		Если Не ПустаяСтрока(Фамилия) Тогда
			Строки.Добавить(Фамилия);
		КонецЕсли;
		Если Не ПустаяСтрока(Имя) Тогда
			Строки.Добавить(Имя);
		КонецЕсли;
		Если Не ПустаяСтрока(Отчество) Тогда
			Строки.Добавить(Отчество);
		КонецЕсли;
		Наименование = СтрСоединить(Строки, " ") + ?(ЗначениеЗаполнено(Должность), ", " + Должность, "");
	КонецЕсли;

	Если ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ЛичныйКонтакт Тогда
		ПользовательЛичногоКонтакта = ОбъектВладелец;
	Иначе
		ПользовательЛичногоКонтакта = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ТипЗнч(ОбъектВладелец) = Тип("СправочникСсылка.Контрагенты") Тогда
			ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента;
		ИначеЕсли ОбъектВладелец = Тип("СправочникСсылка.Пользователи") Тогда
			ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ЛичныйКонтакт;
		Иначе
			ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ПрочееКонтактноеЛицо;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
		
	Если ВидКонтактногоЛица <> Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОбъектВладелец");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры


#КонецЕсли
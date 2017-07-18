﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = ПолучитьДоступныеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска).ДоступныеЗначения;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Отбор") Тогда
		Параметры.Вставить("Отбор", Новый Структура);
	КонецЕсли;
	
	ДанныеВыбора = ПолучитьДоступныеЗначения(Параметры.Отбор, Неопределено).ДоступныеЗначения;
	Параметры.Отбор.Очистить();
	Параметры.Отбор.Вставить("Ссылка", ДанныеВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция ПолучитьСписокДоступныхЗначений(Отбор, ЕстьНедоступные = Ложь) Экспорт
	
	СтруктураДоступныхЗначений = ПолучитьДоступныеЗначения(Отбор, Неопределено);
	
	ЕстьНедоступные = СтруктураДоступныхЗначений.ЕстьНедоступные;
	
	Возврат СтруктураДоступныхЗначений.ДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция выполняет заполнение списка значений 
// данных выбора с учетом настроек параметров учета.
// Поддерживается параметр отбора.
// Обрабатывается также строка поиска.
//
Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска)
	
	Исключения = Новый Массив;
	
	Исключения.Добавить(Перечисления.ВидыОперацийРКО.РасчетыПоКредитамИЗаймам);
	
	Организация = Неопределено;
	Если ТипЗнч(Отбор) = Тип("Структура") И Отбор.Свойство("Организация") И ЗначениеЗаполнено(Отбор.Организация) Тогда
		Организация = Отбор.Организация;
	Иначе // Если отбор не передан, получим значение "по умолчанию", либо "единственную" организацию в ИБ.
		Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ЭтоЮрЛицо = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Организация);
	Иначе
		ЭтоЮрЛицо = Истина; // ИП обычно ведет в базе только себя, а в этом случае организация будет получена.
	КонецЕсли;
	
	Если ЭтоЮрЛицо ИЛИ НЕ ПолучитьФункциональнуюОпцию("ВестиУчетИндивидуальногоПредпринимателя") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.УплатаНалога);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ЛичныеСредстваПредпринимателя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация)
		И Справочники.БанковскиеСчета.КоличествоБанковскихСчетовОрганизации(Организация) = 0 Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВзносНаличнымиВБанк);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.Инкассация);
	ИначеЕсли НЕ Константы.ИспользоватьИнкассацию.Получить() Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.Инкассация);
	КонецЕсли;
	
	Если НЕ УчетЗарплаты.ИспользуетсяПодсистемаУчетаЗарплатыИКадров()
		ИЛИ (НЕ ЭтоЮрЛицо И НЕ УчетЗарплаты.ИПИспользуетТрудНаемныхРаботников(Организация))Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыПоВедомостям);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаДепонентов);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВыдачаЗаймаРаботнику);
		Исключения.Добавить(Перечисления.ВидыОперацийРКО.ВыплатаСотрудникуПоДоговоруПодряда);
	КонецЕсли;
	
	ДоступныеЗначения = Новый СписокЗначений;
	ЕстьНедоступные   = Ложь;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийРКО.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И СтрНайти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийРКО[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийРКО")
			И Отбор <> Ссылка Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ФиксированныйМассив")
			И Отбор.Найти(Ссылка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Исключения.Найти(Ссылка) <> Неопределено Тогда
			ЕстьНедоступные = Истина;
			Продолжить;
		КонецЕсли;
		ДоступныеЗначения.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
	Возврат Новый Структура("ДоступныеЗначения, ЕстьНедоступные", ДоступныеЗначения, ЕстьНедоступные);
	
КонецФункции

#КонецОбласти

#КонецЕсли
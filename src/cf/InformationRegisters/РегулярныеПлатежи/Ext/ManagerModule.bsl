﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Получаем запись регистра по последнему документу введенному по передаваемому правилу
// Если ДатаСреза = Неопределено, то возвращаем последний документ введенный по правилу
Функция ШаблонПравила(Организация, Правило, ДатаСреза = Неопределено) Экспорт

	Запрос  = Новый Запрос;
	Условия = Новый Массив;
	
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("Правило",       Правило);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РегулярныеПлатежи.ПлатежноеПоручение КАК ПлатежноеПоручение,
	|	РегулярныеПлатежи.ПериодСобытия
	|ИЗ
	|	РегистрСведений.РегулярныеПлатежи КАК РегулярныеПлатежи
	|ГДЕ
	|	&Условия
	|
	|УПОРЯДОЧИТЬ ПО
	|	РегулярныеПлатежи.ПериодСобытия УБЫВ,
	|	РегулярныеПлатежи.ПлатежноеПоручение.Дата УБЫВ";
	
	Если ЗначениеЗаполнено(ДатаСреза) Тогда
	
		Запрос.УстановитьПараметр("ДатаСреза", ДатаСреза);
		Условия.Добавить("РегулярныеПлатежи.ПериодСобытия <= &ДатаСреза");
	
	КонецЕсли; 
	
	Условия.Добавить("РегулярныеПлатежи.Правило = &Правило");
	Условия.Добавить("РегулярныеПлатежи.Организация = &Организация");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условия", СтрСоединить(Условия," И "));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
	
		Возврат Неопределено;
	
	Иначе
	
		Возврат ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(РезультатЗапроса);
	
	КонецЕсли; 
	
КонецФункции

Функция ЗаписьПравилаПоПлатежномуПоручению(ПлатежноеПоручение) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПлатежноеПоручение", ПлатежноеПоручение);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегулярныеПлатежи.Правило КАК Правило,
	|	РегулярныеПлатежи.ПериодСобытия КАК ПериодСобытия
	|ИЗ
	|	РегистрСведений.РегулярныеПлатежи КАК РегулярныеПлатежи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПлатежноеПоручение КАК ПлатежноеПоручениеПоПравилу
	|		ПО РегулярныеПлатежи.ПлатежноеПоручение = ПлатежноеПоручениеПоПравилу.Ссылка
	|			И РегулярныеПлатежи.Организация = ПлатежноеПоручениеПоПравилу.Организация
	|ГДЕ
	|	ПлатежноеПоручениеПоПравилу.Ссылка = &ПлатежноеПоручение";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат ОбщегоНазначенияБПВызовСервера.ПолучитьСтруктуруИзРезультатаЗапроса(РезультатЗапроса);
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
КонецФункции 

// Добавляем в набор записей по правилу новое платежное поручение, если добавление не нужно, возвращаем ЛОЖЬ
Функция ДобавитьЗаписьПравила(Организация, ПлатежноеПоручение, ПравилоРегулярногоПлатежа, ПериодСобытия) Экспорт
	
	ДанныеЗаполнения = НовыйСтруктураРегистра();
	СтруктураЗаписи = НовыйСтруктураРегистра();
	
	ОрганизацияПравила = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПравилоРегулярногоПлатежа, "Организация");
	
	Если Организация <> ОрганизацияПравила Тогда
		
		Если ЕстьЗаписиПоДругомуДокументу(Организация, ПравилоРегулярногоПлатежа, ПлатежноеПоручение) Тогда
			// Если по правилу существуют записи других документов по другой организации, то создается копия правила
			ОбъектПравила = ПравилоРегулярногоПлатежа.Скопировать();
			ОбъектПравила.Организация = Организация;
			ОбъектПравила.Записать();
			
			ПравилоРегулярногоПлатежа = ОбъектПравила.Ссылка;
		
		Иначе
		
			ОбъектПравила = ПравилоРегулярногоПлатежа.ПолучитьОбъект();
			ОбъектПравила.Организация = Организация;
			ОбъектПравила.Записать();
			
			// При изменении организации удаляем из задач бухгалтера по прошлой организации записи правила
			РегистрыСведений.ЗадачиБухгалтера.УдалитьЗаписиПоПравилу(ОрганизацияПравила, ПравилоРегулярногоПлатежа, Ложь);
		
		КонецЕсли; 
		
	КонецЕсли; 
	
	НаборЗаписей = РегистрыСведений.РегулярныеПлатежи.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПлатежноеПоручение.Установить(ПлатежноеПоручение);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
	
		ЗаписьПравила = НаборЗаписей[0];
		
	Иначе
		
		ЗаписьПравила = НаборЗаписей.Добавить();
	
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		СтруктураЗаписи,
		ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(ЗаписьПравила, Метаданные.РегистрыСведений.РегулярныеПлатежи));
		
	ДанныеЗаполнения.Вставить("Организация",        Организация);
	ДанныеЗаполнения.Вставить("ПлатежноеПоручение", ПлатежноеПоручение);
	ДанныеЗаполнения.Вставить("Правило",            ПравилоРегулярногоПлатежа);
	ДанныеЗаполнения.Вставить("ПериодСобытия",      ПериодСобытия);
	
	
	ЗаписьИзменена = Ложь;
	
	Если НЕ ОбщегоНазначения.ДанныеСовпадают(СтруктураЗаписи, ДанныеЗаполнения) Тогда
		
		ЗаполнитьЗначенияСвойств(ЗаписьПравила, ДанныеЗаполнения);
		
		НаборЗаписей.Записать();
		
		ЗаписьИзменена = Истина;
	
	КонецЕсли; 
	
	Возврат ЗаписьИзменена;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция НовыйСтруктураРегистра()

	Возврат Новый Структура("Организация, ПлатежноеПоручение, Правило, ПериодСобытия");

КонецФункции 

// Функция проверяет наличие записей по текущему правилу не соотвествующих текущей организации
Функция ЕстьЗаписиПоДругомуДокументу(Организация, Правило, ТекущееПлатежноеПоручение)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",               Организация);
	Запрос.УстановитьПараметр("ТекущееПлатежноеПоручение", ТекущееПлатежноеПоручение);
	Запрос.УстановитьПараметр("Правило",                   Правило);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегулярныеПлатежи.ПлатежноеПоручение
	|ИЗ
	|	РегистрСведений.РегулярныеПлатежи КАК РегулярныеПлатежи
	|ГДЕ
	|	РегулярныеПлатежи.Организация <> &Организация
	|	И РегулярныеПлатежи.Правило = &Правило
	|	И РегулярныеПлатежи.ПлатежноеПоручение <> &ТекущееПлатежноеПоручение";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
КонецФункции 

#КонецОбласти 

#КонецЕсли
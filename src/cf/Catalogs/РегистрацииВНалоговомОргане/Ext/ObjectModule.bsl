﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет значением по умолчанию код региона
//
Процедура ЗаполнитьКодРегиона() Экспорт
	
	Если ЗначениеЗаполнено(КодРегиона) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Возврат;
	КонецЕсли;
	
	КодРегиона = Лев(Код, 2);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
	
		ДанныеЗаполнения = Новый Структура("Владелец");
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И (НЕ ДанныеЗаполнения.Свойство("Владелец")
			ИЛИ НЕ ЗначениеЗаполнено(ДанныеЗаполнения.Владелец)) Тогда
		
		ДанныеЗаполнения.Вставить("Владелец", РегламентированнаяОтчетность.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"))
		
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И (НЕ ДанныеЗаполнения.Свойство("КПП")
			ИЛИ НЕ ЗначениеЗаполнено(ДанныеЗаполнения.КПП)) Тогда
			
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Владелец)
			И ТипЗнч(ДанныеЗаполнения.Владелец) = Тип("СправочникСсылка.Организации") 
			И ДанныеЗаполнения.Владелец.Метаданные().Реквизиты.Найти("КПП") <> Неопределено Тогда
			
			ДанныеЗаполнения.Вставить("КПП", ДанныеЗаполнения.Владелец.КПП);
			
		КонецЕсли;
			
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И (НЕ ДанныеЗаполнения.Свойство("Код")
			ИЛИ НЕ ЗначениеЗаполнено(ДанныеЗаполнения.Код)) Тогда
			
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Владелец)
			И ТипЗнч(ДанныеЗаполнения.Владелец) = Тип("СправочникСсылка.Организации")
			И ДанныеЗаполнения.Владелец.Метаданные().Реквизиты.Найти("КПП") <> Неопределено Тогда
			
			ДанныеЗаполнения.Вставить("Код", Лев(СокрЛ(ДанныеЗаполнения.Владелец.КПП), 4));
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
			
	Если НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Владелец) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КПП");
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Код) И СтрДлина(СокрЛП(Код)) <> 4 Тогда
		ТекстСообщения = "Поле ""Код налогового органа"" должно состоять из 4-х цифр.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Код", , Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КПП) И СтрДлина(СокрЛП(КПП)) <> 9 Тогда
		ТекстСообщения = "Поле ""КПП"" должно состоять из 9-ти символов.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.КПП", , Отказ);
	КонецЕсли;
		
	РегламентированнаяОтчетность.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	флЭтоПБОЮЛ = НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Владелец);
	
	Если ПустаяСтрока(Наименование) Тогда
		Наименование = НаименованиеИФНС;
	КонецЕсли;
	
	Если флЭтоПБОЮЛ Тогда
		КПП = "";
	КонецЕсли;
	
	СуществующаяЗапись = РегламентированнаяОтчетность.ПолучитьПоКодамРегистрациюВИФНС(Владелец, Код, КПП);
	
	Если СуществующаяЗапись <> Неопределено И СуществующаяЗапись <> Ссылка Тогда
		
		РегламентированнаяОтчетностьКлиентСервер.СообщитьОбОшибке(НСтр("ru = 'Для данной организации уже существует запись с указанными кодом налогового органа'") 
															  + ?(флЭтоПБОЮЛ, ".", НСтр("ru = ' и КПП.'")), Отказ);
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = НСтр("ru = 'Для данной организации уже существует запись с указанными кодом налогового органа'") 
						+ ?(флЭтоПБОЮЛ, ".", НСтр("ru = ' и КПП.'"));

		Сообщение.Сообщить();
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Представитель) Тогда
		ДокументПредставителя = "";
		УполномоченноеЛицоПредставителя = "";
	ИначеЕсли Метаданные.Справочники.Найти("ФизическиеЛица") <> Неопределено И ТипЗнч(Представитель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда	
		УполномоченноеЛицоПредставителя = "";
	КонецЕсли;
	
	ЗаполнитьКодРегиона();
	
	Если НЕ ПустаяСтрока(НаименованиеОбособленногоПодразделения) Тогда
		НаименованиеСлужебное = НаименованиеОбособленногоПодразделения;
	ИначеЕсли ЭтоНовый() Тогда
		// При вводе новой регистрации из формы подразделения или организации используется метод УстановитьСсылкуНового()
		// Полученная таким образом ссылка на новую регистрацию устанавливается в поле объекта справочника подразделений/организаций при записи
		// В этом случае метод ПолучитьСсылкуНового() вернет ссылку, которая уже установлена в объекте, "вызвавшем" создание регистрации		
		НаименованиеСлужебное = Справочники.РегистрацииВНалоговомОргане.НаименованиеСлужебное(ПолучитьСсылкуНового());
	Иначе	
		НаименованиеСлужебное = Справочники.РегистрацииВНалоговомОргане.НаименованиеСлужебное(Ссылка);
	КонецЕсли;	
		
КонецПроцедуры 

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Нужно привести КПП и код налогового органа организаций и подразделений текущего налогового органа
	// в соответствии с текущими значениями
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("РегистрацияВНалоговомОргане", Ссылка);
	Запрос.Параметры.Вставить("КПП", КПП);
	Запрос.Параметры.Вставить("КодНалоговогоОргана", Код);
	Запрос.Параметры.Вставить("НаименованиеИФНС", НаименованиеИФНС);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
	|	И (Организации.КПП <> &КПП
	|			ИЛИ Организации.КодНалоговогоОргана <> &КодНалоговогоОргана
	|			ИЛИ Организации.НаименованиеНалоговогоОргана <> &НаименованиеИФНС)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПодразделенияОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|ГДЕ
	|	ПодразделенияОрганизаций.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
	|	И ПодразделенияОрганизаций.КПП <> &КПП
	|	И ПодразделенияОрганизаций.ОбособленноеПодразделение = ИСТИНА";
	
	
	РеквизитыРегистрации = Новый Структура("КПП, КодНалоговогоОргана, НаименованиеНалоговогоОргана", КПП, Код, НаименованиеИФНС);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ОбъектРегистрации = Выборка.Ссылка.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(ОбъектРегистрации, РеквизитыРегистрации);
		ОбъектРегистрации.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

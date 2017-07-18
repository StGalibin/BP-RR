﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Свойство("Объект",) Тогда
			Объект.ПлатежныеПоручения.Загрузить(Результат.Объект.ПлатежныеПоручения);
		КонецЕсли;
		Если Результат.Свойство("Отказ",) Тогда
			Если Результат.Отказ Тогда
				ТекстСообщения = НСтр("ru = 'Не все документы выдачи наличных удалось провести!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискомРаботников()
	
	Результат = ЗаполнитьПоВедомости();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

	КонецЕсли;
	
КонецПроцедуры
	
&НаСервере
Функция ЗаполнитьПоВедомости()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана организация!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "Организация";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		Сообщение.Сообщить();
		
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
		
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("Организация",                   ОбработкаОбъект.Организация);
	СтруктураОбъекта.Вставить("ПлатежныеПоручения",            ОбработкаОбъект.ПлатежныеПоручения.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаПлатежныхПоручений",        ОбработкаОбъект.ДатаПлатежныхПоручений);
	
	ПараметрыЗаполнения = Новый Структура("Объект", СтруктураОбъекта);

	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.Автозаполнение(ПараметрыЗаполнения, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Создание платежных поручений на перечисление зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.Автозаполнение", 
			ПараметрыЗаполнения, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
		
	Если Результат.ЗаданиеВыполнено Тогда	
		ЗагрузитьРезультат();
	КонецЕсли;	
	
	Возврат Результат;
				
КонецФункции

&НаСервере
Функция СоздатьПлатежныеДокументы()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("Организация",                   ОбработкаОбъект.Организация);
	СтруктураОбъекта.Вставить("СчетОрганизации",               ОбработкаОбъект.СчетОрганизации);
	СтруктураОбъекта.Вставить("ПлатежныеПоручения",            ОбработкаОбъект.ПлатежныеПоручения.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаПлатежныхПоручений",        ОбработкаОбъект.ДатаПлатежныхПоручений);
	
	ПараметрыСоздания = Новый Структура("Объект", СтруктураОбъекта);
	
		
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.СоздатьПлатежныеПоручения(ПараметрыСоздания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Создание кассовых документов на выплату зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.СоздатьПлатежныеПоручения", 
			ПараметрыСоздания, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
		
	Если Результат.ЗаданиеВыполнено Тогда	
		ЗагрузитьРезультат();
	КонецЕсли;	
	
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция ПровестиПлатежныеДокументы()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ОбработкаОбъект.ПлатежныеПоручения.Количество() = 0 Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
   
	Если НЕ ЗначениеЗаполнено(ОбработкаОбъект.ДатаПлатежныхПоручений) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана дата, на которую регистрируются кассовые документы!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ДатаПлатежныхПоручений",,);
		
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиДвиженияДенежныхСредств") Тогда
		Если НЕ ЗначениеЗаполнено(ОбработкаОбъект.СтатьяДвиженияДенежныхСредств) Тогда
				ТекстСообщения = НСтр("ru = 'Не указана дата статья движения денежных средств!'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.СтатьяДвиженияДенежныхСредств",,);
				Возврат Новый Структура("ЗаданиеВыполнено", Истина);
		КонецЕсли;
	КонецЕсли;
	
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("Организация",                   ОбработкаОбъект.Организация);
	СтруктураОбъекта.Вставить("ПлатежныеПоручения",            ОбработкаОбъект.ПлатежныеПоручения.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаПлатежныхПоручений",        ОбработкаОбъект.ДатаПлатежныхПоручений);
	
	ПараметрыПроведения = Новый Структура("Объект", СтруктураОбъекта);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.ПровестиПлатежныеПоручения(ПараметрыПроведения, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проведение кассовых документов на выплату зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		Новый УникальныйИдентификатор,
		"Обработки.ВыплатаЗарплатыПлатежнымиПоручениями.ПровестиПлатежныеПоручения", 
		ПараметрыПроведения, 
		НаименованиеЗадания);
		
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда	
		ЗагрузитьРезультат();
	КонецЕсли;	
	
	Возврат Результат;
    	
КонецФункции

&НаСервере
Процедура УстановкаФлажков(Значение = Неопределено)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Если Значение = Неопределено Тогда 
		Для Каждого СтрокаТаблицы Из ОбработкаОбъект.ПлатежныеПоручения Цикл
			СтрокаТаблицы.Отметка = НЕ СтрокаТаблицы.Отметка;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблицы Из ОбработкаОбъект.ПлатежныеПоручения Цикл
			СтрокаТаблицы.Отметка = Значение;
		КонецЦикла;
	КонецЕсли;
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
				
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УчетДенежныхСредствБП.УстановитьБанковскийСчет(
		Объект.СчетОрганизации,
		Объект.Организация,
		Константы.ВалютаРегламентированногоУчета.Получить());
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Процедура ПлатежныеПорученияПлатежноеПоручениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеПорученияПлатежноеПоручениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПлатежнаяВедомостьПриИзменении(Элемент)
	
	ЗаполнитьСпискомРаботников();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	
	Если Объект.ПлатежныеПоручения.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана организация!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "Организация";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		Сообщение.Сообщить();
		
		Возврат
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указан счет организации!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "СчетОрганизации";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		Сообщение.Сообщить();
		
		Возврат
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаПлатежныхПоручений) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана дата, на которую регистрируются платежные документы!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "ДатаПлатежныхПоручений";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		Сообщение.Сообщить();
		
		Возврат
	КонецЕсли;
	
	Если ЭтаФорма.ИспользоватьСтатьиДвиженияДенежныхСредств Тогда		
		Если НЕ ЗначениеЗаполнено(Объект.СтатьяДвиженияДенежныхСредств) Тогда		
			ТекстСообщения = НСтр("ru = 'Не указана статья движения денежных средств!'");

			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст       = ТекстСообщения;
			Сообщение.Поле        = "СтатьяДвиженияДенежныхСредств";
			Сообщение.ПутьКДанным = "Объект";
			Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;		
	КонецЕсли;
	
	Результат = СоздатьПлатежныеДокументы();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

	Иначе
		ПровестиДокументы();
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокументы()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана организация!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "Организация";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		Сообщение.Сообщить();
		
		Возврат
	КонецЕсли;
	
	Результат = ПровестиПлатежныеДокументы();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	Иначе
		Оповестить("ИзменениеОплатыВедомости", , Объект.ПлатежнаяВедомость);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлаги(Команда)
	
	УстановкаФлажков(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлаги(Команда)
	
	УстановкаФлажков(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьФлаги(Команда)
	
	УстановкаФлажков();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	
	Результат = ЗаполнитьПоВедомости();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежнаяВедомостьОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
		Элемент = ПредопределенноеЗначение("Документ.ВедомостьНаВыплатуЗарплаты.ПустаяСсылка");
	Иначе
		Элемент = ПредопределенноеЗначение("Документ.ВедомостьНаВыплатуЗарплатыВБанк.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежнаяВедомостьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация",   Объект.Организация);
		ПараметрыФормы.Вставить("ВидМестаВыплаты", ПредопределенноеЗначение("Перечисление.ВидыМестВыплатыЗарплаты.БанковскийСчет"));
		ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплаты.ФормаВыбора",
			Новый Структура("ПараметрыОтбораСписка, ТекущаяСтрока", ПараметрыФормы, Объект.ПлатежнаяВедомость), Элемент);
	Иначе
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", Объект.Организация);
		ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплатыВБанк.ФормаВыбора",
			Новый Структура("Отбор, ТекущаяСтрока", ПараметрыФормы, Объект.ПлатежнаяВедомость), Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВКлиентБанк(Команда)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("РежимПоУмолчанию", "ГруппаВыгрузка");
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		СтруктураПараметров.Вставить("Организация", Объект.Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.СчетОрганизации) Тогда
		СтруктураПараметров.Вставить("БанковскийСчет", Объект.СчетОрганизации);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДатаПлатежныхПоручений) Тогда
		СтруктураПараметров.Вставить("НачПериода", Объект.ДатаПлатежныхПоручений);
		СтруктураПараметров.Вставить("КонПериода", Объект.ДатаПлатежныхПоручений);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КлиентБанк.Форма", СтруктураПараметров);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Объект.ДатаПлатежныхПоручений = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ИспользоватьСтатьиДвиженияДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиДвиженияДенежныхСредств");
	Элементы.СтатьяДвиженияДенежныхСредств.Видимость = ИспользоватьСтатьиДвиженияДенежныхСредств;
	Если ИспользоватьСтатьиДвиженияДенежныхСредств Тогда
		КонтекстОперации = Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗаработнойПлатыРаботнику;
		Объект.СтатьяДвиженияДенежныхСредств = УчетДенежныхСредствБП.СтатьяДДСПоУмолчанию(КонтекстОперации);
	КонецЕсли;
	
	УчетЗарплатыИКадровВоВнешнейПрограмме = ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме");
	
	Если НЕ Параметры.Свойство("ПлатежнаяВедомость") Тогда
		
		Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
			Объект.ПлатежнаяВедомость = Документы.ВедомостьНаВыплатуЗарплаты.ПустаяСсылка();
		Иначе
			Объект.ПлатежнаяВедомость = Документы.ВедомостьНаВыплатуЗарплатыВБанк.ПустаяСсылка();
		КонецЕсли;
		
	Иначе
		Объект.Организация        = Параметры.ПлатежнаяВедомость.Организация;
		Объект.ПлатежнаяВедомость = Параметры.ПлатежнаяВедомость;
	КонецЕсли;
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.ПлатежнаяВедомость) Тогда
		ЗаполнитьСпискомРаботников();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ЗавершениеРаботы Тогда
		Если ЭтотОбъект.РежимОткрытияОкна <> РежимОткрытияОкнаФормы.Независимый Тогда
			
			СтандартнаяОбработка = Ложь;
			
			СписокДокументов = Новый СписокЗначений;
			Для Каждого Документ ИЗ Объект.ПлатежныеПоручения Цикл
				Если ЗначениеЗаполнено(Документ.ПлатежноеПоручение) Тогда
					СписокДокументов.Добавить(Документ.ПлатежноеПоручение);
				КонецЕсли;
			КонецЦикла;
			Закрыть(СписокДокументов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

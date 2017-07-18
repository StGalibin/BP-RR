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
			Объект.РКО.Загрузить(Результат.Объект.РКО);
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
	СтруктураОбъекта.Вставить("РКО",                           ОбработкаОбъект.РКО.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаРКО",                       ОбработкаОбъект.ДатаРКО);
	
	ПараметрыЗаполнения = Новый Структура("Объект", СтруктураОбъекта);

	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыРасходнымиОрдерами.Автозаполнение(ПараметрыЗаполнения, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Создание кассовых документов на выплату зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ВыплатаЗарплатыРасходнымиОрдерами.Автозаполнение", 
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
	СтруктураОбъекта.Вставить("РКО",                           ОбработкаОбъект.РКО.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаРКО",                       ОбработкаОбъект.ДатаРКО);
	
	ПараметрыСоздания = Новый Структура("Объект", СтруктураОбъекта);
	
		
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыРасходнымиОрдерами.СоздатьРКО(ПараметрыСоздания, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Создание кассовых документов на выплату зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			Новый УникальныйИдентификатор,
			"Обработки.ВыплатаЗарплатыРасходнымиОрдерами.СоздатьРКО", 
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
	
	Если ОбработкаОбъект.РКО.Количество() = 0 Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
   
	Если НЕ ЗначениеЗаполнено(ОбработкаОбъект.ДатаРКО) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана дата, на которую регистрируются кассовые документы!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ДатаРКО",,);
		
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
	СтруктураОбъекта.Вставить("РКО",                           ОбработкаОбъект.РКО.Выгрузить());
	СтруктураОбъекта.Вставить("ПлатежнаяВедомость",            ОбработкаОбъект.ПлатежнаяВедомость);
	СтруктураОбъекта.Вставить("СтатьяДвиженияДенежныхСредств", ОбработкаОбъект.СтатьяДвиженияДенежныхСредств);
	СтруктураОбъекта.Вставить("ДатаРКО",                       ОбработкаОбъект.ДатаРКО);
	
	ПараметрыПроведения = Новый Структура("Объект", СтруктураОбъекта);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		Обработки.ВыплатаЗарплатыРасходнымиОрдерами.ПровестиРКО(ПараметрыПроведения, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проведение кассовых документов на выплату зарплаты'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		Новый УникальныйИдентификатор,
		"Обработки.ВыплатаЗарплатыРасходнымиОрдерами.ПровестиРКО", 
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
		Для Каждого СтрокаТаблицы Из ОбработкаОбъект.РКО Цикл
			СтрокаТаблицы.Отметка = НЕ СтрокаТаблицы.Отметка;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаТаблицы Из ОбработкаОбъект.РКО Цикл
			СтрокаТаблицы.Отметка = Значение;
		КонецЦикла;
	КонецЕсли;
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
				
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ТАБЛИЧНОЙ ЧАСТИ

&НаКлиенте
Процедура РКОРКОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РКОРКООчистка(Элемент, СтандартнаяОбработка)
	
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
	
	Если Объект.РКО.Количество() = 0 Тогда
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
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаРКО) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана дата, на которую регистрируются кассовые документы!'");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст       = ТекстСообщения;
		Сообщение.Поле        = "ДатаРКО";
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

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокументы(Команда)
	
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
		Элемент = ПредопределенноеЗначение("Документ.ВедомостьНаВыплатуЗарплатыВКассу.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежнаяВедомостьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация",   Объект.Организация);
		ПараметрыФормы.Вставить("ВидМестаВыплаты", ПредопределенноеЗначение("Перечисление.ВидыМестВыплатыЗарплаты.Касса"));
		ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплаты.ФормаВыбора",
			Новый Структура("ПараметрыОтбораСписка, ТекущаяСтрока", ПараметрыФормы, Объект.ПлатежнаяВедомость), Элемент);
	Иначе
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", Объект.Организация);
		ОткрытьФорму("Документ.ВедомостьНаВыплатуЗарплатыВКассу.ФормаВыбора",
			Новый Структура("Отбор, ТекущаяСтрока", ПараметрыФормы, Объект.ПлатежнаяВедомость), Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	Объект.ДатаРКО = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ИспользоватьСтатьиДвиженияДенежныхСредств = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиДвиженияДенежныхСредств");
	Элементы.СтатьяДвиженияДенежныхСредств.Видимость = ИспользоватьСтатьиДвиженияДенежныхСредств;
	Если ИспользоватьСтатьиДвиженияДенежныхСредств Тогда
		КонтекстОперации = Перечисления.ВидыОперацийРКО.ВыплатаЗаработнойПлатыРаботнику;
		Объект.СтатьяДвиженияДенежныхСредств = УчетДенежныхСредствБП.СтатьяДДСПоУмолчанию(КонтекстОперации);
	КонецЕсли;
	
	УчетЗарплатыИКадровВоВнешнейПрограмме = ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровВоВнешнейПрограмме");
	
	Если НЕ Параметры.Свойство("ПлатежнаяВедомость") Тогда
		
		Если УчетЗарплатыИКадровВоВнешнейПрограмме Тогда
			Объект.ПлатежнаяВедомость = Документы.ВедомостьНаВыплатуЗарплаты.ПустаяСсылка();
		Иначе
			Объект.ПлатежнаяВедомость = Документы.ВедомостьНаВыплатуЗарплатыВКассу.ПустаяСсылка();
		КонецЕсли;
		
	Иначе
		Объект.Организация        = Параметры.ПлатежнаяВедомость.Организация;
		Объект.ПлатежнаяВедомость = Параметры.ПлатежнаяВедомость;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.ПлатежнаяВедомость) Тогда
		ЗаполнитьСпискомРаботников();
	КонецЕсли;
		
КонецПроцедуры

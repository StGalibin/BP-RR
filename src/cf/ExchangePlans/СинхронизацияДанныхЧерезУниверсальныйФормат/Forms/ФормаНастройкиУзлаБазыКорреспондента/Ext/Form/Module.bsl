﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = "СинхронизацияДанныхЧерезУниверсальныйФормат";
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаБазыКорреспондентаПриСозданииНаСервере(ЭтаФорма, ИмяПланаОбмена);
	
	Если Не ЗначениеЗаполнено(ПравилаОтправкиСправочников) Тогда
		ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПравилаОтправкиДокументов) Тогда
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(РежимВыгрузкиПриНеобходимости) тогда
		РежимВыгрузкиПриНеобходимости = 
			Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	КонецЕсли;

	Если ИспользоватьОтборПоОрганизациям Тогда
		
		ПравилоОтбораСправочников = "Отбор";
		
	Иначе
		
		Если ВыгружатьУправленческуюОрганизацию Тогда
			ПравилоОтбораСправочников = "УпрОрганизация";
		Иначе
			ПравилоОтбораСправочников = "БезОтбора";
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УстановитьДатуЗапретаИзменений",
		"Доступность",
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ДатыЗапретаИзменения));
		
	Результат = ОбменДаннымиПовтИсп.УстановитьВнешнееСоединениеСБазой(ПараметрыВнешнегоСоединения);
	
	Если Результат.Соединение = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ПодробноеОписаниеОшибки,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	ВнешнееСоединение = Результат.Соединение;
	
	ИдентификаторНастройки = "";
	Параметры.Свойство("ИдентификаторНастройки", ИдентификаторНастройки);
	СтруктураФункциональныхОпций = Новый Структура();
	Если ИдентификаторНастройки = "ОбменУТБП" Или ИдентификаторНастройки = "ОбменУТ11" Или ИдентификаторНастройки = "ОбменУПБП" Тогда
		Если Не ЗначениеЗаполнено(УправленческаяОрганизация_Ключ) Тогда
			УправленческаяОрганизация      = ВнешнееСоединение.Справочники.Организации.УправленческаяОрганизация.Наименование;
			УправленческаяОрганизация_Ключ = ВнешнееСоединение.ОбменДаннымиУТУП.СсылкаУправленческойОрганизации();
		КонецЕсли;
		СтруктураФункциональныхОпций.Вставить("ИспользоватьУправленческуюОрганизацию",              ВнешнееСоединение.ПолучитьФункциональнуюОпцию("ИспользоватьУправленческуюОрганизацию"));
		СтруктураФункциональныхОпций.Вставить("ИспользоватьНесколькоОрганизаций",                   ВнешнееСоединение.ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций"));
	Иначе
		СтруктураФункциональныхОпций.Вставить("ИспользоватьУправленческуюОрганизацию",              Ложь);
		СтруктураФункциональныхОпций.Вставить("ИспользоватьНесколькоОрганизаций",                   Ложь);
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбновитьДанныеОбъекта(ВыбранноеЗначение);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФлагИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИПоНеобходимостиПриИзменении(Элемент)
	
	Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" 
		И ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
		
	КонецЕсли;
	
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтправлятьНСИНикогдаПриИзменении(Элемент)
	ПравилаОтправкиДокументов = "НеСинхронизировать";
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьАвтоматическиПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыОтправлятьВручнуюПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательДокументыНеОтправлятьПриИзменении(Элемент)
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковСОтборомПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораСУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОтбораСправочниковБезОтбораБезУпрПриИзменении(Элемент)
	УстрановитьУсловияОрганиченияСинхронизации();
	УстановитьВидимостьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	// Очистка неиспользуемых реквизитов и заполнение служебных
	
	РежимВыгрузкиПриНеобходимости = 
		ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		
	ИначеЕсли ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости");
		
	Иначе
		
		РежимВыгрузкиСправочников = 
			ПредопределенноеЗначение("Перечисление.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию");
		
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	// Сохранение настроек
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокВыбранныхОрганизаций(Команда)
	
	Если Не ВыгружатьУправленческуюОрганизацию
		И Не СтруктураФункциональныхОпций.ИспользоватьУправленческуюОрганизацию Тогда
		КоллекцияФильтров = Новый Массив;
		
		Накладываемыефильтры = Новый Структура();
		Накладываемыефильтры.Вставить("РеквизитОтбора",    "Идентификатор");
		Накладываемыефильтры.Вставить("Условие",           "<>");
		Накладываемыефильтры.Вставить("ИмяПараметра",      "ИсключаемаяСсылка");
		Накладываемыефильтры.Вставить("ЗначениеПараметра", УправленческаяОрганизация_Ключ);
		
		КоллекцияФильтров.Добавить(Накладываемыефильтры);
	Иначе
		КоллекцияФильтров = Неопределено;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ИмяЭлементаФормыДляЗаполнения",          "Организации");
	ПараметрыФормы.Вставить("ИмяРеквизитаЭлементаФормыДляЗаполнения", "Организация");
	ПараметрыФормы.Вставить("ИмяТаблицыВыбора",                       "Справочник.Организации");
	ПараметрыФормы.Вставить("ЗаголовокФормыВыбора",                   НСтр("ru = 'Выберете организации для отбора:'"));
	ПараметрыФормы.Вставить("МассивВыбранныхЗначений",                СформироватьМассивВыбранныхЗначений(ПараметрыФормы));
	ПараметрыФормы.Вставить("ПараметрыВнешнегоСоединения",            ПараметрыВнешнегоСоединения);
	ПараметрыФормы.Вставить("КоллекцияФильтров",                      КоллекцияФильтров);

	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДополнительныхУсловий",
		ПараметрыФормы,
		ЭтаФорма);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДатаНачалаВыгрузкиДокументов",
		"Доступность",
		ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПереключательДокументыНеОтправлять",
		"Доступность",
		Не ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы.ГруппаДокументы.ПодчиненныеЭлементы,
		"ГруппаДокументы",
		"Доступность",
		Не ПравилаОтправкиСправочников = "НеСинхронизировать");
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаНастройкаДополнительныхОтборов",
		"Видимость",
		ПравилаОтправкиСправочников <> "НеСинхронизировать" Или ПравилаОтправкиДокументов <> "НеСинхронизировать");
		
	#Область ГруппаСтраницыОтборПоОрганизациям
	
	ВидимостьОтбораПоОрганизации = СтруктураФункциональныхОпций.ИспользоватьНесколькоОрганизаций
									И ПравилаОтправкиСправочников <> "НеСинхронизировать";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаСтраницыОтборПоОрганизациям",
		"Видимость",
		ВидимостьОтбораПоОрганизации);
		
	Если ВидимостьОтбораПоОрганизации Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				"ОткрытьСписокВыбранныхОрганизаций",
				"Доступность",
				ИспользоватьОтборПоОрганизациям);
		
		//Видимость управленческой организации и вариантаотбора
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ГруппаВыборУправленческойОрганизации",
			"Видимость",
			СтруктураФункциональныхОпций.ИспользоватьУправленческуюОрганизацию);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФлагИспользоватьОтборПоОрганизациям",
			"Видимость",
			НЕ СтруктураФункциональныхОпций.ИспользоватьУправленческуюОрганизацию);
		
	КонецЕсли;
	#КонецОбласти

	#Область ГруппаПрочее
	ВидимостьГруппы = ПравилаОтправкиДокументов <> "НеСинхронизировать"
		Или ПравилаОтправкиСправочников <> "НеСинхронизировать";
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПрочее",
		"Видимость",
		ВидимостьГруппы);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ВыгружатьАналитикуПоСкладам",
		"Видимость",
		ПравилаОтправкиДокументов <> "НеСинхронизировать");
	#КонецОбласти

КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеОбъекта(СтруктураПараметров)
	
	ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Очистить();
	
	СписокВыбранныхЗначений = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресТаблицыВоВременномХранилище);
	
	Если СписокВыбранныхЗначений.Количество() > 0 Тогда
		СписокВыбранныхЗначений.Колонки.Представление.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения;
		СписокВыбранныхЗначений.Колонки.Идентификатор.Имя = СтруктураПараметров.ИмяКолонкиДляЗаполнения + "_Ключ";
		ЭтаФорма[СтруктураПараметров.ИмяТаблицыДляЗаполнения].Загрузить(СписокВыбранныхЗначений);
	КонецЕсли;
	
	ОбновитьНаименованиеКомандФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаименованиеКомандФормы()
	
	//Обновим заголовок выбранных организаций
	Если Организации.Количество() > 0 Тогда
		
		ВыбранныеОрганизации = Организации.Выгрузить().ВыгрузитьКолонку("Организация");
		НовыйЗаголовокОрганизаций = СтрСоединить(ВыбранныеОрганизации, ",");
		
	Иначе
		
		НовыйЗаголовокОрганизаций = НСтр("ru = 'Выбрать организации'");
		
	КонецЕсли;
	
	Элементы.ОткрытьСписокВыбранныхОрганизаций.Заголовок = НовыйЗаголовокОрганизаций;
	
	
КонецПроцедуры

&НаСервере
Функция СформироватьМассивВыбранныхЗначений(ПараметрыФормы)
	
	Возврат ЭтаФорма[ПараметрыФормы.ИмяЭлементаФормыДляЗаполнения].Выгрузить(,ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения + "_Ключ").ВыгрузитьКолонку(ПараметрыФормы.ИмяРеквизитаЭлементаФормыДляЗаполнения + "_Ключ");
	
КонецФункции

&НаКлиенте
Процедура УстрановитьУсловияОрганиченияСинхронизации()
	
	Если ПравилоОтбораСправочников = "Отбор" Тогда
		
		ИспользоватьОтборПоОрганизациям = Истина;
		ВыгружатьУправленческуюОрганизацию = Ложь;
		
	ИначеЕсли ПравилоОтбораСправочников = "УпрОрганизация" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		ВыгружатьУправленческуюОрганизацию = Истина;
		
	ИначеЕсли ПравилоОтбораСправочников = "БезОтбора" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		ВыгружатьУправленческуюОрганизацию = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
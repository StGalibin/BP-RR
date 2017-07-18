﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("РежимРасшифровки") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ВидПлатежа");
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры, "РежимРасшифровки");
	
	Если Параметры.Свойство("ЕстьУплаченныеСтраховыеВзносы") Тогда
		ЕстьУплаченныеСтраховыеВзносы = Параметры.ЕстьУплаченныеСтраховыеВзносы;
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма, ВидПлатежа);
	
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	
	Если ПодключитьОбработчикОжидания Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	ВариантМодифицирован = Ложь;
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
	Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
	ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПриИзмененииПериода(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода, ВидПериода", Отчет.НачалоПериода, Отчет.КонецПериода, ВидПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбора, Элементы.Период, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	ОбновитьТекстЗаголовка(ЭтаФорма, ВидПлатежа);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	Отчет.КонецПериода = КонецМесяца(ДобавитьМесяц(Отчет.КонецПериода, -3));
	ПриИзмененииПериода(Элементы.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	Отчет.КонецПериода = КонецМесяца(ДобавитьМесяц(Отчет.КонецПериода, 3));
	ПриИзмененииПериода(Элементы.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма, ВидПлатежа);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	УстановитьНастройкиКомпоновщика();
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("ВидПлатежа"                       , ВидПлатежа);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВидПлатежа"                       , ВидПлатежа);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , МакетОформления);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , ВыводитьЕдиницуИзмерения);
	ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры"));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма, ВидРасшифровки)
	
	Отчет = Форма.Отчет;
	Форма.Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода, Истина);
	
	НомерКвартала = 4;
	
	Если СтрНайти(Врег(Форма.Период), "КВАРТАЛ") > 0 Тогда
		НомерКвартала = Число(Лев(Форма.Период, 1));
	КонецЕсли;
	
	Если ВидРасшифровки = "АвансовыеПлатежи" Тогда
		Если НомерКвартала = 1 Тогда
			ЗаголовокОтчета = НСтр("ru = 'Авансовый платеж за '");
		Иначе
			ЗаголовокОтчета = НСтр("ru = 'Авансовые платежи за '");
		КонецЕсли;
	Иначе
		ЗаголовокОтчета = НСтр("ru = 'Уплаченные страховые взносы за '");
	КонецЕсли;
	
	ЗаголовокОтчета = ЗаголовокОтчета + Форма.Период;
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Параметры");
	СписокПолей.Добавить("Ресурсы");
	СписокПолей.Добавить("Группировки");
	СписокПолей.Добавить("Организация");
	СписокПолей.Добавить("Подразделение");
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Процедура УстановитьСчетаДт()
	
	СписокСчетовНачислено = Новый СписокЗначений();
	СписокСчетовУплачено = Новый СписокЗначений();
	
	Если ВидПлатежа = "СтраховыеВзносы" Тогда
		СписокСчетовУплачено.ЗагрузитьЗначения(УчетРасходовУменьшающихОтдельныеНалоги.СчетаСтраховыхВзносовУменьшающихНалог());
	ИначеЕсли ВидПлатежа = "АвансовыеПлатежи" Тогда
		СписокСчетовНачислено.Добавить(ПланыСчетов.Хозрасчетный.ПрибылиИУбыткиНеЕНВД); // 99.01.1
		СписокСчетовУплачено.Добавить(ПланыСчетов.Хозрасчетный.ЕНприУСН); // 68.12
	КонецЕсли;
	
	ПараметрСчетаДтНачислено = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СчетаДтНачислено");
	ПараметрСчетаДтНачислено.Использование = Истина;
	ПараметрСчетаДтНачислено.Значение = СписокСчетовНачислено;
	
	ПараметрСчетаДтУплачено = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СчетаДтУплачено");
	ПараметрСчетаДтУплачено.Использование = Истина;
	ПараметрСчетаДтУплачено.Значение = СписокСчетовУплачено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСчетаКт()
	
	СписокСчетовНачислено = Новый СписокЗначений();
	СписокСчетовУплачено = Новый СписокЗначений();
	
	СписокСчетовУплачено.Добавить(ПланыСчетов.Хозрасчетный.КассаОрганизации); // 50.01
	СписокСчетовУплачено.Добавить(ПланыСчетов.Хозрасчетный.РасчетныеСчета);   // 51
	
	Если ВидПлатежа = "АвансовыеПлатежи" Тогда
		СписокСчетовНачислено.Добавить(ПланыСчетов.Хозрасчетный.ЕНприУСН); // 68.12
		
		ПараметрСчетаКтНачислено = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СчетаКтНачислено");
		ПараметрСчетаКтНачислено.Использование = Истина;
		ПараметрСчетаКтНачислено.Значение = СписокСчетовНачислено;
	КонецЕсли;
	
	ПараметрСчетаКтУплачено = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СчетаКтУплачено");
	ПараметрСчетаКтУплачено.Использование = Истина;
	ПараметрСчетаКтУплачено.Значение = СписокСчетовУплачено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидПлатежей()
	
	ПараметрВидыПлатежей = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ВидыПлатежей");
	ПараметрВидыПлатежей.Использование = Истина;
	ПараметрВидыПлатежей.Значение = Перечисления.ВидыПлатежейВГосБюджет.ВидыНалоговыхПлатежей();
	
КонецПроцедуры

&НаСервере
Функция НачисленныеАвансовыеПлатежи()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",   Отчет.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Отчет.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  Отчет.КонецПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетНалогаУСН.ПериодРасчета,
	|	РасчетНалогаУСН.Организация,
	|	РасчетНалогаУСН.НалогИсчисленныйВсего
	|ИЗ
	|	РегистрСведений.РасчетНалогаУСН КАК РасчетНалогаУСН
	|ГДЕ
	|	РасчетНалогаУСН.Организация = &Организация
	|	И РасчетНалогаУСН.ПериодРасчета МЕЖДУ &НачалоПериода И &КонецПериода
	|	И РасчетНалогаУСН.Активность";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	
	Возврат Выборка.Итог("НалогИсчисленныйВсего");
КонецФункции

&НаСервере
Функция УплаченныеАвансовыеПлатежи()
	
	СчетОтраженияНалога  = ПланыСчетов.Хозрасчетный.ПрибылиИУбыткиНеЕНВД; // Дт 99.01.1
	СчетНачисленияНалога = ПланыСчетов.Хозрасчетный.ЕНприУСН;             // Кт 68.12
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация",          Отчет.Организация);
	Запрос.УстановитьПараметр("НачалоПериода",        Отчет.НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",         ДобавитьМесяц(Отчет.КонецПериода, 1));
	Запрос.УстановитьПараметр("СчетНачисленияНалога", СчетНачисленияНалога);
	Запрос.УстановитьПараметр("СчетОтраженияНалога",  СчетОтраженияНалога);
	Запрос.УстановитьПараметр("ВидыПлатежей",         Перечисления.ВидыПлатежейВГосБюджет.ВидыНалоговыхПлатежей());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сумма(ЕСТЬNULL(ХозрасчетныйОборотыДтКт.СуммаОборот, 0)) КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			СчетДт = &СчетОтраженияНалога,
	|			,
	|			СчетКт = &СчетНачисленияНалога,
	|			ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ВидыПлатежейВГосБюджет),
	|			Организация = &Организация
	|				И СубконтоКт1 В (&ВидыПлатежей)) КАК ХозрасчетныйОборотыДтКт";
	
	Выборка = Запрос.Выполнить().Выгрузить();
	
	Возврат Выборка.Итог("Сумма");
	
КонецФункции

&НаСервере
Процедура УстановитьНастройкиКомпоновщика()
	
	ТекНастройкиКомпоновщика = Отчет.КомпоновщикНастроек.Настройки;
	ТекНастройкиКомпоновщика.Структура.Очистить();
	
	УплаченныеАвансовыеПлатежи = УплаченныеАвансовыеПлатежи();
	
	Если ВидПлатежа = "АвансовыеПлатежи" Тогда
		НачисленныеАвансовыеПлатежи = НачисленныеАвансовыеПлатежи();
		
		Если НачисленныеАвансовыеПлатежи > 0 Тогда
			ГруппировкаНачислено = ТекНастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ГруппировкаНачислено.Имя = "Документ начисления";
			ГруппировкаНачислено.Использование = Истина;
			
			ПолеГруппировкиНачислено = ГруппировкаНачислено.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировкиНачислено.Использование  = Истина;
			ПолеГруппировкиНачислено.Поле           = Новый ПолеКомпоновкиДанных("ДокументНачисления");
			ПолеГруппировкиНачислено.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ПолеГруппировкиНачислено.ТипДополнения  = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
			
			ВыбранноеПоле      = ГруппировкаНачислено.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ДокументНачисления");
			ВыбранноеПоле      = ГруппировкаНачислено.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СуммаНачисления");
			
			ЭлементУО = ГруппировкаНачислено.УсловноеОформление.Элементы.Добавить();
			КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДокументНачисления");
			ЭлементУО.Оформление.УстановитьЗначениеПараметра("МинимальнаяШирина", 55);
			
			ЭлементУО = ГруппировкаНачислено.УсловноеОформление.Элементы.Добавить();
			КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СуммаНачисления");
			ЭлементУО.Оформление.УстановитьЗначениеПараметра("МинимальнаяШирина", 13);
			
			ГруппировкаОтступ = ТекНастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ГруппировкаОтступ.Имя = "";
			ГруппировкаОтступ.Использование = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидПлатежа = "АвансовыеПлатежи" И УплаченныеАвансовыеПлатежи > 0 Тогда
		
		ГруппировкаОплачено               = ТекНастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ГруппировкаОплачено.Имя           = "Документ оплаты";
		ГруппировкаОплачено.Использование = Истина;
		
		ПолеГруппировкиОплачено                = ГруппировкаОплачено.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировкиОплачено.Использование  = Истина;
		ПолеГруппировкиОплачено.Поле           = Новый ПолеКомпоновкиДанных("ДокументОплаты");
		ПолеГруппировкиОплачено.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		ПолеГруппировкиОплачено.ТипДополнения  = ТипДополненияПериодаКомпоновкиДанных.БезДополнения;
		
		ВыбранноеПоле      = ГруппировкаОплачено.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ДокументОплаты");
		ВыбранноеПоле      = ГруппировкаОплачено.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СуммаОплаты");
		ВыбранноеПоле      = ГруппировкаОплачено.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		
		ЭлементУО = ГруппировкаОплачено.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДокументОплаты");
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("МинимальнаяШирина", 55);
		
		ЭлементУО = ГруппировкаОплачено.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СуммаОплаты");
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("МинимальнаяШирина", 13);
		
	ИначеЕсли ВидПлатежа = "СтраховыеВзносы" И ЕстьУплаченныеСтраховыеВзносы Тогда
		
		ДетальнаяГруппировка               = ТекНастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ДетальнаяГруппировка.Имя           = "Детальная";
		ДетальнаяГруппировка.Использование = Истина;
		
		ВыбранноеПоле      = ДетальнаяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ДокументОплаты");
		ВыбранноеПоле      = ДетальнаяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СчетУчета");
		ВыбранноеПоле      = ДетальнаяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СуммаОплаты");

		ЭлементУО = ДетальнаяГруппировка.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ДокументОплаты");
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("МаксимальнаяШирина", 20);
		
		ЭлементУО = ДетальнаяГруппировка.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчета");
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("МаксимальнаяШирина", 40);
		
		ЭлементУО = ДетальнаяГруппировка.УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СуммаОплаты");
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("МинимальнаяШирина", 13);
	КонецЕсли;
	
	УстановитьСчетаДт();
	УстановитьСчетаКт();
	УстановитьВидПлатежей();
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", Ложь);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , Ложь);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет",
		ПараметрыОтчета,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат           = РезультатВыполнения.Результат;
	ДанныеРасшифровки   = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
			Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата"              , Отчет.КонецПериода);
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПериода(Элемент)
	
	ВыборПериодаКлиент.ПериодПриИзменении(Элемент, Период, Отчет.НачалоПериода, Отчет.КонецПериода);
	
	Если НЕ ПустаяСтрока(Период) Тогда
		Отчет.НачалоПериода = НачалоГода(Отчет.КонецПериода);
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма, ВидПлатежа);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма, ВидПлатежа); 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
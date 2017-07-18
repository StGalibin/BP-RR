﻿// Форма предназначена только для записанного элемента справочника.

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Первоначальная настройка формы.
	ОрганизацииФормыДляОтчетности.НастроитьЭлементыКонтактнойИнформации(ЭтотОбъект);
	ОрганизацииФормыДляОтчетности.НастроитьЭлементыСистемыНалогообложения(УсловноеОформление);
	
	ОрганизацииФормыДляОтчетности.УстановитьПроверяемыеДанные(
		Объект.Ссылка,
		Параметры.ПроверяемыеРеквизиты,
		Параметры.Контекст,
		АдресПроверяемыеДанные,
		УникальныйИдентификатор);
	ОрганизацииФормыДляОтчетности.НастроитьПроверяемыеРеквизиты(ЭтотОбъект, АдресПроверяемыеДанные);
	
	// В форму могли передать данные для заполнения.
	Если Параметры.Свойство("ПоискИННОтвет") Тогда
		
		Объект.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		
		ЗаполнитьДаннымиЕГР(Параметры.ПоискИННОтвет);
		
		ПроверитьИНН(ПояснениеНекорректныйИНН, Объект.ИНН);
		
	КонецЕсли;
	
	ОрганизацииФормыДляОтчетностиКлиентСервер.УстановитьВидимостьПодсказкиОКВЭД2(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	НастроитьКомандыАвтозаполнения();
	
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, Объект);
	
	ОрганизацииФормыДляОтчетности.ПрочитатьСистемуНалогообложения(СистемаНалогообложенияПредставление, Объект.Ссылка);
	
	ОрганизацииФормыДляОтчетности.ПрочитатьДанныеНалоговогоОргана(
		Объект.РегистрацияВНалоговомОргане,
		ЭтотОбъект,
		ПоляРегистрацииВНалоговомОргане());
	
	ПроверитьИНН(ПояснениеНекорректныйИНН, Объект.ИНН);
	ПояснениеНекорректныйКодПоОКТМО = ОрганизацииФормыДляОтчетностиКлиентСервер.ПроверитьКодПоОКТМО(КодПоОКТМО);
	
	// ПриЧтенииНаСервере может быть выполнено до ПриСозданииНаСервере, а может быть и не выполнено.
	// Поэтому установка проверяемых данных предусмотрена в обоих обработчиках.
	// Однако фактический разбор переданного параметра выполняется только один раз.

	ОрганизацииФормыДляОтчетности.УстановитьПроверяемыеДанные(
		Объект.Ссылка,
		Параметры.ПроверяемыеРеквизиты,
		Параметры.Контекст,
		АдресПроверяемыеДанные,
		УникальныйИдентификатор);
	ВключитьИПИспользуетТрудНаемныхРаботников = НадоВключитьИПИспользуетТрудНаемныхРаботников(АдресПроверяемыеДанные);
	НастроитьЭлементыПриИспользованииТрудаНаемныхРаботников();
	
	ОрганизацииФормыДляОтчетностиКлиентСервер.УстановитьВидимостьПодсказкиОКВЭД2(ЭтотОбъект);
	
	ОрганизацииФормыДляОтчетностиКлиентСервер.УстановитьЗаголовокФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	ОрганизацииФормыДляОтчетности.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, АдресПроверяемыеДанные, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВключитьИПИспользуетТрудНаемныхРаботников();

	ОрганизацииФормыДляОтчетности.ПередЗаписьюКонтактнойИнформации(ЭтотОбъект, ТекущийОбъект, Отказ);
	
	ЗначенияКлючевыхПолейРегистрацииНаФорме = ОрганизацииФормыДляОтчетности.ЗначенияПолейРегистрацииВНалоговомОргане(
		ЭтотОбъект,
		ПоляРегистрацииВНалоговомОргане(Истина));
	
	ОрганизацииФормыДляОтчетности.НачатьЗаписьРеквизитовГосударственныхОрганов(
		ТекущийОбъект,
		ЗначенияКлючевыхПолейРегистрацииНаФорме);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначенияПолейРегистрацииНаФорме = ОрганизацииФормыДляОтчетности.ЗначенияПолейРегистрацииВНалоговомОргане(
		ЭтотОбъект,
		ПоляРегистрацииВНалоговомОргане(Ложь));
	
	ОрганизацииФормыДляОтчетности.ЗаписатьРегистрациюВНалоговомОргане(
		ТекущийОбъект,
		ЗначенияПолейРегистрацииНаФорме);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	СозданаУчетнаяПолитика = Ложь;
	РезультатВыполнения = КалендарьБухгалтера.ЗапуститьЗаполнениеВФоне(УникальныйИдентификатор, ТекущийОбъект.Ссылка, СозданаУчетнаяПолитика);
	ПараметрыЗаписи.Вставить("РезультатВыполненияЗаданияКалендаряБухгалтера", РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОрганизацииФормыДляОтчетностиКлиентСервер.УстановитьЗаголовокФормы(ЭтотОбъект);
	
	Если ПараметрыЗаписи.Свойство("РезультатВыполненияЗаданияКалендаряБухгалтера") Тогда
		КалендарьБухгалтераКлиент.ОжидатьЗавершениеЗаполненияВФоне(ПараметрыЗаписи.РезультатВыполненияЗаданияКалендаряБухгалтера);
	КонецЕсли;
	
	ОрганизацииФормыДляОтчетностиКлиент.ОповеститьОЗаписи(Объект.Ссылка, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПолейФормы

&НаКлиенте
Процедура ФамилияИППриИзменении(Элемент)
	
	ОрганизацииФормыКлиент.ФИОПриИзменении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяИППриИзменении(Элемент)
	
	ОрганизацииФормыКлиент.ФИОПриИзменении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоИППриИзменении(Элемент)
	
	ОрганизацииФормыКлиент.ФИОПриИзменении(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПоискаИННПриИзменении(Элемент)
	
	ПоискИННОтвет = ОрганизацииФормыДляОтчетностиВызовСервера.ЗапроситьДанныеЕГР(НовыйЗапросДанныхЕГР(ПоискИННЗапрос));
		
	// Пользователь сразу после изменения поля мог нажать команду "Заполнить".
	// Дадим возможность выполниться обработчику команды заполнения.
	// Поэтому фактическую обработку результата выполняем после обработчика изменения поля.
	ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПоискаИНН", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПоискаИНН()
	
	ОрганизацииФормыДляОтчетностиКлиент.ОбработатьРезультатПоискаИННПриИзмененииПоляПоиска(
		ПоискИННОтвет,
		ОписаниеОповещенияЗакончитьЗаполнениеДаннымиЕГР());
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ПроверитьИНН(ПояснениеНекорректныйИНН, Объект.ИНН);
	
КонецПроцедуры

&НаКлиенте
Процедура КодПоОКТМОПриИзменении(Элемент)
	ПояснениеНекорректныйКодПоОКТМО = ОрганизацииФормыДляОтчетностиКлиентСервер.ПроверитьКодПоОКТМО(КодПоОКТМО);
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПолеТелефонОрганизацииПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформацияПолеЮрАдресОрганизацииНажатие(Элемент, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиентБП.НачалоВыбора(ЭтотОбъект, Элемент, Модифицированность, СтандартнаяОбработка);
	// По завершении выбора будет вызвана ПослеИзмененияКонтактнойИнформации()
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеИзмененияКонтактнойИнформации(Результат) Экспорт
	
	Если Результат.ИмяРеквизита = "КонтактнаяИнформацияПолеЮрАдресОрганизации" Тогда
		
		ЗаполнитьПоАдресу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	
	// Обязательный обработчик подсистемы контактной информации
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецФункции

&НаКлиенте
Процедура КодНалоговогоОрганаПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.КодНалоговогоОргана) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НаименованиеНалоговогоОргана = ОрганизацииФормыДляОтчетностиВызовСервера.РеквизитыГосударственногоОрганаПоКоду(
		ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.НалоговыйОрган"),
		Объект.КодНалоговогоОргана);
		
КонецПроцедуры

&НаКлиенте
Процедура КодОрганаПФРПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.КодОрганаПФР) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НаименованиеТерриториальногоОрганаПФР = ОрганизацииФормыДляОтчетностиВызовСервера.РеквизитыГосударственногоОрганаПоКоду(
		ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганПФР"),
		Объект.КодОрганаПФР);
		
КонецПроцедуры

&НаКлиенте
Процедура КодПодчиненностиФССПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.КодПодчиненностиФСС) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НаименованиеТерриториальногоОрганаФСС = ОрганизацииФормыДляОтчетностиВызовСервера.РеквизитыГосударственногоОрганаПоКоду(
		ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганФСС"),
		Объект.КодПодчиненностиФСС);
		
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭД2ПриИзменении(Элемент)
	
	ОрганизацииФормыДляОтчетностиКлиентСервер.ИзменениеКодаОКВЭД2(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодОКВЭД2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОрганизацииФормыДляОтчетностиКлиент.ВыбратьКодИзКлассификатора(
		"ОКВЭД2",
		"КодОКВЭД2",
		"НаименованиеОКВЭД2",
		ЭтотОбъект,
		Объект,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СистемаНалогообложенияПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	ОрганизацииФормыДляОтчетностиКлиент.НачатьИзменениеСистемыНалогообложения(
		Объект.Ссылка,
		ЭтотОбъект,
		"СистемаНалогообложенияПредставление",
		СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоПолюПоискаИНН(Команда)
	
	ОрганизацииФормыДляОтчетностиКлиент.ЗаполнитьРеквизитыПоПолюПоискаИНН(
		НовыйЗапросДанныхЕГР(ПоискИННЗапрос),
		ПоискИННОтвет,
		ОписаниеОповещенияЗакончитьЗаполнениеДаннымиЕГР(),
		ТекущийЭлемент,
		Элементы.ПолеПоискаИНН);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоИНН(Команда)
	
	ОрганизацииФормыДляОтчетностиКлиент.ЗаполнитьРеквизитыПоИНН(
		НовыйЗапросДанныхЕГР(Объект.ИНН),
		ПоискИННОтвет,
		ОписаниеОповещенияЗакончитьЗаполнениеДаннымиЕГР(),
		ТекущийЭлемент,
		Элементы.ИНН);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИспользуетТрудНаемныхРаботников

&НаСервереБезКонтекста
Функция ДанныеДляРаботников()
	
	// Эти все реквизиты - в Объект, поля на форме должны иметь те же имена
	
	Данные = Новый Массив;
	Данные.Добавить("РегистрационныйНомерПФР");
	Данные.Добавить("РегистрационныйНомерФСС");
	Данные.Добавить("ФондСоцстрахования");
	Возврат Данные;
	
КонецФункции

&НаСервере
Процедура НастроитьЭлементыПриИспользованииТрудаНаемныхРаботников()

	ИПИспользуетТрудНаемныхРаботников = Объект.ИПИспользуетТрудНаемныхРаботников Или ВключитьИПИспользуетТрудНаемныхРаботников;
	
	Для Каждого ИмяЭлемента Из ДанныеДляРаботников() Цикл
		
		Элементы[ИмяЭлемента].Видимость = ИПИспользуетТрудНаемныхРаботников;
		
	КонецЦикла;
	
	Если ИПИспользуетТрудНаемныхРаботников Тогда
		Элементы.ИПРегистрационныйНомерПФР.Заголовок = НСтр("ru = 'Рег. номер в ПФР (за себя)'");
	Иначе
		// Уберем слова "за себя" в заголовке.
		Элементы.ИПРегистрационныйНомерПФР.Заголовок = НСтр("ru = 'Рег. номер в ПФР'");
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция НадоВключитьИПИспользуетТрудНаемныхРаботников(АдресПроверяемыеДанные)
	
	// У предпринимателя надо включить флаг ИПИспользуетТрудНаемныхРаботников,
	// если для отчетности требуются специфические реквизиты, связанные с наемными работниками
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресПроверяемыеДанные) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПроверяемыеДанные = ПолучитьИзВременногоХранилища(АдресПроверяемыеДанные);
	Если ТипЗнч(ПроверяемыеДанные) <> Тип("Соответствие") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого ИмяЭлемента Из ДанныеДляРаботников() Цикл
		
		ПутьКДанным = "Объект." + ИмяЭлемента;
		Если ПроверяемыеДанные[ПутьКДанным] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Возврат Истина;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ВключитьИПИспользуетТрудНаемныхРаботников()
	
	Если Объект.ИПИспользуетТрудНаемныхРаботников Тогда
		// Уже включено
		Возврат;
	КонецЕсли;
	
	Если Не ВключитьИПИспользуетТрудНаемныхРаботников Тогда
		// Никто не просил
		Возврат;
	КонецЕсли;
	
	ЗаполненыСпецифическиеРеквизиты = Ложь;
	Для Каждого ИмяДанных Из ДанныеДляРаботников() Цикл
		Если Не ПустаяСтрока(Объект[ИмяДанных]) Тогда
			ЗаполненыСпецифическиеРеквизиты = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗаполненыСпецифическиеРеквизиты Тогда
		// Незачем включать
		Возврат;
	КонецЕсли;
	
	Объект.ИПИспользуетТрудНаемныхРаботников = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ИдентификационныеНомераНалогоплательщиков

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьИНН(РезультатПроверки, ИНН)
	
	РезультатПроверки = ОрганизацииФормыДляОтчетностиКлиентСервер.ПроверитьИНН(ИНН, "", Ложь);
		
КонецПроцедуры

#КонецОбласти	

#Область ЗаполнениеДаннымиЕГР

&НаКлиенте
Функция НовыйЗапросДанныхЕГР(ИНН)
	
	Запрос = ОрганизацииФормыДляОтчетностиКлиентСервер.НовыйЗапросДанныхЕГР();
	Запрос.ИНН                       = ИНН;
	Запрос.ЮридическоеФизическоеЛицо = Объект.ЮридическоеФизическоеЛицо;
	Запрос.Ссылка                    = Объект.Ссылка;
	Запрос.ОбъектЗаполнен            = ЗначениеЗаполнено(Объект.ИНН) И ЗначениеЗаполнено(Объект.ФамилияИП);
	
	Возврат Запрос;
	
КонецФункции

&НаСервере
Процедура НастроитьКомандыАвтозаполнения()
	
	ОтобразитьЗаполнениеПоДаннымЕГР =
		Не ЗначениеЗаполнено(Объект.ИНН)
		И Не ЗначениеЗаполнено(Объект.ФамилияИП);
	
	Элементы.ЗаполнениеПоДаннымЕГР.Видимость   = ОтобразитьЗаполнениеПоДаннымЕГР;
	Элементы.ЗаполнитьРеквизитыПоИНН.Видимость = НЕ ОтобразитьЗаполнениеПоДаннымЕГР;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеОповещенияЗакончитьЗаполнениеДаннымиЕГР()
	
	// Параметр оповещения может быть модифицирован - см. НачатьЗаполнениеДаннымиЕГР()
	Возврат Новый ОписаниеОповещения("ЗакончитьЗаполнениеДаннымиЕГР", ЭтотОбъект, Новый Структура);
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьЗаполнениеДаннымиЕГР(Ответ, ПараметрыЗаполнения) Экспорт
	
	ЗаполнитьНаСервере = ОрганизацииФормыДляОтчетностиКлиент.ЗакончитьЗаполнениеДаннымиЕГР(
		ЭтотОбъект,
		Объект.ЮридическоеФизическоеЛицо,
		Ответ,
		ПараметрыЗаполнения);
		
	Если ЗаполнитьНаСервере Тогда
		ЗаполнитьДаннымиЕГР(ПараметрыЗаполнения.ПоискИННОтвет);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиЕГР(Знач ПоискИННОтвет)
	
	ОрганизацииФормыДляОтчетности.ЗаполнитьДаннымиЕГР(ПоискИННОтвет, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ЮридическийАдрес

&НаСервере
Процедура ЗаполнитьПоАдресу()
		
	ОрганизацииФормыДляОтчетности.ЗаполнитьПоАдресу(
		Объект,
		КодПоОКТМО,
		ОрганизацииФормыДляОтчетностиКлиентСервер.АдресОрганизацииЗначенияПолей(КонтактнаяИнформацияОписаниеДополнительныхРеквизитов));
		
КонецПроцедуры
	
#КонецОбласти

#Область РегистрацияВНалоговомОргане

// Методы работы со справочником РегистрацияВНалоговомОргане

&НаКлиентеНаСервереБезКонтекста
Функция ПоляРегистрацииВНалоговомОргане(ТолькоКлючевые = Ложь)
	
	ПоляРегистрации = Новый Структура;
	ПоляРегистрации.Вставить("Код", "Объект.КодНалоговогоОргана");
	
	Если Не ТолькоКлючевые Тогда
		ПоляРегистрации.Вставить("Наименование", "Объект.НаименованиеНалоговогоОргана");
		ПоляРегистрации.Вставить("КодПоОКТМО",   "КодПоОКТМО");
	КонецЕсли;
	
	Возврат ПоляРегистрации;
	
КонецФункции

#КонецОбласти

#КонецОбласти

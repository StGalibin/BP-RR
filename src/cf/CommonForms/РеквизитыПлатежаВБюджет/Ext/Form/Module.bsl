﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Получим данные объекта
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Реквизиты);
	Ссылка              = Параметры.Ссылка;
	ПеречислениеВБюджет = Параметры.ПеречислениеВБюджет;
	УплатаНалога        = Параметры.УплатаНалога;
	КодТерритории8      = КодТерритории;
	
	НалоговыйПериод = Неопределено;
	Если Параметры.Реквизиты.Свойство("НалоговыйПериод", НалоговыйПериод) И ЗначениеЗаполнено(НалоговыйПериод) Тогда
		ПоказателиПериода = ПлатежиВБюджетКлиентСервер.РазобратьНалоговыйПериод(НалоговыйПериод);
		Если ЗначениеЗаполнено(ПоказателиПериода.Дата) Тогда
			ПериодДокумента = Мин(ПоказателиПериода.Дата, Параметры.СвойстваКонтекста.Период);
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПериодДокумента) Тогда
		ПериодДокумента = Параметры.СвойстваКонтекста.Период;
	КонецЕсли;
	
	// В форму передаются данные, доступные на клиенте и позволяющие определить контекст.
	// Например, ссылка на организацию и ссылка на счет получателя.
	// Унифицируем эти данные - получим из них конкретные значения реквизитов,
	// задающих контекст: свойства организации, номер счета и т.п.
	// Контекст везде должен быть одинаковым.
	// А вот состав данных для получения контекста может быть разным в разных конфигурациях-потребителях.
	// Поэтому код, который из свойств контекста получает собственно контекст, должен быть переопределяемым.
	Контекст  = ПлатежиВБюджетПереопределяемый.КонтекстПлатежногоДокумента(Параметры.СвойстваКонтекста);
	Реквизиты = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет(ЭтотОбъект);
	
	Если Параметры.Свойство("СчетПоГосконтракту", СчетПоГосконтракту) И СчетПоГосконтракту Тогда
		ИдентификаторКонтракта = Параметры.Реквизиты.ИдентификаторПлатежа;
		ИдентификаторПлатежа   = "";
	КонецЕсли;
	
	Если ПлатежиВБюджетКлиентСервер.ПрименяетсяОКТМО8Символов(Контекст.Период) Тогда
		ПрименяетсяОКТМО8Символов = Истина;
	КонецЕсли;
	
	// Выполним команды, переданные в форму
	Если Параметры.ИсправитьОшибки Тогда
		
		Изменения = ПлатежиВБюджетКлиентСервер.ИсправитьЗначенияРеквизитов(
			Неопределено,
			Реквизиты,
			Контекст,
			Ложь); // Только исправляем ошибки; не заполняем принудительно значения по-умолчанию
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Изменения);
		
		Модифицированность = Истина;
		
	ИначеЕсли НЕ ПустаяСтрока(Параметры.АдресИнформацииОбОшибках) Тогда
		
		Ошибки = ПолучитьИзВременногоХранилища(Параметры.АдресИнформацииОбОшибках);
		ВывестиСообщенияОбОшибках(Ошибки, ЭтотОбъект);
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ПереходныйПериодПрименения107н(Реквизиты, Контекст) Тогда
		
		Контекст.Период = ПлатежиВБюджетКлиентСервер.НачалоДействияПриказа107н();
		
	КонецЕсли;
	
	// Настроим элементы, которые не меняются в ходе работы с формой
	НастроитьФорму("", Реквизиты);
	
	// Настроим элементы, которые меняются в ходе работы с формой
	Для каждого ИмяРеквизита Из ПлатежиВБюджетКлиентСервер.РеквизитыПлатежаВБюджет() Цикл
		НастроитьФорму(ИмяРеквизита,              Реквизиты);
		НастроитьФорму(ИмяРеквизита + "Детально", Реквизиты);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВывестиСообщениеОбОшибкахУИН();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность ИЛИ НЕ ПеречислениеВБюджет Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина; // Примем решение позже, в зависимости от ответа пользователя
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВопросПеренестиЗначенияВДокументЗавершение", ЭтотОбъект),
		НСтр("ru = 'Перенести указанные значения в документ?'"),
		РежимДиалогаВопрос.ДаНетОтмена,
		, // Заголовок
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренестиЗначенияВДокументЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ПеренестиВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КБКПриИзменении(Элемент)
	
	ЗаполнитьПоУмолчанию("КБК");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПлательщикаПриИзменении(Элемент)
	
	ЗаполнитьПоУмолчанию("СтатусПлательщика");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПлательщикаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПлатежаПриИзменении(Элемент)
	
	ПлатежиВБюджетКлиентСервер.ОтметитьНезаполненноеЗначение(ОснованиеПлатежа);
	ЗаполнитьПоУмолчанию("ОснованиеПлатежа");
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьУплатыПриИзменении(Элемент)
	
	ИзменитьПериодичностьУплаты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГодПлатежаПриИзменении(Элемент)
	
	ПлатежиВБюджетКлиентСервер.ПривестиЭлементыНалоговогоПериода(
		НалоговыйПериод_Периодичность, НалоговыйПериод_Год, НалоговыйПериод_НомерПериода, НалоговыйПериод_Дата, Контекст.ПериодПлатежа);
	Контекст.Период = НалоговыйПериод_Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаДокументаПриИзменении(Элемент)
	
	НастроитьПоДатеДокумента(ЭтотОбъект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерДокументаПриИзменении(Элемент)
	
	ПлатежиВБюджетКлиентСервер.ОтметитьНезаполненноеЗначение(НомерДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПлатежаПриИзменении(Элемент)
	
	ПлатежиВБюджетКлиентСервер.ОтметитьНезаполненноеЗначение(ОснованиеПлатежа);
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторПлатежаПриИзменении(Элемент)
	
	ВывестиСообщениеОбОшибкахУИН();
	
КонецПроцедуры

&НаКлиенте
Процедура ПеречислениеВБюджетПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТерритории8ПриИзменении(Элемент)
	
	КодТерритории = КодТерритории8;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОК(Команда)
	
	ПеренестиВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КонструкторКБК(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КБК",             КБК);
	ПараметрыФормы.Вставить("ПоказательТипа",  ТипПлатежа);
	ПараметрыФормы.Вставить("ВидПеречисления", ВидПеречисления);
	ПараметрыФормы.Вставить("ГодПлатежа",      Год(Мин(ПериодДокумента, Контекст.Период)));
	
	ОткрытьФорму(
		"Справочник.ВидыНалоговИПлатежейВБюджет.Форма.КонструкторКБК",
		ПараметрыФормы, 
		Элементы.КБК);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Взаимодействие с другими формами

&НаКлиентеНаСервереБезКонтекста
Функция РезультатРедактирования(Форма, ЗначениеМодифицированности = Ложь)
	
	Результат = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет(Форма);
	
	Если Форма.Элементы.НалоговыйПериод.Видимость Тогда
		Результат.НалоговыйПериод = ПлатежиВБюджетКлиентСервер.НалоговыйПериод(
			Форма.НалоговыйПериод_Дата,
			Форма.НалоговыйПериод_Периодичность,
			Форма.НалоговыйПериод_Год,
			Форма.НалоговыйПериод_НомерПериода);
	КонецЕсли;
	
	Результат.ДатаДокумента = ПлатежиВБюджетКлиентСервер.ПреобразоватьДатуКСтроке(Форма.ДатаДокумента_Детально);
	
	// Для отдельных полей задана маска и это может привести к ненужным пробелам справа
	Результат.КБК = СокрП(Результат.КБК);
	Если Форма.ПрименяетсяОКТМО8Символов Тогда
		Результат.КодТерритории = Лев(СокрП(Результат.КодТерритории), 8);
	Иначе
		Результат.КодТерритории = СокрП(Результат.КодТерритории);
	КонецЕсли;
	
	Если Форма.СчетПоГосконтракту Тогда
		Результат.Вставить("ИдентификаторКонтракта", Форма.ИдентификаторКонтракта);
	Иначе
		Результат.ИдентификаторПлатежа = СокрП(Результат.ИдентификаторПлатежа);
	КонецЕсли;
	
	ПлатежиВБюджетКлиентСервер.ОтметитьНезаполненныеЗначения(Результат);
	
	Если Результат.Свойство("ТипПлатежа") И НЕ Форма.Элементы.ТипПлатежа.Видимость Тогда
		Результат.ТипПлатежа = "";
	КонецЕсли;
	
	Результат.Вставить("ПеречислениеВБюджет", Форма.ПеречислениеВБюджет);
	Результат.Вставить("Модифицированность",  ЗначениеМодифицированности);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиВДокумент(ПроверитьЗаполнение = Истина)
	
	Если ПроверитьЗаполнение И ПеречислениеВБюджет Тогда
		
		ТекстВопроса = Проверить();
		
		Если НЕ ПустаяСтрока(ТекстВопроса) Тогда
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ВопросПеренестиВДокументРеквизитыСОшибкамиЗавершение", ЭтотОбъект),
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет,
				, // Заголовок
				КодВозвратаДиалога.Нет);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗначениеМодифицированности = Модифицированность;
	Модифицированность = Ложь;
	
	Если ПеречислениеВБюджет Тогда
		Закрыть(РезультатРедактирования(ЭтотОбъект, ЗначениеМодифицированности));
	Иначе
		Закрыть(Новый Структура("ПеречислениеВБюджет", ПеречислениеВБюджет));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПеренестиВДокументРеквизитыСОшибкамиЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция Проверить()
	
	Если НЕ ПлатежиВБюджетКлиентСервер.ДействуетПриказ107н(Контекст.Период) Тогда
		// До даты применения 107н не выполняем проверку, так как был переходный период,
		// в течение которого непонятно, выполнение каких правил контролировать
		Возврат "";
	КонецЕсли;
	
	// Проверим заполнение
	Реквизиты = РезультатРедактирования(ЭтотОбъект);
	
	РезультатПроверки = ПлатежиВБюджетКлиентСервер.ПроверитьЗаполнение(Реквизиты, Контекст);
	
	// Проверим дубли УИН
	ИнформацияДублиУИН = Новый Массив;
	
	Если НЕ СчетПоГосконтракту И ПлатежиВБюджетКлиентСервер.РеквизитЗаполнен(ИдентификаторПлатежа) Тогда
		ИнформацияДублиУИН = ПроверитьДублиУИН(ИдентификаторПлатежа, Ссылка); // Вызов сервера
	КонецЕсли;
	
	// Спросим пользователя
	ТекстВопроса = "";
	Если РезультатПроверки.Ошибки.Количество() > 0 Тогда
		
		ОчиститьСообщения();
		
		Для каждого ОписаниеОшибки Из ИнформацияДублиУИН Цикл
			РезультатПроверки.Ошибки.Добавить(ОписаниеОшибки);
		КонецЦикла;
		
		ВывестиСообщенияОбОшибках(РезультатПроверки.Ошибки, ЭтотОбъект);
		
		Возврат НСтр("ru = 'Указаны неверные значения.
			|Перенести их в документ?'");
		
	ИначеЕсли ИнформацияДублиУИН.Количество() > 0 Тогда
		
		ШаблонТекстаВопроса = НСтр("ru = '[ИнформацияДублиУИН]
			|
			|Перенести указанные значения в документ?'");
		
		ТекстыСообщений = Новый Массив;
		Для каждого ОписаниеОшибки Из ИнформацияДублиУИН Цикл
			ТекстыСообщений.Добавить(ОписаниеОшибки.Описание);
		КонецЦикла;
		
		ПараметрыТекста = Новый Структура;
		ПараметрыТекста.Вставить("ИнформацияДублиУИН", СтрСоединить(ТекстыСообщений, Символы.ПС));
		
		Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонТекстаВопроса, ПараметрыТекста);
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура СформироватьСтрокуПроверкиУИН()
	
	УИН = СокрЛП(ИдентификаторПлатежа);
	
	//Переменная определяющая какое сообщение выводим пользователю:
	//0 - ничего не выводим
	//1 - УИН введен некорректно
	//2 - УИН содержит буквы
	СтатусПредупреждения = 0;
	
	Если ПустаяСтрока(УИН) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПлатежиВБюджетКлиентСервер.ПроверитьУИН(УИН,
		ПлатежиВБюджетКлиентСервер.АдминистраторНачисленияФедеральныйОрганГосударственнойВласти(Контекст.НомерСчетаПолучателя))) Тогда
		СтатусПредупреждения = 1;
		Возврат;
	КонецЕсли;
	
	Для Сч = 1 По СтрДлина(УИН) Цикл
		
		ТекСимвол = Сред(УИН, Сч, 1);
		
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ТекСимвол) Тогда
			СтатусПредупреждения = 2;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьДублиУИН(Знач ИдентификаторПлатежа, Знач Ссылка)
	
	Возврат ПлатежиВБюджет.ПроверитьДублиУИН(ИдентификаторПлатежа,Ссылка);
	
КонецФункции

&НаКлиенте
Процедура ВывестиСообщениеОбОшибкахУИН()
	
	Если СчетПоГосконтракту Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИдентификаторПлатежа) И СокрЛП(ИдентификаторПлатежа) <> "0" Тогда
		СформироватьСтрокуПроверкиУИН();
		УправлениеВидимостьюПредупрежденийОбОшибкахУИН();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеВидимостьюПредупрежденийОбОшибкахУИН();
	
	Если СтатусПредупреждения = 0 Тогда
		Элементы.НадписьУИНВведенНекорректно.Видимость = Ложь;
	ИначеЕсли СтатусПредупреждения = 1 Тогда
		Элементы.НадписьУИНВведенНекорректно.Видимость = Истина;
		Элементы.НадписьУИНСодержитБуквы.Видимость = Ложь;
	ИначеЕсли СтатусПредупреждения = 2 Тогда
		Элементы.НадписьУИНВведенНекорректно.Видимость = Ложь;
		Элементы.НадписьУИНСодержитБуквы.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВывестиСообщенияОбОшибках(Ошибки, Форма)
	
	Для каждого Ошибка Из Ошибки Цикл
		
		ИмяРеквизитаДляПривязкиСообщения = Ошибка.ИмяПоля;
		Если ИмяРеквизитаДляПривязкиСообщения = "НалоговыйПериод" Тогда
			// Это поле может быть представлено разными способами
			Если Форма.Элементы.НалоговыйПериод.Видимость Тогда
				ИмяРеквизитаДляПривязкиСообщения = "НалоговыйПериод_Периодичность";
			КонецЕсли;
		ИначеЕсли ИмяРеквизитаДляПривязкиСообщения = "ДатаДокумента" Тогда
			// Это поле редактируется особым способом - в поле, которое умеет принимать и дату и "0"
			ИмяРеквизитаДляПривязкиСообщения = "ДатаДокумента_Детально";
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Ошибка.Описание,,ИмяРеквизитаДляПривязкиСообщения);
		
	КонецЦикла;
	
КонецПроцедуры

// Заполнение значений

&НаСервере
Процедура ЗаполнитьПоУмолчанию(Знач ИмяИзмененногоРеквизита, Знач НастраиватьФорму = Истина)
	
	// Получим значения по умолчанию, которые отличаются от уже установленных
	Изменения = ПлатежиВБюджетКлиентСервер.ИсправитьЗначенияРеквизитов(
		ИмяИзмененногоРеквизита,
		РезультатРедактирования(ЭтотОбъект),
		Контекст,
		Истина);
	
	// Назначим значения реквизитам формы
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Изменения);
	
	// Настроим форму
	Если НастраиватьФорму Тогда
		
		Реквизиты = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет(ЭтотОбъект);
		
		// Настраиваем детали "стартового" поля
		НастроитьФорму(ИмяИзмененногоРеквизита + "Детально", Реквизиты);
		
		// Настраиваем все зависимые от него поля (не важно, изменились они или нет)
		ЗависимыеРеквизиты = ПлатежиВБюджетКлиентСервер.ВсеЗависимыеРеквизиты(ИмяИзмененногоРеквизита);
		
		ЧастиФормы = Новый Структура; // "Свернем" перечень зависимых реквизитовй 
		Для каждого ИмяРеквизита Из ЗависимыеРеквизиты Цикл
			ЧастиФормы.Вставить(ИмяРеквизита);
		КонецЦикла;
		
		Для каждого ОписаниеЧастиФормы Из ЧастиФормы Цикл
			НастроитьФорму(ОписаниеЧастиФормы.Ключ,              Реквизиты);
			НастроитьФорму(ОписаниеЧастиФормы.Ключ + "Детально", Реквизиты);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОписаниеКБК(Знач КБК, Знач Период, КБК_Наименование, КБК_Администратор)
	
	КБК_Администратор = Справочники.ВидыНалоговИПлатежейВБюджет.НаименованиеГлавногоАдминистратора(КБК);
	Если ПустаяСтрока(КБК_Администратор) Тогда
		КБК_Администратор = НСтр("ru = 'Иные получатели'");
	КонецЕсли;
	
	ОписаниеКБК = Справочники.ВидыНалоговИПлатежейВБюджет.ОписаниеКБК(КБК, Период);
	Если ОписаниеКБК = Неопределено Тогда
		КБК_Наименование  = "";
		Возврат;
	КонецЕсли;
	
	Если ПлатежиВБюджетКлиентСервер.ЭтоКБКШтраф(КБК) Тогда
		НаименованиеПодвидаДохода = НСтр("ru = '(штраф)'");
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоКБКПени(КБК) Тогда
		НаименованиеПодвидаДохода = НСтр("ru = '(пени)'");
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоКБКПроценты(КБК) Тогда
		НаименованиеПодвидаДохода = НСтр("ru = '(проценты)'");
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоКБКПениПроценты(КБК) Тогда
		НаименованиеПодвидаДохода = НСтр("ru = '(пени, проценты)'");
	КонецЕсли;
	
	КБК_Наименование = СокрЛП(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2'"),
		ОписаниеКБК.Наименование,
		НаименованиеПодвидаДохода));
	
КонецПроцедуры

// Настройка формы

&НаСервере
Процедура НастроитьФорму(Знач ЧастьФормы, Знач Реквизиты = Неопределено)
	
	Если Реквизиты = Неопределено Тогда
		Реквизиты = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет(ЭтотОбъект);
	КонецЕсли;
	
	Если ЧастьФормы = "" Тогда
		
		НастроитьСписокВыбора(
			Элементы.СтатусПлательщика,
			ПлатежиВБюджетКлиентСервер.СтатусыПлательщика(
				?(ПериодДокумента > Контекст.Период, ПериодДокумента, Контекст.Период)));
		
		НастроитьСписокВыбора(
			Элементы.ПериодичностьУплаты,
			ПлатежиВБюджетКлиентСервер.ВидыНалоговыхПериодов());
			
		Элементы.КодТерритории.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код %1'"),
			ПлатежиВБюджетКлиентСервер.ЗаголовокКодаТерритории(Контекст.Период));
		
		Элементы.КодТерритории.Видимость  = НЕ ПрименяетсяОКТМО8Символов;
		Элементы.КодТерритории8.Видимость = ПрименяетсяОКТМО8Символов;
		
	ИначеЕсли ЧастьФормы = "КБКДетально" Тогда
		
		УстановитьОписаниеКБК(КБК, Контекст.Период, КБК_Наименование, КБК_Администратор);
		
	ИначеЕсли ЧастьФормы = "ОснованиеПлатежа" Тогда
		
		Комментарий = "";
		РедактированиеОграничено = Не ПлатежиВБюджетКлиентСервер.ИспользуетсяОснованиеПлатежа(ВидПеречисления, Контекст.Период, Комментарий);
		
		НастроитьСписокВыбора(
			Элементы.ОснованиеПлатежа,
			ПлатежиВБюджетКлиентСервер.ОснованияПлатежа(ВидПеречисления, Контекст.Период),
			РедактированиеОграничено,
			Комментарий);
		
	ИначеЕсли ЧастьФормы = "НалоговыйПериод" Тогда
		
		Правило = ПлатежиВБюджетКлиентСервер.ПравилоУказанияНалоговогоПериода(
			Реквизиты,
			Контекст.Период);
		
		Элементы.НалоговыйПериод.Видимость               = (Правило.Назначение = "Период");
		Элементы.КодТаможенногоОргана.Видимость          = (Правило.Назначение = "Орган");
		Элементы.НалоговыйПериодНеИспользуется.Видимость = (Правило.Назначение = "НеИспользуется" ИЛИ Правило.Назначение = Неопределено);
		
		УстановитьРежимРедактирования(
			Элементы.НалоговыйПериодНеИспользуется,
			Правило.Назначение = "НеИспользуется",
			Правило.Комментарий);
		
		Элементы.ПериодичностьУплаты.РасширеннаяПодсказка.Заголовок           = Правило.Подсказка;
		Элементы.КодТаможенногоОргана.РасширеннаяПодсказка.Заголовок          = Правило.Подсказка;
		Элементы.НалоговыйПериодНеИспользуется.РасширеннаяПодсказка.Заголовок = Правило.Подсказка;
		
	ИначеЕсли ЧастьФормы = "НалоговыйПериодДетально" Тогда
		
		НастроитьПоНалоговомуПериоду(ЭтотОбъект);
		
	ИначеЕсли ЧастьФормы = "НомерДокумента" Тогда
		
		Правило = ПлатежиВБюджетКлиентСервер.ПравилоУказанияНомераДокумента(
			Реквизиты,
			Контекст.Период);
		
		Элементы.НомерДокумента.РасширеннаяПодсказка.Заголовок = Правило.Подсказка;
		
		УстановитьРежимРедактирования(
			Элементы.НомерДокумента,
			Правило.Назначение = "НеИспользуется",
			Правило.Комментарий);
		
	ИначеЕсли ЧастьФормы = "ДатаДокумента" Тогда
		
		Правило = ПлатежиВБюджетКлиентСервер.ПравилоУказанияДатыДокумента(
			Реквизиты,
			Контекст.Период);
		
		Элементы.ДатаДокумента.РасширеннаяПодсказка.Заголовок = Правило.Подсказка;
		
		УстановитьРежимРедактирования(
			Элементы.ДатаДокумента,
			Правило.Назначение = "НеИспользуется",
			Правило.Комментарий);
		
	ИначеЕсли ЧастьФормы = "ДатаДокументаДетально" Тогда
		
		НастроитьПоДатеДокумента(ЭтотОбъект);
		
	ИначеЕсли ЧастьФормы = "ТипПлатежа" Тогда
		
		Комментарий = "";
		РедактированиеОграничено = НЕ ПлатежиВБюджетКлиентСервер.ИспользуетсяТипПлатежа(ВидПеречисления, Контекст.Период, Комментарий);
		
		НастроитьСписокВыбора(
			Элементы.ТипПлатежа,
			ПлатежиВБюджетКлиентСервер.ТипыПлатежа(ВидПеречисления, Контекст.Период),
			РедактированиеОграничено,
			Комментарий);
		
		// Установим подсказку
		ПлатежиВБюджетКлиентСервер.ДопустимыеТипыПлатежа(
			Реквизиты,
			Контекст.Период,
			Элементы.ТипПлатежа.РасширеннаяПодсказка.Заголовок);
		
		Элементы.ТипПлатежа.Видимость = Контекст.Период < ПлатежиВБюджетКлиентСервер.НачалоДействияПриказа126н();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.УплатаНалога Тогда
		Элементы.ПеречислениеВБюджет.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.СчетПоГосконтракту Тогда
		Элементы.ГруппаИдентификаторПлатежа.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаРеквизитыПлатежаВБюджет.Доступность = Форма.ПеречислениеВБюджет;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьПоНалоговомуПериоду(Форма, ЗаполнитьВспомогательныеПоля = Истина)
	
	Элементы = Форма.Элементы;
	
	Если ЗаполнитьВспомогательныеПоля Тогда
		// Обратное преобразование - в РезультатРедактирования()
		ОписаниеПериода = ПлатежиВБюджетКлиентСервер.РазобратьНалоговыйПериод(Форма.НалоговыйПериод);
		Форма.НалоговыйПериод_Периодичность = ОписаниеПериода.Периодичность;
		Форма.НалоговыйПериод_Год           = ОписаниеПериода.Год;
		Форма.НалоговыйПериод_НомерПериода  = ОписаниеПериода.НомерПериода;
		Форма.НалоговыйПериод_Дата          = ОписаниеПериода.Дата;
	КонецЕсли;
	
	Периодичность = Форма.НалоговыйПериод_Периодичность;
	
	Элементы.ГодПлатежа.Видимость             = Ложь;
	Элементы.ПериодПлатежаПолугодие.Видимость = Ложь;
	Элементы.ПериодПлатежаКвартал.Видимость   = Ложь;
	Элементы.ПериодПлатежаМесяц.Видимость     = Ложь;
	Элементы.ДатаПлатежа.Видимость            = Ложь;
	
	Если Периодичность = ПлатежиВБюджетКлиентСервер.ПлатежПоКонкретнойДате() Тогда
		Элементы.ДатаПлатежа.Видимость = Истина;
	ИначеЕсли Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьГод() Тогда
		Элементы.ГодПлатежа.Видимость = Истина;
	ИначеЕсли Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьМесяц() Тогда
		Элементы.ГодПлатежа.Видимость         = Истина;
		Элементы.ПериодПлатежаМесяц.Видимость = Истина;
	ИначеЕсли Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьКвартал() Тогда
		Элементы.ГодПлатежа.Видимость           = Истина;
		Элементы.ПериодПлатежаКвартал.Видимость = Истина;
	ИначеЕсли Периодичность = ПлатежиВБюджетКлиентСервер.ПериодичностьПолугодие() Тогда
		Элементы.ГодПлатежа.Видимость             = Истина;
		Элементы.ПериодПлатежаПолугодие.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьПоДатеДокумента(Форма, ЗаполнитьВспомогательныеПоля = Истина)
	
	НезаполненноеЗначение = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение();
	
	Если ЗаполнитьВспомогательныеПоля Тогда
		
		// Обратное преобразование - в РезультатРедактирования()
		Форма.ДатаДокумента_Детально = ПлатежиВБюджетКлиентСервер.ПреобразоватьСтрокуКДате(Форма.ДатаДокумента);
		Если ТипЗнч(Форма.ДатаДокумента_Детально) <> Тип("Дата") 
			Или Не ЗначениеЗаполнено(Форма.ДатаДокумента_Детально) Тогда
			Форма.ДатаДокумента_Детально = НезаполненноеЗначение;
		КонецЕсли;
		
	КонецЕсли;
	
	ИдентификаторВыбораДаты = "#ДАТА";
	
	Если Форма.ДатаДокумента_Детально = ИдентификаторВыбораДаты Тогда // Такое значение добавляется в список ниже
		Форма.ДатаДокумента_Детально = Форма.Контекст.Период;
	ИначеЕсли Не ЗначениеЗаполнено(Форма.ДатаДокумента_Детально) Тогда
		Форма.ДатаДокумента_Детально = НезаполненноеЗначение;
	КонецЕсли;
	
	ПолеВРежимеДаты = ТипЗнч(Форма.ДатаДокумента_Детально) = Тип("Дата");
	Поле = Форма.Элементы.ДатаДокумента;
	Поле.РедактированиеТекста    = ПолеВРежимеДаты;
	Поле.РежимВыбораИзСписка     = Не ПолеВРежимеДаты;
	Поле.СписокВыбора.Очистить();
	Если НЕ ПолеВРежимеДаты Тогда
		ПредставлениеНезаполненного = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 - значение не указывается'"),
			НезаполненноеЗначение);
		Поле.СписокВыбора.Добавить(НезаполненноеЗначение,   ПредставлениеНезаполненного);
		Поле.СписокВыбора.Добавить(ИдентификаторВыбораДаты, НСтр("ru = 'Дата...'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериодичностьУплаты(Форма)
	
	ПлатежиВБюджетКлиентСервер.ПривестиЭлементыНалоговогоПериода(
		Форма.НалоговыйПериод_Периодичность,
		Форма.НалоговыйПериод_Год,
		Форма.НалоговыйПериод_НомерПериода,
		Форма.НалоговыйПериод_Дата,
		Форма.Контекст.Период);
	
	НастроитьПоНалоговомуПериоду(Форма, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьСписокВыбора(Элемент, СписокДанных, РедактированиеОграничено = Ложь, Предупреждение = "")
	
	УстановитьРежимРедактирования(Элемент, РедактированиеОграничено, Предупреждение);
	
	Элемент.СписокВыбора.Очистить();
	
	Если РедактированиеОграничено Или СписокДанных.Количество() = 0 Тогда
		Элемент.РежимВыбораИзСписка = Ложь;
		Элемент.КнопкаОчистки       = Истина;
	Иначе
		Элемент.РежимВыбораИзСписка = Истина;
		Элемент.КнопкаОчистки       = Ложь;
		Для каждого ЭлементДанных Из СписокДанных Цикл
			Элемент.СписокВыбора.Добавить(ЭлементДанных.Значение, ЭлементДанных.Представление);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимРедактирования(Элемент, Предупреждать, Предупреждение = "")
	
	Если Предупреждать Тогда
		Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;
	Иначе
		Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Авто;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Предупреждение) Тогда
		Элемент.ПредупреждениеПриРедактировании = Предупреждение;
	КонецЕсли;
	
КонецПроцедуры

﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.СчетНаОплатуПоставщика);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	УстановитьУсловноеОформление();
	
	// Видимость команд установки статуса документов.
	ЕстьПравоИзмененияСтатусовДокументов = СтатусыДокументов.ПравоИзмененияСтатусовДокументов(
		Метаданные.Документы.СчетНаОплатуПоставщика);
	Элементы.ФормаИзменитьСтатус.Видимость = ЕстьПравоИзмененияСтатусовДокументов;
	Элементы.СписокКонтекстноеМенюИзменитьСтатус.Видимость = ЕстьПравоИзмененияСтатусовДокументов;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусОплатыПоУмолчанию", Перечисления.СтатусОплатыСчета.СтатусНовогоДокумента());
	Список.Параметры.УстановитьЗначениеПараметра(
		"СтатусПоступленияПоУмолчанию", Перечисления.СтатусыПоступленияПоСчету.СтатусНовогоДокумента());
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.Документ.СчетНаОплатуПоставщика",
		"ФормаСписка",
		НСтр("ru='Новости: Счета от поставщиков'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.КомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец подсистема "ОбменСКонтрагентами".
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	ПрисоединенныеФайлыБПКлиент.ОбновитьСписокПослеДобавленияФайла(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РеквизитыОрганизацииЗаполнены = ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций();
	
	Если РеквизитыОрганизацииЗаполнены Тогда
		
		// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
		// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		
	КонецЕсли;
	
	// Подсистема "ОбменСКонтрагентами"
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец Подсистема "ОбменСКонтрагентами"
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	КлючеваяОперация = "СозданиеФормыСчетНаОплатуПоставщика";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	КлючеваяОперация = "ОткрытиеФормыСчетНаОплатуПоставщика";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка <> Неопределено Тогда
		
		Если ПрисоединенныеФайлыБПКлиент.ПараметрыПеретаскиванияСодержатФайлы(ПараметрыПеретаскивания) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Ссылка"                 , Строка);
			ДополнительныеПараметры.Вставить("ПараметрыПеретаскивания", ПараметрыПеретаскивания);
			ДополнительныеПараметры.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПеретаскиваниеФайловОтветПолучен",
				ПрисоединенныеФайлыБПКлиент,
				ДополнительныеПараметры);
			ШаблонВопроса = НСтр("ru='Присоединить файлы к документу %1?'");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса, Строка);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	
	СписокДокументов = Новый СписокЗначений;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока = Элементы.Список.ДанныеСтроки(ВыделеннаяСтрока);
		
		Если ТекущаяСтрока <> Неопределено Тогда
			СписокДокументов.Добавить(ТекущаяСтрока.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	Если СписокДокументов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.СчетНаОплатуПоставщика.Форма.ИзменитьСтатус",
		Новый Структура("СписокДокументов", СписокДокументов),
		ЭтотОбъект,
		КлючУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтаФорма,
		Команда
	);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Срок оплаты красным, если просрочен.
	
	ЭлементУО = Список.УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СрокОплаты");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, 
		"СрокОплаты", ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, ТекущаяДатаСеанса());
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, 
		"Оплата", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.СтатусОплатыСчета.Отменен);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор, 
		"Оплата", ВидСравненияКомпоновкиДанных.НеРавно, Перечисления.СтатусОплатыСчета.Оплачен);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	// Оформление статусов оплаты и поступления.
	
	СтатусыДокументов.УстановитьУсловноеОформлениеСтатусовСчетовНаОплатуПоставщика(Список.УсловноеОформление);
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()

	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти
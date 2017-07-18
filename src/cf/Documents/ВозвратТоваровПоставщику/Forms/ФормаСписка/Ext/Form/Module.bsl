﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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
	
	НастроитьПоВидуОперации();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ВозвратТоваровПоставщику);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , Параметр);
		
	КонецЕсли;
	
	ПрисоединенныеФайлыБПКлиент.ОбновитьСписокПослеДобавленияФайла(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СоздатьПокупкаКомиссия(Команда)

	КлючеваяОперация = "СозданиеФормыВозвратТоваровПоставщику";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийВозвратТоваровПоставщику.ПокупкаКомиссия"));
	ОткрытьФорму("Документ.ВозвратТоваровПоставщику.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИзПереработки(Команда)

	КлючеваяОперация = "СозданиеФормыВозвратТоваровПоставщику";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийВозвратТоваровПоставщику.ИзПереработки"));
	ОткрытьФорму("Документ.ВозвратТоваровПоставщику.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОборудование(Команда)
	
	КлючеваяОперация = "СозданиеФормыВозвратТоваровПоставщику";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийВозвратТоваровПоставщику.Оборудование"));
	ОткрытьФорму("Документ.ВозвратТоваровПоставщику.ФормаОбъекта", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидОперации(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", СтрокаТаблицы.Ссылка);
	ПараметрыФормы.Вставить("ВидОперации", СтрокаТаблицы.ВидОперации);
	ПараметрыФормы.Вставить("ИзменитьВидОперации", Истина);
	
	ОткрытьФорму("Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <Список>

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ВозвратТоваровПоставщику", , ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	КлючеваяОперация = "ОткрытиеФормыВозвратТоваровПоставщику";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

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

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)

	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура НастроитьПоВидуОперации()
	
	// Если форма открыта для работы с конкретным видом операции,
	// то она не должна позволять работать с другими видами операций.
	
	ВидОперации = Отбор_ВидОперации();
	Если ВидОперации = Неопределено Тогда
		НесколькоВидовОпераций = Истина;
	Иначе
		НесколькоВидовОпераций = Ложь;
		Заголовок              = Перечисления.ВидыОперацийВозвратТоваровПоставщику.ПолноеИмяОперации(ВидОперации);
		АвтоЗаголовок          = Ложь;
	КонецЕсли;
		
	Элементы.ПодменюСоздать.Видимость      = НесколькоВидовОпераций;
	Элементы.ИзменитьВидОперации.Видимость = НесколькоВидовОпераций;
	Элементы.Создать.Видимость             = Не НесколькоВидовОпераций;
	
КонецПроцедуры

&НаСервере
Функция Отбор_ВидОперации()
	
	Если Не Параметры.Свойство("Отбор") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не Параметры.Отбор.Свойство("ВидОперации") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Отбор.ВидОперации) <> Тип("ПеречислениеСсылка.ВидыОперацийВозвратТоваровПоставщику") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Отбор.ВидОперации) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Параметры.Отбор.ВидОперации;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ БСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать



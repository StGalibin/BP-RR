﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноСоздаватьЗаписиКУДиР = ПравоДоступа("Изменение", Метаданные.Документы.ЗаписьКУДиР);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация, НачалоПериода, КонецПериода");
	
	Заголовок = ТекстЗаголовка();
	
	ОбъектНалогообложенияДоходы = УчетнаяПолитика.ПрименяетсяУСНДоходы(Организация, КонецПериода);
	
	ЗаполнитьТабличнуюЧасть();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" ИЛИ ИмяСобытия = "ИзменениеВыписки"
			ИЛИ ИмяСобытия = "ИзменениеЗаписиКУДиР" ИЛИ ИмяСобытия = "ИзменениеОперацииБух"
			ИЛИ ИмяСобытия = "ИзменениеНачисленияЗарплаты" ИЛИ ИмяСобытия = "ИзменениеОтраженияЗарплатыВБухучете" 
			ИЛИ ИмяСобытия = "ИзменениеОтраженияЗарплатыВУчете" Тогда
		ЗаполнитьТабличнуюЧасть();
		УправлениеФормой(ЭтотОбъект);
	ИначеЕсли ИмяСобытия = "ОбновитьПоказателиРасчетаУСН" И Источник <> ЭтотОбъект Тогда
		
		ЗаполнитьТабличнуюЧасть();
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекущиеДанные.ДокументРасхода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	ПараметрыФормы = Новый Структура;
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФормы.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("НачалоПериода", НачалоПериода);
		ПараметрыФормы.Вставить("КонецПериода", КонецПериода);
		ПараметрыФормы.Вставить("РежимРасшифровки", Истина);
	КонецЕсли;
	
	ОткрытьФорму("Документ.ЗаписьКУДиР.Форма.ФормаДокумента", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТабличнуюЧасть();
	УправлениеФормой(ЭтотОбъект);
	
	Оповестить("ОбновитьПоказателиРасчетаУСН", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.СоздатьДокумент.Доступность = Форма.МожноСоздаватьЗаписиКУДиР;
	
	Если НЕ Форма.ОбъектНалогообложенияДоходы Тогда
		Элементы.Период.ТекстПодвала          = "Всего: " + ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");;
		Элементы.ПФР.ТекстПодвала             = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.ФСС.ТекстПодвала             = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.ФОМС.ТекстПодвала            = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.ФСС_НС.ТекстПодвала          = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.Больничные.ТекстПодвала      = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.ДМС.ТекстПодвала             = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
		Элементы.ДокументРасхода.ТекстПодвала = ОбщегоНазначенияБПВызовСервера.ФорматСумм(0, , "0.00", " ");
	Иначе
		ИтогоПФР        = 0;
		ИтогоФСС        = 0;
		ИтогоФОМС       = 0;
		ИтогоФСС_НС     = 0;
		ИтогоБольничные = 0;
		ИтогоДМС        = 0;
		
		Для Каждого Колонка Из Форма.Список Цикл
			ИтогоПФР        = ИтогоПФР        + Колонка.ПФР;
			ИтогоФСС        = ИтогоФСС        + Колонка.ФСС;
			ИтогоФОМС       = ИтогоФОМС       + Колонка.ФОМС;
			ИтогоФСС_НС     = ИтогоФСС_НС     + Колонка.ФСС_НС;
			ИтогоБольничные = ИтогоБольничные + Колонка.Больничные;
			ИтогоДМС        = ИтогоДМС        + Колонка.ДобровольноеСтрахование;
		КонецЦикла;
		
		ИтогоРасходы = ИтогоПФР + ИтогоФСС + ИтогоФОМС + ИтогоФСС_НС + ИтогоБольничные + ИтогоДМС;
		
		Элементы.Период.ТекстПодвала     = "Всего: " + ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоРасходы, , "0.00", " ");;
		Элементы.ПФР.ТекстПодвала        = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоПФР, ,        "0.00", " ");
		Элементы.ФСС.ТекстПодвала        = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоФСС, ,        "0.00", " ");
		Элементы.ФОМС.ТекстПодвала       = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоФОМС, ,       "0.00", " ");
		Элементы.ФСС_НС.ТекстПодвала     = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоФСС_НС, ,     "0.00", " ");
		Элементы.Больничные.ТекстПодвала = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоБольничные, , "0.00", " ");
		Элементы.ДМС.ТекстПодвала        = ОбщегоНазначенияБПВызовСервера.ФорматСумм(ИтогоДМС, ,        "0.00", " ");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТекстЗаголовка()
	
	ПредставлениеПериода = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоПериода, КонецПериода, Истина);
	
	ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Расходы, уменьшающие сумму налога УСН за %1'"), ПредставлениеПериода);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ТекстЗаголовка = ТекстЗаголовка + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Организация);
	КонецЕсли;
	
	Возврат ТекстЗаголовка;
	
КонецФункции

&НаСервере
Функция НайтиРегламентнуюОперацию()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",         КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("КонецПериода",          КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("Организация",           Организация);
	Запрос.УстановитьПараметр("УменьшениеНалога",      Перечисления.ВидыРегламентныхОпераций.РасчетРасходовУменьшающихОтдельныеНалоги);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗакрытиеМесяца.Ссылка КАК Документ
	|ИЗ
	|	Документ.РегламентнаяОперация КАК ЗакрытиеМесяца
	|ГДЕ
	|	ЗакрытиеМесяца.ВидОперации = &УменьшениеНалога
	|	И ЗакрытиеМесяца.Организация = &Организация
	|	И ЗакрытиеМесяца.Дата МЕЖДУ &НачалоПериода И &КонецПериода";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Документ;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ЗаполнитьСтруктуруШапкиДокумента()
	
	Ссылка              = НайтиРегламентнуюОперацию();
	ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Организация);
	Отказ               = УчетнаяПолитикаСуществует(ГоловнаяОрганизация, Ссылка);
	
	Если Ссылка = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		ЗаголовокДокумента = ОбщегоНазначенияБПВызовСервера.ПредставлениеДокументаПриПроведении(Ссылка);
	КонецЕсли;
	
	СтруктураШапки      = Новый Структура();
	
	Если Отказ Тогда
		Возврат СтруктураШапки;
	КонецЕсли;
	
	СтруктураШапки.Вставить("НачДата",                 НачалоПериода);
	СтруктураШапки.Вставить("КонДата",                 КонецПериода);
	СтруктураШапки.Вставить("НачГраница",              Новый Граница(СтруктураШапки.НачДата, ВидГраницы.Исключая));
	СтруктураШапки.Вставить("КонГраница",              Новый Граница(СтруктураШапки.КонДата, ВидГраницы.Включая));
	СтруктураШапки.Вставить("НачГода",                 НачалоГода(НачалоПериода));
	СтруктураШапки.Вставить("Организация",             Организация);
	СтруктураШапки.Вставить("Ссылка",                  Ссылка);
	СтруктураШапки.Вставить("Дата",                    Ссылка.Дата);
	СтруктураШапки.Вставить("Номер",                   Ссылка.Номер);
	СтруктураШапки.Вставить("ВидОперации",             Ссылка.ВидОперации);
	СтруктураШапки.Вставить("Заголовок",               ЗаголовокДокумента);
	СтруктураШапки.Вставить("ГоловноеПодразделение",   ГоловнаяОрганизация);
	СтруктураШапки.Вставить("Предприниматель",         УчетнаяПолитика.ПлательщикНДФЛ(Организация, СтруктураШапки.КонДата));
	
	ВсяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсяОрганизация(Организация);
	СписокОП = Новый СписокЗначений;
	
	Для Каждого ОбособленноеПодразделение Из ВсяОрганизация Цикл
		СписокОП.Добавить(ОбособленноеПодразделение);
	КонецЦикла;
	
	СтруктураШапки.Вставить("СписокОрганизаций", СписокОП);
	
	ЕстьОбособленныеПодразделения = СписокОП.Количество() > 1;
	СтруктураШапки.Вставить("ЕстьОбособленныеПодразделения", ЕстьОбособленныеПодразделения);
	СтруктураШапки.Вставить("СуммаПересчетаУбытков",0);
	
	Возврат СтруктураШапки;
	
КонецФункции

&НаСервере
Функция УчетнаяПолитикаСуществует(ОрганизацияДляУчетнойПолитики, Ссылка)
	
	Существует = УчетнаяПолитика.Существует(ОрганизацияДляУчетнойПолитики, КонецПериода, Ложь, Ссылка);
	Отказ      = Не Существует;
	
	Возврат Отказ;
	
КонецФункции

&НаСервере
Функция ЗаписиРаздела4КУДиР()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Период,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Организация,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ПФР,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ФСС,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ФОМС,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ФСС_НС,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Больничные,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ДобровольноеСтрахование,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.ДокументРасхода,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Регистратор,
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.РеквизитыПервичногоДокумента
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовИРасходовРаздел4 КАК РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4
	|ГДЕ
	|	РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Организация = &Организация
	|		И РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|		И РегистрНакопленияКнигаУчетаДоходовИРасходовРаздел4.Регистратор ССЫЛКА Документ.ЗаписьКУДиР
	|";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТабличнуюЧасть()
	
	Если НЕ ОбъектНалогообложенияДоходы Тогда
		Список.Очистить();
		Возврат;
	КонецЕсли;
	
	СтруктураШапкиДокумента = ЗаполнитьСтруктуруШапкиДокумента();
	
	Если СтруктураШапкиДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.РегламентнаяОперация.ПодготовитьПараметрыРасчетаРасходовУменьшающихНалоги(
		СтруктураШапкиДокумента, Ложь);
		
	ОбщаяТаблицаРасходов = УчетРасходовУменьшающихОтдельныеНалоги.РасчетРасходовУменьшающихОтдельныеНалоги(
		ПараметрыПроведения.ТаблицаРеквизиты, Истина);
		
	ТаблицаРасходовУменьшающихНалог = УчетУСН.ПодготовитьТаблицуДвиженийПоРазделу4КУДиР(ОбщаяТаблицаРасходов,
		ПараметрыПроведения.ТаблицаРеквизиты);
		
	ТаблицаРасходовУменьшающихНалог.Колонки.Добавить("НомерДокумента");
	ТаблицаРасходовУменьшающихНалог.Колонки.Добавить("ПредставлениеДокумента");
	ОписаниеТипов = Документы.ТипВсеСсылки();
	
	ЗаписиКУДиР = ЗаписиРаздела4КУДиР();
	
	// Объединим две таблицы
	Если ЗаписиКУДиР.Количество() > 0 Тогда
		Для Каждого СтрокаТаблицыИсточника Из ЗаписиКУДиР Цикл
			ЗаполнитьЗначенияСвойств(ТаблицаРасходовУменьшающихНалог.Добавить(), СтрокаТаблицыИсточника);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СтрокаТаблицы Из ТаблицаРасходовУменьшающихНалог Цикл
		ДокументРасходаПоСтроке = СтрокаТаблицы.ДокументРасхода;
		Значение                = ТипЗнч(ДокументРасходаПоСтроке);
		
		Если Значение = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Выдача наличных, вх. " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.СписаниеСРасчетногоСчета") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Списание с расчетного счета, вх. " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.ЗаписьКУДиР") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Запись книги доходов и расходов УСН " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.ОперацияБух") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Операция " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.НачислениеЗарплаты") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Начисление зарплаты " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.ОтражениеЗарплатыВБухучете") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Отражение зарплаты в бухучете " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		ИначеЕсли Значение = Тип("ДокументСсылка.ОтражениеЗарплатыВУчете") Тогда
			СтрокаТаблицы.ПредставлениеДокумента = "Зарплата (ЗУП 2.5, ЗиК 7.7) " + СтрокаТаблицы.РеквизитыПервичногоДокумента;
		КонецЕсли;
		
		СтрокаТаблицы.Период         = ДокументРасходаПоСтроке.Дата;
		СтрокаТаблицы.НомерДокумента = ДокументРасходаПоСтроке.Номер;
	КонецЦикла;
	
	ТаблицаРасходовУменьшающихНалог.Сортировать("Период");
	Список.Загрузить(ТаблицаРасходовУменьшающихНалог);
	
КонецПроцедуры

#КонецОбласти
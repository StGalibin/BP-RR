﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подготавливает табличный документ и таблицу, содержащие планируемые платежи.
// Параметры:
//   Параметры - Структура - структура параметров фонового задания. Ключи структуры:
//     * Организация      - СправочникСсылка.Организации
//     * ДнейПланирования - Число
//   АдресХранилища - Строка - адрес временного хранилища
//
Процедура ЗаполнитьКалендарь(Параметры, АдресХранилища) Экспорт
	
	Данные = ДанныеКалендаря(Параметры.Организация, Параметры.ДнейПланирования);
	
	Если Данные = Неопределено Тогда
		ПоместитьВоВременноеХранилище(Неопределено, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	РезультатВыполнения = Новый Структура;
	
	НепросроченныеПлатежи = Данные.ВсеПлатежи.Скопировать(
		Новый Структура("Просрочен", Ложь), "ДатаПлатежа, Сумма, Документ");
	
	РезультатВыполнения.Вставить("Платежи",   НепросроченныеПлатежи);
	РезультатВыполнения.Вставить("Календарь", ВывестиКалендарь(Данные));
	
	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
	
КонецПроцедуры

Функция НоваяТаблицаПлатежи() Экспорт
	
	Возврат НоваяТаблицаВсеПлатежи();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПолучениеДанных

Функция ДанныеКалендаря(Организация, ДнейПланирования)
	
	Данные = НовыеДанные(Организация, ДнейПланирования);
	
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Данные.ОстатокДенег = ОстатокДенег(Организация);
	
	ЗаполнитьВсеПлатежи(Данные);
	
	ВсеПлатежныеДокументы = Данные.ВсеПлатежи.Скопировать(,"ПлатежныйДокумент");
	ВсеПлатежныеДокументы.Свернуть("ПлатежныйДокумент");
	
	Данные.ЕстьПлатежныеДокументы = ВсеПлатежныеДокументы.Количество() > 1 
		Или ВсеПлатежныеДокументы.Количество() = 1 И ЗначениеЗаполнено(ВсеПлатежныеДокументы[0].ПлатежныйДокумент);
	
	Возврат Данные;
	
КонецФункции

Процедура ЗаполнитьВсеПлатежи(Данные)
	
	// Заполнение источников данных
	ПлатежиИзСпискаЗадач = ВыполнениеЗадачБухгалтера.ПлатежиПоЗадачам(
							Данные.Организация, Данные.НаДату, Данные.ГоризонтПланирования);
	
	НалогиИВзносы     = ПлатежиИзСпискаЗадач.УплатаНалогов;
	Зарплата          = ПлатежиИзСпискаЗадач.Зарплата;
	РегулярныеПлатежи = ПлатежиИзСпискаЗадач.РегулярныеПлатежи;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПлатежейОтПокупателей") Тогда
		ОплатаОтПокупателей = Обработки.ОжидаемаяОплатаОтПокупателей.ПланируемыеПлатежи(Данные.Организация, Данные.НаДату);
	Иначе
		ОплатаОтПокупателей = Неопределено;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПлатежейПоставщикам") Тогда
		ПлатежиПоставщикам = Обработки.ОплатаПоставщикам.ПланируемыеПлатежи(Данные.Организация, Данные.НаДату);
	Иначе
		ПлатежиПоставщикам = Неопределено;
	КонецЕсли;
	
	// Раздел "Прочие поступления", эквайринг и инкассация.
	ЗаполнитьПрочиеПоступления(Данные);
	
	Раздел1 = ПараметрыРаздела(1, НСтр("ru='Оплата от покупателей'"), "Приход", Ложь,   WebЦвета.Зеленый);
	Раздел2 = ПараметрыРаздела(2, НСтр("ru='Прочие поступления'"),    "Приход", Ложь,   WebЦвета.СветлоЗеленый);
	Раздел3 = ПараметрыРаздела(3, НСтр("ru='Налоги и взносы'"),       "Расход", Истина, WebЦвета.Томатный);
	Раздел4 = ПараметрыРаздела(4, НСтр("ru='Платежи поставщикам'"),   "Расход", Ложь,   WebЦвета.Золотой);
	Раздел5 = ПараметрыРаздела(5, НСтр("ru='Зарплата'"),              "Расход", Истина, WebЦвета.СинийСоСтальнымОттенком);
	Раздел6 = ПараметрыРаздела(6, НСтр("ru='Периодические платежи'"), "Расход", Истина, WebЦвета.Оранжевый);
	
	ДобавитьРаздел(Раздел1, Данные, ОплатаОтПокупателей);
	ДобавитьРаздел(Раздел2, Данные, Неопределено);
	ДобавитьРаздел(Раздел3, Данные, НалогиИВзносы);
	ДобавитьРаздел(Раздел4, Данные, ПлатежиПоставщикам);
	ДобавитьРаздел(Раздел5, Данные, Зарплата);
	ДобавитьРаздел(Раздел6, Данные, РегулярныеПлатежи);
	
	ЗаполнитьПлатежиПоДням(Данные);
	
КонецПроцедуры

Функция ОстатокДенег(Организация)
	
	ПараметрыОстаткиДенег = Новый Структура();
	ПараметрыОстаткиДенег.Вставить("Организация", Организация);
	ПараметрыОстаткиДенег.Вставить("ВариантОкругления", 1);
	ПараметрыОстаткиДенег.Вставить("ПолучатьПрошлыйПериод", Ложь);
	ПараметрыОстаткиДенег.Вставить("РазделыМонитора",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.РазделыМонитораРуководителя.ОстаткиДенежныхСредств));
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	
	МониторРуководителя.ОбновитьДанныеМонитораВФоне(ПараметрыОстаткиДенег, АдресХранилища);
	
	ОстаткиДенежныхСредств = МониторРуководителя.ДанныеОстаткиДенежныхСредств(ПараметрыОстаткиДенег);
	
	Возврат ОстаткиДенежныхСредств.Итого;
	
КонецФункции

Процедура ДобавитьРаздел(ПараметрыРаздела, Данные, Платежи)
	
	Раздел = Данные.Разделы.Добавить();
	
	Раздел.НомерРаздела = ПараметрыРаздела.Номер;
	Раздел.ИмяРаздела   = ПараметрыРаздела.Имя;
	Раздел.ЦветРаздела  = ПараметрыРаздела.Цвет;
	
	Раздел.КоличествоПлатежей     = 0;
	Раздел.КоличествоПросроченных = 0;
	Раздел.ПросроченоНаСумму      = 0;
	
	Если Платежи = Неопределено ИЛИ Платежи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОтсечьПлатежиЗаГоризонтомПланирования(Данные.ГоризонтПланирования, Платежи);
	
	Платежи.Сортировать("ДатаПлатежа, Сумма Убыв");
	
	Платежи.ЗаполнитьЗначения(Раздел.НомерРаздела, "НомерРаздела");
	
	Для Каждого ПлатежРаздела Из Платежи Цикл
		
		Платеж = Данные.ВсеПлатежи.Добавить();
		ЗаполнитьЗначенияСвойств(Платеж, ПлатежРаздела);
		
		Если ПараметрыРаздела.ВидДвижения = "Расход" Тогда 
			Платеж.Сумма = -Платеж.Сумма; // для подсчета итога за день.
		КонецЕсли;
		
		Если Данные.СписокОрганизаций.Количество() > 1 Тогда
			// Нет отбора, в расшифровку нужно добавить организацию.
			Платеж.Расшифровка = Платеж.Расшифровка + ", " + ПлатежРаздела.Организация;
		КонецЕсли;
		
		Платеж.СуммаПлатежа       = ?(Платеж.Сумма > 0, "+", "") + Формат(Платеж.Сумма, "ЧДЦ=2; ЧН=—");
		Платеж.РасшифровкаПлатежа = ?(ПараметрыРаздела.ПлатежиИзСпискаЗадач, Платеж.ПараметрыКоманды, Платеж.Документ);
		
	КонецЦикла;
	
	Раздел.КоличествоПлатежей = Платежи.Количество();
	
	ПросроченныеПлатежи = Платежи.Скопировать(Новый Структура("Просрочен", Истина));
	
	Раздел.КоличествоПросроченных = ПросроченныеПлатежи.Количество();
	
	Если Раздел.КоличествоПросроченных <> 0 Тогда
		Раздел.ПросроченоНаСумму = Макс(ПросроченныеПлатежи.Итог("Сумма"), -ПросроченныеПлатежи.Итог("Сумма"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПлатежиПоДням(Данные)
	
	ДлинаСуток = 86400;
	ПрогнозОстаток = Данные.ОстатокДенег;
	
	Для НомерДня = 0 По Данные.ДнейПланирования-1 Цикл
		
		СтрокаПлатежиПоДням = Данные.ПлатежиПоДням.Добавить();
		
		ДатаПлатежей = Данные.НаДату + ДлинаСуток * НомерДня;
		
		ПлатежиЗаДень = Данные.ВсеПлатежи.Скопировать(Новый Структура("ДатаПлатежа", ДатаПлатежей));
		
		СтрокаПлатежиПоДням.ДатаПлатежей = ДатаПлатежей;
		СтрокаПлатежиПоДням.СуммаОборот = ПлатежиЗаДень.Итог("Сумма");
		
		ПрогнозОстаток = ПрогнозОстаток + СтрокаПлатежиПоДням.СуммаОборот;
		СтрокаПлатежиПоДням.ОстатокДенегПрогноз = ПрогнозОстаток;
		
		// Нужно, чтобы платежи по одному контрагенту, но по разным документам, выводились в одной ячейке.
		СтрокаПлатежиПоДням.ПлатежиЗаДень = СгруппированныеПлатежиЗаДень(ПлатежиЗаДень);
		
	КонецЦикла;
	
КонецПроцедуры

Функция СгруппированныеПлатежиЗаДень(ПлатежиЗаДень)
	
	СгруппированныеПлатежиЗаДень = НоваяТаблицаВсеПлатежи();
	
	НомераРазделовДляГруппировкиПлатежей = НомераРазделовДляГруппировкиПлатежей();
	
	Для Каждого НомерРаздела Из НомераРазделовДляГруппировкиПлатежей Цикл
		
		ПлатежиЗаДеньПоРазделу = ПлатежиЗаДень.Скопировать(Новый Структура("НомерРаздела", НомерРаздела));
		
		ПлатежиЗаДеньПоРазделу.Свернуть("Контрагент, Организация, НомерРаздела", "Сумма");
		
		Для Каждого Платеж Из ПлатежиЗаДеньПоРазделу Цикл
			
			ПлатежВКалендарь = СгруппированныеПлатежиЗаДень.Добавить();
			
			Отбор = Новый Структура("Контрагент, Организация, НомерРаздела", Платеж.Контрагент, Платеж.Организация, НомерРаздела);
			
			ОтобранныеПлатежи = ПлатежиЗаДень.НайтиСтроки(Отбор);
			ЗаполнитьЗначенияСвойств(ПлатежВКалендарь, ОтобранныеПлатежи[0]);
			
			Если ОтобранныеПлатежи.Количество() > 1 Тогда
				
				ПлатежВКалендарь.Сумма        = Платеж.Сумма;
				ПлатежВКалендарь.СуммаПлатежа = ?(Платеж.Сумма > 0, "+", "") + Формат(Платеж.Сумма, "ЧДЦ=2; ЧН=—");
				
				ДокументыВЯчейке = Новый СписокЗначений;
				
				Для Каждого СгруппированныйПлатеж Из ОтобранныеПлатежи Цикл
					
					Документ = СгруппированныйПлатеж.Документ;
					
					СвойстваДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Номер, Дата");
					
					ПредставлениеДокумента = СтрШаблон(НСтр("ru = '%1 %2 от %3 на сумму %4'"), Документ.Метаданные().Синоним,
						ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СвойстваДокумента.Номер, Истина, Ложь),
						Формат(СвойстваДокумента.Дата, "ДЛФ=D"), СгруппированныйПлатеж.СуммаПлатежа);
					
					ДокументыВЯчейке.Добавить(Документ, ПредставлениеДокумента);
				КонецЦикла;
				
				ПлатежВКалендарь.РасшифровкаПлатежа = ДокументыВЯчейке;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Для Каждого СтрокаПлатежиЗаДень Из ПлатежиЗаДень Цикл
		Если НомераРазделовДляГруппировкиПлатежей.Найти(СтрокаПлатежиЗаДень.НомерРаздела) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СгруппированныеПлатежиЗаДень.Добавить(), СтрокаПлатежиЗаДень);
		КонецЕсли;
	КонецЦикла;
	
	СгруппированныеПлатежиЗаДень.Сортировать("НомерРаздела");
	
	Возврат СгруппированныеПлатежиЗаДень;
	
КонецФункции

Процедура ЗаполнитьПрочиеПоступления(Данные)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ГоризонтПланирования", Новый Граница(Данные.ГоризонтПланирования, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("СписокОрганизаций",    Данные.СписокОрганизаций);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	""Эквайринг"" КАК Раздел,
	|	ХозрасчетныйОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&ГоризонтПланирования, Счет В Иерархии (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам)), , Организация В (&СписокОрганизаций)) КАК ХозрасчетныйОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""Инкассация"",
	|	ХозрасчетныйОстатки.СуммаОстаток
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&ГоризонтПланирования, Счет В Иерархии (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПереводыВПути)), , Организация В (&СписокОрганизаций)) КАК ХозрасчетныйОстатки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Раздел = "Эквайринг" Тогда
			Данные.СуммаЭквайринг = Выборка.Сумма;
		ИначеЕсли Выборка.Раздел = "Инкассация" Тогда
			Данные.СуммаИнкассация = Выборка.Сумма;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Конструкторы

Функция НовыеДанные(Организация, ДнейПланирования)
	
	ДоступныеОрганизации = Справочники.Организации.ДоступныеОрганизацииДляОтбора(Организация);
	
	Если ДоступныеОрганизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Данные = Новый Структура;
	
	НаДату = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	
	// Параметры
	Данные.Вставить("Организация",          Организация);
	Данные.Вставить("СписокОрганизаций",    ДоступныеОрганизации);
	Данные.Вставить("ДнейПланирования",     ДнейПланирования);
	Данные.Вставить("НаДату",               НаДату);
	Данные.Вставить("ГоризонтПланирования", ГоризонтПланирования(ДнейПланирования, НаДату));
	Данные.Вставить("ОстатокДенег",         ОбщегоНазначения.ОписаниеТипаЧисло(15, 2, ДопустимыйЗнак.Любой));
	
	// Таблица будет помещена в форму, используется для переноса платежей.
	Данные.Вставить("ВсеПлатежи", НоваяТаблицаВсеПлатежи());
	
	// Таблицы используются для вывода в табличный документ.
	Данные.Вставить("ПлатежиПоДням", НоваяТаблицаПлатежиПоДням());
	Данные.Вставить("Разделы",       НоваяТаблицаРазделы());
	
	// Для определения нужно ли выводить соответствующее обозначение.
	Данные.Вставить("ЕстьПлатежныеДокументы", Ложь);
	Данные.Вставить("ЕстьОплатаПоСчету",      Ложь);
	
	// Прочие поступления
	Данные.Вставить("СуммаЭквайринг",  0);
	Данные.Вставить("СуммаИнкассация", 0);
	
	Возврат Данные;
	
КонецФункции

Функция НоваяТаблицаРазделы()
	
	Разделы = Новый ТаблицаЗначений;
	
	Разделы.Колонки.Добавить("ИмяРаздела",             ОбщегоНазначения.ОписаниеТипаСтрока(50));
	Разделы.Колонки.Добавить("НомерРаздела",           ОбщегоНазначения.ОписаниеТипаЧисло(1,, ДопустимыйЗнак.Неотрицательный));
	Разделы.Колонки.Добавить("ЦветРаздела",            Новый ОписаниеТипов("Цвет"));
	Разделы.Колонки.Добавить("КоличествоПросроченных", ОбщегоНазначения.ОписаниеТипаЧисло(3,, ДопустимыйЗнак.Неотрицательный));
	Разделы.Колонки.Добавить("ПросроченоНаСумму",      ОбщегоНазначения.ОписаниеТипаЧисло(15, 2, ДопустимыйЗнак.Любой));
	Разделы.Колонки.Добавить("КоличествоПлатежей",     ОбщегоНазначения.ОписаниеТипаЧисло(3,, ДопустимыйЗнак.Неотрицательный));
	
	Возврат Разделы;
	
КонецФункции

Функция НоваяТаблицаПлатежиПоДням()
	
	ОписаниеТипаСумма = ОбщегоНазначения.ОписаниеТипаЧисло(15, 2, ДопустимыйЗнак.Любой);
	
	ПлатежиПоДням = Новый ТаблицаЗначений;
	
	ПлатежиПоДням.Колонки.Добавить("ДатаПлатежей",        ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	ПлатежиПоДням.Колонки.Добавить("СуммаОборот",         ОписаниеТипаСумма);
	ПлатежиПоДням.Колонки.Добавить("ОстатокДенегПрогноз", ОписаниеТипаСумма);
	ПлатежиПоДням.Колонки.Добавить("ПлатежиЗаДень",       Новый ОписаниеТипов("ТаблицаЗначений"));
	
	Возврат ПлатежиПоДням;
	
КонецФункции

Функция НоваяТаблицаВсеПлатежи()
	
	ОписаниеТипаСумма = ОбщегоНазначения.ОписаниеТипаЧисло(15, 2, ДопустимыйЗнак.Любой);
	
	Платежи = Новый ТаблицаЗначений;
	
	Платежи.Колонки.Добавить("ДатаПлатежа",           ОбщегоНазначения.ОписаниеТипаДата(ЧастиДаты.Дата));
	Платежи.Колонки.Добавить("Сумма",                 ОписаниеТипаСумма);
	Платежи.Колонки.Добавить("СуммаПлатежа",          ОбщегоНазначения.ОписаниеТипаСтрока(70));
	Платежи.Колонки.Добавить("Расшифровка",           ОбщегоНазначения.ОписаниеТипаСтрока(70));
	Платежи.Колонки.Добавить("НомерРаздела",          ОбщегоНазначения.ОписаниеТипаЧисло(1,, ДопустимыйЗнак.Неотрицательный));
	Платежи.Колонки.Добавить("Просрочен",             Новый ОписаниеТипов("Булево"));
	Платежи.Колонки.Добавить("Примечание",            ОбщегоНазначения.ОписаниеТипаСтрока(0));
	Платежи.Колонки.Добавить("Организация",           Новый ОписаниеТипов("СправочникСсылка.Организации"));
	Платежи.Колонки.Добавить("ЕстьПлатежныйДокумент", Новый ОписаниеТипов("Булево"));
	Платежи.Колонки.Добавить("ПлатежныйДокумент",     Новый ОписаниеТипов("ДокументСсылка.ПлатежноеПоручение"));
	Платежи.Колонки.Добавить("Документ");
	Платежи.Колонки.Добавить("ПараметрыКоманды");
	Платежи.Колонки.Добавить("РасшифровкаПлатежа");
	Платежи.Колонки.Добавить("Контрагент"); // Для группировки платежей в один день.
	
	Возврат Платежи;
	
КонецФункции

#КонецОбласти

#Область ВыводРезультата

Функция ВывестиКалендарь(Данные)
	
	МакетКалендарь = Обработки.ПлатежныйКалендарь.ПолучитьМакет("МакетКалендарь");
	
	ОбластьМакетаДанные         = МакетКалендарь.Область("ЦветоваяПометкаДанные");
	ОбластьМакетаРазделы        = МакетКалендарь.Область("ЦветнаяПометкаРазделы");
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ОбластьМакетаДанные.ШиринаКолонки         = 1;
		ОбластьМакетаРазделы.ШиринаКолонки        = 1.2;
	Иначе
		ОбластьМакетаДанные.ШиринаКолонки         = 0.8;
		ОбластьМакетаРазделы.ШиринаКолонки        = 1;
	КонецЕсли;
	
	Результат = Новый ТабличныйДокумент;
	
	Результат.ФиксацияСверху = 5;
	
	Результат.Присоединить(ОбластьРазделы(МакетКалендарь, Данные));
	
	Для Каждого ПлатежиЗаДень Из Данные.ПлатежиПоДням Цикл
		Результат.Присоединить(ОбластьПлатежиЗаДень(МакетКалендарь, ПлатежиЗаДень, Данные.Разделы, Данные.НаДату));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбластьРазделы(МакетКалендарь, Данные)
	
	ОбластьРазделы = Новый ТабличныйДокумент;
	
	НоваяОбласть = МакетКалендарь.ПолучитьОбласть("ЗаголовокОстатокДенегПериоды|ЗаголовокРазделы");
	
	НоваяОбласть.Параметры.ОстатокДенег = Формат(Данные.ОстатокДенег, "ЧДЦ=2; ЧН=0");
	
	НоваяОбласть.Параметры.РасшифровкаОстатокДенег = "Остатки денег";
	ОбластьРазделы.Вывести(НоваяОбласть);
	
	ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("СтрокаПрогнозДенег|ЗаголовокРазделы"));
	
	Для Каждого СтрокаРаздел Из Данные.Разделы Цикл
		
		Если СтрокаРаздел.НомерРаздела = 2 Тогда
			
			// Для раздела "Прочие поступления" нет платежей.
			// Выводим итоги по эквайрингу и инкассации без возможности расшифровки.
			// Затем выводим отступ между доходами и расходами.
			
			Если Данные.СуммаЭквайринг <> 0 ИЛИ Данные.СуммаИнкассация <> 0 Тогда
				// Вывод информации о прочих поступлениях, если они планируются.
				
				ОбластьРазделы.Вывести(ОбластьПрочиеПоступления(МакетКалендарь, Данные, СтрокаРаздел));
				
			КонецЕсли;
			
			// Вывод отступа между разделами прихода и расхода денег.
			ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("ГоризонтальныйОтступ|ЗаголовокРазделы"));
			
		КонецЕсли;
		
		Если СтрокаРаздел.КоличествоПлатежей = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Расшифровка1 = Неопределено;
		
		// Информация о просроченных по разделу, если есть
		Если СтрокаРаздел.КоличествоПросроченных <> 0 Тогда
			
			ПредметИсчисления = НСтр("ru = 'платеж, платежа, платежей'");
			
			ТекстПросрочено = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
				СтрокаРаздел.КоличествоПросроченных, ПредметИсчисления);
			
			Если СтрокаРаздел.ПросроченоНаСумму <> 0 Тогда
				ТекстПросрочено = ТекстПросрочено
					+ СтрШаблон(НСтр("ru = ' (%1)'"), Формат(СтрокаРаздел.ПросроченоНаСумму, "ЧДЦ=2; ЧН=0"));
			КонецЕсли;
			
			Расшифровка1 = Новый Структура;
			Расшифровка1.Вставить("Расшифровка1",     "Просрочено: " + СтрокаРаздел.ИмяРаздела);
			Расшифровка1.Вставить("ТекстНадписи",     НСтр("ru = 'Просрочено:'"));
			Расшифровка1.Вставить("ЭтоГиперссылка",   Истина);
			Расшифровка1.Вставить("ТекстГиперссылки", ТекстПросрочено);
			Расшифровка1.Вставить("ЦветГиперссылки",  Новый Цвет(178, 34, 34));
			
		КонецЕсли;
		
		ОбластьРазделы.Вывести(ОбластьРаздел(МакетКалендарь, СтрокаРаздел, Расшифровка1));
		
	КонецЦикла;
	
	// Обозначения
	ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("ГоризонтальныйОтступ|ЗаголовокРазделы"));
	ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("ОбозначениеЗадолженность|ЗаголовокРазделы"));
	ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("ОбозначениеОплатаПоСчету|ЗаголовокРазделы"));
	ОбластьРазделы.Вывести(МакетКалендарь.ПолучитьОбласть("ОбозначениеЕстьПлатежныйДокумент|ЗаголовокРазделы"));
	
	Возврат ОбластьРазделы;
	
КонецФункции

Функция ОбластьРаздел(МакетКалендарь, Раздел, Расшифровка1 = Неопределено, Расшифровка2 = Неопределено)
	
	// В разделе может быть две строки расшифровки (как в "Прочие поступления"),
	// одна строка (может быть для всех разделов) или ни одной (например, если нет просроченных по разделу).
	// Макет оформляется зависимо от того сколько расшифровок в разделе, и доступны ли для них действия.
	
	// Оформление
	ОбластьМакета = МакетКалендарь.Область("СтрокаРазделДанные|ЦветнаяПометкаРазделы");
	ОбластьМакета.ЦветФона = Раздел.ЦветРаздела;
	
	ОбластьМакета = МакетКалендарь.Область("СтрокаРасшифровка1|ГиперссылкаРасшифровка");
	
	Если Расшифровка1 = Неопределено ИЛИ НЕ Расшифровка1.ЭтоГиперссылка Тогда
		
		ОбластьМакета.Гиперссылка              = Ложь;
		ОбластьМакета.Шрифт                    = Новый Шрифт(ОбластьМакета.Шрифт,,,,, Ложь);
		ОбластьМакета.ЦветТекста               = Новый Цвет(0, 0, 0);
		ОбластьМакета.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	Иначе
		
		ОбластьМакета.Гиперссылка              = Истина;
		ОбластьМакета.Шрифт                    = Новый Шрифт(ОбластьМакета.Шрифт,,,,, Истина);
		ОбластьМакета.ЦветТекста               = Расшифровка1.ЦветГиперссылки;
		ОбластьМакета.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
		
	КонецЕсли;
	
	ОбластьМакета = МакетКалендарь.Область("СтрокаРасшифровка2|ГиперссылкаРасшифровка");
	
	Если Расшифровка2 = Неопределено ИЛИ НЕ Расшифровка2.ЭтоГиперссылка Тогда
		
		ОбластьМакета.Гиперссылка              = Ложь;
		ОбластьМакета.Шрифт                    = Новый Шрифт(ОбластьМакета.Шрифт,,,,, Ложь);
		ОбластьМакета.ЦветТекста               = Новый Цвет(0, 0, 0);
		ОбластьМакета.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
		
	Иначе
		
		ОбластьМакета.Гиперссылка              = Истина;
		ОбластьМакета.Шрифт                    = Новый Шрифт(ОбластьМакета.Шрифт,,,,, Истина);
		ОбластьМакета.ЦветТекста               = Расшифровка2.ЦветГиперссылки;
		ОбластьМакета.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
		
	КонецЕсли;
	
	// Заполнение
	НоваяОбласть = МакетКалендарь.ПолучитьОбласть("СтрокаРазделДанные|ЗаголовокРазделы");
	НоваяОбласть.Параметры.ИмяРаздела = Раздел.ИмяРаздела;
	
	Если Расшифровка1 = Неопределено Тогда
		НоваяОбласть.Параметры.Расшифровка1            = "";
		НоваяОбласть.Параметры.НадписьРасшифровка1     = "";
		НоваяОбласть.Параметры.ГиперссылкаРасшифровка1 = "";
	Иначе
		НоваяОбласть.Параметры.Расшифровка1            = Расшифровка1.Расшифровка1;
		НоваяОбласть.Параметры.НадписьРасшифровка1     = Расшифровка1.ТекстНадписи;
		НоваяОбласть.Параметры.ГиперссылкаРасшифровка1 = Расшифровка1.ТекстГиперссылки;
	КонецЕсли;
	
	Если Расшифровка2 = Неопределено Тогда
		НоваяОбласть.Параметры.Расшифровка2            = "";
		НоваяОбласть.Параметры.НадписьРасшифровка2     = "";
		НоваяОбласть.Параметры.ГиперссылкаРасшифровка2 = "";
	Иначе
		НоваяОбласть.Параметры.Расшифровка2            = Расшифровка2.Расшифровка2;
		НоваяОбласть.Параметры.НадписьРасшифровка2     = Расшифровка2.ТекстНадписи;
		НоваяОбласть.Параметры.ГиперссылкаРасшифровка2 = Расшифровка2.ТекстГиперссылки;
	КонецЕсли;
	
	Возврат НоваяОбласть;
	
КонецФункции

Функция ОбластьПрочиеПоступления(МакетКалендарь, Данные, Раздел)
	
	СуммаРасшифровка1 = 0;
	СуммаРасшифровка2 = 0;
	
	Если Данные.СуммаЭквайринг <> 0 Тогда
		
		СуммаРасшифровка1 = Формат(Данные.СуммаЭквайринг, "ЧДЦ=2; ЧН=0");
		ТекстРасшифровка1 = "Эквайринг";
		
		Если Данные.СуммаИнкассация <> 0 Тогда
			СуммаРасшифровка2 = Формат(Данные.СуммаИнкассация, "ЧДЦ=2; ЧН=0");
			ТекстРасшифровка2 = "Инкассация";
		КонецЕсли;
		
	ИначеЕсли Данные.СуммаИнкассация <> 0 Тогда
		
		СуммаРасшифровка1 = Формат(Данные.СуммаИнкассация, "ЧДЦ=2; ЧН=0");
		ТекстРасшифровка1 = "Инкассация";
		
	КонецЕсли;
	
	Расшифровка1 = Неопределено;
	Расшифровка2 = Неопределено;
	Если СуммаРасшифровка1 <> 0 Тогда
		Расшифровка1 = Новый Структура;
		Расшифровка1.Вставить("Расшифровка1",     ТекстРасшифровка1);
		Расшифровка1.Вставить("ТекстНадписи",     ТекстРасшифровка1 + ":");
		Расшифровка1.Вставить("ЭтоГиперссылка",   Ложь);
		Расшифровка1.Вставить("ТекстГиперссылки", Формат(СуммаРасшифровка1, "ЧДЦ=2"));
	КонецЕсли;
	Если СуммаРасшифровка2 <> 0 Тогда
		Расшифровка2 = Новый Структура;
		Расшифровка2.Вставить("Расшифровка2",     ТекстРасшифровка2);
		Расшифровка2.Вставить("ТекстНадписи",     ТекстРасшифровка2 + ":");
		Расшифровка2.Вставить("ЭтоГиперссылка",   Ложь);
		Расшифровка2.Вставить("ТекстГиперссылки", Формат(СуммаРасшифровка2, "ЧДЦ=2"));
	КонецЕсли;
	
	Возврат ОбластьРаздел(МакетКалендарь, Раздел, Расшифровка1, Расшифровка2);
	
КонецФункции

Функция ОбластьПлатежиЗаДень(МакетКалендарь, ПлатежиЗаДень, Разделы, НаДату)
	
	ОбластьПлатежиЗаДень = Новый ТабличныйДокумент;
	
	ОбластьПлатежиЗаДень.Вывести(ОбластьЗаголовокПлатежиЗаДень(
		МакетКалендарь, ПлатежиЗаДень.ДатаПлатежей, ПлатежиЗаДень.ОстатокДенегПрогноз, НаДату));
	
	Для Каждого Платеж Из ПлатежиЗаДень.ПлатежиЗаДень Цикл
		
		ОбластьМакета = МакетКалендарь.Область("СтрокаСумма|ДанныеПримечание");
		
		ЕстьПлатежныйДокумент = Платеж.ЕстьПлатежныйДокумент ИЛИ ЗначениеЗаполнено(Платеж.ПлатежныйДокумент);
		ОбластьМакета.Шрифт = Новый Шрифт(ОбластьМакета.Шрифт,,,,,, ЕстьПлатежныйДокумент); // зачеркнуто, если есть
		
		Если ТипЗнч(Платеж.Документ) = Тип("ДокументСсылка.СчетНаОплатуПокупателю")
			ИЛИ ТипЗнч(Платеж.Документ) = Тип("ДокументСсылка.СчетНаОплатуПоставщика") Тогда
			ОбластьМакета.ЦветТекста = ЦветаСтиля.ЗаголовкиСтрокЦветТекста;
		Иначе
			ОбластьМакета.ЦветТекста = Новый Цвет();
		КонецЕсли;
		
		ОбластьМакета = МакетКалендарь.Область("СтрокаРазделДанные|ДанныеПримечание");
		ОбластьМакета.Примечание.Текст = Платеж.Примечание;
		ОбластьМакета.Примечание.Шрифт = ШрифтыСтиля.ШрифтВажнойНадписи;
		
		ОбластьМакета = МакетКалендарь.Область("СтрокаРазделДанные|ЦветоваяПометкаДанные");
		ОбластьМакета.ЦветФона = Разделы.НайтиСтроки(Новый Структура("НомерРаздела", Платеж.НомерРаздела))[0].ЦветРаздела;
		
		НоваяОбласть = МакетКалендарь.ПолучитьОбласть("СтрокаРазделДанные|ДанныеПериод");
		НоваяОбласть.Параметры.Заполнить(Платеж);
		
		ОбластьПлатежиЗаДень.Вывести(НоваяОбласть);
	КонецЦикла;
	
	Возврат ОбластьПлатежиЗаДень;
	
КонецФункции

Функция ОбластьЗаголовокПлатежиЗаДень(МакетКалендарь, ДатаПлатежей, ОстатокДенегПрогноз, НаДату)
	
	ОбластьЗаголовокПлатежиЗаДень = Новый ТабличныйДокумент;
	
	Если ДатаПлатежей = НаДату Тогда
		ИмяДень = НСтр("ru = 'Сегодня'");
	ИначеЕсли ДатаПлатежей = НаДату+86400 Тогда
		ИмяДень = НСтр("ru = 'Завтра'");
	Иначе
		ИмяДень = ТРег(Формат(ДатаПлатежей, "ДФ='dddd'"));
	КонецЕсли;
	
	НоваяОбласть = МакетКалендарь.ПолучитьОбласть("ЗаголовокОстатокДенегПериоды|ДанныеПериод");
	НоваяОбласть.Параметры.ИмяПериода = ИмяДень + Символы.ПС + Формат(ДатаПлатежей, "ДФ=dd.MM.yyyy");
	
	ОбластьЗаголовокПлатежиЗаДень.Вывести(НоваяОбласть);
	
	ЦветОтрицательныйЗаголовок = Новый Цвет(255, 0, 0);
	ЦветОбычныйЗаголовок       = Новый Цвет();
	
	НоваяОбласть = МакетКалендарь.ПолучитьОбласть("СтрокаПрогнозДенег|ДанныеПериод");
	НоваяОбласть.Параметры.ПрогнозОстаткаДенегНаКонецПериода = Формат(ОстатокДенегПрогноз, "ЧН=0");
	
	ОбластьЗаголовокПлатежиЗаДень.Вывести(НоваяОбласть);
	
	Возврат ОбластьЗаголовокПлатежиЗаДень;
	
КонецФункции

#КонецОбласти

#Область ПрочиеВспомогательныеПроцедуры

Процедура ОтсечьПлатежиЗаГоризонтомПланирования(ГоризонтПланирования, ПланируемыеПлатежи)
	
	ПланируемыеПлатежи.Сортировать("ДатаПлатежа");
	НомерПлатежа = ПланируемыеПлатежи.Количество()-1;
	Пока НомерПлатежа >= 0 Цикл
		Если ПланируемыеПлатежи[НомерПлатежа].ДатаПлатежа > ГоризонтПланирования Тогда
			ПланируемыеПлатежи.Удалить(НомерПлатежа);
		Иначе
			Прервать;
		КонецЕсли;
		НомерПлатежа=НомерПлатежа-1;
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыРаздела(Номер, Имя, ВидДвижения, ПлатежиИзСпискаЗадач, ЦветРаздела)
	
	Параметры = Новый Структура;
	Параметры.Вставить("Номер",                Номер);
	Параметры.Вставить("Имя",                  Имя);
	Параметры.Вставить("ВидДвижения",          ВидДвижения);
	Параметры.Вставить("ПлатежиИзСпискаЗадач", ПлатежиИзСпискаЗадач);
	Параметры.Вставить("Цвет",                 ЦветРаздела);
	
	Возврат Параметры;
	
КонецФункции

Функция НомераРазделовДляГруппировкиПлатежей()
	
	НомераРазделовДляГруппировкиПлатежей = Новый Массив;
	НомераРазделовДляГруппировкиПлатежей.Добавить(1);
	НомераРазделовДляГруппировкиПлатежей.Добавить(4);
	
	Возврат НомераРазделовДляГруппировкиПлатежей;
	
КонецФункции

Функция ГоризонтПланирования(ДнейПланирования, ИсходнаяДата = '00010101') Экспорт
	
	Если Не ЗначениеЗаполнено(ИсходнаяДата) Тогда
		ИсходнаяДата = ТекущаяДатаСеанса();
	КонецЕсли;
	Возврат КонецДня(ИсходнаяДата + (ДнейПланирования - 1) * 86400);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
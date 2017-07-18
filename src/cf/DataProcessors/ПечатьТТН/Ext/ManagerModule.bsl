﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Функция РазложитьМассивПоТипамОбъектов(МассивОбъектов)
	СтруктураТипов 	= Новый Структура;
	
	Для Каждого Объект Из МассивОбъектов Цикл
		
		Если ТипЗнч(Объект) 	= Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Если НЕ СтруктураТипов.Свойство("РеализацияТоваровУслуг") Тогда
				МассивРеализаций 	= Новый Массив;
				СтруктураТипов.Вставить("РеализацияТоваровУслуг", МассивРеализаций);
			КонецЕсли;
			СтруктураТипов.РеализацияТоваровУслуг.Добавить(Объект);
		ИначеЕсли ТипЗнч(Объект) 	= Тип("ДокументСсылка.ПередачаТоваров") Тогда
			Если НЕ СтруктураТипов.Свойство("ПередачаТоваров") Тогда
				МассивПеремещений 	= Новый Массив;
				СтруктураТипов.Вставить("ПередачаТоваров", МассивПеремещений);
			КонецЕсли;
			СтруктураТипов.ПередачаТоваров.Добавить(Объект);
		КонецЕсли;
		
	КонецЦикла;
	Возврат СтруктураТипов;
КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ПЕЧАТНЫХ ФОРМ

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТТН") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ТТН", "Товарно-транспортная накладная",
			СформироватьПечатнуюФормуТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати), , "Обработка.ПечатьТТН.ПФ_MXL_ТТН");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

// Функция осуществляет печать формы "1-Т"
// на основании документа "ПеремещениеТоваров".
//
Функция СформироватьПечатнуюФормуТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТТН";
	
	ПечатьТорговыхДокументов.УстановитьМинимальныеПоляПечати(ТабличныйДокумент);
	
	
	НомерТипаДокумента = 0;
	СтруктураТипов = РазложитьМассивПоТипамОбъектов(МассивОбъектов);
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ДанныеДляПечати = Документы[СтруктураОбъектов.Ключ].ПолучитьДанныеДляПечатнойФормыТТН(СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументТТН(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
		Возврат ТабличныйДокумент;
		
	КонецЦикла;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ЗАПОЛНЕНИЯ ТАБЛИЧНОГО ДОКУМЕНТОВ ПЕЧАТНОЙ ФОРМЫ

// Функция формирования структуры хранения итоговых суммы.
//
// Возвращаемое значение:
//	Структура - Структура хранения итоговых сумм
//
Функция СтруктураИтоговыеСуммыТТН()
	
	Структура = Новый Структура;
	
	// Инициализация итогов по странице.
	Структура.Вставить("ИтогоМассаБруттоНаСтранице", 0);
	Структура.Вставить("ИтогоМестНаСтранице", 0);
	Структура.Вставить("ИтогоКоличествоНаСтранице", 0);
	Структура.Вставить("ИтогоСуммаНаСтранице", 0);
	Структура.Вставить("ИтогоМассаНеттоНаСтранице", 0);
	
	// Инициализация итогов по документу.
	Структура.Вставить("ИтогоМассаБрутто", 0);
	Структура.Вставить("ИтогоМест", 0);
	Структура.Вставить("ИтогоКоличество", 0);
	Структура.Вставить("ИтогоСумма", 0);
	Структура.Вставить("ИтогоМассаНетто", 0);
	
	Структура.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", 0);
	Структура.Вставить("СуммаПрописью", "");
	
	Возврат Структура;
	
КонецФункции // СтруктураИтоговыеСуммы()

// Функция формирования структуры хранения данных строки.
//
// Параметры:
//	КоэффициентПересчета - Число - Коэффициент пересчета в валюту регл. учета
//
// Возвращаемое значение:
//	Структура - Структура данных строки товаров
//
Функция СтруктураДанныеСтрокиТТН(КоэффициентПересчета)
	
	Структура = Новый Структура;
	Структура.Вставить("Номер", 0);
	Структура.Вставить("Мест", 0);
	Структура.Вставить("Количество", 0);
	Структура.Вставить("Цена", 0);
	Структура.Вставить("Сумма", 0);
	Структура.Вставить("КоэффициентПересчета", КоэффициентПересчета);
	Структура.Вставить("МассаБрутто", 0);
	Структура.Вставить("МассаНетто", 0);
	
	Возврат Структура;
	
КонецФункции // СтруктураДанныеСтроки()

// Процедура рассчитывает итоговые суммы с учетом строки товаров.
//
// Параметры:
//	ИтоговыеСуммы - Структура - Структура итоговых сумм документа
//	ДанныеСтроки - Структура - Структура данных строки товаров
//
Процедура РассчитатьИтоговыеСуммыТТН(ИтоговыеСуммы, ДанныеСтроки)
	
	// Увеличим итоги по странице.
	ИтоговыеСуммы.ИтогоМестНаСтранице        = ИтоговыеСуммы.ИтогоМестНаСтранице        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = ИтоговыеСуммы.ИтогоКоличествоНаСтранице  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСуммаНаСтранице       = ИтоговыеСуммы.ИтогоСуммаНаСтранице       + ДанныеСтроки.Сумма;
	ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  + ДанныеСтроки.МассаНетто;
	
	// Увеличим итоги по документу.
	ИтоговыеСуммы.ИтогоМест        = ИтоговыеСуммы.ИтогоМест        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличество  = ИтоговыеСуммы.ИтогоКоличество  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСумма       = ИтоговыеСуммы.ИтогоСумма       + ДанныеСтроки.Сумма;
	ИтоговыеСуммы.ИтогоМассаБрутто = ИтоговыеСуммы.ИтогоМассаБрутто + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНетто  = ИтоговыеСуммы.ИтогоМассаНетто  + ДанныеСтроки.МассаНетто;
	
КонецПроцедуры // РассчитатьИтоговыеСуммы()

// Процедура обнуления итоговых сумм по странице.
//
Процедура ОбнулитьИтогиПоСтраницеТТН(ИтоговыеСуммы)
	
	ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = 0;
	ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = 0;
	ИтоговыеСуммы.ИтогоМестНаСтранице        = 0;
	ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = 0;
	ИтоговыеСуммы.ИтогоСуммаНаСтранице       = 0;
	
КонецПроцедуры // ОбнулитьИтогиПоСтранице()

// Процедура формирует итоговые данные для вывода в подвал.
//
Процедура ДобавитьИтоговыеДанныеПодвалаТТН(ИтоговыеСуммы, ВсегоНомеров, ВалютаРегламентированногоУчета)
	
	ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ВсегоНомеров, ,",,,,,,,,0"));
	ИтоговыеСуммы.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСумма, ВалютаРегламентированногоУчета));
	
КонецПроцедуры // ДобавитьИтоговыеДанныеПодвала()

// Процедура заполнения реквизитов строки товара.
//
// Параметры:
//	ДанныеПечати - ВыборкаИзРезультатаЗапроса - Данные шапки документа
//	СтрокаТовары - ВыборкаИзРезультатаЗапроса - Текущая строка товаров
//	ДанныеСтроки - Структура - Данные строки товаров
//	ОбластьМакета - ОбластьЯчеекТабличногоДокумента - Область для вывода строки товаров
//	ТабличныйДокумент - Табличный документа
//
Процедура ЗаполнитьРеквизитыСтрокиТовараТТН(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета, ЕдиницаИзмеренияВеса = Неопределено, КоэффициентПересчетаВТонны = 0)
	
	ПараметрыМакета = Новый Структура;
	
	ПараметрыМакета.Вставить("ТоварНаименование", 
		СокрЛП(СтрокаТовары.ТоварНаименование) + ?(СтрокаТовары.ЭтоВозвратнаяТара, НСтр("ru = ' (возвратная тара)'"), ""));
	
	СтруктураПолей = Новый Структура("ТоварКод, Артикул");
	ЗаполнитьЗначенияСвойств(СтруктураПолей, СтрокаТовары);
	
	ПараметрыМакета.Вставить("ТоварКод", СтруктураПолей.ТоварКод);
	ПараметрыМакета.Вставить("Артикул",  СтруктураПолей.Артикул);
	
	Если ЕдиницаИзмеренияВеса <> Неопределено Тогда
		Если НЕ ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) Тогда
			ДанныеСтроки.МассаБрутто = 0;
			ДанныеСтроки.МассаНетто  = 0;
		Иначе
			ДанныеСтроки.МассаБрутто = СтрокаТовары.МассаБрутто;
			ДанныеСтроки.МассаНетто  = СтрокаТовары.МассаНетто;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеСтроки.Сумма = Окр((СтрокаТовары.Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СтрокаТовары.СуммаНДС)) * ДанныеСтроки.КоэффициентПересчета, 2);
	
	Если Не ДанныеПечати.ЦенаВключаетНДС Тогда
		ДанныеСтроки.Цена = ?(СтрокаТовары.Количество = 0, 0, ДанныеСтроки.Сумма / СтрокаТовары.Количество);
	Иначе
		ДанныеСтроки.Цена = СтрокаТовары.Цена * ДанныеСтроки.КоэффициентПересчета;
	КонецЕсли;
	
	Если СтрокаТовары.Весовой Тогда
		ДанныеСтроки.Мест = 0;
		ДанныеСтроки.Количество = 0;
		
		ПараметрыМакета.Вставить("Цена",  ДанныеСтроки.Цена);
		ПараметрыМакета.Вставить("Сумма", ДанныеСтроки.Сумма);
		ПараметрыМакета.Вставить("Количество",     0);
		ПараметрыМакета.Вставить("КоличествоМест", 0);
		ПараметрыМакета.Вставить("БазоваяЕдиницаНаименование", "");
		ПараметрыМакета.Вставить("ВидУпаковки", "");
		ПараметрыМакета.Вставить("МассаНетто", Окр(СтрокаТовары.МассаНетто * КоэффициентПересчетаВТонны, 2, РежимОкругления.Окр15как20));
		
	Иначе
		ДанныеСтроки.Мест = СтрокаТовары.КоличествоМест;
		ДанныеСтроки.Количество = СтрокаТовары.Количество;
		
		ПараметрыМакета.Вставить("Цена",  ДанныеСтроки.Цена);
		ПараметрыМакета.Вставить("Сумма", ДанныеСтроки.Сумма);
		ПараметрыМакета.Вставить("Количество", ДанныеСтроки.Количество);
		ПараметрыМакета.Вставить("КоличествоМест", ДанныеСтроки.Мест);
		ПараметрыМакета.Вставить("БазоваяЕдиницаНаименование", СтрокаТовары.БазоваяЕдиницаНаименование);
		ПараметрыМакета.Вставить("ВидУпаковки", СтрокаТовары.ВидУпаковки);
		ПараметрыМакета.Вставить("МассаНетто", 0);
	КонецЕсли;
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
КонецПроцедуры // ЗаполнитьРеквизитыСтрокиТовара()

// Процедура заполнения реквизитов шапки ТТН.
//
// Параметры:
//	ДанныеПечати - ВыборкаИзРезультатаЗапроса - Данные шапки документа
//	Макет - Макет ТТН
//	ТабличныйДокумент - Табличный документ
//
Процедура ЗаполнитьРеквизитыШапкиТТН(ДанныеПечати, Макет, ТабличныйДокумент, СведенияОКонтрагентах)
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	ПараметрыМакета = Новый Структура;
	ПараметрыМакета.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Истина, Ложь));
	ПараметрыМакета.Вставить("ДатаДокумента",  ДанныеПечати.Дата);
	
	Если ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
		ПараметрыМакета.Вставить("ПредставлениеОрганизации", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Поставщик,
																"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны"));
	Иначе
		ПараметрыМакета.Вставить("ПредставлениеОрганизации", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Грузоотправитель,
																"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны"));
	КонецЕсли;
	
	ПараметрыМакета.Вставить("ПредставлениеГрузополучателя", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Грузополучатель, 
																"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
	
	ПараметрыМакета.Вставить("ПредставлениеПлательщика", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Покупатель));
	
	
	ПараметрыМакета.Вставить("ОрганизацияПоОКПО",     СведенияОКонтрагентах.Поставщик.КодПоОКПО);
	ПараметрыМакета.Вставить("ГрузополучательПоОКПО", СведенияОКонтрагентах.Грузополучатель.КодПоОКПО);
	ПараметрыМакета.Вставить("ПлательщикПоОКПО",      СведенияОКонтрагентах.Покупатель.КодПоОКПО);
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры

// Процедура заполнения реквизитов подвала ТТН.
//
// Параметры:
//	ДанныеПечати - ВыборкаИзРезультатаЗапроса - Данные шапки документа
//	ИтоговыеСуммы - Структура - Структура итоговых сумм документа
//	Макет - Макет ТТН
//	ТабличныйДокумент - Табличный документ
//
Процедура ЗаполнитьРеквизитыПодвалаТТН(ДанныеПечати, ИтоговыеСуммы, Макет, ТабличныйДокумент, ЕдиницаИзмеренияВеса = Неопределено, КоэффициентПересчетаВТонны = 0)
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	
	ПараметрыМакета = Новый Структура;
	
	ПолнаяДатаДокумента = Формат(ДанныеПечати.Дата, "ДФ=""дд ММММ гггг """"года""""""");
	ДлинаСтроки = СтрДлина(ПолнаяДатаДокумента);
	ПервыйРазделитель = СтрНайти(ПолнаяДатаДокумента, " ");
	ВторойРазделитель = СтрНайти(Прав(ПолнаяДатаДокумента, ДлинаСтроки - ПервыйРазделитель), " ") + ПервыйРазделитель;
	
	ПараметрыМакета.Вставить("ДатаДокументаДень",  """" + Лев(ПолнаяДатаДокумента, ПервыйРазделитель -1 ) + """");
	ПараметрыМакета.Вставить("ДатаДокументаМесяц", Сред(ПолнаяДатаДокумента, ПервыйРазделитель + 1, ВторойРазделитель - ПервыйРазделитель - 1));
	ПараметрыМакета.Вставить("ДатаДокументаГод",   Прав(ПолнаяДатаДокумента, ДлинаСтроки - ВторойРазделитель));
	
	ПодразделениеОтветственныхЛиц = ДанныеПечати.ПодразделениеОрганизации;
	
	Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(ДанныеПечати.Руководители, ДанныеПечати.Дата, ПодразделениеОтветственныхЛиц);
	
	// Главный бухгалтер
	Если Руководители.ГлавныйБухгалтер = ДанныеПечати.ГлавныйБухгалтер ИЛИ НЕ ЗначениеЗаполнено(ДанныеПечати.ГлавныйБухгалтер) Тогда
		ПараметрыМакета.Вставить("ФИОГлавБухгалтера", Руководители.ГлавныйБухгалтерПредставление);
	Иначе
		ДанныеОтветственногоЛица =  ОтветственныеЛицаБП.РеквизитыПодписиУполномоченногоЛица(ДанныеПечати.Организация, ДанныеПечати.ГлавныйБухгалтер,ДанныеПечати.ЗаГлавногоБухгалтераНаОсновании, ДанныеПечати.Дата);
		ЗаместительПоПриказу = "" + ДанныеОтветственногоЛица.ФИО.Представление;
		Если ЗначениеЗаполнено(ДанныеПечати.ЗаГлавногоБухгалтераНаОсновании) Тогда 
			ЗаместительПоПриказу = ЗаместительПоПриказу + ", " + ДанныеОтветственногоЛица.ОснованиеПраваПодписиПредставление;
		КонецЕсли;
		ПараметрыМакета.Вставить("ФИОГлавБухгалтера", ЗаместительПоПриказу);
		
	КонецЕсли;
	
	Если Руководители.Руководитель = ДанныеПечати.Руководитель ИЛИ НЕ ЗначениеЗаполнено(ДанныеПечати.Руководитель) Тогда
		ПараметрыМакета.Вставить("ФИОРуководителя",       Руководители.РуководительПредставление);
		ПараметрыМакета.Вставить("ДолжностьРуководителя", Руководители.РуководительДолжностьПредставление);
	Иначе
		ДанныеОтветственногоЛица = ОтветственныеЛицаБП.РеквизитыПодписиУполномоченногоЛица(ДанныеПечати.Организация, ДанныеПечати.Руководитель,ДанныеПечати.ЗаРуководителяНаОсновании, ДанныеПечати.Дата);
		ЗаместительПоПриказу = "" + ДанныеОтветственногоЛица.ФИО.Представление;
		Если ЗначениеЗаполнено(ДанныеПечати.ЗаРуководителяНаОсновании) Тогда 
			ЗаместительПоПриказу = ЗаместительПоПриказу + ", " + ДанныеОтветственногоЛица.ОснованиеПраваПодписиПредставление;
		КонецЕсли;
		ПараметрыМакета.Вставить("ФИОРуководителя",       ЗаместительПоПриказу);
		ПараметрыМакета.Вставить("ДолжностьРуководителя", ДанныеОтветственногоЛица.ДолжностьПредставление);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеПечати.ОтпускПроизвел) Тогда
		ДанныеОтветственногоЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ДанныеПечати.Организация, ДанныеПечати.ОтпускПроизвел, ДанныеПечати.Дата);
		ПараметрыМакета.Вставить("ФИОКладовщика",       ДанныеОтветственногоЛица.Представление);
		ПараметрыМакета.Вставить("ДолжностьКладовщика", ДанныеОтветственногоЛица.Должность);
	ИначеЕсли ЗначениеЗаполнено(ДанныеПечати.Ссылка.Склад) Тогда 
		МОЛ = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(ДанныеПечати.Ссылка.Склад, ДанныеПечати.Дата);
		ДанныеОтветственногоЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ДанныеПечати.Организация, МОЛ, ДанныеПечати.Дата);
		ПараметрыМакета.Вставить("ФИОКладовщика",       ДанныеОтветственногоЛица.Представление);
		ПараметрыМакета.Вставить("ДолжностьКладовщика", ДанныеОтветственногоЛица.Должность);
	Иначе
		ПараметрыМакета.Вставить("ФИОКладовщика",       "");
		ПараметрыМакета.Вставить("ДолжностьКладовщика", "");
	КонецЕсли;
	
	// Доверенность
	ПараметрыМакета.Вставить("ДоверенностьНомер",     ДанныеПечати.ДоверенностьНомер);
	ПараметрыМакета.Вставить("ДоверенностьДата",      Формат(ДанныеПечати.ДоверенностьДата, "ДФ=dd.MM.yyyy"));
	ПараметрыМакета.Вставить("ДоверенностьВыдана",    ДанныеПечати.ДоверенностьВыдана);
	ПараметрыМакета.Вставить("ДоверенностьЧерезКого", ДанныеПечати.ДоверенностьЧерезКого);
	
	Если ИтоговыеСуммы.ИтогоМест > 0 Тогда
		ПараметрыМакета.Вставить("ВсегоМестПрописью", ЧислоПрописью(ИтоговыеСуммы.ИтогоМест, ,",,,,,,,,0"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) И ИтоговыеСуммы.ИтогоМассаБрутто > 0 Тогда
		ПараметрыМакета.Вставить("МассаГрузаБуттоПрописью", ЧислоПрописью(ИтоговыеСуммы.ИтогоМассаБрутто, ,",,,,,,,,0")+ " " + СокрЛП(ЕдиницаИзмеренияВеса) + ".");
		Если КоэффициентПересчетаВТонны <> 0 Тогда
			ПараметрыМакета.Вставить("МассаГрузаБрутто", Окр(ИтоговыеСуммы.ИтогоМассаБрутто * КоэффициентПересчетаВТонны,2,РежимОкругления.Окр15как20));
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) И ИтоговыеСуммы.ИтогоМассаНетто > 0 Тогда
		ПараметрыМакета.Вставить("МассаГрузаНеттоПрописью", ЧислоПрописью(ИтоговыеСуммы.ИтогоМассаНетто, ,",,,,,,,,0")+ " " + СокрЛП(ЕдиницаИзмеренияВеса) + ".");
		Если КоэффициентПересчетаВТонны <> 0 Тогда
			ПараметрыМакета.Вставить("МассаГрузаНетто", Окр(ИтоговыеСуммы.ИтогоМассаНетто * КоэффициентПересчетаВТонны,2,РежимОкругления.Окр15как20));
		КонецЕсли;                  
	КонецЕсли;
	
	ПараметрыМакета.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью);
	ПараметрыМакета.Вставить("ВсегоНаименованийПрописью", ЧислоПрописью(ДанныеПечати.КоличествоНаименований, ,",,,,,,,,0"));
	ПараметрыМакета.Вставить("СуммаПрописью", ИтоговыеСуммы.СуммаПрописью);
	
	ПараметрыМакета.Вставить("ФИОГрузПринял", ДанныеПечати.Водитель);
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры // ЗаполнитьРеквизитыПодвалаТТН()

// Процедура заполнения реквизитов подвала ТТН.
//
// Параметры:
//	ДанныеПечати - ВыборкаИзРезультатаЗапроса - Данные шапки документа
//	ИтоговыеСуммы - Структура - Структура итоговых сумм документа
//	Макет - Макет ТТН
//	ТабличныйДокумент - Табличный документ
//
Процедура ЗаполнитьРеквизитыТранспортногоРазделаТТН(ДанныеПечати, Макет, ОбластьМакета, СведенияОКонтрагентах)
	
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	ПараметрыМакета = Новый Структура;
	
	ПараметрыМакета.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Ложь));
	
	ПараметрыМакета.Вставить("ПредставлениеПеревозчика", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Перевозчик, 
														"НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
	
	ПараметрыМакета.Вставить("МаркаАвтомобиля",       ДанныеПечати.МаркаАвтомобиля);
	ПараметрыМакета.Вставить("ГосНомерАвтомобиля",    ДанныеПечати.РегистрационныйЗнакАвтомобиля);
	ПараметрыМакета.Вставить("ПредставлениеВодителя", ДанныеПечати.Водитель);
	ПараметрыМакета.Вставить("ВодительскоеУдостоверение", ДанныеПечати.ВодительскоеУдостоверение);
	ПараметрыМакета.Вставить("ПунктПогрузки",  ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Грузоотправитель, "ФактическийАдрес"));
	ПараметрыМакета.Вставить("ПунктРазгрузки", ДанныеПечати.АдресДоставки);
	
	ПараметрыМакета.Вставить("ПредставлениеЗаказчикаПеревозок", ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОКонтрагентах.Покупатель,
																"НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет"));
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
	СтандартнаяКарточка  = Истина;
	ОграниченнаяКарточка = Ложь;
	
	Если СтандартнаяКарточка
		Или ОграниченнаяКарточка Тогда
		ШрифтСтандарт   = Новый Шрифт(ОбластьМакета.Области.Стандарт.Шрифт, , , , , ,Не СтандартнаяКарточка);
		ШрифтОграничено = Новый Шрифт(ОбластьМакета.Области.Стандарт.Шрифт, , , , , ,Не ОграниченнаяКарточка);
	КонецЕсли;
	
	ОбластьМакета.Области.Стандарт.Шрифт   = ШрифтСтандарт;
	ОбластьМакета.Области.Ограничено.Шрифт = ШрифтОграничено;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыСведенийОГрузе(ДанныеПечати, Макет, ОбластьМакета)
	
	ПараметрыМакета = Новый Структура;
	
	ПараметрыМакета.Вставить("КраткоеНаименованиеГруза",  ДанныеПечати.КраткоеНаименованиеГруза);
	ПараметрыМакета.Вставить("СпороводительныеДокументы", ДанныеПечати.СопроводительныеДокументы);
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПодвалаСведенийОГрузе(ДанныеПечати, Макет, ОбластьМакета)
	
	ПараметрыМакета = Новый Структура;
	
	Если ЗначениеЗаполнено(ДанныеПечати.ОтпускПроизвел) Тогда
		
		ДанныеОтветственногоЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ДанныеПечати.Организация, ДанныеПечати.ОтпускПроизвел, ДанныеПечати.Дата);
		
		ПараметрыМакета.Вставить("ФИОКладовщика",       ДанныеОтветственногоЛица.Представление);
		ПараметрыМакета.Вставить("ДолжностьКладовщика", ДанныеОтветственногоЛица.Должность);
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеПечати.Ссылка.Склад) Тогда 
		
		МОЛ = ОтветственныеЛицаБП.ОтветственноеЛицоНаСкладе(ДанныеПечати.Ссылка.Склад, ДанныеПечати.Дата);
		ДанныеФизЛица = ОбщегоНазначенияБПВызовСервера.ДанныеФизЛица(ДанныеПечати.Организация, МОЛ, ДанныеПечати.Дата);
		
		ПараметрыМакета.Вставить("ДолжностьКладовщика", ДанныеФизЛица.Должность);
		ПараметрыМакета.Вставить("ФИОКладовщика",       ДанныеФизЛица.Представление);
		
	Иначе
		
		ПараметрыМакета.Вставить("ФИОКладовщика",       "");
		ПараметрыМакета.Вставить("ДолжностьКладовщика", "");
	КонецЕсли;
	
	ПараметрыМакета.Вставить("Водитель", ДанныеПечати.Водитель);
	
	ОбластьМакета.Параметры.Заполнить(ПараметрыМакета);
	
КонецПроцедуры

// Процедура заполняет табличный документ ТТН.
//
Процедура ЗаполнитьТабличныйДокументТТН(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ДанныеПечати        = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТТН.ПФ_MXL_ТТН");
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		// Найдем в выборке товары по текущему документу
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		
		ВыборкаПоДокументам.Сбросить();
		Если НЕ ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОКонтрагентах = Новый Структура();
		СведенияОКонтрагентах.Вставить("Поставщик", БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДанныеПечати.Организация,      ДанныеПечати.Дата, ДанныеПечати.БанковскийСчетОрганизации));
		СведенияОКонтрагентах.Вставить("Покупатель", БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДанныеПечати.Контрагент,       ДанныеПечати.Дата));
		СведенияОКонтрагентах.Вставить("Перевозчик", БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДанныеПечати.Перевозчик,            ДанныеПечати.Дата));
		СведенияОКонтрагентах.Вставить("Грузоотправитель", БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата));
		СведенияОКонтрагентах.Вставить("Грузополучатель", БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата));
		
		ЗаполнитьРеквизитыШапкиТТН(ДанныеПечати, Макет, ТабличныйДокумент, СведенияОКонтрагентах);
		
		НомерСтраницы = 1;
		ИтоговыеСуммы = СтруктураИтоговыеСуммыТТН();
		
		ДанныеСтроки = СтруктураДанныеСтрокиТТН(1);
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть докмента
		ОбластьЗаголовокТаблицы      = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакета                = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице      = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего                 = Макет.ПолучитьОбласть("Всего");
		ОбластьПодвала               = Макет.ПолучитьОбласть("Подвал");
		ОбластьТранспортногоРаздела  = Макет.ПолучитьОбласть("ТранспортныйРаздел");
		ОбластьСведенийОГрузе        = Макет.ПолучитьОбласть("СведенияОГрузе");
		ОбластьПодвалаСведенийОГрузе = Макет.ПолучитьОбласть("ПодвалСведенийОГрузе");
		ОбластьПрочихСведений        = Макет.ПолучитьОбласть("ПрочиеСведения");
		ОбластьПогрузочныеОперации	 = Макет.ПолучитьОбласть("ПогрузочныеОперации");
		
		КоличествоСтрок = ВыборкаПоДокументам.Количество();
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ЗаполнитьРеквизитыСтрокиТовараТТН(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета);
			
			Если ДанныеСтроки.Номер = 1 Тогда // первая строка
			
				ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			Иначе
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьМакета);
				МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
				
				Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
					
					МассивВыводимыхОбластей.Добавить(ОбластьВсего);
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					
				КонецЕсли;
				
				Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					
					ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
					ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
					
					// Очистим итоги по странице.
					ОбнулитьИтогиПоСтраницеТТН(ИтоговыеСуммы);
					
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			РассчитатьИтоговыеСуммыТТН(ИтоговыеСуммы, ДанныеСтроки);
			
		КонецЦикла;
		
		// Выводим итоги по последней странице
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		ДобавитьИтоговыеДанныеПодвалаТТН(ИтоговыеСуммы, ДанныеСтроки.Номер, ВалютаРегламентированногоУчета);
		ЗаполнитьРеквизитыПодвалаТТН(ДанныеПечати, ИтоговыеСуммы, Макет, ТабличныйДокумент);
		
		МассивВыводимыхОбластей.Очистить();
		
		ЗаполнитьРеквизитыТранспортногоРазделаТТН(ДанныеПечати, Макет, ОбластьТранспортногоРаздела, СведенияОКонтрагентах);
		
		МассивВыводимыхОбластей.Добавить(ОбластьТранспортногоРаздела);
		МассивВыводимыхОбластей.Добавить(ОбластьСведенийОГрузе);
		МассивВыводимыхОбластей.Добавить(ОбластьПодвалаСведенийОГрузе);
		МассивВыводимыхОбластей.Добавить(ОбластьПогрузочныеОперации);
		МассивВыводимыхОбластей.Добавить(ОбластьПрочихСведений);
		
		Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьТранспортногоРаздела);
		
		ЗаполнитьРеквизитыСведенийОГрузе(ДанныеПечати, Макет, ОбластьСведенийОГрузе);
		ТабличныйДокумент.Вывести(ОбластьСведенийОГрузе);
		
		ЗаполнитьРеквизитыПодвалаСведенийОГрузе(ДанныеПечати, Макет, ОбластьПодвалаСведенийОГрузе);
		ТабличныйДокумент.Вывести(ОбластьПодвалаСведенийОГрузе);
		
		ТабличныйДокумент.Вывести(ОбластьПогрузочныеОперации);
		ТабличныйДокумент.Вывести(ОбластьПрочихСведений);
	
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличныйДокументТТН()

#КонецЕсли
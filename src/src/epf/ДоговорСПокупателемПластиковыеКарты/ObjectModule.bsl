﻿Функция СведенияОВнешнейОбработке() Экспорт

	ПараметрыРегистрации = Новый Структура;
	МассивНазначений     = Новый Массив;
	МассивНазначений.Добавить( "Справочник.ДоговорыКонтрагентов" );
	ПараметрыРегистрации.Вставить( "Вид", "ПечатнаяФорма" );
	ПараметрыРегистрации.Вставить( "Назначение", МассивНазначений );
	ПараметрыРегистрации.Вставить( "Наименование", "Договор поставки (пластиковые карты)" ); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить( "БезопасныйРежим", ЛОЖЬ );
	ПараметрыРегистрации.Вставить( "Версия", "1.0" );
	ПараметрыРегистрации.Вставить( "Информация", "Печатная форма договора поставки (пластиковые карты)" );
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду( ТаблицаКоманд, "Договор поставки (пластиковые карты)", "ДоговорПоставкиПластиковыеКарты", "ВызовСерверногоМетода", Истина, "ПечатьMXL" );
	ПараметрыРегистрации.Вставить( "Команды", ТаблицаКоманд );
	
	Возврат ПараметрыРегистрации;
	

КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить( "Представление", Новый ОписаниеТипов( "Строка" ) ); //как будет выглядеть описание печ.формы для пользователя
	Команды.Колонки.Добавить( "Идентификатор", Новый ОписаниеТипов( "Строка" ) ); //имя макета печ.формы
	Команды.Колонки.Добавить( "Использование", Новый ОписаниеТипов( "Строка" ) ); //ВызовСерверногоМетода
	Команды.Колонки.Добавить( "ПоказыватьОповещение", Новый ОписаниеТипов( "Булево" ) );
	Команды.Колонки.Добавить( "Модификатор", Новый ОписаниеТипов( "Строка" ) );
	
	Возврат Команды;

КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")

НоваяКоманда = ТаблицаКоманд.Добавить();
НоваяКоманда.Представление = Представление; 
НоваяКоманда.Идентификатор = Идентификатор;
НоваяКоманда.Использование = Использование;
НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
НоваяКоманда.Модификатор = Модификатор;

КонецПроцедуры

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ДоговорПоставкиПластиковыеКарты", "Договор поставки (пластиковые карты)", СформироватьПечатнуюФорму(МассивОбъектов[0], ОбъектыПечати));

КонецПроцедуры // Печать()

Функция СформироватьПечатнуюФорму(ДоговорСсылка, ОбъектыПечати)

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДоговорПоставкиПластиковыеКарты";
	
	МакетОбработки = ПолучитьМакет( "ДоговорПоставкиПластиковыеКарты" );
	
	Если Не ДоговорСсылка.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		
		ОбластьОшибка = МакетОбработки.ПолучитьОбласть( "ОшибкаВыполнения" );
		ТабличныйДокумент.Вывести( ОбластьОшибка );
		
	Иначе
		
		РеквизитыДоговора = Справочники.ДоговорыКонтрагентов.ПодготовитьПараметрыПечатиТекстаДоговора( ДоговорСсылка );
		ОбластьШапка      = МакетОбработки.ПолучитьОбласть( "Шапка" );
		ОбластьШапка.Параметры.НомерДоговора = РеквизитыДоговора.Номер;
		ОбластьШапка.Параметры.ДатаДоговора  = Формат ( РеквизитыДоговора.Дата, "ДФ='dd MMMM yyyy ""г.""'" );
		
		// данные организации
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице( ДоговорСсылка.Организация,
																					  ДоговорСсылка.Дата );
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации( СведенияОбОрганизации,
																					   "НаименованиеДляПечатныхФорм," );
		ОбластьШапка.Параметры.Организация          = ПредставлениеОрганизации;
		ОбластьШапка.Параметры.ПодписантОрганизация = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
			ДоговорСсылка.ДолжностьРуководителя.Наименование,
			2,
			ДоговорСсылка );
		ОбластьШапка.Параметры.ФИОПодписантаОрганизация = СклонениеПредставленийОбъектов.ПросклонятьФИО(
			ДоговорСсылка.Руководитель.ФИО,
			2,
			ДоговорСсылка,
			ДоговорСсылка.Руководитель.Пол );
		ОбластьШапка.Параметры.ОснованиеПолномочийОрганизация = ? (
			ЗначениеЗаполнено(
				ДоговорСсылка.ЗаРуководителяПоПриказу ),
			СклонениеПредставленийОбъектов.ПросклонятьПредставление( ДоговорСсылка.ЗаРуководителяПоПриказу,
																	 2,
																	 ДоговорСсылка ),
																 "Устава" );
																 
		// данные контрагента
		СведенияОКонтрагенте = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице( ДоговорСсылка.Владелец,
																					 ДоговорСсылка.Дата );
		ПредставлениеКонтрагента = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации( СведенияОКонтрагенте,
																					   "НаименованиеДляПечатныхФорм," );
		ОбластьШапка.Параметры.Контрагент          = ПредставлениеКонтрагента;
		ОбластьШапка.Параметры.ПодписантКонтрагент = СклонениеПредставленийОбъектов.ПросклонятьПредставление(
			ДоговорСсылка.ДолжностьРуководителяКонтрагента,
			2,
			ДоговорСсылка );
		ОбластьШапка.Параметры.ФИОПодписантаКонтрагент = СклонениеПредставленийОбъектов.ПросклонятьФИО(
			ДоговорСсылка.РуководительКонтрагента,
			2,
			ДоговорСсылка,
			ДоговорСсылка.ПолРуководителяКонтрагента );
		ОбластьШапка.Параметры.ОснованиеПолномочийКонтрагент = ? (
			ЗначениеЗаполнено(
				ДоговорСсылка.ЗаРуководителяКонтрагентаПоПриказу ),
			СклонениеПредставленийОбъектов.ПросклонятьПредставление( ДоговорСсылка.ЗаРуководителяКонтрагентаПоПриказу,
																	 2,
																	 ДоговорСсылка ),
																 "Устава" );
		
		// выводим шапку в табличный документ
		ТабличныйДокумент.Вывести( ОбластьШапка );
		
		ОбластьДанные = МакетОбработки.ПолучитьОбласть( "Данные" );
		//ОбластьДанные.Параметры.Контрагент = ОбластьШапка.Параметры.Контрагент;
		//ОбластьДанные.Параметры.ПодписантКонтрагент     = ОбластьШапка.Параметры.ПодписантКонтрагент;
		//ОбластьДанные.Параметры.ФИОПодписантаКонтрагент = ОбластьШапка.Параметры.ФИОПодписантаКонтрагент;
		ОбластьДанные.Параметры.СрокДействияДоговора    = Формат ( ДоговорСсылка.СрокДействия, "ДФ='dd MMMM yyyy ""г.""'" );
		ТабличныйДокумент.Вывести( ОбластьДанные );
		
		
		// //заполняем подвал
		ОбластьПодвал = МакетОбработки.ПолучитьОбласть( "Подвал" );
		
		// организация
		ОбластьПодвал.Параметры.Организация    = ПредставлениеОрганизации;
		ОбластьПодвал.Параметры.ИННОрганизация = ДоговорСсылка.Организация.ИНН;
		
		
		ОбластьПодвал.Параметры.ЮрАдресОрганизация       = СведенияОбОрганизации.ЮридическийАдрес;
		ОбластьПодвал.Параметры.ПочтАдресОрганизация     = СведенияОбОрганизации.ПочтовыйАдрес;
		ОбластьПодвал.Параметры.РасчетныйСчетОрганизация = СведенияОбОрганизации.НомерСчета;
		ОбластьПодвал.Параметры.БанкОрганизация          = СведенияОбОрганизации.Банк;
		ОбластьПодвал.Параметры.КоррСчетОрганизация      = СведенияОбОрганизации.КоррСчет;
		ОбластьПодвал.Параметры.БИКОрганизация           = СведенияОбОрганизации.БИК;
		ОбластьПодвал.Параметры.ОКПООрганизация          = СведенияОбОрганизации.КодПоОКПО;
		ОбластьПодвал.Параметры.ОКВЭДОрганизация         =
		
			//ДоговорСсылка.Организация.КодОКВЭД + ", " +
		ДоговорСсылка.Организация.КодОКВЭД2;
		ОбластьПодвал.Параметры.ЭлПочтаОрганизация       = СведенияОбОрганизации.Email;
		ОбластьПодвал.Параметры.ТелефоныОрганизация      = СведенияОбОрганизации.Телефоны;
		ОбластьПодвал.Параметры.ПодписантОрганизация     = ДоговорСсылка.ДолжностьРуководителя.Наименование;
		ОбластьПодвал.Параметры.ФИОПОдписантаОрганизация = ФизическиеЛицаКлиентСервер.ФамилияИнициалы( ДоговорСсылка.Руководитель.ФИО );
		
		// Контрагент
		ОбластьПодвал.Параметры.Контрагент    = ПредставлениеКонтрагента;
		ОбластьПодвал.Параметры.ИННКонтрагент = ДоговорСсылка.Владелец.ИНН;
		
		
		ОбластьПодвал.Параметры.ЮрАдресКонтрагент       = СведенияОКонтрагенте.ЮридическийАдрес;
		ОбластьПодвал.Параметры.ПочтАдресКонтрагент     = СведенияОКонтрагенте.ПочтовыйАдрес;
		ОбластьПодвал.Параметры.РасчетныйСчетКонтрагент = СведенияОКонтрагенте.НомерСчета;
		ОбластьПодвал.Параметры.БанкКонтрагент          = СведенияОКонтрагенте.Банк;
		ОбластьПодвал.Параметры.КоррСчетКонтрагент      = СведенияОКонтрагенте.КоррСчет;
		ОбластьПодвал.Параметры.БИККонтрагент           = СведенияОКонтрагенте.БИК;
		ОбластьПодвал.Параметры.ЭлПочтаКонтрагент       = СведенияОКонтрагенте.Email;
		ОбластьПодвал.Параметры.ТелефоныКонтрагент      = СведенияОКонтрагенте.Телефоны;
		ОбластьПодвал.Параметры.ПодписантКонтрагент     = ДоговорСсылка.ДолжностьРуководителяКонтрагента;
		ОбластьПодвал.Параметры.ФИОПОдписантаКонтрагент = ФизическиеЛицаКлиентСервер.ФамилияИнициалы( ДоговорСсылка.РуководительКонтрагента );
		
		
		ТабличныйДокумент.Вывести( ОбластьПодвал );
		
	КонецЕсли;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;

КонецФункции
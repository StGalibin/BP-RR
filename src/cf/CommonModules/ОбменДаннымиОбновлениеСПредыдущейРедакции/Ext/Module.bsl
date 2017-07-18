﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ЗаменитьСсылкуВУдалитьСоответствияОбъектовИнформационныхБаз(СтарыйОбъект, НовыйОбъект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(НовыйОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СоответствияОбъектовНовые  = РегистрыСведений.УдалитьСоответствияОбъектовИнформационныхБаз.СоздатьНаборЗаписей();
	СоответствияОбъектовНовые.Отбор.УникальныйИдентификаторИсточника.Установить(НовыйОбъект);
	СоответствияОбъектовНовые.Прочитать();
	Если СоответствияОбъектовНовые.Количество() = 0 Тогда
		
		СоответствияОбъектовСтарые = РегистрыСведений.УдалитьСоответствияОбъектовИнформационныхБаз.СоздатьНаборЗаписей();
		СоответствияОбъектовСтарые.Отбор.УникальныйИдентификаторИсточника.Установить(СтарыйОбъект);
		СоответствияОбъектовСтарые.Прочитать();
		Если СоответствияОбъектовСтарые.Количество()>0 Тогда
		
			СоответствияОбъектовНовые.Загрузить(СоответствияОбъектовСтарые.Выгрузить());
			Для Каждого НастройкаУзла Из СоответствияОбъектовНовые Цикл
				НастройкаУзла.УникальныйИдентификаторИсточника = НовыйОбъект;
				НастройкаУзла.УникальныйИдентификаторИсточникаСтрокой = Строка(НовыйОбъект.УникальныйИдентификатор());
				НастройкаУзла.ТипИсточника = Строка(ТипЗнч(НовыйОбъект));
			КонецЦикла;
			
			СоответствияОбъектовСтарые.Очистить();
			СоответствияОбъектовСтарые.Записать();
			СоответствияОбъектовНовые.Записать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПереносПлановОбменаБСП() Экспорт
	
	СоответствияПлановОбмена = Новый Соответствие;
	
	Если Метаданные.ПланыОбмена.Найти("ОбменУправлениеНебольшойФирмойБухгалтерия30") <> Неопределено Тогда
		СоответствияПлановОбмена.Вставить("УдалитьОбменУправлениеНебольшойФирмойБухгалтерия20", 
			"ОбменУправлениеНебольшойФирмойБухгалтерия30");
	КонецЕсли;
	СоответствияПлановОбмена.Вставить("УдалитьОбменУправлениеТорговлейБухгалтерияПредприятияКОРП", 
		"ОбменУправлениеТорговлейБухгалтерияПредприятияКОРП30"); // КОРП
	СоответствияПлановОбмена.Вставить("УдалитьОбменРозницаБухгалтерияПредприятия", 
		"ОбменРозницаБухгалтерияПредприятия30");
	СоответствияПлановОбмена.Вставить("УдалитьОбменУправлениеТорговлейБухгалтерияПредприятия", 
		"ОбменУправлениеТорговлейБухгалтерияПредприятия30"); // ПРОФ
	Для Каждого СоответствиеПлановОбмена ИЗ СоответствияПлановОбмена Цикл
		ПеренестиУзлыПланаОбменаБСП(СоответствиеПлановОбмена.Ключ, СоответствиеПлановОбмена.Значение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПереносПлановОбменаУниверсальногоОбмена() Экспорт
	
	ПеренестиУзлыПланаОбменаУТ10();
	
КонецПроцедуры

Процедура ПеренестиНастройкиОбменаДанными(СтарыйУзел, НовыйУзел) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтарыйУзел", СтарыйУзел);
	Запрос.УстановитьПараметр("НовыйУзел", НовыйУзел);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьНастройкиОбменаДанными.*
	|ИЗ
	|	Справочник.УдалитьНастройкиОбменаДанными КАК УдалитьНастройкиОбменаДанными
	|ГДЕ
	|	УдалитьНастройкиОбменаДанными.УзелИнформационнойБазы = &СтарыйУзел
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.Узел
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|ГДЕ
	|	НастройкиТранспортаОбмена.Узел = &НовыйУзел";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	СтарыйНастройки = РезультатЗапроса[0].Выгрузить();
	НовыеНастройки = РезультатЗапроса[1].Выгрузить();
	Если СтарыйНастройки.Количество() = 0 ИЛИ
		НовыеНастройки.Количество() > 0 Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Строка = СтарыйНастройки[0];
	МенеджерЗаписи = РегистрыСведений.НастройкиТранспортаОбмена.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Узел = НовыйУзел;
	МенеджерЗаписи.Прочитать();
	
	МенеджерЗаписи.Узел = НовыйУзел;
	
	МенеджерЗаписи.COMАутентификацияОперационнойСистемы = Строка.АутентификацияWindowsИнформационнойБазыДляПодключения;
	МенеджерЗаписи.COMВариантРаботыИнформационнойБазы = ?(Строка.ТипИнформационнойБазыДляПодключения, 0, 1); // Истина - файловая(0), Ложь - клиент-серверная(1) 
	МенеджерЗаписи.COMИмяИнформационнойБазыНаСервере1СПредприятия = Строка.ИмяИнформационнойБазыНаСервереДляПодключения;
	МенеджерЗаписи.COMИмяПользователя = Строка.ПользовательИнформационнойБазыДляПодключения;
	МенеджерЗаписи.COMИмяСервера1СПредприятия = Строка.ИмяСервераИнформационнойБазыДляПодключения;
	МенеджерЗаписи.COMКаталогИнформационнойБазы = Строка.КаталогИнформационнойБазыДляПодключения;
	
	МенеджерЗаписи.EMAILМаксимальныйДопустимыйРазмерСообщения = Строка.МаксимальныйРазмерОтправляемогоПакетаЧерезПочту;
	МенеджерЗаписи.EMAILСжиматьФайлИсходящегоСообщения = Строка.ВыполнятьАрхивациюФайловОбмена;
	МенеджерЗаписи.EMAILУчетнаяЗапись = Строка.УчетнаяЗаписьПриемаОтправкиСообщений;
	
	МенеджерЗаписи.FILEКаталогОбменаИнформацией = Строка.КаталогОбменаИнформацией;
	МенеджерЗаписи.FILEСжиматьФайлИсходящегоСообщения = Строка.ВыполнятьАрхивациюФайловОбмена;
	
	МенеджерЗаписи.FTPСжиматьФайлИсходящегоСообщения = Строка.ВыполнятьАрхивациюФайловОбмена;
	МенеджерЗаписи.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения = Строка.МаксимальныйРазмерОтправляемогоПолучаемогоПакетаЧерезFTP;
	
	МенеджерЗаписи.FTPСоединениеПассивноеСоединение = Строка.ПассивноеFTPСоединение;
	МенеджерЗаписи.FTPСоединениеПользователь = Строка.ПользовательFTPСоединения;
	МенеджерЗаписи.FTPСоединениеПорт = Строка.ПортFTPСоединения;
	МенеджерЗаписи.FTPСоединениеПуть = Строка.FTPАдресОбмена;
	
	Если ЗначениеЗаполнено(Строка.УчетнаяЗаписьПриемаОтправкиСообщений) Тогда
		МенеджерЗаписи.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL;
	ИначеЕсли Строка.ТипНастройки = Перечисления.УдалитьТипыАвтоматическогоОбменаДанными.ОбменЧерезComСоединение Тогда
		МенеджерЗаписи.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.COM;
	ИначеЕсли Строка.ТипНастройки = Перечисления.УдалитьТипыАвтоматическогоОбменаДанными.ОбменЧерезFTPРесурс Тогда
		МенеджерЗаписи.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP;
	ИначеЕсли Строка.ТипНастройки = Перечисления.УдалитьТипыАвтоматическогоОбменаДанными.ОбменЧерезФайловыйРесурс Тогда
		МенеджерЗаписи.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FILE;
	КонецЕсли;
	
	МенеджерЗаписи.Записать();
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НовыйУзел, Строка.ПарольИнформационнойБазыДляПодключения, "COMПарольПользователя");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НовыйУзел, Строка.ПарольFTPСоединения, "FTPСоединениеПароль");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НовыйУзел, Строка.ПарольНаОтправку, "ПарольАрхиваСообщенияОбмен");
	
	ТекстПравилПриемника = Строка.ПравилаОбмена.Получить();
	Если ТипЗнч(ТекстПравилПриемника) = Тип("Строка") И СтрДлина(ТекстПравилПриемника) < 1000 
		И НовыйУзел <> ПланыОбмена.ГлавныйУзел() Тогда 
		// одностронний обмен
		НовыйУзелОбъект = НовыйУзел.ПолучитьОбъект();
		НовыйУзелОбъект.РежимВыгрузкиОбъектов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		НовыйУзелОбъект.Записать();
	КонецЕсли;
	
	НастройкаОбмена = Строка.Ссылка.ПолучитьОбъект();
	НастройкаОбмена.УстановитьПометкуУдаления(Истина);
	
	// Перенос сценариев синхронизации данных
	ПеренестиНастройкиВыполненияОбменаДанными(Строка.Ссылка, НовыйУзел, МенеджерЗаписи.ВидТранспортаСообщенийОбменаПоУмолчанию);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПеренестиУзлыПланаОбменаУТ10()
	
	ПланОбменаБП20 = "УдалитьОбменУправлениеТорговлейБухгалтерияКОРП";
	ПланОбменаБП30 = "ОбменУправлениеТорговлей103БухгалтерияПредприятия30";
	
	ИспользоватьСинхронизациюДанных = Ложь;
	
	Запрос = Новый Запрос();
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПланОбменаБП20.Ссылка КАК УзелПланаОбменаБП20,
	|	ПланОбменаБП30.Ссылка КАК УзелПланаОбменаБП30,
	|	ПланОбменаБП20.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю КАК ВыгрузкаДокументов
	|ИЗ
	|	ПланОбмена.[ПланОбменаБП20] КАК ПланОбменаБП20
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.[ПланОбменаБП30] КАК ПланОбменаБП30
	|		ПО ПланОбменаБП20.Код = ПланОбменаБП30.Код
	|ГДЕ
	|	ПланОбменаБП20.ПометкаУдаления = ЛОЖЬ И ПланОбменаБП20.Код <> """"";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПланОбменаБП20]", ПланОбменаБП20);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПланОбменаБП30]", ПланОбменаБП30);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Если ЗначениеЗаполнено(Выборка.УзелПланаОбменаБП30)
			И ((Выборка.УзелПланаОбменаБП20 = ПланыОбмена[ПланОбменаБП20].ЭтотУзел()) = (Выборка.УзелПланаОбменаБП30 = ПланыОбмена[ПланОбменаБП30].ЭтотУзел())) Тогда
			
			НовыйУзел = Выборка.УзелПланаОбменаБП30;
			
		Иначе
			
			НовыйУзел = ПолучитьОбъектНовогоУзла(Выборка.УзелПланаОбменаБП20, ПланОбменаБП20, ПланОбменаБП30);
			НовыйУзел.ИспользоватьОтборПоОрганизациям = (НовыйУзел.Организации.Количество() > 0);
			НовыйУзел.РегистрироватьИзменения = НовыйУзел.Ссылка = ПланыОбмена[ПланОбменаБП30].ЭтотУзел();
			
			Если Выборка.ВыгрузкаДокументов = Перечисления.УдалитьВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.НеВыгружать Тогда
				НовыйУзел.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю = Перечисления.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.НеВыгружать;
			ИначеЕсли Выборка.ВыгрузкаДокументов = Перечисления.УдалитьВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.СчетНаОплатуПокупателю Тогда
				НовыйУзел.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю = Перечисления.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.СчетНаОплатуПокупателю;
			ИначеЕсли Выборка.ВыгрузкаДокументов = Перечисления.УдалитьВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.ЗаказПокупателя Тогда
				НовыйУзел.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю = Перечисления.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.ЗаказПокупателя;
			КонецЕсли;	
			
			// по умолчанию считаем, что обмен - двухсторонний, при переносе настроек обмена данными проверим направленность обмена
			НовыйУзел.РежимВыгрузкиОбъектов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
			
			Если Не НовыйУзел.Ссылка = ПланыОбмена.ОбменУправлениеТорговлей103БухгалтерияПредприятия30.ЭтотУзел() Тогда
				НовыйУзел.СкладДляОбменаДаннымиСУТ = Константы.УдалитьСкладДляОбменаДаннымиСУТ.Получить();
			КонецЕсли;
			
			НовыйУзел.Записать();
			НовыйУзел = НовыйУзел.Ссылка;
			
		КонецЕсли;
		
		Если Выборка.УзелПланаОбменаБП20 = ПланыОбмена[ПланОбменаБП20].ЭтотУзел() Тогда
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		ПеренестиРегистрацииИзмененийДляУзла(Выборка.УзелПланаОбменаБП20, НовыйУзел);
		
		ЗапросФоновогоУзла = Новый Запрос();
		ЗапросФоновогоУзла.Параметры.Вставить("УзелИнформационнойБазы", Выборка.УзелПланаОбменаБП20);
		ЗапросФоновогоУзла.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УдалитьНастройкиОбменаДанными.УзелФоновогоОбмена
		|ИЗ
		|	Справочник.УдалитьНастройкиОбменаДанными КАК УдалитьНастройкиОбменаДанными
		|ГДЕ
		|	УдалитьНастройкиОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
		ВыборкаФоновогоУзла = ЗапросФоновогоУзла.Выполнить().Выбрать();
		Если ВыборкаФоновогоУзла.Следующий() Тогда
			Если ЗначениеЗаполнено(ВыборкаФоновогоУзла.УзелФоновогоОбмена) Тогда
				ПеренестиРегистрацииИзмененийДляУзла(ВыборкаФоновогоУзла.УзелФоновогоОбмена, НовыйУзел);
			КонецЕсли;
		КонецЕсли;
		
		ПеренестиНастройкиОбменаДанными(Выборка.УзелПланаОбменаБП20, НовыйУзел);
		
		ИспользоватьСинхронизациюДанных = Истина;
		
		ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.УзелПланаОбменаБП20);
		
		Объект = Выборка.УзелПланаОбменаБП20.ПолучитьОбъект();
		Объект.УстановитьПометкуУдаления(Истина);
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
	// установить константу синхронизации данных в значение Истина только в случае обработки узлов плана обмена БП30
	Если ИспользоватьСинхронизациюДанных Тогда
		Константы.ИспользоватьСинхронизациюДанных.Установить(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПеренестиУзлыПланаОбменаБСП(ПланОбменаБП20, ПланОбменаБП30)
	
	Если Метаданные.ПланыОбмена.Найти(ПланОбменаБП20) = Неопределено
		ИЛИ Метаданные.ПланыОбмена.Найти(ПланОбменаБП30) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПланОбменаБП20.Ссылка КАК УзелПланаОбменаБП20,
	|	ПланОбменаБП30.Ссылка КАК УзелПланаОбменаБП30
	|ИЗ
	|	ПланОбмена.[ПланОбменаБП20] КАК ПланОбменаБП20
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.[ПланОбменаБП30] КАК ПланОбменаБП30
	|		ПО ПланОбменаБП20.Код = ПланОбменаБП30.Код
	|ГДЕ
	|	ПланОбменаБП20.ПометкаУдаления = ЛОЖЬ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПланОбменаБП20]", ПланОбменаБП20);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПланОбменаБП30]", ПланОбменаБП30);
	
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Если НЕ ЗначениеЗаполнено(Выборка.УзелПланаОбменаБП30) Тогда
			НовыйУзел = СоздатьНовыйУзелПланаОбмена(Выборка.УзелПланаОбменаБП20, ПланОбменаБП20, ПланОбменаБП30);
		Иначе
			НовыйУзел = Выборка.УзелПланаОбменаБП30;
		КонецЕсли;
		
		Если Выборка.УзелПланаОбменаБП20 = ПланыОбмена[ПланОбменаБП20].ЭтотУзел() Тогда
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		ПеренестиРегистрацииИзмененийДляУзла(Выборка.УзелПланаОбменаБП20, НовыйУзел);
		
		ПеренестиНастройкиУзла(Выборка.УзелПланаОбменаБП20, НовыйУзел);
		
		Объект = Выборка.УзелПланаОбменаБП20.ПолучитьОбъект();
		Объект.УстановитьПометкуУдаления(Истина);
		ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.УзелПланаОбменаБП20);
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьОбъектНовогоУзла(СтарыйУзел, ИмяСтарогоПланаОбмена, ИмяНовогоПланаОбмена)
	
	Если СтарыйУзел = ПланыОбмена[ИмяСтарогоПланаОбмена].ЭтотУзел() Тогда
		НовыйУзел = ПланыОбмена[ИмяНовогоПланаОбмена].ЭтотУзел().ПолучитьОбъект();
		ИсключаяСвойства = "НомерОтправленного, НомерПринятого, ПометкаУдаления";
	Иначе
		НовыйУзел = ПланыОбмена[ИмяНовогоПланаОбмена].СоздатьУзел();
		ИсключаяСвойства = "ПометкаУдаления";
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НовыйУзел, СтарыйУзел, , ИсключаяСвойства);
	Для Каждого ТабличнаяЧасть ИЗ Метаданные.ПланыОбмена[ИмяСтарогоПланаОбмена].ТабличныеЧасти Цикл
		Если Метаданные.ПланыОбмена[ИмяНовогоПланаОбмена].ТабличныеЧасти.Найти(ТабличнаяЧасть.Имя) <> Неопределено Тогда
			Для Каждого СтрокаСтарогоУзла Из СтарыйУзел[ТабличнаяЧасть.Имя] Цикл
				СтрокаНовогоУзла = НовыйУзел[ТабличнаяЧасть.Имя].Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНовогоУзла, СтрокаСтарогоУзла);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НовыйУзел;
	
КонецФункции

Функция СоздатьНовыйУзелПланаОбмена(СтарыйУзел, ИмяСтарогоПланаОбмена, ИмяНовогоПланаОбмена)
	
	НовыйУзел = ПолучитьОбъектНовогоУзла(СтарыйУзел, ИмяСтарогоПланаОбмена, ИмяНовогоПланаОбмена);
	НовыйУзел.Записать();
	
	Возврат НовыйУзел.Ссылка;
	
КонецФункции

Процедура ПеренестиРегистрацииИзмененийДляУзла(СтарыйУзел, НовыйУзел)
	
	СоставНовогоПланаОбмена = НовыйУзел.Метаданные().Состав;
	НомерСообщения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтарыйУзел, "НомерОтправленного");
	ВыборкаИзменений = ПланыОбмена.ВыбратьИзменения(СтарыйУзел, НомерСообщения);
	Пока ВыборкаИзменений.Следующий() Цикл
		Объект = ВыборкаИзменений.Получить();
		
		Если Объект = Неопределено Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Объект) = Тип("УдалениеОбъекта") Тогда
			Если НЕ СоставНовогоПланаОбмена.Содержит(Объект.Ссылка.Метаданные()) Тогда
				Продолжить;
			КонецЕсли;
		ИначеЕсли НЕ СоставНовогоПланаОбмена.Содержит(Объект.Метаданные()) Тогда
			Продолжить;
		КонецЕсли;
		
		ПланыОбмена.ЗарегистрироватьИзменения(НовыйУзел, Объект);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПеренестиНастройкиУзла(СтарыйУзел, НовыйУзел)
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("УзелИнформационнойБазы", СтарыйУзел);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СценарийОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Для Каждого СтрокаСценария Из СценарийОбъект.НастройкиОбмена Цикл
			Если СтрокаСценария.УзелИнформационнойБазы = СтарыйУзел Тогда
				СтрокаСценария.УзелИнформационнойБазы = НовыйУзел;
			КонецЕсли;
		КонецЦикла;
		СценарийОбъект.Записать();
	КонецЦикла;
	
	НастройкиТранспортаОбменаНовогоУзла = РегистрыСведений.НастройкиТранспортаОбмена.СоздатьНаборЗаписей();
	НастройкиТранспортаОбменаНовогоУзла.Отбор.Узел.Установить(НовыйУзел);
	НастройкиТранспортаОбменаНовогоУзла.Прочитать();
	Если НастройкиТранспортаОбменаНовогоУзла.Количество()=0 Тогда
		НастройкиТранспортаОбменаСтарогоУзла = РегистрыСведений.НастройкиТранспортаОбмена.СоздатьНаборЗаписей();
		НастройкиТранспортаОбменаСтарогоУзла.Отбор.Узел.Установить(СтарыйУзел);
		НастройкиТранспортаОбменаСтарогоУзла.Прочитать();
		
		Если НастройкиТранспортаОбменаСтарогоУзла.Количество()>0 Тогда
			НастройкиТранспортаОбменаНовогоУзла.Загрузить(НастройкиТранспортаОбменаСтарогоУзла.Выгрузить());
			Для Каждого НастройкаУзла Из НастройкиТранспортаОбменаНовогоУзла Цикл
				НастройкаУзла.Узел = НовыйУзел;
			КонецЦикла;
			
			НастройкиТранспортаОбменаСтарогоУзла.Очистить();
			НастройкиТранспортаОбменаСтарогоУзла.Записать();
			НастройкиТранспортаОбменаНовогоУзла.Записать();
		КонецЕсли;
	КонецЕсли;
	
	НастройкиУзловИнформационныхБазНовогоУзла = РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.СоздатьНаборЗаписей();
	НастройкиУзловИнформационныхБазНовогоУзла.Отбор.УзелИнформационнойБазы.Установить(НовыйУзел);
	НастройкиУзловИнформационныхБазНовогоУзла.Прочитать();
	Если НастройкиУзловИнформационныхБазНовогоУзла.Количество()=0 Тогда
		НастройкиУзловИнформационныхБазСтарогоУзла = РегистрыСведений.ОбщиеНастройкиУзловИнформационныхБаз.СоздатьНаборЗаписей();
		НастройкиУзловИнформационныхБазСтарогоУзла.Отбор.УзелИнформационнойБазы.Установить(СтарыйУзел);
		НастройкиУзловИнформационныхБазСтарогоУзла.Прочитать();
		
		Если НастройкиУзловИнформационныхБазСтарогоУзла.Количество()>0 Тогда
			НастройкиУзловИнформационныхБазНовогоУзла.Загрузить(НастройкиУзловИнформационныхБазСтарогоУзла.Выгрузить());
			Для Каждого НастройкаУзла Из НастройкиУзловИнформационныхБазНовогоУзла Цикл
				НастройкаУзла.УзелИнформационнойБазы = НовыйУзел;
			КонецЦикла;
			
			НастройкиУзловИнформационныхБазСтарогоУзла.Очистить();
			НастройкиУзловИнформационныхБазСтарогоУзла.Записать();
			НастройкиУзловИнформационныхБазНовогоУзла.Записать();
		КонецЕсли;
	КонецЕсли;
	
	СоответствияНовогоУзла = РегистрыСведений.СоответствияОбъектовИнформационныхБаз.СоздатьНаборЗаписей();
	СоответствияНовогоУзла.Отбор.УзелИнформационнойБазы.Установить(НовыйУзел);
	СоответствияНовогоУзла.Прочитать();
	Если СоответствияНовогоУзла.Количество()=0 Тогда
		СоответствияСтарогоУзла = РегистрыСведений.УдалитьСоответствияОбъектовИнформационныхБаз.СоздатьНаборЗаписей();
		СоответствияСтарогоУзла.Отбор.УзелИнформационнойБазы.Установить(СтарыйУзел);
		СоответствияСтарогоУзла.Прочитать();
		Если СоответствияСтарогоУзла.Количество()>0 Тогда
			СоответствияНовогоУзла.Загрузить(СоответствияСтарогоУзла.Выгрузить());
			СоответствияНовогоУзла.ОбменДанными.Загрузка = Истина;
			Для Каждого НастройкаУзла Из СоответствияНовогоУзла Цикл
				НастройкаУзла.УзелИнформационнойБазы = НовыйУзел;
				Если ЗначениеЗаполнено(НастройкаУзла.УникальныйИдентификаторИсточника) Тогда
					Если НЕ ЗначениеЗаполнено(НастройкаУзла.УникальныйИдентификаторПриемника) Тогда
						НастройкаУзла.ОбъектВыгруженПоСсылке = Истина;
					ИначеЕсли СОКРЛП(НастройкаУзла.УникальныйИдентификаторИсточникаСтрокой) = ""
							И НЕ НастройкаУзла.ОбъектВыгруженПоСсылке Тогда
						НастройкаУзла.УникальныйИдентификаторИсточникаСтрокой = Строка(НастройкаУзла.УникальныйИдентификаторИсточника.УникальныйИдентификатор());
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			СоответствияСтарогоУзла.Очистить();
			СоответствияСтарогоУзла.Записать();
			СоответствияНовогоУзла.Записать();
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("УзелИнформационнойБазы", СтарыйУзел);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РезультатыОбменаДанными.ПроблемныйОбъект,
	|	РезультатыОбменаДанными.ТипПроблемы
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = РегистрыСведений.РезультатыОбменаДанными.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
		МенеджерЗаписи.УзелИнформационнойБазы = НовыйУзел;
		МенеджерЗаписи.Записать();
		
	КонецЦикла;
	
	СостоянияОбменовДаннымиНовогоУзла = РегистрыСведений.СостоянияОбменовДанными.СоздатьНаборЗаписей();
	СостоянияОбменовДаннымиНовогоУзла.Отбор.УзелИнформационнойБазы.Установить(НовыйУзел);
	СостоянияОбменовДаннымиНовогоУзла.Прочитать();
	Если СостоянияОбменовДаннымиНовогоУзла.Количество()=0 Тогда
		СостоянияОбменовДаннымиСтарогоУзла = РегистрыСведений.СостоянияОбменовДанными.СоздатьНаборЗаписей();
		СостоянияОбменовДаннымиСтарогоУзла.Отбор.УзелИнформационнойБазы.Установить(СтарыйУзел);
		СостоянияОбменовДаннымиСтарогоУзла.Прочитать();
		Если СостоянияОбменовДаннымиСтарогоУзла.Количество()>0 Тогда
			СостоянияОбменовДаннымиНовогоУзла.Загрузить(СостоянияОбменовДаннымиСтарогоУзла.Выгрузить());
			СостоянияОбменовДаннымиНовогоУзла.ОбменДанными.Загрузка = Истина;
			Для Каждого НастройкаУзла Из СостоянияОбменовДаннымиНовогоУзла Цикл
				НастройкаУзла.УзелИнформационнойБазы = НовыйУзел;
			КонецЦикла;
			
			СостоянияОбменовДаннымиСтарогоУзла.Очистить();
			СостоянияОбменовДаннымиСтарогоУзла.Записать();
			СостоянияОбменовДаннымиНовогоУзла.Записать();
		КонецЕсли;
	КонецЕсли;
	
	СостоянияОбменовДаннымиНовогоУзла = РегистрыСведений.СостоянияУспешныхОбменовДанными.СоздатьНаборЗаписей();
	СостоянияОбменовДаннымиНовогоУзла.Отбор.УзелИнформационнойБазы.Установить(НовыйУзел);
	СостоянияОбменовДаннымиНовогоУзла.Прочитать();
	Если СостоянияОбменовДаннымиНовогоУзла.Количество()=0 Тогда
		СостоянияОбменовДаннымиСтарогоУзла = РегистрыСведений.СостоянияУспешныхОбменовДанными.СоздатьНаборЗаписей();
		СостоянияОбменовДаннымиСтарогоУзла.Отбор.УзелИнформационнойБазы.Установить(СтарыйУзел);
		СостоянияОбменовДаннымиСтарогоУзла.Прочитать();
		Если СостоянияОбменовДаннымиСтарогоУзла.Количество()>0 Тогда
			СостоянияОбменовДаннымиНовогоУзла.Загрузить(СостоянияОбменовДаннымиСтарогоУзла.Выгрузить());
			СостоянияОбменовДаннымиНовогоУзла.ОбменДанными.Загрузка = Истина;
			Для Каждого НастройкаУзла Из СостоянияОбменовДаннымиНовогоУзла Цикл
				НастройкаУзла.УзелИнформационнойБазы = НовыйУзел;
			КонецЦикла;
			
			СостоянияОбменовДаннымиСтарогоУзла.Очистить();
			СостоянияОбменовДаннымиСтарогоУзла.Записать();
			СостоянияОбменовДаннымиНовогоУзла.Записать();
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

Процедура ПеренестиНастройкиВыполненияОбменаДанными(СтараяНастройкаОбмена, НовыйУзел, ВидТранспортаСообщенийОбмена)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СтараяНастройкаОбмена", СтараяНастройкаОбмена);
	Запрос.УстановитьПараметр("НовыйУзел", 			   НовыйУзел);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиОбмена.Ссылка,
	|	НастройкиОбмена.НастройкаОбмена,
	|	НастройкиОбмена.ВыполняемоеДействие,
	|	НастройкиОбмена.Ссылка.Наименование,
	|	НастройкиОбмена.Ссылка.ИспользоватьРегламентныеЗадания,
	|	НастройкиОбмена.Ссылка.РегламентноеЗадание,
	|	НастройкиОбмена.Ссылка.КоличествоЭлементовВТранзакцииНаЗагрузкуДанных,
	|	НастройкиОбмена.Ссылка.КоличествоЭлементовВТранзакцииНаВыгрузкуДанных,
	|	НастройкиОбмена.Ссылка.Комментарий
	|ИЗ
	|	Справочник.УдалитьНастройкиВыполненияОбмена.НастройкиОбмена КАК НастройкиОбмена
	|ГДЕ
	|	НастройкиОбмена.НастройкаОбмена = &СтараяНастройкаОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка,
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &НовыйУзел";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	СтарыеНастройкиВыполненияОбмена  	= РезультатЗапроса[0].Выгрузить();
	НовыеНастройкиСинхронизацииДанных 	= РезультатЗапроса[1].Выгрузить();
	
	Если СтарыеНастройкиВыполненияОбмена.Количество() = 0 
		ИЛИ НовыеНастройкиСинхронизацииДанных.Количество() > 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СтарыеНастройки = СтарыеНастройкиВыполненияОбмена[0];
	
	НовыйСценарийОбменаДанными = Справочники.СценарииОбменовДанными.СоздатьЭлемент();
	НовыйСценарийОбменаДанными.Наименование 					= СтарыеНастройки.Наименование;
	НовыйСценарийОбменаДанными.ИспользоватьРегламентноеЗадание 	= СтарыеНастройки.ИспользоватьРегламентныеЗадания;
	НовыйСценарийОбменаДанными.Комментарий 					  	= СтарыеНастройки.Комментарий;
	
	СтароеРегламентноеЗадание = ОбменДаннымиВызовСервера.НайтиРегламентноеЗаданиеПоПараметру(СтарыеНастройки.РегламентноеЗадание);
	Если СтароеРегламентноеЗадание <> Неопределено Тогда
		Отказ = Ложь;
		Справочники.СценарииОбменовДанными.ОбновитьДанныеРегламентногоЗадания(Отказ, СтароеРегламентноеЗадание.Расписание, НовыйСценарийОбменаДанными);
	КонецЕсли;
	
	Для Каждого СтрокаСтарыхНастроекОбмена ИЗ СтарыеНастройкиВыполненияОбмена Цикл
		
		Если СтрокаСтарыхНастроекОбмена.ВыполняемоеДействие = Перечисления.УдалитьДействиеПриОбмене.ОтложенныеДвижения 
			ИЛИ НЕ ЗначениеЗаполнено(СтрокаСтарыхНастроекОбмена.ВыполняемоеДействие) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяНастройкаОбмена = НовыйСценарийОбменаДанными.НастройкиОбмена.Добавить();
		
		НоваяНастройкаОбмена.УзелИнформационнойБазы = НовыйУзел;  
		НоваяНастройкаОбмена.ВидТранспортаОбмена    = ВидТранспортаСообщенийОбмена;
		
		Если СтрокаСтарыхНастроекОбмена.ВыполняемоеДействие = Перечисления.УдалитьДействиеПриОбмене.ЗагрузкаДанных Тогда
			НоваяНастройкаОбмена.ВыполняемоеДействие 			= Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
		ИначеЕсли СтрокаСтарыхНастроекОбмена.ВыполняемоеДействие = Перечисления.УдалитьДействиеПриОбмене.ВыгрузкаДанных Тогда
			НоваяНастройкаОбмена.ВыполняемоеДействие 			= Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйСценарийОбменаДанными.Записать();
	
	НастройкаВыполненияОбмена = СтарыеНастройки.Ссылка.ПолучитьОбъект();
	НастройкаВыполненияОбмена.УстановитьПометкуУдаления(Истина);
	
КонецПроцедуры


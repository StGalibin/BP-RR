﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеНевозможностьПредоставления.Форма.Форма2015_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "ТС-2/приказ ФНС России от 22.06.2015 № ММВ-7-14/249@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ПечатьСразу_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат СформироватьМакет_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2015_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2015_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2015_1(Объект);
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция СформироватьСписокЛистовФорма2015_1(Объект)
	Листы = Новый СписокЗначений;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить().СтруктураРеквизитов;
	
	ПараметрыПечати = Новый Структура;
	РеквизитыИФНС = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Наименование, Код"); 
	ПараметрыПечати.Вставить("НаимНО", РеквизитыИФНС.Наименование);
	ПараметрыПечати.Вставить("КодНО", РеквизитыИФНС.Код);
	
	ПараметрыПечати.Вставить("УведомлениеНомер", СтруктураПараметров._Номер);
	ПараметрыПечати.Вставить("Дата", Формат(Объект.ДатаПодписи, "ДЛФ=DD"));
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		НаимОргПолн = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, "НаимЮЛПол").НаимЮЛПол;
	Иначе
		НаимОргПолн = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, "ФИО").ФИО;
	КонецЕсли;
	ПараметрыПечати.Вставить("НаимОргПолн", НаимОргПолн);
	ПараметрыПечати.Вставить("ДатаЗапроса", Формат(СтруктураПараметров._ДатаТреб, "ДЛФ=DD"));
	ПараметрыПечати.Вставить("НомерЗапроса", СтруктураПараметров._НомТреб);
	
	ДокументыСтр = "";
	Информация = "";
	Приложения = "";
	
	Для Каждого Стр Из СтруктураПараметров._ПорНомДок Цикл 
		Если Стр.Информация Тогда 
			Информация = Информация + Стр.НомДок+ "; ";
		Иначе
			ДокументыСтр = ДокументыСтр + Стр.НомДок+ "; ";
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из СтруктураПараметров._ПриложенныеФайлы.Строки Цикл 
		Приложения = Приложения + Стр.Документ+ "; ";
	КонецЦикла;
	
	ПараметрыПечати.Вставить("Документы", ДокументыСтр);
	ПараметрыПечати.Вставить("Информация", Информация);
	ПараметрыПечати.Вставить("Приложения", Приложения);
	ПараметрыПечати.Вставить("Причина", СтруктураПараметров._ОписПричНепред);
	ПараметрыПечати.Вставить("ДатаПредст", Формат(СтруктураПараметров._СрокПредст, "ДЛФ=DD"));
	ПараметрыПечати.Вставить("КП1", Строка(СтруктураПараметров._КодПрич / 10));
	ПараметрыПечати.Вставить("КП2", "0");
	ПараметрыПечати.Вставить("ПрПодп", Строка(СтруктураПараметров._ПрПодп));
	
	ПараметрыПечати.Вставить("Должность", СтруктураПараметров._ДолжнПодп);
	ПараметрыПечати.Вставить("ФИО", СтруктураПараметров._ФамилияПодп + " " + СтруктураПараметров._ИмяПодп + " " + СтруктураПараметров._ОтчествоПодп);
	ПараметрыПечати.Вставить("Телефон", СтруктураПараметров._Тлф);
	ПараметрыПечати.Вставить("ЭлектроннаяПочта", СтруктураПараметров._Email);
	ПараметрыПечати.Вставить("ДокументПредставителя", СтруктураПараметров._НаимДокПодп);
	
	НомСтр = 0;
	МакетПФ = Отчеты.РегламентированноеУведомлениеНевозможностьПредоставления.ПолучитьМакет("ПФ_MXL_Форма2015_1");
	Для Инд = 1 По 4 Цикл 
		Стр = МакетПФ.ПолучитьОбласть("Стр" + Инд);
		ЗаполнитьЗначенияСвойств(Стр.Параметры, ПараметрыПечати);
		Если Не ПечатнаяФорма.ПроверитьВывод(Стр) Тогда 
			ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
		КонецЕсли;
		ПечатнаяФорма.Вывести(Стр);
	КонецЦикла;
	ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр);
	
	Возврат Листы;
КонецФункции

Процедура ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр) Экспорт 
	Лист = Новый Массив;
	Лист.Добавить(ПоместитьВоВременноеХранилище(ПечатнаяФорма));
	Лист.Добавить(Новый УникальныйИдентификатор);
	Лист.Добавить(Метаданные.Отчеты[Объект.ИмяОтчета].Синоним + " Лист." + НомСтр);
	Листы.Добавить(Лист, Метаданные.Отчеты[Объект.ИмяОтчета].Синоним + " Лист." + НомСтр);
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
КонецПроцедуры

Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.Вывести(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьМакет("МакетПредупреждениеОНевозможностиПечати"));
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2015_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2015_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(СведенияОтправки)
	Префикс = "ON_UVNPDUS";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2015_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	
	ДанныеОрг = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьСведенияОбОрганизации(Объект);
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не ДанныеОрг.ЭтоЮрЛицо);
	Если Не ДанныеОрг.ЭтоЮрЛицо Тогда
		ОсновныеСведения.Вставить("ИННФЛ", ДанныеОрг.ИНН);
		ОсновныеСведения.Вставить("Фамилия", ДанныеОрг.Фамилия);
		ОсновныеСведения.Вставить("Имя", ДанныеОрг.Имя);
		ОсновныеСведения.Вставить("Отчество", ДанныеОрг.Отчество);
	Иначе
		ОсновныеСведения.Вставить("НаимОрг", ДанныеОрг.НаименованиеПолное);
		ОсновныеСведения.Вставить("ИННЮЛ", ДанныеОрг.ИНН);
		ОсновныеСведения.Вставить("КПП", ДанныеОрг.КПП);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	СтруктураРеквизитов = Данные.СтруктураРеквизитов;
	Для Каждого КЗ Из СтруктураРеквизитов Цикл 
		Если ТипЗнч(КЗ.Значение) = Тип("Строка")
			Или ТипЗнч(КЗ.Значение) = Тип("Число") Тогда 
			ОсновныеСведения.Вставить(КЗ.Ключ, КЗ.Значение);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
			ОсновныеСведения.Вставить(КЗ.Ключ, Формат(КЗ.Значение, "ДФ=dd.MM.yyyy"));
		КонецЕсли;
	КонецЦикла;
	
	ОсновныеСведения.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	ОсновныеСведения.Вставить("_Дата", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЗаполнитьДанными_Форма2015_1(Объект, СтруктураВыгрузки, СписокФайлов, ИменаФайлов, ОсновныеСведения)
	Данные = Объект.ДанныеУведомления.Получить();
	КолФайл = 0;
	
	Для Каждого Стр1 Из Данные.СтруктураРеквизитов._ПриложенныеФайлы.Строки Цикл 
		УИД1 = Строка(Новый УникальныйИдентификатор);
		Для Каждого Стр2 Из Стр1.Строки Цикл
			ПрисоединенныйФайл = Стр2.ПрисоединенныйФайл;
			Если ЗначениеЗаполнено(ПрисоединенныйФайл) И ПрисоединенныйФайл.ПолучитьОбъект() <> Неопределено Тогда
				КолФайл = КолФайл + 1;
				УИД2 = Строка(Новый УникальныйИдентификатор);
				Расширение = Сред(Стр2.Документ, СтрНайти(Стр2.Документ, ".", НаправлениеПоиска.СКонца));
				ИмяФайлаПрод = "PR_" + ОсновныеСведения.ИдентификаторОтправителя + "_"  + ОсновныеСведения.КодНО 
								+ "_" + УИД1 + ОсновныеСведения.ДатаИмФайла + УИД2 + Расширение;
				ИменаФайлов.Добавить(ИмяФайлаПрод);
				СписокФайлов.Добавить(ПрисоединенныйФайл);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(СтруктураВыгрузки, "Документ");
	Узел_СвНевозмПред = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "СвНевозмПред");
	Узел_ПорНомДок = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СвНевозмПред, "ПорНомДок");
	Для Каждого Стр Из Данные.СтруктураРеквизитов._ПорНомДок Цикл 
		Узел_Нов = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_ПорНомДок);
		Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_Нов, Стр.НомДок);
	КонецЦикла;
	РегламентированнаяОтчетность.УдалитьУзел(Узел_ПорНомДок);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		Узел_ИмяФайл = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СвНевозмПред, "ИмяФайл");
		Для Каждого Стр Из ИменаФайлов Цикл 
			Узел_Нов = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_ИмяФайл);
			Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_Нов, Стр);
		КонецЦикла;
		РегламентированнаяОтчетность.УдалитьУзел(Узел_ИмяФайл);
		
		Если КолФайл > 0 Тогда
			Узел_КолФайл = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "КолФайл");
			Документы.УведомлениеОСпецрежимахНалогообложения.ВывестиПоказательВXML(Узел_КолФайл, КолФайл);
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор)
	СписокФайлов = Новый Массив;
	ИменаФайлов = Новый Массив;
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	ДвоичныеДанные = Новый ОписаниеТипов("ДвоичныеДанные");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ДвоичныеДанныеФайла", ДвоичныеДанные);
	
	ДатаИмФайла = Формат(ТекущаяДатаСеанса(), "ДФ=_yyyyMMdd_");
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор);
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		ИННФЛ = ?(ЗначениеЗаполнено(ОсновныеСведения.ИННФЛ), ОсновныеСведения.ИННФЛ, "000000000000");
		ИдентификаторОтправителя = СокрЛП(ИННФЛ);
	Иначе
		ИННЮЛ = ?(ЗначениеЗаполнено(ОсновныеСведения.ИННЮЛ), ОсновныеСведения.ИННЮЛ, "0000000000");
		КПП = ?(ЗначениеЗаполнено(ОсновныеСведения.КПП), ОсновныеСведения.КПП, "000000000");
		ИдентификаторОтправителя = ИННЮЛ + КПП;
	КонецЕсли;
	ОсновныеСведения.Вставить("ДатаИмФайла", ДатаИмФайла);
	ОсновныеСведения.Вставить("ИдентификаторОтправителя", ИдентификаторОтправителя);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2015_1");
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(ОсновныеСведения, СтруктураВыгрузки);
	ЗаполнитьДанными_Форма2015_1(Объект, СтруктураВыгрузки, СписокФайлов, ИменаФайлов, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		МодульПрисоединенныеФайлы = ОбщегоНазначения.ОбщийМодуль("ПрисоединенныеФайлы");
		Для Инд = 0 По СписокФайлов.ВГраница() Цикл 
			Файл = СписокФайлов[Инд];
			ИмяФайлаПрод = ИменаФайлов[Инд];
			СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
			СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ИмяФайлаПрод;
			СтрокаСведенийЭлектронногоПредставления.ДвоичныеДанныеФайла = МодульПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Файл);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ПеренестиФайлыИзРегистраВПрисоединенныеФайлы(Ссылка) Экспорт
	Если Метаданные.РегистрыСведений.Найти("УдалитьДополнительныеФайлыУведомлений") = Неопределено Тогда 
		Возврат;
	КонецЕсли;
		
	ДанныеОтчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ДанныеУведомления").Получить();
	Если ДанныеОтчета.СтруктураРеквизитов._ПриложенныеФайлы.Колонки.Найти("ПрисоединенныйФайл") <> Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ПрисоединенныеФайлыПодсистемаСуществует = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
		МодульПрисоединенныеФайлы = ОбщегоНазначения.ОбщийМодуль("ПрисоединенныеФайлы");
		ПрисоединенныеФайлыПодсистемаСуществует = Истина;
	КонецЕсли;
	
	Попытка
		НачатьТранзакцию();
		ДокОбъект = Ссылка.ПолучитьОбъект();
		ПриложенныеФайлы = ДанныеОтчета.СтруктураРеквизитов._ПриложенныеФайлы;
		ПриложенныеФайлы.Колонки.Добавить("ПрисоединенныйФайл");
		
		Для Каждого Стр1 Из ПриложенныеФайлы.Строки Цикл 
			Для Каждого Стр2 Из Стр1.Строки Цикл 
				Если ПрисоединенныеФайлыПодсистемаСуществует Тогда 
					ЗаписьРегистра = РегистрыСведений["УдалитьДополнительныеФайлыУведомлений"].СоздатьМенеджерЗаписи();
					ЗаписьРегистра.Уведомление = Ссылка;
					ЗаписьРегистра.ВидДополнительногоФайла = Строка(Стр2.УИДДокумент) + "@" + Строка(Стр2.УИДФайл);
					ЗаписьРегистра.Прочитать();
					
					Если ЗаписьРегистра.Выбран() Тогда 
						ПараметрыФайла = Новый Структура;
						ПараметрыФайла.Вставить("ВладелецФайлов", Ссылка);
						ПараметрыФайла.Вставить("Автор", Неопределено);
						ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
						ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
						ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
						ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
						НоваяСсылкаНаФайл = МодульПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, 
																								ПоместитьВоВременноеХранилище(ЗаписьРегистра.СодержимоеФайла.Получить()), ,
																								"Файл создан автоматически из формы уведомления, редактирование запрещено.");
						Стр2.ПрисоединенныйФайл = НоваяСсылкаНаФайл;
						ЗаписьРегистра.Удалить();
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		ДокОбъект.ДанныеУведомления = Новый ХранилищеЗначения(ДанныеОтчета);
		ДокОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Регламентированная отчетность. Обработка обновления. Преобразование присоедниненных файлов уведомлений'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОтменитьТранзакцию();
	КонецПопытки;
КонецПроцедуры

Процедура СоздатьУведомленияОНевозможностиПредоставления(ВыборкаСтрока) Экспорт
	Попытка
		Если Метаданные.РегистрыСведений.Найти("СоответствиеРегОтчетовУведомлениям") = Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		РегОтчет = ВыборкаСтрока.Ссылка.ПолучитьОбъект();
		Уведомление = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		Уведомление.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов;
		Уведомление.Организация = ВыборкаСтрока.Организация;
		
		ДанныеОтчета = ВыборкаСтрока.ДанныеОтчета.Получить();
		Уведомление.ИмяОтчета = "РегламентированноеУведомлениеНевозможностьПредоставления";
		Уведомление.ИмяФормы = "Форма2015_1";
		Уведомление.ПодписантФамилия = ДанныеОтчета.СобранныеДанныеРазделов._ФамилияПодп;
		Уведомление.ПодписантИмя = ДанныеОтчета.СобранныеДанныеРазделов._ИмяПодп;
		Уведомление.ПодписантОтчество = ДанныеОтчета.СобранныеДанныеРазделов._ОтчествоПодп;
		Уведомление.ДатаПодписи = РегОтчет.Дата;
		Уведомление.Дата = ТекущаяДатаСеанса();
		Уведомление.РегистрацияВИФНС = ДанныеОтчета.Регистрация;
		Уведомление.Записать();

		
		СтруктураУведомления = Новый Структура;
		Для Каждого КЗ Из ДанныеОтчета.ПоказателиОтчета.ПолеТабличногоДокументаТитульный Цикл 
			Если ТипЗнч(КЗ.Значение) = Тип("Строка")
				Или ТипЗнч(КЗ.Значение) = Тип("Число")
				Или ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
				СтруктураУведомления.Вставить(КЗ.Ключ, КЗ.Значение);
			КонецЕсли;
		КонецЦикла;
		Для Каждого КЗ Из ДанныеОтчета.СобранныеДанныеРазделов Цикл 
			Если ТипЗнч(КЗ.Значение) = Тип("Строка")
				Или ТипЗнч(КЗ.Значение) = Тип("Число")
				Или ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
				СтруктураУведомления.Вставить(КЗ.Ключ, КЗ.Значение);
			КонецЕсли;
		КонецЦикла;
		СтруктураУведомления.Вставить("_ПорНомДок", ДанныеОтчета.СобранныеДанныеРазделов._ПорНомДок);
		НовоеДерево = Новый ДеревоЗначений;
		НовоеДерево.Колонки.Добавить("Документ");
		НовоеДерево.Колонки.Добавить("ИндексКартинки");
		НовоеДерево.Колонки.Добавить("ПрисоединенныйФайл");
		НовоеДерево.Колонки.Добавить("УИДДокумент");
		НовоеДерево.Колонки.Добавить("УИДФайл");
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
			МодульПрисоединенныеФайлы = ОбщегоНазначения.ОбщийМодуль("ПрисоединенныеФайлы");
		КонецЕсли;
		
		Для Каждого Стр1 Из ДанныеОтчета.СобранныеДанныеРазделов._ПриложенныеФайлы.Строки Цикл 
			НовСтр = НовоеДерево.Строки.Добавить();
			НовСтр.ИндексКартинки = 0;
			НовСтр.Документ = Стр1.Документ;
			НовСтр.УИДДокумент = Новый УникальныйИдентификатор(Стр1.УИДДокумент);
			Для Каждого Стр2 Из Стр1.Строки Цикл
				НовСтрПодч = НовСтр.Строки.Добавить();
				НовСтрПодч.ИндексКартинки = 2;
				НовСтрПодч.Документ = Стр2.Документ;
				НовСтрПодч.УИДДокумент = Новый УникальныйИдентификатор(Стр2.УИДДокумент);
				НовСтрПодч.УИДФайл = Новый УникальныйИдентификатор(Стр2.УИДФайл);
				Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрисоединенныеФайлы") Тогда
					ЗаписьРегистраСведений = РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов.СоздатьМенеджерЗаписи();
					ЗаписьРегистраСведений.РегламентированныйОтчет = ВыборкаСтрока.Ссылка;
					ЗаписьРегистраСведений.ВидДополнительногоФайла = Стр2.УИДДокумент + "@" + Стр2.УИДФайл;
					ЗаписьРегистраСведений.Прочитать();
					Если ЗаписьРегистраСведений.Выбран() Тогда
						ПараметрыФайла = Новый Структура;
						ПараметрыФайла.Вставить("ВладелецФайлов", Уведомление.Ссылка);
						ПараметрыФайла.Вставить("Автор", Неопределено);
						ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
						ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
						ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
						ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
						НоваяСсылкаНаФайл = МодульПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, 
																ПоместитьВоВременноеХранилище(ЗаписьРегистраСведений.СодержимоеФайла.Получить()), ,
																"Файл создан автоматически из формы уведомления, редактирование запрещено.");
						НовСтрПодч.ПрисоединенныйФайл = НоваяСсылкаНаФайл;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		СтруктураУведомления.Вставить("_ПриложенныеФайлы", НовоеДерево);
		СтруктураПараметров = Новый Структура("СтруктураРеквизитов", СтруктураУведомления);
		Уведомление.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		
		РегОтчет.Комментарий = "##УведомлениеОСпецрежимахНалогообложения##" + ВыборкаСтрока.Комментарий;
		РегОтчет.ПометкаУдаления = Истина;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РегОтчет);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Уведомление);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Уведомление = Уведомление;
		ЗаписьСоответствия.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Регламентированная отчетность. Не удалось преобразовать отчет'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,ВыборкаСтрока.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли
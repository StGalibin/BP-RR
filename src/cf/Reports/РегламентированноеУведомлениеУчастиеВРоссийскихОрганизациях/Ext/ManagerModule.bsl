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
	Возврат "Отчет.РегламентированноеУведомлениеУчастиеВРоссийскихОрганизациях.Форма.Форма2015_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "С-09-6/приказ ФНС от 11.08.2015 № СА-7-14/345@";
	
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
			ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2015_1(Данные, ОсновныеСведения, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("ПФ_MXL_Форма2015_1");
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный[0];
	
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ПараметрыМакета = ОбластьТитульный.Параметры;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРН, "ОГРН_", ПараметрыМакета, 13);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРНИП, "ОГРНИП_", ПараметрыМакета, 15);
	Если Титульный.ПРИЛОЖЕНО_ЛИСТОВ <> 0 Тогда 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Истина);
	КонецЕсли;
	Если Титульный.КОЛИЧЕСТВО_СТРАНИЦ <> 0 Тогда 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.КОЛИЧЕСТВО_СТРАНИЦ, "КоличествоСтраниц_", ПараметрыМакета, 3, Истина);
	КонецЕсли;
	
	ПараметрыМакета.ПризнакПодписанта = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ИНН_ПОДПИСАНТА, "ИНН_ПОДПИСАНТ_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	ПараметрыМакета.Email = Титульный.EMAIL_ПОДПИСАНТА;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета);
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница = 1;
	Для Каждого ДопЛист Из СтруктураПараметров.ДопЛисты Цикл 
		
		ОбластьДопЛист = МакетУведомления.ПолучитьОбласть("ДопЛист");
		ПараметрыМакета = ОбластьДопЛист.Параметры;
		Страница = Страница + 1;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 12);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета("000", "СТР_", ПараметрыМакета, 3);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Страница, "СТР_", ПараметрыМакета, 3);
		
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НАМИНОВАНИЕ_ПОДРАЗДЕЛЕНИЯ, "ПолнНазвРО_", ПараметрыМакета, 160);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ОГРНОРГ, "ОГРНРО_", ПараметрыМакета, 13);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ИННОРГ, "ИННРО_", ПараметрыМакета, 10);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КППОРГ, "КППРО_", ПараметрыМакета, 9);
		ПараметрыМакета.ПрУчастие = ДопЛист.ПРИЗНАК;
		Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(ДопЛист.ДатаНач, "ДатаВознПрава_", ПараметрыМакета);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоСРазделителемВПараметрыМакета(ДопЛист.ДоляУчастия, 3, 5, "ДоляУчастия_", ПараметрыМакета);
		Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(ДопЛист.ДатаКон, "ДатаУтрПрава_", ПараметрыМакета);
		
		ПечатнаяФорма.Вывести(ОбластьДопЛист);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
	
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
	Префикс = "UT_SBUCHROS";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2015_1(Данные, ОсновныеСведения, УникальныйИдентификатор)
	Титульный = Данные.Титульный[0];
	Ошибок = 0;
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда 
		Если (Не ЗначениеЗаполнено(Титульный.ОГРНИП))
			Или (Не ЗначениеЗаполнено(Титульный.П_ИНН))Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ИНН/ОГРНИП на титульном листе", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
	Иначе
		Если (Не ЗначениеЗаполнено(Титульный.ОГРН))
			Или (Не ЗначениеЗаполнено(Титульный.П_ИНН))
			Или (Не ЗначениеЗаполнено(Титульный.П_КПП)) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ИНН/КПП/ОГРН на титульном листе", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ((Не ЗначениеЗаполнено(Титульный.ОГРН)) И (Не ЗначениеЗаполнено(Титульный.ОГРНИП)))
		Или (Не ЗначениеЗаполнено(Титульный.П_ИНН))
		Или (Не ЗначениеЗаполнено(Титульный.П_КПП) И (Не ЗначениеЗаполнено(Титульный.ОГРНИП)))Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ИНН/КПП/ОГРН на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Страница = 0;
	Для Каждого ДопЛист Из Данные.ДопЛисты Цикл
		Страница = Страница + 1;
		
		Если (Не ЗначениеЗаполнено(ДопЛист.НАМИНОВАНИЕ_ПОДРАЗДЕЛЕНИЯ))
			Или (Не ЗначениеЗаполнено(ДопЛист.ОГРНОРГ))
			Или (Не ЗначениеЗаполнено(ДопЛист.ИННОРГ))
			Или (Не ЗначениеЗаполнено(ДопЛист.КППОРГ))
			Или (Не ЗначениеЗаполнено(ДопЛист.ПРИЗНАК))
			Или (Не ЗначениеЗаполнено(ДопЛист.ДатаНач))
			Или (Не ЗначениеЗаполнено(ДопЛист.ДоляУчастия)) Тогда 
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнены обязательные пункты 1-7 (доп. лист " + Страница + ")", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Ошибок > 3 Тогда
			ВызватьИсключение "";
		КонецЕсли;
	КонецЦикла;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Проверить_Форма2015_1(Данные, ОсновныеСведения, УникальныйИдентификатор);
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("ИННПодп", Титульный.ИНН_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("НаимДок", Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("НаимОргПредст", Титульный.ОРГ_ПРЕДСТАВИТЕЛЬ);
	ОсновныеСведения.Вставить("ПрПодп", Титульный.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("Тлф", Титульный.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("EmailПодп", Титульный.EMAIL_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("ОГРН", Титульный.ОГРН);
	ОсновныеСведения.Вставить("ОГРНИП", Титульный.ОГРНИП);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2015_1");
	ЗаполнитьДанными_Форма2015_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2015_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ДопЛисты = Данные.ДопЛисты;
	ПрСообщ = Данные.Титульный[0].ПРИЗНАК_СООБЩЕНИЯ;
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_СведРосОрг = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "СведРосОрг");
	
	НомерДопЛиста = 0;
	Для Каждого ДопЛист Из ДопЛисты Цикл
		НомерДопЛиста = НомерДопЛиста + 1;
		НовыйУзел_СведРосОрг = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_СведРосОрг);
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "НаимОрг", ДопЛист.НАМИНОВАНИЕ_ПОДРАЗДЕЛЕНИЯ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "ОГРН", ДопЛист.ОГРНОРГ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "ИННЮЛ", ДопЛист.ИННОРГ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "КПП", ДопЛист.КППОРГ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "Участие", ДопЛист.ПРИЗНАК);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "ДатаНачУч", ДопЛист.ДатаНач);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "ДоляУч", ДопЛист.ДоляУчастия);
		Если ЗначениеЗаполнено(ДопЛист.ДатаКон) Тогда 
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(НовыйУзел_СведРосОрг, "ДатаКонУч", ДопЛист.ДатаКон);
		КонецЕсли;
	КонецЦикла;
	
	РегламентированнаяОтчетность.УдалитьУзел(Узел_СведРосОрг);
КонецПроцедуры
#КонецОбласти

#КонецЕсли
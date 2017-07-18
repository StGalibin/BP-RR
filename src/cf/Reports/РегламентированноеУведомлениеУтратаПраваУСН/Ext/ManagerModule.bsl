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
	Возврат "Отчет.РегламентированноеУведомлениеУтратаПраваУСН.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "26.2-2/приказ ФНС от 02.11.2012 N ММВ-7-3/829@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("ПФ_MXL_Форма2014_1");
	ПараметрыМакета = МакетУведомления.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Объект.ДатаПодписи, "ДатаПодписи_", ПараметрыМакета);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 120);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20);
	ПараметрыМакета.ПризнакПредставителя = СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.КОД_НО, "КОД_НО_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_ИНН, "ИНН_", ПараметрыМакета, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ОРГАНИЗАЦИЯ, "ОрганизацияНазвание_", ПараметрыМакета, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.П_КПП, "КПП_", ПараметрыМакета, 9);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(СтруктураПараметров.ДАТА_УТРАТЫ_ПРАВА, "ДатаПерехода_", ПараметрыМакета);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ГОД1, "Год2_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ГОД2, "Год3_", ПараметрыМакета, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.НАЛОГОВЫЙ_ПЕРИОД1, "НалоговыйПериод1_", ПараметрыМакета, 2);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.НАЛОГОВЫЙ_ПЕРИОД2, "НалоговыйПериод2_", ПараметрыМакета, 2);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.ПОДПУНКТ1, "Подпункт_", ПараметрыМакета, 3);
	ПараметрыМакета.Пункт = СтруктураПараметров.ПУНКТ1;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(СтруктураПараметров.СТАТЬЯ1, "Статья_", ПараметрыМакета, 2);
	
	ПечатнаяФорма.Вывести(МакетУведомления);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "SR_UPUSN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные;
	Ошибок = 0;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_УТРАТЫ_ПРАВА) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата перехода на иной режим налогообложения", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Титульный.ПОДПУНКТ1) 
		Или ЗначениеЗаполнено(Титульный.ПУНКТ1)
		Или ЗначениеЗаполнено(Титульный.СТАТЬЯ1) Тогда
		
		Если Не ЗначениеЗаполнено(Титульный.ПОДПУНКТ1) 
			И Титульный.ПУНКТ1 <> "4" Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указаны соответствующие подпункты пункта 3 статьи 346.12, пункта 3 статьи 346.14 Налогового кодекса Российской Федерации", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Титульный.ПУНКТ1) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указаны пункт 3 или пункт 4 статьи 346.12, пункта 3 статьи 346.14 Налогового кодекса Российской Федерации", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Титульный.СТАТЬЯ1) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана статья 346.12 или статья 346.14 Налогового кодекса Российской Федерации", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Титульный.НАЛОГОВЫЙ_ПЕРИОД1) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан отчетный период", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Титульный.ГОД1) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан отчетный год", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Титульный.НАЛОГОВЫЙ_ПЕРИОД2)
		Или ЗначениеЗаполнено(Титульный.ГОД2) Тогда
		Если Не ЗначениеЗаполнено(Титульный.НАЛОГОВЫЙ_ПЕРИОД2) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан отчетный период, за который был превышен доход", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Титульный.ГОД2) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан отчетный год, за который был превышен доход", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
	КонецЕсли;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
	
	ОсновныеСведения.Вставить("ДатаПер", Формат(Данные.ДАТА_УТРАТЫ_ПРАВА, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("НомППункт", Данные.ПОДПУНКТ1);
	ОсновныеСведения.Вставить("НомПунктНс", Данные.ПУНКТ1);
	ОсновныеСведения.Вставить("НомСтатНс", ?(ЗначениеЗаполнено(Данные.СТАТЬЯ1), "346." + Данные.СТАТЬЯ1, ""));
	ОсновныеСведения.Вставить("ПериодНс", Данные.НАЛОГОВЫЙ_ПЕРИОД1);
	ОсновныеСведения.Вставить("ОтчетГодНс", Данные.ГОД1);
	ОсновныеСведения.Вставить("ПериодПр", Данные.НАЛОГОВЫЙ_ПЕРИОД2);
	ОсновныеСведения.Вставить("ОтчетГодПр", Данные.ГОД2);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
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

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
КонецПроцедуры

#КонецОбласти
#КонецЕсли
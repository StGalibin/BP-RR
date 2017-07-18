﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДФЛ.СформироватьПрименениеСтандартныхВычетов(Движения, Отказ, ДанныеДляПроведения());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	УчетНДФЛФормы.ПроверитьЗанятостьПолучателяВычетов(Организация, Месяц, Сотрудник, Отказ);
	
	Если НЕ ИзменитьВычетыНаДетей И Не ИзменитьЛичныйВычет Тогда
		ТекстСообщения = НСтр("ru = 'Должен быть указан личный вычет или вычет на детей.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
	ВычетыНаДетейДействуетДоПР = ПроверяемыеРеквизиты.Найти("ВычетыНаДетей.ДействуетДо");
	Если ВычетыНаДетейДействуетДоПР <> Неопределено Тогда
		Для Каждого ВычетНаДетей Из ВычетыНаДетей Цикл
			Если Не ЗначениеЗаполнено(ВычетНаДетей.ДействуетДо) Тогда
				ТекстСообщения = НСтр("ru = 'Не указана дата окончания действия вычета в строке №%1.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВычетНаДетей.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ВычетыНаДетей[" + Формат(ВычетНаДетей.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДействуетДо", , Отказ);
				
			ИначеЕсли ЗначениеЗаполнено(ВычетНаДетей.ДействуетДо) И ВычетНаДетей.ДействуетДо < Месяц Тогда
				ТекстСообщения = НСтр("ru = 'Дата окончания действия вычета в строке №%1 меньше, чем месяц с которого применяются стандартные вычеты.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ВычетНаДетей.НомерСтроки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ВычетыНаДетей[" + Формат(ВычетНаДетей.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДействуетДо", , Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
		ПроверяемыеРеквизиты.Удалить(ВычетыНаДетейДействуетДоПР);
	КонецЕсли;
	
	// Проверка на дубли движений
	МассивВычетов = Новый Массив;
	Для Каждого СтрокаВычет Из ВычетыНаДетей Цикл
		МассивВычетов.Добавить(СтрокаВычет.КодВычета);
	КонецЦикла;
	
	Запрос = Документы.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ.КонфликтующиеРегистраторы(Ссылка, Месяц, Сотрудник, МассивВычетов);
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ") Тогда
				ТекстСообщения = НСтр("ru = 'Не удалось провести заявление. Чтобы изменить вычеты отредактируйте заявление %1.'");
			ИначеЕсли ТипЗнч(Выборка.Регистратор) = Тип("ДокументСсылка.ПрекращениеСтандартныхВычетовНДФЛ") Тогда
				ТекстСообщения = НСтр("ru = 'В периоде %2 г. право на вычеты отменено. Отмените проведение документа %1 перед проведением заявления на вычеты.'");
			Иначе
				ТекстСообщения = НСтр("ru = 'В периоде %2 г. право на вычеты отменено в связи с увольнением. Внесите изменение в документ %1 перед проведением заявления на вычеты.'");
			КонецЕсли;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Регистратор, Формат(Месяц, "ДФ='ММММ гггг'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Выборка.Регистратор, , , Отказ);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	ДанныеОВычетах = Новый Структура(
		"МесяцРегистрации,ФизическоеЛицо,ГоловнаяОрганизация,
		|ИзменитьВычетыНаДетей,ВычетыНаДетей,
		|ИзменитьЛичныйВычет,КодВычетаЛичный,ДокументПодтверждающийПравоНаЛичныйВычет");
	
	ЗаполнитьЗначенияСвойств(ДанныеОВычетах, СведенияОПримененииВычетовИЛичномВычете());
	
	ДанныеОВычетах.ДокументПодтверждающийПравоНаЛичныйВычет = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Заявление от %1 №%2. %3.'"),
			Формат(Дата, "ДЛФ=D"), 
			Символы.НПП + Номер, 
			ДанныеОВычетах.ДокументПодтверждающийПравоНаЛичныйВычет);
	
	Если ДанныеОВычетах.ИзменитьВычетыНаДетей Тогда
		ДанныеОВычетах.Вставить("ВычетыНаДетей", СведенияОВычетахНаДетей(ДанныеОВычетах));
	КонецЕсли;
	
	Возврат ДанныеОВычетах;
	
КонецФункции

Функция СведенияОПримененииВычетовИЛичномВычете()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Месяц КАК МесяцРегистрации,
	|	Док.Сотрудник КАК ФизическоеЛицо,
	|	Док.КодВычетаЛичный КАК КодВычетаЛичный,
	|	Док.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Док.ИзменитьЛичныйВычет,
	|	Док.ИзменитьВычетыНаДетей,
	|	Док.ДокументПодтверждающийПравоНаЛичныйВычет
	|ИЗ
	|	Документ.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ КАК Док
	|ГДЕ
	|	Док.Ссылка = &Документ";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Документ", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СведенияОВычетахНаДетей(ДанныеОВычетах)
	
	ТаблицаВычетыНаДетей = Новый ТаблицаЗначений;
	ТаблицаВычетыНаДетей.Колонки.Добавить("ФизическоеЛицо");
	ТаблицаВычетыНаДетей.Колонки.Добавить("МесяцРегистрации");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КодВычета");
	ТаблицаВычетыНаДетей.Колонки.Добавить("ДатаДействия");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КоличествоДетей");
	ТаблицаВычетыНаДетей.Колонки.Добавить("ДействуетДо");
	ТаблицаВычетыНаДетей.Колонки.Добавить("КоличествоДетейПоОкончании");
	ТаблицаВычетыНаДетей.Колонки.Добавить("Основание");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДокВычетыНаДетей.КодВычета КАК КодВычета,
	|	ДокВычетыНаДетей.ДействуетДо КАК ДействуетДо,
	|	КОЛИЧЕСТВО(1) КАК КоличествоДетей
	|ИЗ
	|	Документ.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ.ВычетыНаДетей КАК ДокВычетыНаДетей
	|ГДЕ
	|	ДокВычетыНаДетей.Ссылка = &Документ
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокВычетыНаДетей.КодВычета,
	|	ДокВычетыНаДетей.ДействуетДо
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодВычета,
	|	ДействуетДо";
	ВычетыНаДетейВыборка =  Запрос.Выполнить().Выбрать();
	
	Пока ВычетыНаДетейВыборка.СледующийПоЗначениюПоля("КодВычета") Цикл
		ТЗ = Новый ТаблицаЗначений;
		ТЗ.Колонки.Добавить("ДатаДействия");
		ТЗ.Колонки.Добавить("КоличествоДетей");
		ТЗ.Колонки.Добавить("ДействуетДо");
		ТЗ.Колонки.Добавить("КоличествоДетейПоОкончании");
		ПредыдущаяДатаДействия = ДанныеОВычетах.МесяцРегистрации;
		Пока ВычетыНаДетейВыборка.Следующий() Цикл
			Если ПредыдущаяДатаДействия <> ДанныеОВычетах.МесяцРегистрации Тогда
				ПредыдущаяСтрокаВычета = Неопределено;
				Для Каждого СтрокаВычета Из ТЗ Цикл
					СтрокаВычета.КоличествоДетей = СтрокаВычета.КоличествоДетей + ВычетыНаДетейВыборка.КоличествоДетей;
					Если ПредыдущаяСтрокаВычета <> Неопределено Тогда
						ПредыдущаяСтрокаВычета.КоличествоДетейПоОкончании = СтрокаВычета.КоличествоДетей;
					КонецЕсли;
					ПредыдущаяСтрокаВычета = СтрокаВычета;
				КонецЦикла;
				ПредыдущаяСтрокаВычета.КоличествоДетейПоОкончании = ВычетыНаДетейВыборка.КоличествоДетей;
			КонецЕсли;
			
			СтрокаВычета = ТЗ.Найти(ПредыдущаяДатаДействия, "ДатаДействия");
			Если СтрокаВычета = Неопределено Тогда
				СтрокаВычета = ТЗ.Добавить();
				СтрокаВычета.ДатаДействия			= ПредыдущаяДатаДействия;
			КонецЕсли;
			
			СтрокаВычета.КоличествоДетей			= ВычетыНаДетейВыборка.КоличествоДетей;
			СтрокаВычета.ДействуетДо				= НачалоМесяца(ВычетыНаДетейВыборка.ДействуетДо);
			СтрокаВычета.КоличествоДетейПоОкончании	= 0;
			
			ПредыдущаяДатаДействия = КонецМесяца(ВычетыНаДетейВыборка.ДействуетДо) + 1;
		КонецЦикла;
		ТЗ.Свернуть("ДатаДействия, ДействуетДо", "КоличествоДетей, КоличествоДетейПоОкончании");
		
		Для Каждого СтрокаВычета Из ТЗ Цикл
			ЗаписьОВычетеНаДетей = ТаблицаВычетыНаДетей.Добавить();
			
			ЗаписьОВычетеНаДетей.ФизическоеЛицо				= ДанныеОВычетах.ФизическоеЛицо;
			ЗаписьОВычетеНаДетей.МесяцРегистрации			= ДанныеОВычетах.МесяцРегистрации;
			ЗаписьОВычетеНаДетей.КодВычета					= ВычетыНаДетейВыборка.КодВычета;
			ЗаписьОВычетеНаДетей.ДатаДействия				= СтрокаВычета.ДатаДействия;
			ЗаписьОВычетеНаДетей.КоличествоДетей			= СтрокаВычета.КоличествоДетей;
			ЗаписьОВычетеНаДетей.ДействуетДо				= СтрокаВычета.ДействуетДо;
			ЗаписьОВычетеНаДетей.КоличествоДетейПоОкончании	= СтрокаВычета.КоличествоДетейПоОкончании;
			
			ЗаписьОВычетеНаДетей.Основание = 
				ЗаявлениеИДокументыПодтверждающиеПраваНаВычеты(ВычетыНаДетейВыборка.КодВычета,
					СтрокаВычета.ДатаДействия,
					СтрокаВычета.ДействуетДо);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаВычетыНаДетей;
	
КонецФункции

// Формирует строку с реквизитами заявления и перечнем документов-оснований 
// (через ", ") соответствующих указанному в параметрах периоду действия
//
// Параметры:
//  КодВычета  - СправочникСсылка.ВидыВычетовНДФЛ - Код вычета.
//  НачалоПериода  - Дата - Дата начала периода
//  ОкончаниеПериода  - Дата - Дата окончания периода 
//                 
//
// Возвращаемое значение:
//   Строка   - Значение формируемое из полей "ДокументПодтверждающийПравоНаВычет"
//				в виде "Заявление № ... от 15.01.15 + данные о документах"
//
Функция ЗаявлениеИДокументыПодтверждающиеПраваНаВычеты(КодВычета, НачалоПериода, ОкончаниеПериода)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей.ДокументПодтверждающийПравоНаВычет
		|ИЗ
		|	Документ.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ.ВычетыНаДетей КАК ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей
		|ГДЕ
		|	ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей.Ссылка = &Ссылка
		|	И ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей.КодВычета = &КодВычета
		|	И ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей.ДействуетДо >= &НачалоПериода
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛВычетыНаДетей.ДействуетДо";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("КодВычета", КодВычета);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	
	ТЗРезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	МассивДокументовПодтверждающихПраваНаВычеты = ТЗРезультатыЗапроса.ВыгрузитьКолонку(ТЗРезультатыЗапроса.Колонки[0]);
	ДокументыПодтверждающиеПраваНаВычеты = СтрСоединить(МассивДокументовПодтверждающихПраваНаВычеты, ", ");
	ВозвращаемоеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Заявление от %1 №%2. %3.'"),
			Формат(Дата, "ДЛФ=D"), 
			Символы.НПП + Номер, 
			ДокументыПодтверждающиеПраваНаВычеты);
	
	Возврат ВозвращаемоеЗначение;

КонецФункции

#КонецОбласти

#КонецЕсли

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудники.Сотрудник");
	
КонецПроцедуры

// Подсистема "Управление доступом".

// Выбирает данные, необходимые для проверки.
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоСотрудникамДляПроверки()
	
	ТаблицаСотрудники = Сотрудники.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТЧСотрудники", Сотрудники);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник КАК ФизическоеЛицо,
	|	Сотрудники.ДатаПолученияСвидетельства,
	|	Сотрудники.СтраховойНомерПФРВСвидетельстве,
	|	Сотрудники.ФамилияВСвидетельстве,
	|	Сотрудники.ИмяВСвидетельстве,
	|	Сотрудники.ОтчествоВСвидетельстве,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.Пол,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.МестоРождения,
	|	Сотрудники.Гражданство,
	|	Сотрудники.ПризнакОтменыОтчества,
	|	Сотрудники.ПризнакОтменыМестаРождения,
	|	Сотрудники.АдресРегистрации,
	|	Сотрудники.АдресФактический,
	|	Сотрудники.СерияДокумента,
	|	Сотрудники.ВидДокумента,
	|	Сотрудники.НомерДокумента,
	|	Сотрудники.ДатаВыдачи,
	|	Сотрудники.КемВыдан
	|ПОМЕСТИТЬ ВТФизЛицаДокумента
	|ИЗ
	|	&ТЧСотрудники КАК Сотрудники
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудники.Сотрудник";
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, Дата, Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизЛицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ФизЛицаДокумента.ФизическоеЛицо КАК Сотрудник,
	|	ФизЛицаДокумента.ФизическоеЛицо.ФИО КАК СотрудникНаименование,
	|	ФизЛицаДокумента.АдресРегистрации КАК АдресРегистрации,
	|	ФизЛицаДокумента.АдресФактический КАК АдресФактический,
	|	ФизЛицаДокумента.ДатаРождения КАК ДатаРождения,
	|	ФизЛицаДокумента.ВидДокумента КАК ВидДокумента,
	|	ФизЛицаДокумента.СерияДокумента КАК СерияДокумента,
	|	ФизЛицаДокумента.НомерДокумента КАК НомерДокумента,
	|	ФизЛицаДокумента.ДатаВыдачи КАК ДатаВыдачи,
	|	ФизЛицаДокумента.КемВыдан КАК КемВыдан,
	|	ФизЛицаДокумента.ДатаПолученияСвидетельства КАК ДатаПолученияСвидетельства,
	|	ФизЛицаДокумента.СтраховойНомерПФРВСвидетельстве КАК СтраховойНомерПФРВСвидетельстве,
	|	ФизЛицаДокумента.ФамилияВСвидетельстве КАК ФамилияВСвидетельстве,
	|	ФизЛицаДокумента.ИмяВСвидетельстве КАК ИмяВСвидетельстве,
	|	ФизЛицаДокумента.ОтчествоВСвидетельстве КАК ОтчествоВСвидетельстве,
	|	ФизЛицаДокумента.Фамилия КАК Фамилия,
	|	ФизЛицаДокумента.Имя КАК Имя,
	|	ФизЛицаДокумента.Отчество КАК Отчество,
	|	ФизЛицаДокумента.Пол КАК Пол,
	|	ФизЛицаДокумента.МестоРождения КАК МестоРождения,
	|	ФизЛицаДокумента.Гражданство КАК Гражданство,
	|	ФизЛицаДокумента.ПризнакОтменыОтчества КАК ПризнакОтменыОтчества,
	|	ФизЛицаДокумента.ПризнакОтменыМестаРождения КАК ПризнакОтменыМестаРождения,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	ДублиСтрок.НомерСтроки КАК КонфликтующаяСтрока
	|ИЗ
	|	ВТФизЛицаДокумента КАК ФизЛицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизЛицаДокумента КАК ДублиСтрок
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = ДублиСтрок.ФизическоеЛицо
	|			И ФизЛицаДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицаДокумента.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ПроверяемыеРеквизитыСотрудников = Новый Массив;
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.СтраховойНомерПФРВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ФамилияВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ИмяВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ВидДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.НомерДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ДатаВыдачи");
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);	
	
	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, КодПоОКПО"); 
	
	ВыборкаСотрудникиДляПроверки = СформироватьЗапросПоСотрудникамДляПроверки().Выбрать();
	
	Если ВыборкаСотрудникиДляПроверки.Количество() > 200 Тогда
		ТекстОшибки = Нстр("ru = 'В документе должно быть не более 200 анкет (сотрудников).'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка,,,Отказ);
	КонецЕсли;
	
	Пока ВыборкаСотрудникиДляПроверки.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Сотрудник) Тогда
			
			Если Не ВыборкаСотрудникиДляПроверки.СотрудникРаботаетВОрганизации Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2 не работает в организации %3.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование, ДанныеОрганизации.Наименование);     
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если ВыборкаСотрудникиДляПроверки.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %2 была введена в документе ранее.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Фамилия) И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Имя) И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Отчество)
				И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Пол)  И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ДатаРождения) И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.МестоРождения)
				И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.АдресРегистрации) И НЕ ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.АдресФактический) 
				И НЕ(ВыборкаСотрудникиДляПроверки.ПризнакОтменыОтчества) И НЕ(ВыборкаСотрудникиДляПроверки.ПризнакОтменыМестаРождения) Тогда 
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: не заполнены изменившиеся сведения.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
		КонецЕсли;
		
		ФизическиеЛицаЗарплатаКадры.ПроверитьПерсональныеДанныеСотрудника(Ссылка, ВыборкаСотрудникиДляПроверки, ПроверяемыеРеквизитыСотрудников, НеПроверяемыеРеквизиты, Дата, Истина, Отказ);		
		ПерсонифицированныйУчет.ПроверитьСоответствиеИзменившихсяДанныхДаннымСвидетельства(Ссылка, ВыборкаСотрудникиДляПроверки, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат КонецДня(Дата);
	
КонецФункции

#КонецОбласти

#КонецЕсли
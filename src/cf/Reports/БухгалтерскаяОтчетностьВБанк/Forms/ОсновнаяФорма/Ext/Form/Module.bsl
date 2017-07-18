﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ИсточникОтчета = СтрЗаменить(СтрЗаменить(Строка(ЭтаФорма.ИмяФормы), "Отчет.", ""), ".Форма.ОсновнаяФорма", "");
	
	ЗначениеВДанныеФормы(Отчеты[ИсточникОтчета].ТаблицаФормОтчета(), мТаблицаФормОтчета);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость = Ложь;
		
	КонецЕсли;
	
	ОрганизацияДатаРегистрации = ДатаРегистрацииОрганизации(Организация);
	
	Если мДатаКонцаПериодаОтчета <> Неопределено Тогда
		ИзменитьПериод(ЭтаФорма, 0);
	КонецЕсли;
	
	ОткорректироватьНачальныйПериод(Организация);
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	ОписаниеДокумента = НСтр("ru = 'Форма предоставления финансовой отчетности в ПАО СБЕРБАНК'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ЗаполнитьБанкПоУмолчанию", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
	ВидПериода = ВидПериодаОтчета(ЭтаФорма, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
	ВидПериода = ВидПериодаОтчета(ЭтаФорма, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтаФорма, ОрганизацияДатаРегистрации);
	
	УстановитьДоступностьКнопокПериода(ЭтаФорма, ОрганизацияДатаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопирован.
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(,НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Банк) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.Текст = НСтр("ru='Не выбран банк'");
		
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ПараметрыКлиента = Новый Структура;
	ПараметрыКлиента.Вставить("ТипПлатформы", Строка(СистемнаяИнформация.ТипПлатформы));
	ПараметрыКлиента.Вставить("ВерсияОС", СистемнаяИнформация.ВерсияОС);

	ВозможнаОтправка = ОтчетностьВБанкиСлужебныйВызовСервера.ВозможнаОтправкаОтчета(Организация, Банк, ПараметрыКлиента);
	
	Если НЕ ВозможнаОтправка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ПараметрыФормы.Вставить("СпособСозданияОрганизации",
		?(СпособСозданияОрганизации = 1, "Реорганизация", "ВновьСозданная"));
	ПараметрыФормы.Вставить("ДатаСозданияОрганизации", НачалоДня(ОрганизацияДатаРегистрации));
	
	ПараметрыФормы.Вставить("Банк", Банк);
	
	Форма = ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Если мВыбраннаяФорма = "ФормаОтчета2011Кв4" Тогда
		Форма.ОткрытьУведомление();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ЗаполнитьБанкПоУмолчанию", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьБанкПоУмолчанию()

	Если ЗначениеЗаполнено(Организация) Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		ПараметрыКлиента = Новый Структура;
		ПараметрыКлиента.Вставить("ТипПлатформы", Строка(СистемнаяИнформация.ТипПлатформы));
		ПараметрыКлиента.Вставить("ВерсияОС", СистемнаяИнформация.ВерсияОС);
		БанкПоУмолчанию = БанкПоУмолчанию(Организация, ПараметрыКлиента);
		Если ЗначениеЗаполнено(БанкПоУмолчанию) Тогда
			Банк = БанкПоУмолчанию;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДатаРегистрацииОрганизации(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(ВыбОрганизация, , "ДатаРегистрации");
	
	Если ЗначениеЗаполнено(ОргСведения) И ОргСведения.Свойство("ДатаРегистрации") Тогда
		Возврат ОргСведения["ДатаРегистрации"];
	Иначе
		Возврат РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма, ОргДатаРегистрации)
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода <> "Стандартный" Тогда
		СтрПериодОтчета = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=dd.MM.yyyy")
			+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'");
	Иначе
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			СтрПериодОтчета = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		Иначе
			СтрПериодОтчета = "Январь - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		КонецЕсли;
	КонецЕсли;
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидПериодаОтчета(Форма, ОргДатаРегистрации)
	
	ДатаРегистрации = НачалоДня(ОргДатаРегистрации);
	ДатаРасширенногоПериода = Дата(Год(Форма.мДатаКонцаПериодаОтчета) - 1, 10, 1);
	ДатаНачалаОбычногоПериода = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	Если (ДатаРегистрации > ДатаНачалаОбычногоПериода И ДатаРегистрации < Форма.мДатаКонцаПериодаОтчета) Тогда
		Возврат "Сокращенный";
	ИначеЕсли Форма.СпособСозданияОрганизации = 0
		И (ДатаРегистрации >= ДатаРасширенногоПериода И ДатаРегистрации < ДатаНачалаОбычногоПериода) Тогда
		Возврат "Расширенный";
	Иначе
		Возврат "Стандартный";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОткорректироватьНачальныйПериод(ВыбОрганизация)
	
	ПредставляетсяЗаГод = Ложь;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		Если ПредставляетсяЗаГод Тогда
			мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(КонецГода(ТекущаяДатаСеанса()), -12));
		Иначе
			мДатаКонцаПериодаОтчета = КонецКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		КонецЕсли;
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ДатаРегистрации = НачалоДня(ВыбОрганизация.ДатаРегистрации);
	РасширятьПериод = (ДатаРегистрации >= Дата(Год(ДатаРегистрации), 10, 1) И СпособСозданияОрганизации <> 1);
	
	Если мДатаКонцаПериодаОтчета < ДатаРегистрации Тогда
		// Период предшествует дате регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		Иначе
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДатаРегистрации);
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(ДатаРегистрации);
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	ИначеЕсли мДатаНачалаПериодаОтчета <= ДатаРегистрации И ДатаРегистрации <= мДатаКонцаПериодаОтчета Тогда
		// Период содержит дату регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	Иначе
		// Период следует за датой регистрации.
		Если РасширятьПериод Тогда
			ДатаРасширенногоПериода = Дата(Год(мДатаКонцаПериодаОтчета) - 1, 10, 1);
			Если ДатаРегистрации >= ДатаРасширенногоПериода Тогда
				мДатаНачалаПериодаОтчета = ДатаРегистрации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКнопокПериода(Форма, ОргДатаРегистрации);
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода = "Расширенный" Тогда
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли ВидПериода = "Сокращенный" Тогда
		Если КонецМесяца(Форма.мДатаКонцаПериодаОтчета) <= КонецМесяца(Форма.мДатаНачалаПериодаОтчета) Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция БанкПоУмолчанию(Знач Организация, Знач ПараметрыКлиента)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	БанковскиеСчетаОрганизаций.Банк.Код КАК БИК,
	               |	БанковскиеСчетаОрганизаций.Банк КАК Банк
	               |ИЗ
	               |	Справочник.БанковскиеСчета КАК БанковскиеСчетаОрганизаций
	               |ГДЕ
	               |	БанковскиеСчетаОрганизаций.Владелец = &Организация
	               |	И НЕ БанковскиеСчетаОрганизаций.ПометкаУдаления
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	БанковскиеСчетаОрганизаций.Банк,
	               |	БанковскиеСчетаОрганизаций.Банк.Код";
	
	ТаблицаБанков = Запрос.Выполнить().Выгрузить();
	
	МассивБИКов = ТаблицаБанков.ВыгрузитьКолонку("БИК");
	
	Если МассивБИКов.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВремФайл = ПолучитьИмяВременногоФайла();
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ВремФайл);
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	ЗаписьJSON.ЗаписатьИмяСвойства("bics");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	Для Каждого БИК ИЗ МассивБИКов Цикл
		ЗаписьJSON.ЗаписатьЗначение(БИК);
	КонецЦикла;
	ЗаписьJSON.ЗаписатьКонецМассива();
	
	ОтчетностьВБанкиСлужебный.ДобавитьДополнительныеПараметры(ЗаписьJSON, ПараметрыКлиента);
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	ЗаписьJSON.Закрыть();
	
	Данные = Новый ДвоичныеДанные(ВремФайл);
	
	Попытка
		УдалитьФайлы(ВремФайл);
	Исключение
		ВидОперации = НСтр("ru = 'Удаление временного файла.'");
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробноеПредставлениеОшибки);
	КонецПопытки;
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Результат = ОтчетностьВБанкиСлужебный.ОтправитьЗапросНаСервер(
		"https://reportbank.1c.ru", "/api/rest/bank/getAvailable/", Заголовки, Данные, Истина, 15);
	
	Успех = Ложь;
	ТекстСообщения = ""; ТекстОшибки = "";
	
	Если Результат.Статус Тогда
		ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
		Если НЕ ДанныеОтвета = Неопределено Тогда
			МассивДоступныхБИКов = ДанныеОтвета.available;
			Если МассивДоступныхБИКов.Количество() = 1 Тогда
				БИКПоУмолчанию = МассивДоступныхБИКов.Получить(0);
				ТекСтрока = ТаблицаБанков.Найти(БИКПоУмолчанию, "БИК");
				Если ТекСтрока = Неопределено Тогда
					Возврат Неопределено;
				Иначе
					Возврат ТекСтрока.Банк;
				КонецЕсли;
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		Если Результат.КодСостояния = 404 Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Результат.Тело) Тогда
			ДанныеОтвета = ОтчетностьВБанкиСлужебный.ДанныеИзСтрокиJSON(Результат.Тело);
			Если НЕ ДанныеОтвета = Неопределено Тогда
				Если ДанныеОтвета.Свойство("errorText") Тогда
					ТекстСообщения = ДанныеОтвета.errorText;
				Иначе
					ТекстСообщения = НСтр("ru = 'Получена неизвестная ошибка с сервиса Бизнес-сеть.'");
				КонецЕсли;
			КонецЕсли;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1
								|%2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Результат.КодСостояния, Результат.Тело);
		Иначе
			ТекстСообщения = Результат.СообщениеОбОшибке;
			ТекстОшибки = НСтр("ru = 'Ошибка получения данных с сервиса Бизнес-сеть.
								|Код состояния: %1'");
		КонецЕсли;
		ВидОперации = НСтр("ru = 'Получение списка банков с сервиса Бизнес-сеть.'");
		ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти


﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен с банками по зарплатным проектам".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает заполнена ли анкета открытия лицевого счета или нет.
//
// Параметры:
//		СтрокаОткрытиеЛицевыхСчетов - Коллекция данных анкеты.
//
// Возвращаемое значение:
//		Булево, Истина, если в анкете заполнены все обязательные поля
//			Ложь, если есть хоть одно не заполненное обязательное поле.
//
Функция АнкетаЗаполнена(СтрокаОткрытиеЛицевыхСчетов) Экспорт
	
	Заполнена = Истина;
	
	// Физическое лицо
	Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ФизическоеЛицо) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Эмбоссированный текст
	Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.ЭмбоссированныйТекст1) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.ЭмбоссированныйТекст2) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Проверка максимальной длины эмбоссированного текста, она не должна превышать 19 символов.
	ДлинаЭмбоссированногоТекста = СтрДлина(СтрокаОткрытиеЛицевыхСчетов.ЭмбоссированныйТекст1);
	ДлинаЭмбоссированногоТекста = ДлинаЭмбоссированногоТекста + СтрДлина(СтрокаОткрытиеЛицевыхСчетов.ЭмбоссированныйТекст2);
	ДлинаЭмбоссированногоТекста = ДлинаЭмбоссированногоТекста + СтрДлина(СтрокаОткрытиеЛицевыхСчетов.ЭмбоссированныйТекст3);
	Если ДлинаЭмбоссированногоТекста > 19 Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Дата рождения
	Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаРождения) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Пол
	Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.Пол) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Система расчетов по банковским картам.
	Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.СистемаРасчетовПоБанковскимКартам) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Счет дебета
	Если НЕ ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.СчетДебета) И СтрДлина(СтрокаОткрытиеЛицевыхСчетов.СчетДебета) <> 20 Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Вид документа
	Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДокументВид) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Номер документа
	Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.ДокументНомер) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Дата выдачи документа
	Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДокументДатаВыдачи) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Кем выдан документ
	Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.ДокументКемВыдан) Тогда
		Заполнена = Ложь;
	КонецЕсли;
	
	// Миграционная карта
	Если Не ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.НомерМиграционнойКарты)
		Или ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционнойКарты)
		Или ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционнойКарты) Тогда
		Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.НомерМиграционнойКарты) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционнойКарты) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционнойКарты) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционнойКарты > СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционнойКарты Тогда
			Заполнена = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Миграционный документ
	Если ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ВидМиграционногоДокумента)
		Или Не ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.НомерМиграционногоДокумента)
		Или ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционногоДокумента)
		Или ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционногоДокумента) Тогда
		Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ВидМиграционногоДокумента) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если ПустаяСтрока(СтрокаОткрытиеЛицевыхСчетов.НомерМиграционногоДокумента) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционногоДокумента) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционногоДокумента) Тогда
			Заполнена = Ложь;
		КонецЕсли;
		Если СтрокаОткрытиеЛицевыхСчетов.ДатаНачалаПребыванияМиграционногоДокумента > СтрокаОткрытиеЛицевыхСчетов.ДатаОкончанияПребыванияМиграционногоДокумента Тогда
			Заполнена = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Заполнена;
	
КонецФункции

Процедура УстановитьПояснениеКНомеруЛицевогоСчета(Форма, ИмяПоляДляПодсказки, СтруктураПояснения = Неопределено) Экспорт
	
	Если СтруктураПояснения = Неопределено
		ИЛИ ПустаяСтрока(СтруктураПояснения.СообщенияПроверки) Тогда
		
		РасширеннаяПодсказка = "";
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
		
	Иначе
		ЭлементЦветТекста = СтруктураПояснения.ЭлементЦветТекста;
		РасширеннаяПодсказка = Новый ФорматированнаяСтрока(СтруктураПояснения.СообщенияПроверки, , СтруктураПояснения.ЭлементЦветТекста);
		Если СтруктураПояснения.ВведенДокументом Тогда
			РасширеннаяПодсказка = Новый ФорматированнаяСтрока(РасширеннаяПодсказка, Символы.ПС, СтруктураПояснения.ТекстНадписи);
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(Форма, ИмяПоляДляПодсказки, РасширеннаяПодсказка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, ИмяПоляДляПодсказки, "ЦветТекста", ЭлементЦветТекста);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамНомерЛицевогоСчета", "Доступность", Не Форма.ФизическоеЛицоЛСВведенДокументом);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамЗарплатныйПроект", "Доступность", Не Форма.ФизическоеЛицоЛСВведенДокументом);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПериодСтрокой", "Доступность", Не Форма.ФизическоеЛицоЛСВведенДокументом);
	
КонецПроцедуры

// Преобразует строку из кириллицы в латиницу по соответствию символов.
//
// Параметры:
//		ИсходныйТекст - преобразуемая строка.
//		СоответствиеСимволов - соответствие символов кириллицы и латиницы.
//
// Возвращаемое значение:
//		ГотовоеЗначение - преобразованная строка.
//
Функция СтрокаНаЛатинском(Знач ИсходныйТекст, СоответствиеСимволов) Экспорт
	
	ГотовоеЗначение = "";
	ИсходныйТекст = СокрЛП(ВРег(ИсходныйТекст));
	Для НомерСимвола = 1 По СтрДлина(ИсходныйТекст) Цикл
		
		ТекущийСимвол = Сред(ИсходныйТекст, НомерСимвола, 1);
		ТекущийГотовыйСимвол = СоответствиеСимволов.Получить(ТекущийСимвол);
		ГотовоеЗначение = ГотовоеЗначение + ?(ТекущийГотовыйСимвол = Неопределено, ТекущийСимвол, ТекущийГотовыйСимвол);
		
	КонецЦикла;
	
	Возврат ГотовоеЗначение;
	
КонецФункции

// Получает соответствие символов кириллицы и латиницы для составления эмбоссированного текста.
//
// Возвращаемое значение:
//		Соответствие символов
Функция СоответствиеСимволовЭмбоссированногоТекста() Экспорт
	
	СоответствиеСимволов = Новый Соответствие;
	СоответствиеСимволов.Вставить("А", "A");
	СоответствиеСимволов.Вставить("Б", "B");
	СоответствиеСимволов.Вставить("В", "V");
	СоответствиеСимволов.Вставить("Г", "G");
	СоответствиеСимволов.Вставить("Д", "D");
	СоответствиеСимволов.Вставить("Е", "E");
	СоответствиеСимволов.Вставить("Ё", "E");
	СоответствиеСимволов.Вставить("Ж", "ZH");
	СоответствиеСимволов.Вставить("З", "Z");
	СоответствиеСимволов.Вставить("И", "I");
	СоответствиеСимволов.Вставить("Й", "Y");
	СоответствиеСимволов.Вставить("К", "K");
	СоответствиеСимволов.Вставить("Л", "L");
	СоответствиеСимволов.Вставить("М", "M");
	СоответствиеСимволов.Вставить("Н", "N");
	СоответствиеСимволов.Вставить("О", "O");
	СоответствиеСимволов.Вставить("П", "P");
	СоответствиеСимволов.Вставить("Р", "R");
	СоответствиеСимволов.Вставить("С", "S");
	СоответствиеСимволов.Вставить("Т", "T");
	СоответствиеСимволов.Вставить("У", "U");
	СоответствиеСимволов.Вставить("Ф", "F");
	СоответствиеСимволов.Вставить("Х", "KH");
	СоответствиеСимволов.Вставить("Ц", "TS");
	СоответствиеСимволов.Вставить("Ч", "CH");
	СоответствиеСимволов.Вставить("Ш", "SH");
	СоответствиеСимволов.Вставить("Щ", "SHCH");
	СоответствиеСимволов.Вставить("Ъ", "");
	СоответствиеСимволов.Вставить("Ы", "Y");
	СоответствиеСимволов.Вставить("Ь", "");
	СоответствиеСимволов.Вставить("Э", "E");
	СоответствиеСимволов.Вставить("Ю", "YU");
	СоответствиеСимволов.Вставить("Я", "YA");
	
	Возврат СоответствиеСимволов;
	
КонецФункции

Функция ПривестиСтрокуКИдентификатору(СтрокаДляПреобразования) Экспорт
	
	СтрокаВИдентификатор = СтрЗаменить(СтрокаДляПреобразования, ".", "_");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "-", "_");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, " ", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "~", "");
	СтрокаВИдентификатор = СтрЗаменить(СтрокаВИдентификатор, "%", "");
	
	Возврат СтрокаВИдентификатор;
	
КонецФункции

#КонецОбласти

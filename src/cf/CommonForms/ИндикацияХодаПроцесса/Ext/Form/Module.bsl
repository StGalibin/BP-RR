﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	КоличествоОрганизаций = Параметры.КоличествоОрганизаций;
	КоличествоМесяцев     = Параметры.КоличествоМесяцев;
	
	Если КоличествоОрганизаций * КоличествоМесяцев < 2 Тогда
		// Расчет по одной организации и за один месяц. Скрываем индикатор по месяцам-организациям.
		Элементы.ПрогрессОрганизация.Видимость = Ложь;
	Иначе
		// Число шагов индикатора организаций и месяцев делаем чуть больше требуемого,
		// т.к. сразу устанавливаем его в 1, чтобы было видно, что стало выполняться,
		// а также чтобы не выставлялось сразу 100% при переходе к последней комбинации "организация + месяц".
		Элементы.ПрогрессОрганизация.МаксимальноеЗначение = КоличествоОрганизаций * КоличествоМесяцев + 2;
		ПрогрессОрганизация = 1;
	КонецЕсли;

	ТекущийМесяц       = НачалоМесяца(Параметры.Месяц);
	ТекущаяОрганизация = Параметры.Организация;
	
	ОбновитьНадписьМесяцОрганизация();
		
	// Оставим на форме необходимые индикаторы.
	КоличествоОтсутствующихИндикаторов = 0;
	ИмяПервогоЭтапа = "";
	
	Если Параметры.ИспользоватьПерепроведениеДокументов Тогда
		ИмяПервогоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов();
	Иначе
		Элементы.ГруппаПерепроведениеДокументов.Видимость = Ложь;
		КоличествоОтсутствующихИндикаторов = КоличествоОтсутствующихИндикаторов + 1;
	КонецЕсли;
	
	Если Параметры.ИспользоватьАктуализациюРасчетовСКонтрагентами Тогда
		Если ПустаяСтрока(ИмяПервогоЭтапа) Тогда
			ИмяПервогоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами();
		КонецЕсли;
	Иначе
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентами.Видимость = Ложь;
		КоличествоОтсутствующихИндикаторов = КоличествоОтсутствующихИндикаторов + 1;
	КонецЕсли;
	
	Если Параметры.ИспользоватьЗакрытиеМесяца Тогда
		Если ПустаяСтрока(ИмяПервогоЭтапа) Тогда
			ИмяПервогоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца();
		КонецЕсли;
	Иначе
		Элементы.ГруппаЗакрытиеМесяца.Видимость = Ложь;
		КоличествоОтсутствующихИндикаторов = КоличествоОтсутствующихИндикаторов + 1;
	КонецЕсли;
	
	Если КоличествоОтсутствующихИндикаторов > 2 Тогда
		ВызватьИсключение НСтр("ru = 'При вызове общей формы ИндикацияХодаПроцесса не задано использование ни одного из индикаторов прогресса.'");
	КонецЕсли;
	
	ОбновитьВидимостьПоЭтапу(ИмяПервогоЭтапа);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		// В файловой базе возможна ситуация, когда выполнение текущего фонового задания не началось, т.к. вынуждено ждать
		// ранее запущенное другое фоновое задание. О такой ситуации требуется информировать пользователя.
		// Признаком этого является использование реквизита ПараметрыСохраняемыеНаВремяОжидания.
		ПараметрыСохраняемыеНаВремяОжидания = Новый Структура;
		ТекстСообщенияОжидание = ИменаРанееЗапущенныхЗаданий(ИдентификаторЗадания);
		ПереключитьРежимОжидания(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ПараметрыСохраняемыеНаВремяОжидания) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьНаличиеДругихЗаданий", 15, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	// Высота не должна зависеть от количества элементов. Поэтому при закрытии формы должен сохраниться ключ,
	// отличающийся от ключа по-умолчанию.
	КлючСохраненияПоложенияОкна = "НастройкаСохраненияПоложенияОкна";
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере(ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
// Возвращает имена ранее запущенных и активных в данный момент фоновых заданий кроме текущего.
//
// Параметры:
//  ТекущееЗадание - УникальныйИдентификатор - идентификатор задания, пропускаемого при построении списка.
//
// Возвращаемое значение:
//   Строка      - список имен фоновых заданий, разделенный переносами строки.
//
Функция ИменаРанееЗапущенныхЗаданий(Знач ТекущееЗадание) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ИменаФоновыхЗаданий = Новый Массив;
	
	СостояниеАктивности = Новый Структура("Состояние", СостояниеФоновогоЗадания.Активно);
	ЗапущенныеФоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(СостояниеАктивности);
	Для каждого Задание Из ЗапущенныеФоновые Цикл
		Если Задание.УникальныйИдентификатор <> ТекущееЗадание Тогда
			ИменаФоновыхЗаданий.Добавить(Задание.Наименование);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрСоединить(ИменаФоновыхЗаданий, Символы.ПС);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьНаличиеДругихЗаданий()
	
	Если Не ЗначениеЗаполнено(ПараметрыСохраняемыеНаВремяОжидания) Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьНаличиеДругихЗаданий");
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстСообщенияОжидание) Тогда
		Возврат;
	КонецЕсли;
	
	// Перед актуализацией списка фоновых заданий сохраняем "шапку" надписи.
	ПозицияИменЗаданий = СтрНайти(ТекстСообщенияОжидание, Символы.ПС);
	СообщениеОжидания = Лев(ТекстСообщенияОжидание, ПозицияИменЗаданий);
	// Новый список ранее запущенных фоновых заданий.
	ТекстСообщенияОжидание = ИменаРанееЗапущенныхЗаданий(ИдентификаторЗадания);
	Если ПустаяСтрока(ТекстСообщенияОжидание) Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьНаличиеДругихЗаданий");
		ПереключитьРежимОжидания(ЭтотОбъект);
	Иначе
		ТекстСообщенияОжидание = СообщениеОжидания + ТекстСообщенияОжидание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьРежимОжидания(Форма)
	
	Элементы = Форма.Элементы;
	ПараметрыСохраняемыеНаВремяОжидания = Форма.ПараметрыСохраняемыеНаВремяОжидания;
	Если Не ПустаяСтрока(Форма.ТекстСообщенияОжидание) Тогда // ожидать завершения стороннего фонового задания
		
		Если ПараметрыСохраняемыеНаВремяОжидания <> Неопределено
		   И Не ЗначениеЗаполнено(ПараметрыСохраняемыеНаВремяОжидания) Тогда
		   
			Элементы.ГруппаОжидания.Видимость = Истина;

			ИмяТекущегоЭтапа = Форма.ИмяТекущегоЭтапа;
			Если ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов()
			 Или ПустаяСтрока(ИмяТекущегоЭтапа) И Элементы.ГруппаПерепроведениеДокументов.Видимость Тогда
			 
				СообщениеОжидания = Элементы.НадписьПерепроведениеДокументовБезПрогресса.Заголовок;
				
			ИначеЕсли ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами()
			 Или ПустаяСтрока(ИмяТекущегоЭтапа) И Элементы.ГруппаАктуализацияРасчетовСКонтрагентами.Видимость Тогда
			 
				СообщениеОжидания = Элементы.НадписьАктуализацияРасчетовСКонтрагентамиБезПрогресса.Заголовок;
				
			ИначеЕсли ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца()
			 Или ПустаяСтрока(ИмяТекущегоЭтапа) И Элементы.ГруппаЗакрытиеМесяца.Видимость Тогда
			 
				СообщениеОжидания = Элементы.НадписьЗакрытиеМесяцаБезПрогресса.Заголовок;
				
			КонецЕсли;
			Форма.ТекстСообщенияОжидание = НСтр("ru = '%1 выполнится после завершения служебной операции:'")
				+ Символы.ПС + Форма.ТекстСообщенияОжидание;
			Форма.ТекстСообщенияОжидание = СтрШаблон(Форма.ТекстСообщенияОжидание, СообщениеОжидания);
		   
			ПараметрыСохраняемыеНаВремяОжидания.Вставить("ГруппаОрганизация", Элементы.ГруппаОрганизация.Видимость);
			Элементы.ГруппаОрганизация.Видимость = Ложь;
			
			ПараметрыСохраняемыеНаВремяОжидания.Вставить("ИспользоватьПерепроведениеДокументов",
				Элементы.ГруппаПерепроведениеДокументов.Видимость);
			Элементы.ГруппаПерепроведениеДокументов.Видимость = Ложь;
				
			ПараметрыСохраняемыеНаВремяОжидания.Вставить("ИспользоватьАктуализациюРасчетовСКонтрагентами",
				Элементы.ГруппаАктуализацияРасчетовСКонтрагентами.Видимость);
			Элементы.ГруппаАктуализацияРасчетовСКонтрагентами.Видимость = Ложь;
			
			ПараметрыСохраняемыеНаВремяОжидания.Вставить("ИспользоватьЗакрытиеМесяца", Элементы.ГруппаЗакрытиеМесяца.Видимость);
			Элементы.ГруппаЗакрытиеМесяца.Видимость = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ПараметрыСохраняемыеНаВремяОжидания) Тогда // ожидать завершения выполнения нашего задания
	   
		Элементы.ГруппаОжидания.Видимость = Ложь;
	   
	    Элементы.ГруппаОрганизация.Видимость = ПараметрыСохраняемыеНаВремяОжидания.ГруппаОрганизация;
		
		Элементы.ГруппаПерепроведениеДокументов.Видимость
			= ПараметрыСохраняемыеНаВремяОжидания.ИспользоватьПерепроведениеДокументов;
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентами.Видимость
			= ПараметрыСохраняемыеНаВремяОжидания.ИспользоватьАктуализациюРасчетовСКонтрагентами;
		Элементы.ГруппаЗакрытиеМесяца.Видимость = ПараметрыСохраняемыеНаВремяОжидания.ИспользоватьЗакрытиеМесяца;
		
		ПараметрыСохраняемыеНаВремяОжидания.Очистить();
		
	Иначе
		
		Элементы.ГруппаОжидания.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(Знач ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьМесяцОрганизацию(Месяц, Организация)

	ПрогрессОрганизация	= ПрогрессОрганизация + 1;

	ТекущийМесяц = НачалоМесяца(Месяц);
	ТекущаяОрганизация = Организация;

	ОбновитьНадписьМесяцОрганизация();
	
	// Обнуляем текущие значения.
	ИмяТекущегоЭтапа                           = "";

	ПрогрессПерепроведениеДокументов           = 0;
	ПрогрессАктуализацияРасчетовСКонтрагентами = 0;
	ПрогрессЗакрытиеМесяца                     = 0;

	ТекстСообщенияПерепроведениеДокументов     = "";
	ТекстСообщенияАктуализацияРасчетовСКонтрагентами = "";
	ТекстСообщенияЗакрытиеМесяца               = "";
	
	ДатаНачалаПерепроведенияДокументов         = '0001-01-01';
	ДатаОкончанияПерепроведенияДокументов      = '0001-01-01';
	ТекущаяДатаПерепроведенияДокументов        = '0001-01-01';

	КоличествоДоговоровКонтрагентов            = 0;
	ОбработаноДоговоровКонтрагентов            = 0;

	КоличествоОперацийЗакрытияМесяца           = 0;
	ОбработаноОперацийЗакрытияМесяца           = 0;

КонецПроцедуры

&НаСервере
Процедура УстановитьГраницыЭтапа(ИмяЭтапа, НачальноеЗначение, КонечноеЗначение)
	
	Если ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов() Тогда
		// НачальноеЗначение и КонечноеЗначение - даты начала и окончания
		ДатаНачалаПерепроведенияДокументов    = НачальноеЗначение;
		ДатаОкончанияПерепроведенияДокументов = КонечноеЗначение;
		
		// Сбрасываем нижестоящие индикаторы
		ПрогрессПерепроведениеДокументов           = 0;
		ПрогрессАктуализацияРасчетовСКонтрагентами = 0;
		ПрогрессЗакрытиеМесяца                     = 0;

	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда
		// НачальноеЗначение - 0, КонечноеЗначение - количество актуализируемых договоров
		КоличествоДоговоровКонтрагентов = КонечноеЗначение;
		
		// Сбрасываем нижестоящие индикаторы
		ПрогрессАктуализацияРасчетовСКонтрагентами = 0;
		ПрогрессЗакрытиеМесяца                     = 0;

	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда
		// НачальноеЗначение - 0, КонечноеЗначение - количество операций закрытия месяца
		КоличествоОперацийЗакрытияМесяца = КонечноеЗначение;

		// Сбрасываем нижестоящие индикаторы
		ПрогрессЗакрытиеМесяца           = 0;
	
	КонецЕсли;

	ИмяТекущегоЭтапа = ИмяЭтапа;
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьЭтап(ИмяЭтапа)

	Если ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов() Тогда
	
		ПрогрессПерепроведениеДокументов = МаксимальноеЗначениеПрогресса();
		ТекстСообщенияПерепроведениеДокументов = "";

	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда

		ПрогрессАктуализацияРасчетовСКонтрагентами = МаксимальноеЗначениеПрогресса();
		ТекстСообщенияАктуализацияРасчетовСКонтрагентами = "";
		
	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда

		ПрогрессЗакрытиеМесяца = МаксимальноеЗначениеПрогресса();
		ТекстСообщенияЗакрытиеМесяца = "";
	
	КонецЕсли;

	ИмяТекущегоЭтапа = "";

КонецПроцедуры

&НаКлиенте
// Перемещает прогресс-бар на новый шаг.
//
// Параметры:
//  ПараметрыСообщенияПрогресса - Структура - см. ЗакрытиеМесяцаКлиентСервер.НовыеПараметрыСообщенийПрогресса()
//  ТекстСообщения - Строка - Дополнительный текст для вывода сообщений.
//
Процедура ОбновитьСостояниеВыполнения(ПараметрыСообщенийПрогресса, ТекстСообщения) Экспорт

	Если ПараметрыСохраняемыеНаВремяОжидания <> Неопределено Тогда
		// Условие выполняется только в случае выполнения на файловой базе.
		Если ПараметрыСообщенийПрогресса.КонтрольРанееЗапущенных Тогда
			// Если требуется запустить еще одно задание, не закрывая форму, то проверим, что нет мешающих ему.
			ТекстСообщенияОжидание = ИменаРанееЗапущенныхЗаданий(ИдентификаторЗадания);
			ПереключитьРежимОжидания(ЭтотОбъект);
			Возврат;
			
		Иначе
			// Если мы ожидали окончания другого задания, то вернемся к выполнению текущего.
			ТекстСообщенияОжидание = "";
			ПереключитьРежимОжидания(ЭтотОбъект);
		КонецЕсли;
	Иначе
		Если ПараметрыСообщенийПрогресса.КонтрольРанееЗапущенных Тогда
			// Проверка требуется только на файловой базе.
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если НачалоМесяца(ПараметрыСообщенийПрогресса.Месяц) = НачалоМесяца(ТекущийМесяц)
		И ПараметрыСообщенийПрогресса.Организация = ТекущаяОрганизация
		И ПараметрыСообщенийПрогресса.ИмяЭтапа = ИмяТекущегоЭтапа Тогда

		// Продвижение прогресса по текущему этапу.
		ОбновитьСостояниеВыполненияБезКонтекста(ЭтотОбъект, ПараметрыСообщенийПрогресса, ТекстСообщения);

	Иначе

		// Изменился месяц, организация и/или этап, требуется перестроить элементы на формы, выполняем это на сервере.
		ОбновитьСостояниеВыполненияНаСервере(ПараметрыСообщенийПрогресса, ТекстСообщения);

	КонецЕсли;

	ОбновитьОтображениеДанных();

КонецПроцедуры

&НаСервере
Процедура ОбновитьСостояниеВыполненияНаСервере(Знач ПараметрыСообщенийПрогресса, Знач ТекстСообщения)
	
	// Проверка смены месяца или организации.
	Если (НачалоМесяца(ПараметрыСообщенийПрогресса.Месяц) <> НачалоМесяца(ТекущийМесяц)
			ИЛИ ПараметрыСообщенийПрогресса.Организация <> ТекущаяОрганизация)
		И КоличествоОрганизаций * КоличествоМесяцев > 1 Тогда
		УстановитьМесяцОрганизацию(ПараметрыСообщенийПрогресса.Месяц, ПараметрыСообщенийПрогресса.Организация);
	КонецЕсли;

	// Проверка смены этапа.
	Если ПараметрыСообщенийПрогресса.ИмяЭтапа <> ИмяТекущегоЭтапа Тогда
		УстановитьГраницыЭтапа(
			ПараметрыСообщенийПрогресса.ИмяЭтапа,
			ПараметрыСообщенийПрогресса.НачальноеЗначение,
			ПараметрыСообщенийПрогресса.КонечноеЗначение);
			
		// Отметим как завершенные предыдущие этапы, даже если для них не вызывалась ни разу ОбновлениСостояниеВыполнения(),
		// чтобы они не выглядели как пропущенные.
		Если ПараметрыСообщенийПрогресса.ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда
			ЗавершитьЭтап(ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов());
		
		ИначеЕсли ПараметрыСообщенийПрогресса.ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда
		
			ЗавершитьЭтап(ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов());
			ЗавершитьЭтап(ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами());
			
		КонецЕсли;
			
		// Запоминаем новый этап.
		ИмяТекущегоЭтапа = ПараметрыСообщенийПрогресса.ИмяЭтапа;
		
	КонецЕсли;
	
	ОбновитьВидимостьПоЭтапу(ИмяТекущегоЭтапа);
	
	ОбновитьСостояниеВыполненияБезКонтекста(ЭтотОбъект, ПараметрыСообщенийПрогресса, ТекстСообщения);
	
	Если ПараметрыСохраняемыеНаВремяОжидания <> Неопределено Тогда
		// Возможно нам необходимо ожидать после смены этапа на следующий.
		ТекстСообщенияОжидание = ИменаРанееЗапущенныхЗаданий(ИдентификаторЗадания);
		ПереключитьРежимОжидания(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеВыполненияБезКонтекста(Форма, ПараметрыСообщенийПрогресса, ТекстСообщения)
	
	МаксЗначение = МаксимальноеЗначениеПрогресса();
	
	// Установка достигнутого значения для нового этапа.
	// При этом 100% выполнение устанавливаем только при завершении этапа,
	// до этого момента считаем, что еще не все операции выполнены.
	Если Форма.ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов() Тогда
		
		Форма.ТекущаяДатаПерепроведенияДокументов = ПараметрыСообщенийПрогресса.ДостигнутоеЗначение;
		
		НовоеЗначениеПрогресса = ЗначениеПрогрессаПерепроведенияДокументов(
			Форма.ДатаНачалаПерепроведенияДокументов,
			Форма.ДатаОкончанияПерепроведенияДокументов,
			Форма.ТекущаяДатаПерепроведенияДокументов);
		
		Форма.ПрогрессПерепроведениеДокументов = Мин(Макс(Форма.ПрогрессПерепроведениеДокументов, НовоеЗначениеПрогресса), МаксЗначение - 1);
		
		Форма.ТекстСообщенияПерепроведениеДокументов = ТекстСообщения;
	
	ИначеЕсли Форма.ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда
	
		Форма.ОбработаноДоговоровКонтрагентов = ПараметрыСообщенийПрогресса.ДостигнутоеЗначение;
		
		НовоеЗначениеПрогресса = ЗначениеПрогресса(
			Форма.КоличествоДоговоровКонтрагентов,
			Форма.ОбработаноДоговоровКонтрагентов);
		
		Форма.ПрогрессАктуализацияРасчетовСКонтрагентами = Мин(Макс(Форма.ПрогрессАктуализацияРасчетовСКонтрагентами, НовоеЗначениеПрогресса), МаксЗначение - 1);
		
		Форма.ТекстСообщенияАктуализацияРасчетовСКонтрагентами = ТекстСообщения;
		
	ИначеЕсли Форма.ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда
	
		Форма.ОбработаноОперацийЗакрытияМесяца = ПараметрыСообщенийПрогресса.ДостигнутоеЗначение;
		
		НовоеЗначениеПрогресса = ЗначениеПрогресса(
			Форма.КоличествоОперацийЗакрытияМесяца,
			Форма.ОбработаноОперацийЗакрытияМесяца);
		
		Форма.ПрогрессЗакрытиеМесяца = Мин(Макс(Форма.ПрогрессЗакрытиеМесяца, НовоеЗначениеПрогресса), МаксЗначение - 1);
		
		Форма.ТекстСообщенияЗакрытиеМесяца = ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Перемещает прогресс-бар на один условный шаг.
//
Процедура ПродвинутьПрогрессБезСобытия() Экспорт

	Если ЗначениеЗаполнено(ПараметрыСохраняемыеНаВремяОжидания) Тогда
		// Ожидаем завершения другого фонового задания, чтобы начать выполнять текущее.
		Возврат;
	КонецЕсли;
	
	// Продвигаем прогресс не далее, чем бы он был бы сдвинут при окончательном переходе к следующему значению.
	// Пи этом назад не откатываемся, если из фонового задания пришло значение меньше, чем то, до которого дошли
	// по обработчику ожидания.
	Если ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов() Тогда

		СледующаяДатаПерепроведения = КонецДня(ТекущаяДатаПерепроведенияДокументов) + 1;
		СледующееЗначениеПрогресса = ЗначениеПрогрессаПерепроведенияДокументов(
			ДатаНачалаПерепроведенияДокументов,
			ДатаОкончанияПерепроведенияДокументов,
			СледующаяДатаПерепроведения);

		НовоеЗначениеПрогресса = Мин(ПрогрессПерепроведениеДокументов + 1, СледующееЗначениеПрогресса - 1);
		ПрогрессПерепроведениеДокументов = Макс(ПрогрессПерепроведениеДокументов, НовоеЗначениеПрогресса);

	ИначеЕсли ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда
		
		СледующееЗначениеПрогресса = ЗначениеПрогресса(КоличествоДоговоровКонтрагентов, ОбработаноДоговоровКонтрагентов + 1);
		НовоеЗначениеПрогресса = Мин(ПрогрессАктуализацияРасчетовСКонтрагентами + 1, СледующееЗначениеПрогресса - 1);
		ПрогрессАктуализацияРасчетовСКонтрагентами = Макс(ПрогрессАктуализацияРасчетовСКонтрагентами, НовоеЗначениеПрогресса);

	ИначеЕсли ИмяТекущегоЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда
	
		СледующееЗначениеПрогресса = ЗначениеПрогресса(КоличествоОперацийЗакрытияМесяца, ОбработаноОперацийЗакрытияМесяца + 1);
		НовоеЗначениеПрогресса = Мин(ПрогрессЗакрытиеМесяца + 1, СледующееЗначениеПрогресса - 1);
		ПрогрессЗакрытиеМесяца = Макс(ПрогрессЗакрытиеМесяца, НовоеЗначениеПрогресса);
	
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьМесяцОрганизация()

	Если ЗначениеЗаполнено(ТекущийМесяц) И ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		ТекстМесяц = Формат(ТекущийМесяц, "ДФ=""ММММ гггг 'г.'""");
		
		Если ИспользоватьНесколькоОрганизаций Тогда
			ТекстСообщенияТекущаяОрганизация = СтрШаблон(
				"%1 %2",
				ТекстМесяц,
				СокрП(ТекущаяОрганизация));
		Иначе
			ТекстСообщенияТекущаяОрганизация = ТекстМесяц;
		КонецЕсли;
	Иначе
		ТекстСообщенияТекущаяОрганизация = НСтр("ru = 'Пожалуйста, подождите...'");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПоЭтапу(ИмяЭтапа)

	ПустаяКартинка = Новый Картинка;

	Если ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаПерепроведениеДокументов() Тогда
	
		// Перепроведение документов - выполняется.
		Элементы.ГруппаПерепроведениеДокументовПрогресс.Видимость     = Истина;
		Элементы.ГруппаПерепроведениеДокументовБезПрогресса.Видимость = Ложь;
	
		// Нижележащие этапы - ожидают выполнения.
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиПрогресс.Видимость     = Ложь;
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиБезПрогресса.Видимость = Истина;
		Элементы.КартинкаАктуализацияРасчетовСКонтрагентами.Картинка            = ПустаяКартинка;

		Элементы.ГруппаЗакрытиеМесяцаПрогресс.Видимость     = Ложь;
		Элементы.ГруппаЗакрытиеМесяцаБезПрогресса.Видимость = Истина;
		Элементы.КартинкаЗакрытиеМесяца.Картинка            = ПустаяКартинка;
	
	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаАктуализацияРасчетовСКонтрагентами() Тогда

		// Перепроведение документов - выполнено.
		Элементы.ГруппаПерепроведениеДокументовПрогресс.Видимость     = Ложь;
		Элементы.ГруппаПерепроведениеДокументовБезПрогресса.Видимость = Истина;
		Элементы.КартинкаПерепроведениеДокументов.Картинка            = БиблиотекаКартинок.ФлажокУзкий;
		
		// Актуализация расчетов с контрагентами - выполняется.
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиПрогресс.Видимость     = Истина;
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиБезПрогресса.Видимость = Ложь;
		
		// Закрытие месяца - ожидает выполнения.
		Элементы.ГруппаЗакрытиеМесяцаПрогресс.Видимость     = Ложь;
		Элементы.ГруппаЗакрытиеМесяцаБезПрогресса.Видимость = Истина;
		Элементы.КартинкаЗакрытиеМесяца.Картинка            = ПустаяКартинка;
		
	ИначеЕсли ИмяЭтапа = ЗакрытиеМесяцаКлиентСервер.ИмяЭтапаЗакрытиеМесяца() Тогда
		
		// Перепроведение документов и актуализация расчетов с контрагентами - выполнены.
		Элементы.ГруппаПерепроведениеДокументовПрогресс.Видимость     = Ложь;
		Элементы.ГруппаПерепроведениеДокументовБезПрогресса.Видимость = Истина;
		Элементы.КартинкаПерепроведениеДокументов.Картинка            = БиблиотекаКартинок.ФлажокУзкий;
		
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиПрогресс.Видимость     = Ложь;
		Элементы.ГруппаАктуализацияРасчетовСКонтрагентамиБезПрогресса.Видимость = Истина;
		Элементы.КартинкаАктуализацияРасчетовСКонтрагентами.Картинка            = БиблиотекаКартинок.ФлажокУзкий;
		
		// Закрытие месяца - выполняется.
		Элементы.ГруппаЗакрытиеМесяцаПрогресс.Видимость     = Истина;
		Элементы.ГруппаЗакрытиеМесяцаБезПрогресса.Видимость = Ложь;

	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МаксимальноеЗначениеПрогресса()

	Возврат 100

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПрогрессаПерепроведенияДокументов(ДатаНачала, ДатаОкончания, ТекущаяДата)
	
	Результат = 0;

	Числитель   = (НачалоДня(ТекущаяДата) - НачалоДня(ДатаНачала)) / 86400 + 1;

	Знаменатель = (НачалоДня(ДатаОкончания) - НачалоДня(ДатаНачала)) / 86400 + 1;
	
	МаксЗначение = МаксимальноеЗначениеПрогресса();
	
	Если Знаменатель <> 0 Тогда
		Результат = Макс(Мин(Цел(Числитель / Знаменатель * МаксЗначение), МаксЗначение), 0);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПрогресса(ВсегоШагов, ВыполненоШагов)

	Результат = 0;

	МаксЗначение = МаксимальноеЗначениеПрогресса();

	Если ВсегоШагов <> 0 Тогда
		Результат = Макс(Мин(Цел(ВыполненоШагов / ВсегоШагов * МаксЗначение), МаксЗначение), 0);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

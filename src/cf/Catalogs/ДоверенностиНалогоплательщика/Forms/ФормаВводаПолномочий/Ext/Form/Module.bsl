﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// определяем возможные полномочия в таблице
	ОпределитьПолномочиеВТаблице("01", НСтр("ru = 'подписывать налоговую декларацию, др. отчетность'"));
	ОпределитьПолномочиеВТаблице("02", НСтр("ru = 'представлять налоговую декларацию, др. отчетность'"));
	ОпределитьПолномочиеВТаблице("03", НСтр("ru = 'получать документы в инспекции ФНС России'"));
	ОпределитьПолномочиеВТаблице("04", НСтр("ru = 'вносить изменения в документы налоговой отчетности'"));
	ОпределитьПолномочиеВТаблице("05", НСтр("ru = 'подписывать документы, используемые при постановке и снятии с учета и сообщении сведений, установленных НК РФ (за исключением документов, используемых при  учете и контроле банковских счетов)'"));
	ОпределитьПолномочиеВТаблице("06", НСтр("ru = 'представлять документы, используемые при постановке и снятии с учета и сообщении сведений, установленных НК РФ (за исключением документов,  используемых при  учете и контроле банковских счетов)'"));
	ОпределитьПолномочиеВТаблице("07", НСтр("ru = 'получать от налогового органа документы, подтверждающие постановку и снятие с учета'"));
	ОпределитьПолномочиеВТаблице("08", НСтр("ru = 'подписывать документы, используемые при  учете и контроле банковских счетов'"));
	ОпределитьПолномочиеВТаблице("09", НСтр("ru = 'представлять документы, используемые при  учете и контроле банковских счетов'"));
	ОпределитьПолномочиеВТаблице("10", НСтр("ru = 'представлять документы по применению специальных налоговых режимов и консолидации учета по обособленным подразделениям'"));
	ОпределитьПолномочиеВТаблице("11", НСтр("ru = 'получать в инспекции ФНС России документы по применению специальных налоговых режимов и консолидации учета по обособленным подразделениям'"));
	ОпределитьПолномочиеВТаблице("12", НСтр("ru = 'подписывать документы по консолидации учета по обособленным подразделениям'"));
	ОпределитьПолномочиеВТаблице("13", НСтр("ru = 'представлять заявления и запросы на проведение сверки расчетов с бюджетом, получение справок о состоянии расчетов с бюджетом'"));
	ОпределитьПолномочиеВТаблице("14", НСтр("ru = 'получать в инспекции ФНС России акты сверок и справки о состоянии расчетов с бюджетом'"));
	ОпределитьПолномочиеВТаблице("15", НСтр("ru = 'подписывать акт сверки расчетов с бюджетом'"));
	ОпределитьПолномочиеВТаблице("16", НСтр("ru = 'подписывать акт и решение налоговой проверки'"));
	ОпределитьПолномочиеВТаблице("17", НСтр("ru = 'подписывать заявление на зачет/возврат налога'"));
	ОпределитьПолномочиеВТаблице("18", НСтр("ru = 'подписывать заявления о ввозе товаров и уплате косвенных налогов'"));
	ОпределитьПолномочиеВТаблице("19", НСтр("ru = 'получать заявления о ввозе товаров и уплате'"));
	ОпределитьПолномочиеВТаблице("20", НСтр("ru = 'подписывать документы по применению специальных налоговых режимов, игорному бизнесу и консолидации учета по обособленным подразделениям'"));
	ОпределитьПолномочиеВТаблице("21", НСтр("ru = 'подписывать документы (информацию)'"));
	ОпределитьПолномочиеВТаблице("22", НСтр("ru = 'представлять документы (информацию)'"));
	
	// расставляем флажки
	ПолныеПолномочия = Параметры.ИсходныеДанныеСтроки.ПризнакПолныеПолномочия;
	Если НЕ ПолныеПолномочия Тогда
		Для Каждого СтрПолномочие Из Полномочия Цикл
			СтрПолномочие.Пометка = Параметры.ИсходныеДанныеСтроки["Признак" + СтрПолномочие.Код];
		КонецЦикла;
	КонецЕсли;
	
	// устанавливаем в исходное значение переключатель "Полные полномочия"
	ПереключательПолныеПолномочия = ?(ПолныеПолномочия, "0", "1");
	
	// инициализируем КПП
	ЭтоПБОЮЛ = НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Параметры.Организация);
	Элементы.КПП.Видимость = НЕ ЭтоПБОЮЛ;
	КПП = Параметры.ИсходныеДанныеСтроки.КПП;
	
	// инициализируем ОКАТО
	ОКАТО = Параметры.ИсходныеДанныеСтроки.ОКАТО;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитПереключательПолныеПолномочияПриИзменении(Элемент)
	
	ПолныеПолномочия = ?(ПереключательПолныеПолномочия = "0", Истина, Ложь);
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого Стр Из Полномочия Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого Стр Из Полномочия Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеОК(Команда)
	
	Если НЕ СохранениеВозможно() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПризнакПолныеПолномочия", ?(ПереключательПолныеПолномочия = "0", Истина, Ложь));
	Результат.Вставить("ОКАТО", СокрЛП(ОКАТО));
	Результат.Вставить("КПП", СокрЛП(КПП));
	Для Каждого Стр Из Полномочия Цикл
		Результат.Вставить("Признак" + Стр.Код, ?(ПереключательПолныеПолномочия = "0", Ложь, Стр.Пометка));
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеЭУ()
	
	Элементы.ГруппаТаблицаПолномочий.Доступность = НЕ ПолныеПолномочия;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьПолномочиеВТаблице(КодПолномочия, НаименованиеПолномочия)
	
	НовСтр = Полномочия.Добавить();
	НовСтр.Код = КодПолномочия;
	НовСтр.Наименование = НаименованиеПолномочия;
	
КонецПроцедуры

&НаКлиенте
Функция СохранениеВозможно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	// проверяем полномочия
	Если ПереключательПолныеПолномочия <> "0" Тогда
		СтрокиИстина = Полномочия.НайтиСтроки(Новый Структура("Пометка", Истина));
		Если СтрокиИстина.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран ни один вид полномочия.'"), , "Полномочия", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// проверяем ОКАТО
	СокрЛПОКАТО = СокрЛП(ОКАТО);
	Если СтрДлина(СокрЛПОКАТО) <> 0 И СтрДлина(СокрЛПОКАТО) <> 11 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Число цифр в ОКАТО должно быть равно 11.'"), , "ОКАТО", , Отказ);
	ИначеЕсли НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛПОКАТО) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'ОКАТО должен состоять только из цифр.'"), , "ОКАТО", , Отказ);
	КонецЕсли;
	
	// проверяем КПП
	Если Элементы.КПП.Видимость Тогда
		СокрЛПКПП = СокрЛП(КПП);
		Если СтрДлина(СокрЛПКПП) <> 0 И СтрДлина(СокрЛПКПП) <> 9 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Число цифр в КПП должно быть равно 9.'"), , "КПП", , Отказ);
		ИначеЕсли НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СокрЛПКПП) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'КПП должен состоять только из цифр.'"), , "КПП", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Возврат НЕ Отказ;
	
КонецФункции

#КонецОбласти

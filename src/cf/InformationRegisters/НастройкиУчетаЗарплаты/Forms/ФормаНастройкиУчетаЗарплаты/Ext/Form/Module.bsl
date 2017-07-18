﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
//

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Организация

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"БухучетЗарплатыОрганизацийПериод", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НеЗаполненноеСубконто);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не выбрана организация>'"));

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		
		Форма.Элементы.РайонныйКоэффициент.Доступность   = Форма.ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент;	
		Форма.Элементы.РайонныйКоэффициентРФ.Доступность = Форма.ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент;	
		
		Если Форма.ЭтоЮрЛицо 
			И Форма.РасчетЗарплатыДляНебольшихОрганизаций Тогда 
			Форма.Элементы.НастройкиРасчетаРезервовОтпусковПредельнаяВеличинаОтчисленийВРезервОтпусков.Доступность = Форма.ФормироватьРезервОтпусков;
			Форма.Элементы.НастройкиРасчетаРезервовОтпусковНормативОтчисленийВРезервОтпусков.Доступность           = Форма.ФормироватьРезервОтпусков;
			Форма.Элементы.ГруппаРезервыОтпусков.Доступность = НЕ Форма.ЭтоОбособленноеПодразделение;
			Форма.Элементы.РезервОтпусковПродолжительность.Доступность                                             = Форма.ФормироватьРезервОтпусков;
		КонецЕсли;
		Форма.Элементы.РезервОтпусковОтражениеВУчете.Доступность = Форма.ФормироватьРезервОтпусков;
		
		Форма.Элементы.СпособРасчетаАванса.Доступность = НЕ Форма.Запись.ИндивидуальныйАванс;
		Форма.Элементы.АвансРазмерГруппа.Доступность   = НЕ Форма.Запись.ИндивидуальныйАванс;
		
	Иначе
		Форма.Элементы.УчетРезерваОтпусков.Доступность = НЕ Форма.ЭтоОбособленноеПодразделение;
		Форма.Элементы.РезервОтпусковОбменДанными.Доступность = Форма.ФормироватьРезервОтпусков;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройки(РеквизитПериод = Неопределено)
	
	Организация = Запись.Организация;
	
	Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		
		Если РеквизитПериод = Неопределено Тогда
			РайонныйКоэффициент        = Организация.РайонныйКоэффициент;
			РайонныйКоэффициентРФ      = Организация.РайонныйКоэффициентРФ;
			
			МенеджерЗаписи = РегистрыСведений.НастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.Прочитать();	
			ЭтаФорма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "ЗарплатаКадрыНастройкиОрганизаций");
			
		КонецЕсли;
		
		Если РеквизитПериод = Неопределено ИЛИ СтрНайти(РеквизитПериод, "БухучетЗарплатыОрганизаций") > 0 Тогда
			Отбор = Новый Структура("Организация", Организация);			
			ЗаписиРегистраСрезПоследних = РегистрыСведений.БухучетЗарплатыОрганизаций.СрезПоследних(?(РеквизитПериод <> Неопределено, ЭтаФорма[РеквизитПериод], Период), Отбор);
			МенеджерЗаписи = РегистрыСведений.БухучетЗарплатыОрганизаций.СоздатьМенеджерЗаписи();	
			МенеджерЗаписи.Организация = Организация;
			Если ЗаписиРегистраСрезПоследних.Количество() <> 0 Тогда
				МенеджерЗаписи.Период = ЗаписиРегистраСрезПоследних[0].Период;
			Иначе
				МенеджерЗаписи.Период = Период;
			КонецЕсли;
			Если РеквизитПериод <> Неопределено Тогда
				БухучетЗарплатыОрганизацийПериод = ЭтаФорма[РеквизитПериод];
			Иначе
				БухучетЗарплатыОрганизацийПериод = МенеджерЗаписи.Период;
			КонецЕсли;
			МенеджерЗаписи.Прочитать();	
			ЭтаФорма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "БухучетЗарплатыОрганизаций");			
		КонецЕсли;
				
		Если РеквизитПериод = Неопределено ИЛИ СтрНайти(РеквизитПериод, "ТерриториальныеУсловияПФР") > 0 Тогда
			Отбор = Новый Структура("СтруктурнаяЕдиница", Организация);
			ЗаписиРегистраСрезПоследних = РегистрыСведений.ТерриториальныеУсловияПФР.СрезПоследних(?(РеквизитПериод <> Неопределено, ЭтаФорма[РеквизитПериод], Период), Отбор);
			МенеджерЗаписи = РегистрыСведений.ТерриториальныеУсловияПФР.СоздатьМенеджерЗаписи();	
			МенеджерЗаписи.СтруктурнаяЕдиница = Организация;
			Если ЗаписиРегистраСрезПоследних.Количество() <> 0 Тогда
				МенеджерЗаписи.Период = ЗаписиРегистраСрезПоследних[0].Период;				
			Иначе
				МенеджерЗаписи.Период = Период;				
			КонецЕсли;
			Если РеквизитПериод <> Неопределено Тогда
				ТерриториальныеУсловияПФРПериод = ЭтаФорма[РеквизитПериод];
			Иначе
				ТерриториальныеУсловияПФРПериод = МенеджерЗаписи.Период;
			КонецЕсли;
			МенеджерЗаписи.Прочитать();	
			ЭтаФорма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "ТерриториальныеУсловияПФР");			
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.НастройкиУчетаПособийСоциальногоСтрахования.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Прочитать();	
		ЭтаФорма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "НастройкиУчетаПособийСоциальногоСтрахования");
		
		ПорядокРасчетаАванса = Запись.ИндивидуальныйАванс;
		РазмерАвансаВПроцентахПоУмолчанию = РасчетЗарплатыФормы.РазмерАвансаВПроцентахПоУмолчанию(Запись.Организация);
		ПрименитьИзменениеРасчетаАванса(ЭтаФорма);
		
	КонецЕсли;
	
	Если РеквизитПериод = Неопределено ИЛИ СтрНайти(РеквизитПериод, "НастройкиРасчетаРезервовОтпусков") > 0 Тогда
		Отбор = Новый Структура("Организация", ГоловнаяОрганизация);
		ЗаписиРегистраСрезПоследних = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СрезПоследних(?(РеквизитПериод <> Неопределено, ЭтаФорма[РеквизитПериод], Период), Отбор);
		МенеджерЗаписи = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = ГоловнаяОрганизация;
		Если ЗаписиРегистраСрезПоследних.Количество() <> 0 Тогда
			МенеджерЗаписи.Период = ЗаписиРегистраСрезПоследних[0].Период;
		Иначе
			МенеджерЗаписи.Период = Период;
		КонецЕсли;
		Если РеквизитПериод <> Неопределено Тогда
			НастройкиРасчетаРезервовОтпусковПериод = ЭтаФорма[РеквизитПериод];
		Иначе
			НастройкиРасчетаРезервовОтпусковПериод = МенеджерЗаписи.Период;
		КонецЕсли;
		МенеджерЗаписи.Прочитать();
		ЭтаФорма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "НастройкиРасчетаРезервовОтпусков");
		
		ЭтаФорма.ФормироватьРезервОтпусков = МенеджерЗаписи.ФормироватьРезервОтпусковБУ
			ИЛИ МенеджерЗаписи.ФормироватьРезервОтпусковНУ;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПараметры(Отказ)
	
	Если ТолькоПросмотр Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтаФорма.Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНастройкиПараметровУчета(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		
		Организация = Запись.Организация;
		
		// особенности записи регистра
		// заполнение сведений для подразделений
		// осуществляется каскадно при записи организации
		МенеджерЗаписи = РегистрыСведений.ТерриториальныеУсловияПФР.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период      = ТерриториальныеУсловияПФРПериод;
		МенеджерЗаписи.СтруктурнаяЕдиница = Организация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, ТерриториальныеУсловияПФР, "ТерриториальныеУсловияПФР") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ТерриториальныеУсловияПФР);
			МенеджерЗаписи.Период      = ТерриториальныеУсловияПФРПериод;
			МенеджерЗаписи.СтруктурнаяЕдиница = Организация;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		ОрганизацияОбъект = Организация.ПолучитьОбъект();
		Попытка
			Если ОрганизацияОбъект.ПрименятьРайонныйКоэффициент <> ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент
				ИЛИ ОрганизацияОбъект.ПрименятьСевернуюНадбавку <> ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку
				ИЛИ ОрганизацияОбъект.ТерриториальныеУсловияПФР <> ТерриториальныеУсловияПФР.ТерриториальныеУсловияПФР 
				ИЛИ ОрганизацияОбъект.РайонныйКоэффициент       <> РайонныйКоэффициент
				ИЛИ ОрганизацияОбъект.РайонныйКоэффициентРФ     <> РайонныйКоэффициентРФ Тогда
				
				ДополнительныеОбработки = Новый Массив;
				
				ОрганизацияОбъект.Заблокировать();
				ОрганизацияОбъект.ТерриториальныеУсловияПФР    = ТерриториальныеУсловияПФР.ТерриториальныеУсловияПФР;
				
				Если ОрганизацияОбъект.ПрименятьРайонныйКоэффициент <> ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент Тогда
					Если ОрганизацияОбъект.ПрименятьРайонныйКоэффициент Тогда
						ДополнительныеОбработки.Добавить("УдалитьРК");
					КонецЕсли;
				КонецЕсли;
				ОрганизацияОбъект.ПрименятьРайонныйКоэффициент = ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент;
				
				Если ОрганизацияОбъект.ПрименятьСевернуюНадбавку <> ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку Тогда
					Если ОрганизацияОбъект.ПрименятьСевернуюНадбавку Тогда
						ДополнительныеОбработки.Добавить("УдалитьСН");
					КонецЕсли;
				КонецЕсли;
				ОрганизацияОбъект.ПрименятьСевернуюНадбавку    = ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку;
				
				ОрганизацияОбъект.РайонныйКоэффициент          = РайонныйКоэффициент;
				ОрганизацияОбъект.РайонныйКоэффициентРФ        = РайонныйКоэффициентРФ;
				ОрганизацияОбъект.Записать();
				
				
				Если ДополнительныеОбработки.Количество() <> 0 Тогда
					ЗарплатаКадрыВызовСервера.ОбработкаДанныхПриЗаписиОрганизации(Организация, ДополнительныеОбработки);
				КонецЕсли;
				
			КонецЕсли;
			
		Исключение
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать объект: '") + ОрганизацияОбъект + Символы.ПС + НСтр("ru='Запись настройки параметров учета зарплаты не выполнена.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);			
			Отказ = Истина;
			Возврат;
		КонецПопытки;
		
		МенеджерЗаписи = РегистрыСведений.НастройкиЗарплатаКадры.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, ЗарплатаКадрыНастройкиОрганизаций, "НастройкиЗарплатаКадры") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ЗарплатаКадрыНастройкиОрганизаций);
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ОтражениеВРегламентированномУчетеНастройкиОрганизаций.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, ОтражениеВРегламентированномУчетеНастройкиОрганизаций, "ОтражениеВРегламентированномУчетеНастройкиОрганизаций") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ОтражениеВРегламентированномУчетеНастройкиОрганизаций);
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.ФормироватьПроводкиВКонцеПериода = Ложь;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.БухучетЗарплатыОрганизаций.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период      = БухучетЗарплатыОрганизацийПериод;
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, БухучетЗарплатыОрганизаций, "БухучетЗарплатыОрганизаций") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, БухучетЗарплатыОрганизаций);
			МенеджерЗаписи.Период      = БухучетЗарплатыОрганизацийПериод;
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
		Если НЕ ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку Тогда
			// сбросим признак для всех подразделений
			СписокСеверныхТерриторий = Справочники.ТерриториальныеУсловияПФР.СписокТерриторийСОсобымиКлиматическимиУсловиями();
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Организация",              Организация);
			Запрос.УстановитьПараметр("Период",                   ТерриториальныеУсловияПФРПериод);
			Запрос.УстановитьПараметр("СписокСеверныхТерриторий", СписокСеверныхТерриторий);
			
			Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТерриториальныеУсловияПФРСрезПоследних.СтруктурнаяЕдиница
			|ИЗ
			|	РегистрСведений.ТерриториальныеУсловияПФР.СрезПоследних(
			|			&Период,
			|			СтруктурнаяЕдиница.Владелец = &Организация
			|				И ТерриториальныеУсловияПФР В (&СписокСеверныхТерриторий)) КАК ТерриториальныеУсловияПФРСрезПоследних";
			
			ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
			ТерриториальныеУсловияПФРПустаяСсылка = Справочники.ТерриториальныеУсловияПФР.ПустаяСсылка();
			Пока ВыборкаЗапроса.Следующий() Цикл
				МенеджерЗаписи = РегистрыСведений.ТерриториальныеУсловияПФР.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Период                    = ТерриториальныеУсловияПФРПериод;
				МенеджерЗаписи.СтруктурнаяЕдиница        = ВыборкаЗапроса.СтруктурнаяЕдиница;
				МенеджерЗаписи.ТерриториальныеУсловияПФР = ТерриториальныеУсловияПФРПустаяСсылка;
				МенеджерЗаписи.Записать();
			КонецЦикла;
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.НастройкиУчетаПособийСоциальногоСтрахования.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, НастройкиУчетаПособийСоциальногоСтрахования, "НастройкиУчетаПособийСоциальногоСтрахования") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, НастройкиУчетаПособийСоциальногоСтрахования);
			МенеджерЗаписи.Организация = Организация;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтоОбособленноеПодразделение Тогда
		МенеджерЗаписи = РегистрыСведений.НастройкиРасчетаРезервовОтпусков.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период      = НастройкиРасчетаРезервовОтпусковПериод;
		МенеджерЗаписи.Организация = ГоловнаяОрганизация;
		МенеджерЗаписи.Прочитать();
		Если ТребуетсяПерезапись(МенеджерЗаписи, НастройкиРасчетаРезервовОтпусков, "НастройкиРасчетаРезервовОтпусков") Тогда
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, НастройкиРасчетаРезервовОтпусков);
			МенеджерЗаписи.Период      = НастройкиРасчетаРезервовОтпусковПериод;
			МенеджерЗаписи.Организация = ГоловнаяОрганизация;
			
			Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
				МенеджерЗаписи.МетодНачисленияРезерваОтпусков = Перечисления.МетодыНачисленияРезервовОтпусков.НормативныйМетод;
				МенеджерЗаписи.ФормироватьРезервОтпусковБУ = ФормироватьРезервОтпусков;
				МенеджерЗаписи.ФормироватьРезервОтпусковНУ = ФормироватьРезервОтпусков;
			Иначе
				МенеджерЗаписи.ФормироватьРезервОтпусковБУ = ФормироватьРезервОтпусков;
			КонецЕсли;
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ТребуетсяПерезапись(НоваяЗапись, ТекущаяЗапись, ИмяРегистра)
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	
	Ресурсы = МетаданныеРегистра.Ресурсы;
	
	Если НЕ МетаданныеРегистра.ПериодичностьРегистраСведений = Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		Если НоваяЗапись.Период <> ТекущаяЗапись.Период Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Ресурс ИЗ Ресурсы Цикл
		
		Если НоваяЗапись[Ресурс.Имя] <> ТекущаяЗапись[Ресурс.Имя] Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура ПроверитьНастройкиПараметровУчета(Отказ)
	
	Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
		
		Если НЕ ЗначениеЗаполнено(БухучетЗарплатыОрганизаций.СпособОтраженияЗарплатыВБухучете) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", "Способ отражения в учете",,,);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "БухучетЗарплатыОрганизацийСпособОтраженияЗарплатыВБухучете",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры	

&НаКлиенте
Процедура ИсторияНажатие(ИмяРегистра)
	
	ПараметрыОтбора = Новый Структура("ГоловнаяОрганизация, Организация, СтруктурнаяЕдиница", Организация, Организация, Организация);
	
	РегистрСведенийФорма = ОткрытьФорму("РегистрСведений." + ИмяРегистра + ".ФормаСписка", Новый Структура("Отбор", ПараметрыОтбора));
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольПараметровНачисленияРезерваОтпусков()

	Если НЕ ФормироватьРезервОтпусков Тогда
		НастройкиРасчетаРезервовОтпусков.НормативОтчисленийВРезервОтпусков = 0;
		НастройкиРасчетаРезервовОтпусков.ПредельнаяВеличинаОтчисленийВРезервОтпусков = 0;
	КонецЕсли;
	
	НастройкиРасчетаРезервовОтпусков.ФормироватьРезервОтпусковБУ = ФормироватьРезервОтпусков;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЮрЛицо(Организация)
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ЭтоЮрЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо")
			= Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Иначе
		ЭтоЮрЛицо = Истина;
	КонецЕсли;
	
	Возврат ЭтоЮрЛицо;
	
КонецФункции

&НаСервере
Процедура ЗарплатаКадрыНастройкиОрганизацийПрименятьСевернуюНадбавкуПриИзмененииНаСервере()
	
	Если НЕ ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку Тогда
		СписокСеверныхТерриторий = Справочники.ТерриториальныеУсловияПФР.СписокТерриторийСОсобымиКлиматическимиУсловиями();
		Если СписокСеверныхТерриторий.НайтиПоЗначению(ТерриториальныеУсловияПФР.ТерриториальныеУсловияПФР) <> Неопределено Тогда
			ТерриториальныеУсловияПФР.ТерриториальныеУсловияПФР = Справочники.ТерриториальныеУсловияПФР.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ
//

&НаКлиенте
Процедура РайонныйКоэффициентПриИзменении(Элемент)
		
	Если РайонныйКоэффициент < 1 Тогда
		РайонныйКоэффициент	= 1;
	ИначеЕсли РайонныйКоэффициент > 3 Тогда
		РайонныйКоэффициент	= 3;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура РайонныйКоэффициентРФПриИзменении(Элемент)
		
	Если РайонныйКоэффициентРФ < 1 Тогда
		РайонныйКоэффициентРФ	= 1;
	ИначеЕсли РайонныйКоэффициентРФ > 3 Тогда
		РайонныйКоэффициентРФ	= 3;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаКадрыНастройкиОрганизацийПрименятьРайонныйКоэффициентПриИзменении(Элемент)
	
	Если НЕ ЭтаФорма.ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент Тогда
		РайонныйКоэффициент   = 1;
		РайонныйКоэффициентРФ = 1;
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокаПриИзменении(Элемент)
	
	РеквизитПериод = Лев(Элемент.Имя, СтрНайти(Элемент.Имя, "Период") + 5);
	ЭтаФорма[РеквизитПериод + "Строка"]= БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(НачалоМесяца(ЭтаФорма[РеквизитПериод]), КонецМесяца(ЭтаФорма[РеквизитПериод]), Истина);
	ПрочитатьНастройки(РеквизитПериод);
		
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РеквизитПериод = Лев(Элемент.Имя, СтрНайти(Элемент.Имя, "Период") + 5);
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(ЭтаФорма[РеквизитПериод]), КонецМесяца(ЭтаФорма[РеквизитПериод]));
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы[Элемент.Имя], , , , ОписаниеОповещения);
					
КонецПроцедуры

&НаКлиенте
Процедура ПериодСтрокаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРасчетаРезервовОтпусковПериодЧислоПриИзменении(Элемент)
	
	Если НастройкиРасчетаРезервовОтпусковПериодЧисло = 0 Тогда
		НастройкиРасчетаРезервовОтпусковПериодЧисло = Год(НастройкиРасчетаРезервовОтпусковПериод);
	Иначе
		НастройкиРасчетаРезервовОтпусковПериод = Дата(НастройкиРасчетаРезервовОтпусковПериодЧисло, 1, 1);
	КонецЕсли;
	ПрочитатьНастройки("НастройкиРасчетаРезервовОтпусковПериод");
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияЗарплатаНажатие(Элемент)
	
	ИсторияНажатие("БухучетЗарплатыОрганизаций");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияТерриториальныеУсловияПФРНажатие(Элемент)
	
	ИсторияНажатие("ТерриториальныеУсловияПФР");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияРезервыОтпусковНажатие(Элемент)
	
	ИсторияНажатие("НастройкиРасчетаРезервовОтпусков");
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаДополнительноТерриториальныеУсловияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура("Вид, Организация, ПрименятьРайонныйКоэффициент, ПрименятьСевернуюНадбавку, Период", "Подразделения", Организация, ЗарплатаКадрыНастройкиОрганизаций.ПрименятьРайонныйКоэффициент, ЗарплатаКадрыНастройкиОрганизаций.ПрименятьСевернуюНадбавку, ТерриториальныеУсловияПФРПериод);
	ОткрытьФорму("РегистрСведений.НастройкиУчетаЗарплаты.Форма.ФормаДополнительныхДанных", ПараметрыФормы,ЭтаФорма);
	
КонецПроцедуры	

&НаКлиенте
Процедура ФормироватьРезервОтпусковПриИзменении(Элемент)
	
	КонтрольПараметровНачисленияРезерваОтпусков();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьРезервОтпусковОбменДаннымиПриИзменении(Элемент)
	
	КонтрольПараметровНачисленияРезерваОтпусков();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаКадрыНастройкиОрганизацийПрименятьСевернуюНадбавкуПриИзменении(Элемент)
	ЗарплатаКадрыНастройкиОрганизацийПрименятьСевернуюНадбавкуПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НастройкаНалоговИОтчетов(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	
	ОткрытьФорму("ОбщаяФорма.НалогиИОтчеты", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокРасчетаАвансаПриИзменении(Элемент)
	
	Запись.ИндивидуальныйАванс = ПорядокРасчетаАванса;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаАвансаПриИзменении(Элемент)
	
	ПрименитьИзменениеРасчетаАванса(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПрименитьИзменениеРасчетаАванса(Форма)
	
	Если Форма.Запись.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа") Тогда
		Форма.Запись.Аванс = Форма.РазмерАвансаВПроцентахПоУмолчанию;
	Иначе
		Форма.Запись.Аванс = 0;
	КонецЕсли;
	
	РасчетЗарплатыКлиентСервер.УстановитьПоказРазмераАванса(Форма, "Запись.СпособРасчетаАванса", "АвансРазмерГруппа", "АвансРазмерность");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаАвансаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период = НачалоМесяца(ТекущаяДатаСеанса());
	
	НадписьНачисляетсяРКиСН  = НСтр("ru = 'В организации или ее подразделениях начисляется:'");
	
	УчетЗарплатыИКадровСредствамиБухгалтерии = ПолучитьФункциональнуюОпцию("УчетЗарплатыИКадровСредствамиБухгалтерии");
	
	ЭтоЮрЛицо                    = ЭтоЮрЛицо(Запись.Организация);
	ЭтоОбособленноеПодразделение = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоОбособленноеПодразделение(Запись.Организация);
	ГоловнаяОрганизация          = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Запись.Организация);
	РасчетЗарплатыДляНебольшихОрганизаций = УчетЗарплаты.РасчетЗарплатыДляНебольшихОрганизаций();
	
	Элементы.ОбменДанными.Видимость  = НЕ УчетЗарплатыИКадровСредствамиБухгалтерии;
	
	Элементы.РезервыОтпусков.Видимость     = ЭтоЮрЛицо;
	Элементы.УчетРезерваОтпусков.Видимость = ЭтоЮрЛицо;
	
	Элементы.ПараметрыРезерваОтпусковПравая.Видимость  = РасчетЗарплатыДляНебольшихОрганизаций;
	Элементы.ПараметрыРезерваОтпусковЛевая.Видимость   = РасчетЗарплатыДляНебольшихОрганизаций;
	Элементы.РезервОтпусковПродолжительность.Видимость = РасчетЗарплатыДляНебольшихОрганизаций;
	
	ПрочитатьНастройки();
	
	Если НЕ УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
				
		Элементы.ГруппаНастройка.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаНастройка.ТекущаяСтраница    = Элементы.ОбменДанными;
		
		Элементы.ИсторияЗарплата.Видимость        = Ложь;
		
	КонецЕсли;	
		
	Элементы.ГиперссылкаДополнительноТерриториальныеУсловия.Видимость = ПолучитьФункциональнуюОпцию("ВестиУчетПоПодразделениям");
	
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ЭтаФорма, "БухучетЗарплатыОрганизацийПериодСтрока", Формат(БухучетЗарплатыОрганизацийПериод, "ДФ='MMMM yyyy'"));
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ЭтаФорма, "ТерриториальныеУсловияПФРПериодСтрока", Формат(ТерриториальныеУсловияПФРПериод, "ДФ='MMMM yyyy'"));
	
	НастройкиРасчетаРезервовОтпусковПериодЧисло = Год(НастройкиРасчетаРезервовОтпусковПериод);
	
	УправлениеФормой(ЭтаФорма);
	УстановитьУсловноеОформление();
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Функциональные опции, влияющие на список КБК
	ПараметрыЗаписи.Вставить("ИзмененныеОпцииПодсистемы", РасчетыСБюджетом.ИзмененныеОпцииПодсистемыУчетаЗарплатыИКадров());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ТолькоПросмотр Тогда
		Отказ = Ложь;
		ЗаписатьПараметры(Отказ);
		Если Отказ Тогда
			Возврат;
		Иначе
			Если УчетЗарплатыИКадровСредствамиБухгалтерии Тогда
				ТекущийОбъект.ИспользоватьФорматОбменаЗУП25 = Ложь;		
			Иначе
				ТекущийОбъект.СписаниеДепонированныхСумм = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ИзмененныеОпцииПодсистемы = РасчетыСБюджетом.ИзмененныеОпцииПодсистемыУчетаЗарплатыИКадров(ПараметрыЗаписи.ИзмененныеОпцииПодсистемы);
	ЕстьИзменения = Ложь;
	Для каждого ОпцияПодсистемы Из ИзмененныеОпцииПодсистемы Цикл
		Если ОпцияПодсистемы.Значение Тогда
			ЕстьИзменения = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ЕстьИзменения Тогда
		Справочники.ВидыНалоговИПлатежейВБюджет.СоздатьПоставляемыеЭлементы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Описание оповещений

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитПериод) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма[РеквизитПериод] = РезультатВыбора.НачалоПериода;
	
КонецПроцедуры

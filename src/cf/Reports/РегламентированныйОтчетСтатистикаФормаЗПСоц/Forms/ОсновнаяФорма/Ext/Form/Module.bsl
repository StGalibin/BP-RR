﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	ОбработкаПериодичностьОтчета(Форма);
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
			
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = Форма.ВидимостьСсылкиИзмененияЗаконодательства И (ГодПериода > 2012);
										
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		Форма.мДатаКонцаПериодаОтчета  = КонецКвартала(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг*3));
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	Иначе
		Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг)); 
		Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ПоказатьПериод(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаПериодичностьОтчета(Форма)
					
	// Периодичность может быть разной.
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Очистить();
	// Сначала заполняем "помесячно".
	ДатаКонца		= КонецКвартала(Форма.мДатаКонцаПериодаОтчета);
	ДатаНачала		= НачалоГода(Форма.мДатаНачалаПериодаОтчета);
	
	ВремДатаКонца	= ДобавитьМесяц(ДатаКонца,-2);
	
	Если Месяц(ВремДатаКонца) = 1 Тогда 
		СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
	Иначе
		СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""") + " - " + Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
	КонецЕсли;
		
	Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
	Если Месяц(ВремДатаКонца) <> 1 Тогда 
		СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
	КонецЕсли;
		
	Пока ВремДатаКонца <> ДатаКонца Цикл
			
		ВремДатаКонца = КонецМесяца(ДобавитьМесяц(ВремДатаКонца,1));
		
		Если Месяц(ВремДатаКонца) = 1 Тогда 
			СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
		Иначе
			СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""") + " - " + Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
		КонецЕсли;
		
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
		
		Если Месяц(ВремДатаКонца) <> 1 Тогда 
			СтрПериодОтчета = Формат(ВремДатаКонца, "ДФ=""ММММ гггг ' г.'""");
			Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчета);
		КонецЕсли;
	КонецЦикла;
		
	// Добавим квартал.
	СтрПериодОтчетаКвартал = ПредставлениеПериода(НачалоДня(ДатаНачала), КонецКвартала(ДатаКонца), "ФП = Истина" );
		
	// Добавим если не совпадает с последним добавленным помесячно периодом.
	Если СтрПериодОтчетаКвартал <> СтрПериодОтчета Тогда
		Форма.Элементы.ПолеВыбораПериодичностиПоказаПериода.СписокВыбора.Добавить(СтрПериодОтчетаКвартал);
	КонецЕсли;
	
	// Присвоим текущее значение.
	Если Форма.ПолеВыбораПериодичность = Форма.ПеречислениеПериодичностьКвартал Тогда
	
		СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина" );
		
	Иначе
		
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = Месяц(Форма.мДатаНачалаПериодаОтчета) Тогда 
			СтрПериодОтчета = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг ' г.'""");
		Иначе
			СтрПериодОтчета = Формат(ДатаНачала, "ДФ=""ММММ гггг ' г.'""") + " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ=""ММММ гггг ' г.'""");
		КонецЕсли;

	КонецЕсли; 
		
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация        = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
		
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию       = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	// Устнавливаем границы периода построения отчета как квартал
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ПеречислениеПериодичностьМесяц   = Перечисления.Периодичность.Месяц;
	ПеречислениеПериодичностьКвартал = Перечисления.Периодичность.Квартал;
	Если НЕ ЗначениеЗаполнено(мПериодичность) ИЛИ НЕ (мПериодичность = ПеречислениеПериодичностьМесяц ИЛИ мПериодичность = ПеречислениеПериодичностьКвартал) Тогда
		мПериодичность = ПеречислениеПериодичностьКвартал;
	КонецЕсли;
	
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Месяц);
	Элементы.ПолеВыбораПериодичность.СписокВыбора.Добавить(Перечисления.Периодичность.Квартал);
	
	ПолеВыбораПериодичность = мПериодичность;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;

	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;

	КонецЕсли;
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "http://v8.1c.ru/lawmonitor/lawchanges.jsp?";
	СпрРеглОтчетов = Справочники.РегламентированныеОтчеты;
	НайденнаяСсылка = СпрРеглОтчетов.НайтиПоРеквизиту("ИсточникОтчета", ИсточникОтчета);
	
	ВидимостьСсылкиИзмененияЗаконодательства = Истина;
	
	Если НайденнаяСсылка = СпрРеглОтчетов.ПустаяСсылка() Тогда
		
	    ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
		ВидимостьСсылкиИзмененияЗаконодательства = Ложь;
		
	Иначе
		
	    УИДОтчета = НайденнаяСсылка.УИДОтчета;
		
		Если Не ПустаяСтрока(УИДОтчета) Тогда
		
			Фильтр1 = "regReportForm=" + УИДОтчета;
			Фильтр2 = "regReportOnly=true";
			УИДКонфигурации = "";
			РегламентированнаяОтчетностьПереопределяемый.ПолучитьУИДКонфигурации(УИДКонфигурации);
			Фильтр3 = "userConfiguration=" + УИДКонфигурации;
			
			ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства +
			                                                Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;	
		Иначе
			
			ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
			ВидимостьСсылкиИзмененияЗаконодательства = Ложь;
			
		КонецЕсли; 
																
	КонецЕсли;
													
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
		
	РегламентированнаяОтчетность.УстановитьОтборВФормеВыбораОтчета(ЭтаФорма);
	
	ИзменитьПериод(ЭтаФорма, 0);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПолеВыбораПериодичностиПоказаПериодаПриИзменении(Элемент)
	
	СтрВыбораПериодичностиПоказаПериода = ПолеВыбораПериодичностиПоказаПериода;
	СтрПериодОтчетаГод = ПредставлениеПериода(НачалоГода(мДатаКонцаПериодаОтчета), КонецГода(мДатаКонцаПериодаОтчета), "ФП = Истина" );
	
	Если (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"КВАРТАЛ") > 1) 
		или  (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"ГОД") > 1) 
		или  (СтрНайти(ВРег(СтрВыбораПериодичностиПоказаПериода),"МЕСЯЦЕВ") > 1) 
		или  (СтрВыбораПериодичностиПоказаПериода = СтрПериодОтчетаГод) Тогда
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал;
		
	Иначе
		
		ПолеВыбораПериодичность = ПеречислениеПериодичностьМесяц;
		
	КонецЕсли;
	
	ДатаНачала = "";
	ДатаКонца  = "";	
	РегламентированнаяОтчетностьКлиент.ПолучитьНачалоКонецПериода(СтрВыбораПериодичностиПоказаПериода, ДатаНачала, ДатаКонца);
	
	Если ПолеВыбораПериодичность = ПеречислениеПериодичностьКвартал Тогда  // ежеквартально
		
		мДатаКонцаПериодаОтчета  = КонецКвартала(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоКвартала(ДатаНачала);
		
	Иначе
		
		мДатаКонцаПериодаОтчета  = КонецМесяца(ДатаКонца);
		мДатаНачалаПериодаОтчета = НачалоМесяца(ДатаНачала);
		
	КонецЕсли;

	мПериодичность = ПолеВыбораПериодичность;
		
	ПоказатьПериод(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	// Ищем в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);	
	
	Если МассивСтрок.Количество() > 0 Тогда
		
	    ВыбраннаяФорма = МассивСтрок[0];
		// Присваиваем.
	    мВыбраннаяФорма		= ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок	= ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ был скопиран. 
		// Проверяем соответствие форм.
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			Возврат;
						
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;

		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());

		Сообщение.Сообщить();
				
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
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
	    // Нет общей части - ничего не делаем.
		Возврат;
	КонецЕсли; 
	
	// Фильтр4 - год.
	Фильтр4 = "currentYear=" + Формат(Год(мДатаКонцаПериодаОтчета),"ЧГ=0");
	
	// Фильтр5 - квартал.
	МесяцКонцаКварталаОтчета = Месяц(КонецКвартала(мДатаКонцаПериодаОтчета));
	КварталОтчета = МесяцКонцаКварталаОтчета/3;
	
	Фильтр5 = "currentQuartal=" + Строка(КварталОтчета);

	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + 
										"&" + Фильтр4 + "&" + Фильтр5;
										
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
	
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
		
			ЭтаФорма.Активизировать();
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

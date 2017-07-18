﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
// Определяет срок представления отчетности в налоговые органы
// в зависимости от выбранного периода.
//
// Возвращаемое значение:
//   Дата
//
Функция ПолучитьСрокПредставленияОтчетности(Форма)

	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	СтрСрокПредставления = "Не позднее ";
	ДатаСрокаПредставления = Дата(ГодПериода + 1, 4, 30); //30 апреля
	СтрСрокПредставления = СтрСрокПредставления + Формат(ДатаСрокаПредставления, "ДФ=""дд ММММ гггг 'года'""") + 
								" (п.5 ст. 227 НК РФ)";
								
	Возврат НСтр("ru='"+СтрСрокПредставления+".'");
	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)

	СтрПериодОтчета = ПредставлениеПериода(НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина" );
		
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	Форма.НадписьСрокПредставленияОтчета = ПолучитьСрокПредставленияОтчетности(Форма);
	
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

	Форма.НадписьКтоСдаетОтчет = НСтр("ru='Только индивидуальные предприниматели и лица, занимающиеся частной практикой (пп. 1, 2 п. 1 ст. 227 НК РФ).'");	
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
	УправлениеФормой(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = Дата(Год(Форма.мДатаКонцаПериодаОтчета) + Шаг, 12, 31, 23, 59, 59);
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Доступность = ЗначениеЗаполнено(Форма.Организация);
	
	Форма.Элементы.ОткрытьФормуОтчета.Доступность = Доступность;
	Форма.Элементы.ГруппаПериод.Доступность = Доступность;
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		
		мДатаКонцаПериодаОтчета  = КонецГода(НачалоГода(ТекущаяДатаСеанса())-1);
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
		
	КонецЕсли;

	мПериодичность = Перечисления.Периодичность.Год;

	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	ИзменитьПериод(ЭтаФорма, 0);

	Если НЕ ЗначениеЗаполнено(Организация) 
	   И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	ОрганизацияСписокВыбора = ЭтаФорма.Элементы.Организация.СписокВыбора;
	СписокФизЛиц = Новый СписокЗначений;
	
	РегламентированнаяОтчетность.ПолучитьСписокДоступныхИндивидуальныхПредпринимателей(СписокФизЛиц);
	
	ОрганизацияПустаяСсылка = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ПустаяСсылка();
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		Организация = ОргПоУмолчанию;
		
		ОрганизацияСписокВыбора.Очистить();
		
		Элементы.НадписьОрганизация.Видимость  =  Ложь;
		
	Иначе
		
		Если СписокФизЛиц.НайтиПоЗначению(Организация) = Неопределено Тогда
			Организация = ОрганизацияПустаяСсылка;
		КонецЕсли;
		
		Для Каждого ЭлементСписка Из СписокФизЛиц Цикл
			
			ОрганизацияСписокВыбора.Добавить(ЭлементСписка.Значение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "http://v8.1c.ru/lawmonitor/lawchanges.jsp?";
	СпрРеглОтчетов = Справочники.РегламентированныеОтчеты;
	НайденнаяСсылка = СпрРеглОтчетов.НайтиПоРеквизиту("ИсточникОтчета", ИсточникОтчета);
	
	Если НайденнаяСсылка = СпрРеглОтчетов.ПустаяСсылка() Тогда
		
	    ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
		
	Иначе
		
	    УИДОтчета = НайденнаяСсылка.УИДОтчета;
		
		Фильтр1 = "regReportForm=" + УИДОтчета;
		Фильтр2 = "regReportOnly=true";
		УИДКонфигурации = "";
		РегламентированнаяОтчетностьПереопределяемый.ПолучитьУИДКонфигурации(УИДКонфигурации);
		Фильтр3 = "userConfiguration=" + УИДКонфигурации;
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства +
		                                                Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;
														
	КонецЕсли; 
													
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
	
	Если СписокФизЛиц.Количество() = 0 Тогда
		
		Организация = ОрганизацияПустаяСсылка;
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		
		Сообщение.Текст = НСтр("ru='Декларацию 3-НДФЛ представляют только индивидуальные предприниматели и лица, занимающиеся частной практикой (пп. 1, 2 п. 1 ст. 227 НК РФ).
			|В справочнике ""Организации"" сведения об индивидуальных предпринимателях отсутствуют.'");
			
		Сообщение.Сообщить();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

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
		Если ВРег(мВыбраннаяФорма) <> ВРег(мСкопированаФорма) Тогда
			
			ПоказатьПредупреждение(,НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			Возврат;

		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		
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
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417", РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ДопТекстОписания = НСтр("ru='Декларацию 3-НДФЛ представляют только индивидуальные предприниматели и лица, занимающиеся частной практикой (пп. 1, 2 п. 1 ст. 227 НК РФ).'");
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения, ДопТекстОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
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
	
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + "&" + Фильтр4;
										
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

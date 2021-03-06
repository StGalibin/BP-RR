﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", 
		"Объект.Организация",
		"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.РеестрСоставил = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ответственный, "ФизическоеЛицо");
		
		ПриПолученииДанныхНаСервере("Объект");
		
		ОрганизацияПриИзмененииНаСервере();
		
		Объект.СтатусДокумента = Перечисления.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе; 
		
	КонецЕсли;
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодПричиныНетрудоспособности(Элементы.КодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодПричиныНетрудоспособности(Элементы.ВторойКодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораДополнительныйКодПричиныНетрудоспособности(Элементы.ДополнительныйКодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодНарушенияРежима(Элементы.КодНарушенияРежима);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораГруппаИнвалидности(Элементы.ГруппаИнвалидности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораИное(Элементы.НовыйСтатусНетрудоспособного);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод1);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод2);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод3);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораТипРодственнойСвязи(Элементы.ПоУходуРодственнаяСвязь1);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораТипРодственнойСвязи(Элементы.ПоУходуРодственнаяСвязь2);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ФСС");
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("ЗаписьДокумента", Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// До проверки объекта создаем его, дозаполняем и сами проверяем.
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	Отказ = Отказ Или Не ТекущийОбъект.ПроверитьЗаполнение();
	ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
	Если Отказ Тогда
		ОбработатьСообщенияПользователю();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДокументБольничныйЛистПослеЗаписи" Тогда
		СтрокиСИзменившимсяБольничным = Объект.СведенияНеобходимыеДляНазначенияПособий.НайтиСтроки(Новый Структура("ПервичныйДокумент", Параметр.Ссылка));
		Если СтрокиСИзменившимсяБольничным.Количество() > 0 Тогда
			
			МассивДокументов = Новый Массив;
			
			Для каждого СтрокаСИзменившимсяБольничным Из СтрокиСИзменившимсяБольничным Цикл
			    МассивДокументов.Добавить(СтрокаСИзменившимсяБольничным.Заявление);
			КонецЦикла;
			
			ОбновитьВторичныеДанныеДокумента(Ложь, Истина, МассивДокументов);	
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВидПособияПриИзменении(Элемент)
	УстановитьСтраницы(Элементы, Объект.ВидРеестра);
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СведенияНеобходимыеДляНазначенияПособий

&НаКлиенте
Процедура СведенияНеобходимыеДляНазначенияПособийПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьИзмененияДанныхТекущейСтроки(Элементы.СведенияНеобходимыеДляНазначенияПособий.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СведенияНеобходимыеДляНазначенияПособийЗаявлениеПриИзменении(Элемент)
	ЗаполнитьСтрокуСведений(Элементы.СведенияНеобходимыеДляНазначенияПособий.ТекущаяСтрока); 	
КонецПроцедуры

&НаКлиенте
Процедура СведенияНеобходимыеДляНазначенияПособийПослеУдаления(Элемент)
	СведенияНеобходимыеДляНазначенияПособийПослеУдаленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СведенияНеобходимыеДляНазначенияПособийПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	СведенияНеобходимыеДляНазначенияПособийПриОкончанииРедактированияНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура МедицинскаяОрганизацияПриИзменении(Элемент)
	Идентификатор = ЭтаФорма.Элементы["СведенияНеобходимыеДляНазначенияПособий"].ТекущаяСтрока;

	МедицинскаяОрганизацияПриИзмененииНаСервере(Идентификатор);
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, "МедицинскаяОрганизация", 				Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, "НаименованиеМедицинскойОрганизации", 	Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, "АдресМедицинскойОрганизации", 		Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, "ОГРНМедицинскойОрганизации", 			Идентификатор);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Заполнить(Команда)
	Если Не ЗначениеЗаполнено(Объект.ВидРеестра) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан вид реестра.'"), ,"ВидРеестра","Объект");
		Возврат;
	КонецЕсли;
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайл(Команда)
	ЗаписатьФайлДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда) 
	ОтменитьВсеИсправленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВторичныеДанные(Команда)
	ОбновитьВторичныеДанныеДокумента();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормой

&НаСервере
Процедура МедицинскаяОрганизацияПриИзмененииНаСервере(ИдентификаторСтроки)
	
	ТекущееЗаявление = Объект.СведенияНеобходимыеДляНазначенияПособий.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если ТекущееЗаявление = Неопределено Тогда
	    Возврат;
	КонецЕсли;

	ЗначенияРеквизитовМедицинскойОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущееЗаявление.МедицинскаяОрганизация, "Наименование,ОГРН,Адрес");
	ТекущееЗаявление.НаименованиеМедицинскойОрганизации = ЗначенияРеквизитовМедицинскойОрганизации.Наименование;
	ТекущееЗаявление.АдресМедицинскойОрганизации = ЗначенияРеквизитовМедицинскойОрганизации.Адрес;
	ТекущееЗаявление.ОГРНМедицинскойОрганизации = ЗначенияРеквизитовМедицинскойОрганизации.ОГРН;
	
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ОбъектЗафиксирован();
	
КонецФункции 

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтаФорма, "Организация");
	ОбновитьВторичныеДанныеДокумента(Истина, Ложь);
	ФиксацияОбновитьФиксациюВФорме();
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтаФорма, "ФСС");
КонецПроцедуры

&НаСервере
Процедура СведенияНеобходимыеДляНазначенияПособийПриОкончанииРедактированияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура СведенияНеобходимыеДляНазначенияПособийПослеУдаленияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ДополнитьФорму()
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтаФорма);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	УстановитьСтраницы(Элементы, Объект.ВидРеестра);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницы(Элементы, ВидРеестра)
	
	Если ВидРеестра = ПредопределенноеЗначение("Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ЕдиновременныеПособияПриРожденииРебенка") Тогда
		Элементы.СтраницыДанныеСтроки.ТекущаяСтраница = Элементы.СтраницыДанныеСтроки.ПодчиненныеЭлементы.СтраницаЕдиновременноеПриРождении;
		Элементы.СведенияНеобходимыеДляНазначенияПособийПервичныйДокумент.Видимость = Ложь;
	ИначеЕсли ВидРеестра = ПредопределенноеЗначение("Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПособияВставшимНаУчетВРанниеСроки") Тогда
		Элементы.СтраницыДанныеСтроки.ТекущаяСтраница = Элементы.СтраницыДанныеСтроки.ПодчиненныеЭлементы.СтраницаПособияВставшимНаУчетВРанниеСроки;
		Элементы.СведенияНеобходимыеДляНазначенияПособийПервичныйДокумент.Видимость = Ложь;
	ИначеЕсли ВидРеестра = ПредопределенноеЗначение("Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПособияПоНетрудоспособности") Тогда
		Элементы.СтраницыДанныеСтроки.ТекущаяСтраница = Элементы.СтраницыДанныеСтроки.ПодчиненныеЭлементы.СтраницаНетрудоспособность;
		Элементы.СведенияНеобходимыеДляНазначенияПособийПервичныйДокумент.Видимость = Истина;
	ИначеЕсли ВидРеестра = ПредопределенноеЗначение("Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ЕжемесячныеПособияПоУходуЗаРебенком") Тогда
		Элементы.СтраницыДанныеСтроки.ТекущаяСтраница = Элементы.СтраницыДанныеСтроки.ПодчиненныеЭлементы.СтраницаЕжемесячноеПособиеПоУходуЗаРебенком;
		Элементы.СведенияНеобходимыеДляНазначенияПособийПервичныйДокумент.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИменаРеквизитовСтрокиНаФорме()
	СписокРеквизитов = Новый СписокЗначений;
	СписокРеквизитов.Добавить("НомерЛисткаНетрудоспособности");
	СписокРеквизитов.Добавить("НомерПервичногоЛисткаНетрудоспособности");
	СписокРеквизитов.Добавить("ДатаВыдачиЛисткаНетрудоспособности");
	СписокРеквизитов.Добавить("ЯвляетсяПервичнымЛисткомНетрудоспособности");
	СписокРеквизитов.Добавить("ПредоставленДубликатЛисткаНетрудоспособности");
	СписокРеквизитов.Добавить("ДатаВыдачиЛисткаНетрудоспособности");
	СписокРеквизитов.Добавить("МедицинскаяОрганизация");
	СписокРеквизитов.Добавить("АдресМедицинскойОрганизации");
	СписокРеквизитов.Добавить("ОГРНМедицинскойОрганизации");
	СписокРеквизитов.Добавить("НомерЛисткаПоОсновномуМестуРаботы");
	СписокРеквизитов.Добавить("ДатаИзмененияКодаПричиныНетрудоспособности");
	СписокРеквизитов.Добавить("ДатаОкончанияПутевки");
	СписокРеквизитов.Добавить("НомерПутевки");
	СписокРеквизитов.Добавить("ОГРН_Санатория");
	СписокРеквизитов.Добавить("КодПричиныНетрудоспособности");
	СписокРеквизитов.Добавить("ДополнительныйКодПричиныНетрудоспособности");
	СписокРеквизитов.Добавить("ВторойКодПричиныНетрудоспособности");
	СписокРеквизитов.Добавить("ПоУходуВозрастЛет1");
	СписокРеквизитов.Добавить("ПоУходуВозрастМесяцев1");
	СписокРеквизитов.Добавить("ПоУходуРодственнаяСвязь1");
	СписокРеквизитов.Добавить("ПоУходуФИО1");
	СписокРеквизитов.Добавить("ПоУходуИспользованоДней1");
	СписокРеквизитов.Добавить("ПоУходуВозрастЛет2");
	СписокРеквизитов.Добавить("ПоУходуВозрастМесяцев2");
	СписокРеквизитов.Добавить("ПоУходуРодственнаяСвязь2");
	СписокРеквизитов.Добавить("ПоУходуФИО2");
	СписокРеквизитов.Добавить("ПоУходуИспользованоДней2");
	СписокРеквизитов.Добавить("ПоставленаНаУчетВРанниеСрокиБеременности");
	СписокРеквизитов.Добавить("КодНарушенияРежима");
	СписокРеквизитов.Добавить("ДатаНарушенияРежима");
	СписокРеквизитов.Добавить("ПериодНахожденияВСтационареСРебенкомС");
	СписокРеквизитов.Добавить("ПериодНахожденияВСтационареСРебенкомПо");
	СписокРеквизитов.Добавить("ДатаНаправленияВБюроМСЭ");
	СписокРеквизитов.Добавить("ДатаРегистрацииДокументовМСЭ");
	СписокРеквизитов.Добавить("ДатаОсвидетельствованияМСЭ");
	СписокРеквизитов.Добавить("ОсвобождениеДатаНачала1");
	СписокРеквизитов.Добавить("ОсвобождениеДатаОкончания1");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрача1");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрача1");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрача1");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрачаПредседателяВК1");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрачаПредседателяВК1");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрачаПредседателяВК1");
	СписокРеквизитов.Добавить("ОсвобождениеДатаНачала2");
	СписокРеквизитов.Добавить("ОсвобождениеДатаОкончания2");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрача2");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрача2");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрача2");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрачаПредседателяВК2");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрачаПредседателяВК2");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрачаПредседателяВК2");
	СписокРеквизитов.Добавить("ОсвобождениеДатаНачала3");
	СписокРеквизитов.Добавить("ОсвобождениеДатаОкончания3");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрача3");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрача3");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрача3");
	СписокРеквизитов.Добавить("ОсвобождениеФИОВрачаПредседателяВК3");
	СписокРеквизитов.Добавить("ОсвобождениеДолжностьВрачаПредседателяВК3");
	СписокРеквизитов.Добавить("ОсвобождениеИдентификационныйНомерВрачаПредседателяВК3");
	СписокРеквизитов.Добавить("ПриступитьКРаботеС");
	СписокРеквизитов.Добавить("ДатаНовыйСтатусНетрудоспособного");
	СписокРеквизитов.Добавить("НовыйСтатусНетрудоспособного");
	СписокРеквизитов.Добавить("НомерЛисткаПродолжения");
	СписокРеквизитов.Добавить("УсловияИсчисленияКод1");
	СписокРеквизитов.Добавить("УсловияИсчисленияКод2");
	СписокРеквизитов.Добавить("УсловияИсчисленияКод3");
	СписокРеквизитов.Добавить("ДатаАктаН1");
	СписокРеквизитов.Добавить("ДатаНачалаРаботы");
	СписокРеквизитов.Добавить("ОчередностьРожденияРебенка");
	СписокРеквизитов.Добавить("ОдновременныйУходЗаНесколькимиДетьми");
	СписокРеквизитов.Добавить("ДатаРожденияРебенка");
	СписокРеквизитов.Добавить("ВидПодтверждающегоДокумента");
	СписокРеквизитов.Добавить("НаименованиеПодтверждающегоДокумента");
	СписокРеквизитов.Добавить("ДатаДокумента");
	СписокРеквизитов.Добавить("СерияДокумента");
	СписокРеквизитов.Добавить("НомерДокумента");
	СписокРеквизитов.Добавить("НаличиеРешенияСудаОЛишенииПрав");
	СписокРеквизитов.Добавить("ФамилияРебенка");
	СписокРеквизитов.Добавить("ИмяРебенка");
	СписокРеквизитов.Добавить("ОтчествоРебенка");
	
	Возврат СписокРеквизитов
КонецФункции

&НаСервере
Процедура УстановитьДоступностьИзмененияДанныхТекущейСтроки(ИдентификаторСтроки)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменениеЗапрещено = Истина;
	
	ТекущееЗаявление = Объект.СведенияНеобходимыеДляНазначенияПособий.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если НЕ ТекущееЗаявление = Неопределено Тогда
		ИзменениеЗапрещено = ЗначениеЗаполнено(ТекущееЗаявление.ПервичныйДокумент);
	КонецЕсли;
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.УстановитьДоступностьИзмененияДанныхСтрокиРеестраСведений(ЭтотОбъект, ИзменениеЗапрещено);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю()
	
	// Перед записью переадресуем сообщения с полей объекта на поля формы.
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "].Заявление") > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НачалоНомераСтроки = СтрНайти(Сообщение.Поле, "[");
		ОкончаниеНомераСтроки = СтрНайти(Сообщение.Поле, "]");
		Если НачалоНомераСтроки > 0  
			И ОкончаниеНомераСтроки > 0 Тогда
			НачалоНомераСтроки = НачалоНомераСтроки + 1;
			НомерСтроки = Сред(Сообщение.Поле, НачалоНомераСтроки, ОкончаниеНомераСтроки - НачалоНомераСтроки); 	
			ПервичныйДокумент = Объект.СведенияНеобходимыеДляНазначенияПособий[Число(НомерСтроки)].ПервичныйДокумент;
			Если ЗначениеЗаполнено(ПервичныйДокумент) Тогда
				Сообщение.КлючДанных = ПервичныйДокумент;
				Сообщение.Поле = Прав(Сообщение.Поле, СтрДлина(Сообщение.Поле) - (ОкончаниеНомераСтроки + 1));
				Сообщение.ПутьКДанным = "Объект";
			Иначе
				Сообщение.Поле = Лев(Сообщение.Поле, СтрНайти(Сообщение.Поле, "]")) + ".Заявление";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтаФорма, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"]));
	ДополнитьФорму();
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокумент()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьДокумент();
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтаФорма);
	 	
КонецПроцедуры

&НаСервере
Функция ДанныеСтроки(Ссылка)
	
	Документ = РеквизитФормыВЗначение("Объект");
	
	Возврат Документ.СведенияПервичногоДокументаНеобходимыеДляНазначенияИВыплатыПособий(Ссылка);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтрокуСведений(Идентификатор)
	ТекущаяСтрока = Объект.СведенияНеобходимыеДляНазначенияПособий.НайтиПоИдентификатору(Идентификатор);
	
	СписокРеквизитов = ИменаРеквизитовСтрокиНаФорме();
	Для каждого Реквизит Из СписокРеквизитов Цикл
		ТекущаяСтрока[Реквизит.Значение] = Неопределено
	КонецЦикла; 
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.Заявление) Тогда 
		ДанныеСтроки = ДанныеСтроки(ТекущаяСтрока.Заявление);
		Если ЗначениеЗаполнено(ДанныеСтроки) Тогда
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеСтроки);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти  

#Область РаботаСXML

&НаКлиенте
Процедура ПоказатьФайл(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат
	КонецЕсли;

	СтруктураПараметровЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись);	
	Если Не Записать(СтруктураПараметровЗаписи) Тогда
		Возврат;
	КонецЕсли;

	ЕстьОшибки = Ложь;
	ТекстФайла = ТекстФайлаНаСервере(Объект.Ссылка, ЕстьОшибки);
	Если ЕстьОшибки Тогда
		Возврат;
	КонецЕсли;	 
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстФайла); 
	ТекстовыйДокумент.Показать(, Нстр("ru = 'Файл сведений'"));
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстФайлаНаСервере(Ссылка, ЕстьОшибки)
	Возврат ОписаниеФайлаНаСервере(Ссылка, ЕстьОшибки).ТекстФайла;
КонецФункции

&НаСервереБезКонтекста
Функция ОписаниеФайлаНаСервере(Ссылка, Отказ)
	Возврат Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПолучитьОписаниеФайла(Ссылка, Отказ);
КонецФункции

// Записывает файл сведений документа в каталог, указанный пользователем.
&НаКлиенте
Процедура ЗаписатьФайлДокумента()
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат
	КонецЕсли;
	
	СтруктураПараметровЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись);	
	Если Не Записать(СтруктураПараметровЗаписи) Тогда
		Возврат;
	КонецЕсли;

	Отказ = Ложь;
	
	УчетПособийСоциальногоСтрахованияКлиент.ВыгрузитьДокументОтчетности(Объект.Ссылка);
	
КонецПроцедуры	

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.СведенияНеобходимыеДляНазначенияПособий");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "ВидПособия",	Нстр("ru = 'вида реестра'")));
	Возврат Массив
КонецФункции

#КонецОбласти 

#Область МеханизмФиксацииИзменений

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	ОписаниеЭлементаФормы.ПрефиксПутиТекущиеДанные = "Элементы.СведенияНеобходимыеДляНазначенияПособий.ТекущиеДанные";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	ОписаниеФормы.Вставить("ФормаРедактируетсяПослеФиксации", Ложь);
	Возврат ОписаниеФормы;
КонецФункции

&НаСервере
Функция ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(ПараметрыФиксацииВторичныхДанных)
		
	ИсключаемыеЭлементы = Новый Массив;
	ИсключаемыеЭлементы.Добавить("СведенияНеобходимыеДляНазначенияПособийМедицинскаяОрганизация");
	
	ОписаниеЭлементов = Новый Соответствие;
	Для каждого Описание Из ПараметрыФиксацииВторичныхДанных.ОписаниеФиксацииРеквизитов Цикл
		Если ИсключаемыеЭлементы.Найти(Описание.Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеЭлементов.Вставить(Описание.Значение.ИмяРеквизита, Описание.Значение.ИмяРеквизита);
		
	КонецЦикла;
	
	Возврат ОписаниеЭлементов;
	
КонецФункции

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	
	ОписанияТЧ = Форма["ПараметрыФиксацииВторичныхДанных"]["ОписанияТЧ"];
	
	Для каждого ОписаниеТЧ Из ОписанияТЧ Цикл
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыФиксТЧ(Форма.Объект[ОписаниеТЧ.Ключ]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеОПособиях = Истина, МассивПервичныхДокументов = Неопределено)
	
	Если ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	ДокументОбъект = ФиксацияПодготовленныйДокумент();
	
	ДокументОбъект.ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации, ДанныеОПособиях, МассивПервичныхДокументов);
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтаФорма, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеДокумента();
	ФиксацияОбновитьФиксациюВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	
	ЭлементыШапки = Новый Массив;
	ЭлементыШапки.Добавить(Элементы.РегистрационныйНомерФСС);
	ЭлементыШапки.Добавить(Элементы.ДополнительныйКодФСС);
	ЭлементыШапки.Добавить(Элементы.КодПодчиненностиФСС);
	ЭлементыШапки.Добавить(Элементы.ИНН);
	ЭлементыШапки.Добавить(Элементы.КПП);
	ЭлементыШапки.Добавить(Элементы.ОГРН);
	ЭлементыШапки.Добавить(Элементы.Руководитель);
	ЭлементыШапки.Добавить(Элементы.ДолжностьРуководителя);
	ЭлементыШапки.Добавить(Элементы.ГлавныйБухгалтер);
		
	Если ЭлементыШапки.Найти(Элемент) = Неопределено Тогда
		ТекущаяСтрока = ЭтаФорма.Элементы["СведенияНеобходимыеДляНазначенияПособий"].ТекущаяСтрока;
	Иначе	                                                                                                     
		ТекущаяСтрока = 0;
	КонецЕсли;

	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтаФорма, Элемент, ФиксацияЭлементыОбработчикаЗафиксироватьИзменение(ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"]), ТекущаяСтрока);
КонецПроцедуры
	
#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// ОТПРАВКА ОТЧЕТА В ФСС

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтаФорма, "ФСС");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтаФорма, "ФСС");
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, "ФСС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, "ФСС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, "ФСС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, "ФСС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, "ФСС");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

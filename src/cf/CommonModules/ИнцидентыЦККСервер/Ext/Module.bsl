﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "ПодсистемыЦККВМоделиСервиса".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс     

// Создает структуру описания типа инцидента, которую требуется заполнить и передать функции СоздатьЗаписьТипа.
//
// Параметры:
//  ИмяТипа	 - Строка - Имя типа инцидента. Имя должно быть уникальным, например: Конфигурация1.ПОдсистема1.Инцидент1.
// 
// Возвращаемое значение:
//   - Структура - поля структуры:
// 		- ТипИнцидента (строка): имя типа
//		- УровеньИнцидента (строка): "Информация", "Предупреждение" (по умолчанию), "Ошибка", "КритическаяОшибка"
//		- Подсистема (строка): подсистема с точки зрения ЦКК
//		- КонтекстИнформационнойБазы (булево): определять контекст подключения. По умолчанию нет.
//		- ПроцедураПроверки (строка): имя процедуры, которая будет вызываться периодически, если есть открытые инциденты указанного типа для проверки
//			их актуальности. Если указано "Авто", будет использована проверка по полю "Актуален" из регистра открытых инцидентов
//		- МинутМеждуИнцидентами (число): ограничивать частоту отсылки инцидентов. По умолчанию 0: не ограничивать
//		- Теги (структура) с булевыми полями Оборудование, Доступность, Производительность, ПрикладнаяОшибка и строкой Дополнительные. В строку можно
//			разместить произвольные теги, разделенные пробелом.
Функция СоздатьОписаниеТипаИнцидента(ИмяТипа) Экспорт
	Описание = Новый Структура();
	Описание.Вставить("ТипИнцидента", ИмяТипа);
	Описание.Вставить("УровеньИнцидента", "Предупреждение");
	Описание.Вставить("Подсистема", "");
	Описание.Вставить("КонтекстИнформационнойБазы", Ложь);
	Описание.Вставить("ПроцедураПроверки", "");
	Описание.Вставить("МинутМеждуИнцидентами", 0);
	Описание.Вставить("Теги", Новый Структура("Оборудование,Доступность,Производительность,ПрикладнаяОшибка,Дополнительные", Ложь, Ложь, Ложь, Ложь, ""));
	Возврат Описание;
КонецФункции

// Создает запись типа инцидента и помещает ее в словарь. Если в словаре тип уже зарегистрирован, он будет перезаписан.
//
// Параметры:
//  СловарьТипов	- Соответствие - Ключ: имя типа инцидента, Значение: структура с описанием типа (создается)
//	Описание		- Структура - см. СоздатьОписаниеТипаИнцидента.
Процедура СоздатьЗаписьТипа(Знач СловарьТипов, Знач Описание) Экспорт

	Если ТипЗнч(СловарьТипов)<>Тип("Соответствие") Тогда		
		ВызватьИсключение НСтр("ru = 'Параметр СловарьТипов должен иметь тип Соответствие.'");
	КонецЕсли;
	
	Если ТипЗнч(Описание)<>Тип("Структура") Тогда		
		ВызватьИсключение НСтр("ru = 'Параметр Описание должен иметь тип Структура.'");
	КонецЕсли;
	
	Теги = ТегиВСтроку(
		Описание.Теги.Оборудование, 
		Описание.Теги.Доступность, 
		Описание.Теги.Производительность, 
		Описание.Теги.ПрикладнаяОшибка, 
		Описание.Теги.Дополнительные);
	
	Если ПустаяСтрока(Описание.ТипИнцидента) Тогда
		ВызватьИсключение НСтр("ru = 'ТипИнцидента не указан'");
	КонецЕсли;
	
	УровеньИнцидента = Описание.УровеньИнцидента;
	Если УровеньИнцидента<>"Информация" И 
		УровеньИнцидента<>"Предупреждение" И 
		УровеньИнцидента<>"Ошибка" И 
		УровеньИнцидента<>"КритическаяОшибка" Тогда
		ВызватьИсключение НСтр("ru = 'Неверное значение уровня инцидента'");
	КонецЕсли;
	
	Запись = Новый Структура(
		"УровеньИнцидента,Подсистема,Теги,ПроцедураПроверки,КонтекстИнформационнойБазы,МинутМеждуИнцидентами",
		УровеньИнцидента,
		Описание.Подсистема,
		Теги,
		Описание.ПроцедураПроверки, 
		Описание.КонтекстИнформационнойБазы,
		Описание.МинутМеждуИнцидентами);
	
	СловарьТипов[Описание.ТипИнцидента] = Запись;
	
КонецПроцедуры

// Регистрирует инциденты в ЦКК. Требуется ее вызвать по факту установки не-пустых значений констант доступа к внешнему ЦКК.
// Параметр нужен для отложенного способа вызова обработчиков ИБ.

// Регистрирует типы инцидентов в ИБ.
//
// Параметры:
//  ПараметрыОбработчика - Структура, параметры обработчика.
//
Процедура ЗарегистрироватьТипыИнцидентовВЦКК(ПараметрыОбработчика = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(Константы.АдресЦКК.Получить()) ИЛИ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	
	СписокТипов = Новый Соответствие();
	ИнцидентыЦККПереопределяемый.СписокТиповИнцидентовПереопределяемый(СписокТипов);
	Для Каждого ТекТип из СписокТипов Цикл
		
		Запись = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Incidents/1_0_1_1", "IncidentType"));
		Запись.Type			= ТекТип.Ключ;
		Запись.Level		= ТекТип.Значение.УровеньИнцидента;
		Запись.SubSystem	= ТекТип.Значение.Подсистема;
		Запись.Tags			= ТекТип.Значение.Теги;
		
		ВыполнитьЗапрос("DefineType", Запись);
		
	КонецЦикла;
	
	// При смене или первичном указании адреса ЦКК очистим буферные регистры
	
	НаборЗаписей = РегистрыСведений.ИнцидентыОграничениеСкоростиОтсылки.СоздатьНаборЗаписей();
	НаборЗаписей.Записать(Истина);
	
	НаборЗаписей = РегистрыСведений.ИнцидентыОткрытые.СоздатьНаборЗаписей();
	НаборЗаписей.Записать(Истина);
	
	НаборЗаписей = РегистрыСведений.ИнцидентыОтложенныеПроверки.СоздатьНаборЗаписей();
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

// Открывает инцидент. Если адрес ЦКК не указан, ничего не делает. Если инцидент отсылается чаще 
// указанных в типе ограничений, такая отсылка будет проигнорирована без вызова исключений. 
// Если указано Асинхронно=Истина, то метод будет выполнен с помощью менеджера фоновых заданий.
//
// Параметры:
//  ТипИнцидента		- Строка - Идентификатор типа инцидента. Должен быть среди зарегистрированных типов.
//  КодИнцидента		- Строка - Строковый идентификатор инцидента. Должен быть уникален внутри типа. Если повторяется, считается, что инцидент еще раз и счетчик срабатываний его в ЦКК увеличится.
//  ТекстСообщения		- Строка - текст сообщения инцидента
//  ИнформационнаяБаза	- Строка - контекст информационной базы для инцидента
//  Кластер				- Строка - контекст кластера для инцидента.
//
Процедура ОткрытьИнцидент(Знач ТипИнцидента, Знач КодИнцидента, Знач ТекстСообщения, Знач Асинхронно = Ложь) Экспорт
	
	Если ПустаяСтрока(ТипИнцидента) Тогда	
		ВызватьИсключение НСтр("ru = 'Не указан тип инцидента'"); 
	КонецЕсли;
	Если ПустаяСтрока(КодИнцидента) Тогда	
		ВызватьИсключение НСтр("ru = 'Не указан код инцидента'"); 
	КонецЕсли;
	Если ПустаяСтрока(ТекстСообщения) Тогда	
		ВызватьИсключение НСтр("ru = 'Не указано сообщение инцидента'"); 
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина); 
	
	Если ПустаяСтрока(Константы.АдресЦКК.Получить()) ИЛИ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда	
		Возврат; 
	КонецЕсли;
	
	Если Асинхронно Тогда
		Параметры = Новый Массив();
		Параметры.Добавить(ТипИнцидента);
		Параметры.Добавить(КодИнцидента);
		Параметры.Добавить(ТекстСообщения);
		Параметры.Добавить(Ложь);
		ФоновыеЗадания.Выполнить("ИнцидентыЦККСервер.ОткрытьИнцидент", Параметры);
		Возврат;
	КонецЕсли;
	
	СписокТипов = Новый Соответствие();
	ИнцидентыЦККПереопределяемый.СписокТиповИнцидентовПереопределяемый(СписокТипов);
	Для Каждого ТекТип из СписокТипов Цикл
		Если ТекТип.Ключ = ТипИнцидента Тогда
			
			Если ТекТип.Значение.МинутМеждуИнцидентами > 0 Тогда
				
				ЗаписьИОСО = РегистрыСведений.ИнцидентыОграничениеСкоростиОтсылки.СоздатьМенеджерЗаписи();
				ЗаписьИОСО.ТипИнцидента = ТипИнцидента;
				ЗаписьИОСО.Прочитать();
				Если ЗаписьИОСО.Выбран() Тогда
					Если ТекущаяДатаСеанса() < ЗаписьИОСО.ПоследняяОтсылка + (ТекТип.МинутМеждуИнцидентами * 60) Тогда
						Возврат; //предотвращаем более частую отсылку, чем указано в типе инцидента
					КонецЕсли;
				КонецЕсли;
				ЗаписьИОСО.ПоследняяОтсылка = ТекущаяДатаСеанса();
				ЗаписьИОСО.Записать(Истина);
				
			КонецЕсли;
			
			Инцидент = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Incidents/1_0_1_1", "Incident"));
			Инцидент.Type		= ТипИнцидента;
			Инцидент.Id 		= КодИнцидента;
			Инцидент.Message	= ТекстСообщения;
			Инцидент.Count		= 1;
			Инцидент.Infobase	= "";
			Инцидент.Cluster	= "";
			
			Если ТекТип.Значение.КонтекстИнформационнойБазы Тогда
				ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
				Если ПараметрыСоединения.Свойство("Ref") И ПараметрыСоединения.Свойство("Srvr") Тогда
					Инцидент.Infobase	= ВРег(ПараметрыСоединения.Ref);
					Инцидент.Cluster	= ВРег(ПараметрыСоединения.Srvr);
				КонецЕсли;
			КонецЕсли;
			
			ВыполнитьЗапрос("Open", Инцидент);
			
			Если НЕ ПустаяСтрока(ТекТип.Значение.ПроцедураПроверки) Тогда
				
				Запись = РегистрыСведений.ИнцидентыОткрытые.СоздатьМенеджерЗаписи();
				Запись.ТипИнцидента = ТипИнцидента;
				Запись.КодИнцидента = КодИнцидента;
				Запись.ИнцидентАктуален = Истина;
				Запись.Записать(Истина);
				
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;
	КонецЦикла;
	ВызватьИсключение СтрШаблон(
		НСтр("ru = 'Тип инцидента %1 не зарегистрирован'"), 
		ТипИнцидента);
	
КонецПроцедуры

// Процедура - Помечает инцидент в регистре ИнцидентыОткрытые как неактуальный. Инцидент закроется в ЦКК при следующем вызове проверки на актуальность.
//
// Параметры:
//  ТипИнцидента - Строка - Идентификатор типа инцидента.
//  КодИнцидента - Строка - Идентификатор инцидента. 
//
Процедура ПометитьИнцидентКакНеактуальный(Знач ТипИнцидента, Знач КодИнцидента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(Константы.АдресЦКК.Получить()) ИЛИ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда	
		Возврат; 
	КонецЕсли;
	
	Запись = РегистрыСведений.ИнцидентыОткрытые.СоздатьМенеджерЗаписи();
	Запись.ТипИнцидента = ТипИнцидента;
	Запись.КодИнцидента = КодИнцидента;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.ИнцидентАктуален = Ложь;
		Запись.Записать(Истина);
	КонецЕсли;
КонецПроцедуры

// Отсылает счетчик в ЦКК, используя InputStatistics/InputStatisticsDate (СИНХРОННАЯ ОТСЫЛКА СЧЕТЧИКА).
//
// Параметры:
//  ИдентификаторСчетчика	- Строка - Идентификатор счетчика для ЦКК, разделенные точками
//  ЗначениеСчетчика		- Число - Значение счетчика на передаваемый (указанный) момент времени
//  Данные					- Соответствие: ключ - идентификатор счетчика, значение - значение счетчика (если указано, имеет приоритет)
//  ДатаСчетчика			- Дата - Если указано, используется InputStatisticsDate, иначе - InputStatistics.
//
// Когда указаны массивы в параметрах ИдентификаторСчетчика/ЗначениеСчетчика, происходит передача всего
// массива за один вызов.
Процедура ОтослатьСтатистику(Знач ИдентификаторСчетчика, Знач ЗначениеСчетчика, Знач Данные = неопределено, Знач ДатаСчетчика = неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	АдресWS = Константы.АдресЦКК.Получить();
	Если ПустаяСтрока(АдресWS) ИЛИ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	АдресWS = АдресWS + ?(ДатаСчетчика = неопределено, "/ws/InputStatistics?wsdl", "/ws/InputStatisticsDate?wsdl");
	УстановитьПривилегированныйРежим(Истина);
	Владелец	= ТехнологияСервисаИнтеграцияСБСП.ИдентификаторОбъектаМетаданных("Константа.АдресЦКК");
	ЛогинWS		= ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
	ПарольWS	= ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);	
	
	Определение = Новый WSОпределения(
		АдресWS, 
		ЛогинWS, 
		ПарольWS);
	
	ПараметрыПодключения = ТехнологияСервисаИнтеграцияСБСП.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = АдресWS;
	ПараметрыПодключения.URIПространстваИмен = "http://1c.ru";
	ПараметрыПодключения.ИмяСервиса = ?(ДатаСчетчика = Неопределено, "InputStatistics", "InputStatisticsDate");
	ПараметрыПодключения.ИмяТочкиПодключения = ?(ДатаСчетчика = Неопределено, "InputStatisticsSoap", "InputStatisticsDateSoap");
	ПараметрыПодключения.ИмяПользователя = ЛогинWS;
	ПараметрыПодключения.Пароль = ПарольWS;
	
	Прокси = ТехнологияСервисаИнтеграцияСБСП.СоздатьWSПрокси(ПараметрыПодключения);
	
	МассивДляПередачи = Новый Массив();
	
	Если ТипЗнч(Данные)<>Тип("Соответствие") Тогда
		МассивДляПередачи.Добавить(
			ИдентификаторСчетчика + "." + 
			Формат(ЗначениеСчетчика, "ЧДЦ=3; ЧН=0,0; ЧГ=0") + 
			?(ДатаСчетчика = неопределено, "", ".1,0"));
	Иначе
		Для Каждого ТекСтрока из Данные Цикл
			МассивДляПередачи.Добавить(
				ТекСтрока.Ключ + "." + 
				Формат(ТекСтрока.Значение, "ЧДЦ=3; ЧН=0,0; ЧГ=0") + 
				?(ДатаСчетчика = неопределено, "", ".1,0"));
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеДляПередачи = СтрСоединить(МассивДляПередачи, ";");
	
	Если ДатаСчетчика = неопределено Тогда
		Результат = Прокси.InputData(ЗначениеДляПередачи);
	Иначе
		Результат = Прокси.InputData(ДатаСчетчика, ЗначениеДляПередачи); 
	КонецЕсли;
	
	Если Результат <> "OK" Тогда
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ИнтеграцияЦКК'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			НСтр("ru='Ошибка при передаче счетчика в ЦКК'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс


// Вызывается из регламентной процедуры МониторингЦКК 
Процедура ВыполнитьМониторингЦКК() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	АдресWS = Константы.АдресЦКК.Получить();
	Если ПустаяСтрока(АдресWS) ИЛИ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьАктуальностьОткрытыхИнцидентов();
	ОтослатьПоказателиДлиныОчередейЗаданий();
		
	// Определяемые прикладные задачи периодического мониторинга
		
	ИнцидентыЦККПереопределяемый.ВыполнитьЗадачиМониторингаЦКК();
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"ТехнологияСервиса.РаботаВМоделиСервиса.ПодсистемыЦККВМоделиСервиса\ПриВыполненииЗадачПериодическогоМониторинга");
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриВыполненииЗадачПериодическогоМониторинга();
	КонецЦикла;
		
	
КонецПроцедуры

Процедура ПроверитьАктуальностьОткрытыхИнцидентов() 
	
	НачалоРаботыЗадания = ТекущаяДатаСеанса();
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Интересуют все инциденты, кроме тех, тип которых отложен на время более времени запуска.
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Т.ТипИнцидента КАК ТипИнцидента
	                      |ПОМЕСТИТЬ ВР_ОТЛОЖЕННЫЕ
	                      |ИЗ
	                      |	РегистрСведений.ИнцидентыОтложенныеПроверки КАК Т
	                      |ГДЕ
	                      |	Т.ВремяСледующегоСтарта > &НачалоРаботыЗадания
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	ТипИнцидента
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Т.ТипИнцидента КАК ТипИнцидента,
	                      |	Т.КодИнцидента КАК КодИнцидента,
	                      |	Т.ИнцидентАктуален
	                      |ИЗ
	                      |	РегистрСведений.ИнцидентыОткрытые КАК Т
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВР_ОТЛОЖЕННЫЕ КАК ВР_ОТЛОЖЕННЫЕ
	                      |		ПО Т.ТипИнцидента = ВР_ОТЛОЖЕННЫЕ.ТипИнцидента
	                      |ГДЕ
	                      |	ВР_ОТЛОЖЕННЫЕ.ТипИнцидента ЕСТЬ NULL 
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ТипИнцидента,
	                      |	КодИнцидента");
	Запрос.УстановитьПараметр("НачалоРаботыЗадания", НачалоРаботыЗадания);
	
	
	
	// Соответствие ЗагруженныеТипыИнцидентов: ТипИнцидента(строка)=>СписокОткрытыхИнцидентов(соответствие)
	// В свою очередь каждое значение - это вложенное соответствие КодИнцидента(строка)=>Актуальность(булево).
	
	ЗагруженныеТипыИнцидентов = Новый Соответствие();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗагруженныеТипыИнцидентов[Выборка.ТипИнцидента] = неопределено Тогда
			ЗагруженныеТипыИнцидентов[Выборка.ТипИнцидента] = Новый Соответствие();
		КонецЕсли;
		ЗагруженныеТипыИнцидентов[Выборка.ТипИнцидента][Выборка.КодИнцидента] = Выборка.ИнцидентАктуален;
	КонецЦикла;
	
	СписокТипов = Новый Соответствие();
	ИнцидентыЦККПереопределяемый.СписокТиповИнцидентовПереопределяемый(СписокТипов); 
	ТребуетсяОтложить = Новый Соответствие();
	УдалитьТипы = Новый Массив();
	
	Для Каждого ТекТипИнцидента из ЗагруженныеТипыИнцидентов Цикл
		
		ОпределениеТипа = СписокТипов[ТекТипИнцидента.Ключ]; //Структура типа
		
		Если ОпределениеТипа = неопределено ИЛИ ПустаяСтрока(ОпределениеТипа.ПроцедураПроверки) Тогда
			УдалитьТипы.Добавить(ТекТипИнцидента.Ключ);
			Продолжить;
		КонецЕсли;
		
		Продолжительность = 0;
		Если НЕ ПустаяСтрока(ОпределениеТипа.ПроцедураПроверки) Тогда
			
			// АВТО-процедура проверки не вызывает внешнюю процедуру, а только проверяет флаги в регистре, установленные ПометитьИнцидентКакНеактуальный.
			Если ВРег(ОпределениеТипа.ПроцедураПроверки)<>"АВТО" Тогда
				// До вызова процедуры инциденты могли стать неактуальными с помощью вызова ПометитьИнцидентКакНеактуальный в регистре.
				НеактуальныеКлючи = Новый Массив();
				Для Каждого ТекСтрока из ТекТипИнцидента.Значение Цикл
					Если ТекСтрока.Значение = Ложь Тогда НеактуальныеКлючи.Добавить(ТекСтрока.Ключ); КонецЕсли;
				КонецЦикла;
				Для Каждого ТекСтрока из НеактуальныеКлючи Цикл
					ТекТипИнцидента.Значение.Удалить(ТекСтрока);
				КонецЦикла;
				// Выполняем внешнюю функцию и замеряем продолжительность ее работы
				НачалоРаботыФункцииПроверки = ТекущаяУниверсальнаяДатаВМиллисекундах();
				
				Попытка
					Выполнить(ОпределениеТипа.ПроцедураПроверки + "(ТекТипИнцидента.Значение);");
				Исключение
					// Исключение здесь приводит к продолжению работы со следующим типом отложенных инцидентов. 
					// Ошибки процедур проверки следует отлаживать отдельно вручную.
					// При необходимости процедура проверки может писать отладочную информацию во внешний приемник, например: ЖР.
					Продолжить;
				КонецПопытки;					
				
				Продолжительность = (ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоРаботыФункцииПроверки) / 1000;
			КонецЕсли;
			
			// В процедуре могли переопределить переменную во что-то другое. Проверяем и игнорируем это.
			Если ТипЗнч(ТекТипИнцидента.Значение)=Тип("Соответствие") Тогда 
				Для Каждого ТекКодИнцидента из ТекТипИнцидента.Значение Цикл
					Если ТекКодИнцидента.Значение=Ложь Тогда
						// закрываем инцидент и удаляем его из регистра
						ВыполнитьЗапрос("Close", ТекКодИнцидента.Ключ);
						Запись = РегистрыСведений.ИнцидентыОткрытые.СоздатьМенеджерЗаписи();
						Запись.ТипИнцидента = ТекТипИнцидента.Ключ;
						Запись.КодИнцидента = ТекКодИнцидента.Ключ;
						Запись.Удалить();
						
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			// Если процедура проверки открытых инцидентов работала более 1/5 периода вызова проверок,
			// (по умолчанию: 1 минута, макс время работы процедуры: 12 сек)
			// откладываем следующий запуск процедуры проверки этого типа на время, равное:
			// Сейчас + (ПродолжительностьРаботы * 7).
			
			Если Продолжительность >= ПериодВызоваРегламентногоЗадания() / 5 Тогда
				ТребуетсяОтложить[ТекТипИнцидента.Ключ] = ТекущаяДатаСеанса() + Продолжительность * 7;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ТекТип из УдалитьТипы Цикл
		Набор = РегистрыСведений.ИнцидентыОткрытые.СоздатьНаборЗаписей();
		Набор.Отбор.ТипИнцидента.Установить(ТекТип);
		Набор.Записать(Истина);
	КонецЦикла;
	
	// Очищаем РС.ИнцидентыОтложенныеПроверки от просроченных строк и дополняем новыми
	ОтложенныеЗаписи = РегистрыСведений.ИнцидентыОтложенныеПроверки.СоздатьНаборЗаписей();
	ОтложенныеЗаписи.Прочитать();
	ТекИндекс = ОтложенныеЗаписи.Количество()-1;
	Пока ТекИндекс>=0 Цикл
		Если ОтложенныеЗаписи[ТекИндекс].ВремяСледующегоСтарта<=НачалоРаботыЗадания Тогда
			ОтложенныеЗаписи.Удалить(ТекИндекс);
		КонецЕсли;
		ТекИндекс = ТекИндекс - 1;
	КонецЦикла;
	Для Каждого ТекТребование из ТребуетсяОтложить Цикл
		НоваяСтрока = ОтложенныеЗаписи.Добавить();
		НоваяСтрока.ТипИнцидента = ТекТребование.Ключ;
		НоваяСтрока.ВремяСледующегоСтарта = ТекТребование.Значение;
	КонецЦикла;
	ОтложенныеЗаписи.Записать(ИСТИНА);
	
КонецПроцедуры

Функция ПериодВызоваРегламентногоЗадания() Экспорт
	Возврат 60;
КонецФункции

Процедура ВыполнитьЗапрос(КомандаЗапроса, Данные)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктурированныйАдрес = ОбщегоНазначенияКлиентСервер.СтруктураURI(Константы.АдресЦКК.Получить());
	Запрос = Новый HTTPЗапрос();
	Запрос.АдресРесурса = СтруктурированныйАдрес.ПутьНаСервере + "/hs/InputIncidentTickets/" + КомандаЗапроса;
	Запрос.Заголовки["Accept-Charset"] = "utf-8";
	Запрос.Заголовки["Accept"] = "application/xml";
	Запрос.Заголовки["Content-Type"] = "application/xml;charset=utf-8";
	Если ТипЗнч(Данные)=Тип("ОбъектXDTO") Тогда
		Поток = Новый ЗаписьXML(); 
		Поток.УстановитьСтроку();
		ФабрикаXDTO.ЗаписатьXML(Поток, Данные);
		ДанныеКакСтрока = Поток.Закрыть();
		Запрос.УстановитьТелоИзСтроки(ДанныеКакСтрока);
	Иначе
		Запрос.УстановитьТелоИзСтроки(Данные);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Владелец	= ТехнологияСервисаИнтеграцияСБСП.ИдентификаторОбъектаМетаданных("Константа.АдресЦКК");
	ЛогинWS		= ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин", Истина);
	ПарольWS	= ТехнологияСервисаИнтеграцияСБСП.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль", Истина);
	УстановитьПривилегированныйРежим(Ложь);	
	
	Соединение = Новый HTTPСоединение(
		СтруктурированныйАдрес.Хост, 
		СтруктурированныйАдрес.Порт, 
		ЛогинWS,
		ПарольWS);
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	Если Ответ.КодСостояния<>200 Тогда
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'ИнтеграцияЦКК'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, 
			СтрШаблон(
			НСтр("ru = 'Ошибка (код %3) команды %1 сервиса инцидентов ЦКК: %2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			КомандаЗапроса, Ответ.ПолучитьТелоКакСтроку(), Ответ.КодСостояния));
	КонецЕсли;
	
КонецПроцедуры

// Возвращает теги строкой, разделенные пробелом, включая предопределенные
//
// Параметры:
//  ТегОборудование			 - Булево - Тег "Оборудование"
//  ТегДоступность			 - Булево - Тег "Доступность"
//  ТегПроизводительность	 - Булево - Тег "Производительность"
//  ТегПрикладнаяОшибка		 - Булево - Тег "Прикладная ошибка"
//  ДопТеги					 - Строка - произвольные доп.теги. Если в них указаны предопределенные, дубликаты будут исключены.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ТегиВСтроку(Знач ТегОборудование, Знач ТегДоступность, Знач ТегПроизводительность, Знач ТегПрикладнаяОшибка, Знач ДопТеги) 
	
	СловарьТегов = Новый Соответствие(); 
	Для Каждого ТекТег из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДопТеги, " ", Ложь) Цикл
		СловарьТегов[ТекТег] = 1;
	КонецЦикла;
	
	Если ТегОборудование		Тогда СловарьТегов["Оборудование"] = 1; КонецЕсли;
	Если ТегДоступность			Тогда СловарьТегов["Доступность"] = 1; КонецЕсли;
	Если ТегПроизводительность	Тогда СловарьТегов["Производительность"] = 1; КонецЕсли;
	Если ТегПрикладнаяОшибка	Тогда СловарьТегов["ПрикладнаяОшибка"] = 1; КонецЕсли;
	
	МассивТегов = Новый Массив();
	Для Каждого ТекТег из СловарьТегов Цикл
		МассивТегов.Добавить(ТекТег.Ключ);
	КонецЦикла;
	
	Возврат СтрСоединить(МассивТегов, " ");
	
КонецФункции

Процедура ОтослатьПоказателиДлиныОчередейЗаданий() 
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	Если ПараметрыСоединения.Свойство("Ref") И ПараметрыСоединения.Свойство("Srvr") Тогда
		Infobase	= ВРег(ПараметрыСоединения.Ref);
		Cluster		= ВРег(ПараметрыСоединения.Srvr);
	Иначе
		ВызватьИсключение НСтр("ru='Невозможно определить имя кластера и информационной базы из строки подключения'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// счетчик "запланированные, но пока не выполненные задания" (очередь)
	
	ИмяСчетчика = Cluster + "\" + InfoBase + ".ДлинаОчередиЗаданий";	
	Результат = 0.001;
	НачалоВыборки = ТекущаяУниверсальнаяДата();
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КОЛИЧЕСТВО(ОЧ.Ссылка) КАК КоличествоЗаданий
	                      |ИЗ
	                      |	Справочник.ОчередьЗаданийОбластейДанных КАК ОЧ
	                      |ГДЕ
	                      |	ОЧ.ЗапланированныйМоментЗапуска <= &Сейчас
	                      |	И ОЧ.Использование
	                      |	И ОЧ.СостояниеЗадания = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаданий.Запланировано)");
	Запрос.УстановитьПараметр("Сейчас", НачалоВыборки);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = ?(Выборка.КоличествоЗаданий = 0, Результат, Выборка.КоличествоЗаданий);
	КонецЕсли;       
	ОтослатьСтатистику(ИмяСчетчика, Результат, Неопределено, НачалоВыборки);
	
КонецПроцедуры

#КонецОбласти

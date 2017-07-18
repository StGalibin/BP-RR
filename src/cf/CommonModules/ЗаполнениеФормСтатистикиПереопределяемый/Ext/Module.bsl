﻿
#Область СлужебныйПрограммныйИнтерфейс

// Получает набор внешних данных по имени объекта.
// Параметры:
//	ИмяОбъекта - Строка - Идентификатор данных которые требуется получить.
// Возвращаемое значение
//	ТаблицаЗначений, Неопределено - Набор данных в виде таблицы, если для запрашиваемого объекта нет данных возвращает неопределено.
//
Функция ВнешниеДанные(ИмяОбъекта) Экспорт
	
	Если ИмяОбъекта = "ПравилаПересчетаЕдиницИзмерения" Тогда
		// В схеме компоновки данных Перечисления.ИсточникиДанныхСтатистическихПоказателей.Макеты.ЗакупкиИЗатраты.
		// Длина кода справочника КлассификаторЕдиницИзмерения задана в явном виде как Строка(4) с фиксированной длиной.
		Возврат Справочники.КлассификаторЕдиницИзмерения.ПравилаПересчетаЕдиницИзмерения();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	
КонецФункции

// Возвращает список форм статистики для которых может быть выполнена настройка заполнения
// и которые встречаются в настройках списка налогов и отчетов переданной организации.
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация для которой нужно найти формы.
// Возвращаемое значение:
// ТаблицаЗначений:
//	* Форма- СправочникСсылка.ФормыСтатистики - Форма статистики.
//	* Организация - СправочникСсылка.Организации - Организация.
//
Функция НастраиваемыеФормыСтатистикиПредоставляемыеОрганизацией(Организация) Экспорт
	
	Результат = Новый ТаблицаЗначений; // Ссылки на формы.
	Результат.Колонки.Добавить("Форма", 		Новый ОписаниеТипов("СправочникСсылка.ФормыСтатистики"));
	Результат.Колонки.Добавить("Организация", 	Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	НастраиваемыеФормыСтатистики = ЗаполнениеФормСтатистики.НастраиваемыеФормыСтатистики(); // Может содержать формы, которые организация не сдает.
	НастраиваемыеФормыСтатистики.Индексы.Добавить("ИмяРегламентированногоОтчета");
	
	// Определим, какие из этих форм сдает организация.
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалогиОтчеты.Организация,
	|	НалогиОтчеты.НалогОтчет.Владелец.Код КАК Задача,
	|	НалогиОтчеты.НалогОтчет.Код КАК Правило
	|ИЗ
	|	РегистрСведений.НалогиОтчеты КАК НалогиОтчеты
	|ГДЕ
	|	&УсловиеПоОрганизации
	|	И НЕ НалогиОтчеты.НалогОтчет.Владелец.Код ЕСТЬ NULL ";
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоОрганизации", "ИСТИНА");
	ИначеЕсли ТипЗнч(Организация) = Тип("Массив") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоОрганизации", "НалогиОтчеты.Организация В (&Организация)");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеПоОрганизации", "НалогиОтчеты.Организация = &Организация");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = ТекстЗапроса;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ИсполнителиТребований = ИнтерфейсыВзаимодействияБРО.РеглОтчетыИсполнителиТребований();// Это ускорит определение имени отчета.
	Пока Выборка.Следующий() Цикл
		
		ИмяПравила = Справочники.ПравилаПредставленияОтчетовУплатыНалогов.СкомпоноватьПолноеИмяПравила(Выборка.Задача, Выборка.Правило);
		ИмяРегламентированногоОтчета = ИнтерфейсыВзаимодействияБРО.ИмяРеглОтчета(ИмяПравила, ИсполнителиТребований);
		
		НастраиваемаяФорма = НастраиваемыеФормыСтатистики.Найти(ИмяРегламентированногоОтчета, "ИмяРегламентированногоОтчета");
		Если НастраиваемаяФорма = Неопределено Тогда
			// Не требует настройки.
			Продолжить;
		КонецЕсли;
			
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.Форма = НастраиваемаяФорма.ФормаСтатистики;
		НоваяСтрока.Организация = Выборка.Организация;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет показатели выручки предпринимателя.
// Параметры:
//	Показатели - ТаблицаЗначений - Коллекция показателей формы статистики с необходимыми настройками, подробнее см. НовыйОписаниеПоказателей().
//	Формулы - ТаблицаЗначений - Коллекция показателей формы статистики для которых указан дополнительный алгоритм, подробнее см. НовыйОписаниеПоказателей().
//
Процедура ВыручкаПредпринимателя(Показатели, Формулы) Экспорт
	
	ВыручкаИППоВидамДейтельности = Неопределено;
	
	Для Каждого Формула Из Формулы Цикл
		
		Если Формула.ДополнительныйАлгоритм <> Перечисления.ДополнительныеАлгоритмыЗаполненияФормСтатистики.ВыручкаПредпринимателя Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыручкаИППоВидамДейтельности = Неопределено Тогда
			ВыручкаИППоВидамДейтельности = 
				УчетДоходовИРасходовПредпринимателяЗаполнениеФормСтатистики.ВыручкаИППоВидамДейтельности(Формула.Организация, Формула.НачалоПериода, Формула.КонецПериода);
		КонецЕсли;
			
		ПоказателиВыручкиИП = Показатели.НайтиСтроки(Новый Структура("ДополнительныйАлгоритм, ИмяПоля", Перечисления.ДополнительныеАлгоритмыЗаполненияФормСтатистики.ВыручкаПредпринимателя, Формула.ИмяПоля));
		
		Для Каждого АналитикаВыручки Из ВыручкаИППоВидамДейтельности Цикл
			
			Для Каждого Показатель Из ПоказателиВыручкиИП Цикл
				
				НовыйПоказатель = Показатели.Добавить();
				ЗаполнитьЗначенияСвойств(НовыйПоказатель, Показатель,, "ДополнительныйАлгоритм, Значение, Аналитика");
				
				Значение = Новый Структура();
				Значение.Вставить(НовыйПоказатель.Характеристика, Неопределено);
				ЗаполнитьЗначенияСвойств(Значение, АналитикаВыручки);
				
				НовыйПоказатель.Аналитика 		= АналитикаВыручки.Аналитика;
				НовыйПоказатель.Значение 		= Значение[НовыйПоказатель.Характеристика];
				НовыйПоказатель.Детализировать 	= Истина;
				
			КонецЦикла;
		КонецЦикла;
		
		Для Каждого Показатель Из ПоказателиВыручкиИП Цикл
			
			Показатели.Удалить(Показатель);
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

// Заполняет показатели численности персонала.
// Параметры:
//	Показатели - ТаблицаЗначений - Коллекция показателей формы статистики с необходимыми настройками, подробнее см. НовыйОписаниеПоказателей().
//	Формулы - ТаблицаЗначений - Коллекция показателей формы статистики для которых указан дополнительный алгоритм, подробнее см. НовыйОписаниеПоказателей().
//
Процедура ЧисленностьПерсонала(Показатели, Формула) Экспорт
	
	Если Формула.ДополнительныйАлгоритм 
		<> Перечисления.ДополнительныеАлгоритмыЗаполненияФормСтатистики.ЧисленностьПерсонала Тогда
		Возврат;
	КонецЕсли;
	
	Результаты = УчетЗарплаты.СведенияОЧисленностиИВыплатах(Формула.Организация, Формула.НачалоПериода, Формула.КонецПериода, Истина);
	
	КоличествоРезультатов = Результаты.Количество();
	
	Если КоличествоРезультатов > 0 Тогда
		
		ПоказателиЧисленности = Показатели.НайтиСтроки(Новый Структура(
				"ДополнительныйАлгоритм, ИмяПоля",
				Перечисления.ДополнительныеАлгоритмыЗаполненияФормСтатистики.ЧисленностьПерсонала,
				Формула.ИмяПоля));
		
		СведенияОЧисленности = Результаты[КоличествоРезультатов - 4].Выгрузить();
		
		Для Каждого Показатель Из ПоказателиЧисленности Цикл
			
			Характеристика = Показатель.Характеристика;
			
			Если СведенияОЧисленности.Колонки.Найти(Характеристика) <> Неопределено Тогда
				
				Показатель.Значение = СведенияОЧисленности.Итог(Характеристика);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет поиск единицы измерения в классификаторе единиц измерения.
//
// Параметры:
//	КодПоОКЕИ - Строка - код единицы измерения по ОКЕИ.
//	Наименование - Строка - Наименование единицы измерения.
//
// Возвращаемое значение:
// СправочникСсылка.КлассификаторЕдиницИзмерения, Неопределено - если поиск и попытка добавления элемента не дали результатов то неопределено.
//
Функция ЕдиницаИзмеренияПоКоду(КодЕдиницыИзмерения, НаименованиеЕдиницыИзмерения) Экспорт
	Возврат Справочники.КлассификаторЕдиницИзмерения.ЕдиницаИзмеренияПоКоду(
				КодЕдиницыИзмерения,
				НаименованиеЕдиницыИзмерения);
КонецФункции

#КонецОбласти
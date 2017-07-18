﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Заполнение "пустого" документа.
	ЗначенияДляЗаполнения = Новый Структура("Организация", "Организация");
	ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);

	УстановитьОтборыВДинамическихСписках();
	
	// Обработчик подсистемы "Печать".
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ЗаявленияНаВыплатуПособияКонтекстноеМеню);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Больничные

&НаКлиенте
Процедура БольничныеЛистыПриАктивизацииСтроки(Элемент)
	Доступна = Ложь;
	Если Не ЭтаФорма.Элементы.БольничныеЛисты.ТекущиеДанные = Неопределено Тогда
		Доступна = Не ЭтаФорма.Элементы.БольничныеЛисты.ТекущиеДанные.ЕстьЗаявление;
	КонецЕсли;
	ЭтаФорма.Элементы.ПособияКонтекстноеМенюОформитьЗаявление.Доступность = Доступна;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ЗаявленияНаВыплатуПособия);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ОформитьЗаявлениеНаВыплатуБольничного(Команда)
	МассивСсылок = ЭтаФорма.Элементы.БольничныеЛисты.ВыделенныеСтроки;
	Если МассивСсылок.Количество() > 0 Тогда
		ОформитьНедостающиеЗаявленияПоСпискуДокументов(МассивСсылок);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБольничныйЛист(Команда)
	ОткрытьФорму("Документ.БольничныйЛист.Форма.ФормаДокумента");	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостающиеЗаявления(Команда)
	ОформитьНедостающиеЗаявленияПоСпискуДокументов();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРеестрНаВыплатуПособий(Команда)
	ОткрытьФорму("Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Форма.ФормаДокумента");	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРееструСтатусОтправлен(Команда)
	МассивСсылок = ЭтаФорма.Элементы.Реестры.ВыделенныеСтроки;
	Если МассивСсылок.Количество() > 0 Тогда
		УстановитьНовыйСтатусРеестру(МассивСсылок, ПредопределенноеЗначение("Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ПереданВФСС"));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРееструСтатусПринят(Команда)
	МассивСсылок = ЭтаФорма.Элементы.Реестры.ВыделенныеСтроки;
	Если МассивСсылок.Количество() > 0 Тогда
		УстановитьНовыйСтатусРеестру(МассивСсылок, ПредопределенноеЗначение("Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ПринятФСС"));
	КонецЕсли;
КонецПроцедуры  

&НаКлиенте
Процедура СоздатьЗаявление(Команда)
	ОткрытьФорму("Документ.ЗаявлениеСотрудникаНаВыплатуПособия.Форма.ФормаДокумента");	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	ОбновитьВсеНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВРеестр(Команда)
	МассивСсылок = ЭтаФорма.Элементы.ЗаявленияНаВыплатуПособия.ВыделенныеСтроки;
	Если МассивСсылок.Количество() > 0 Тогда
		ВключитьВРеестрНаСервере(МассивСсылок);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявлениеОВозмещенииДополнительныхВыходныхДней(Команда)
	ОткрытьФорму("Документ.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.Форма.ФормаДокумента");	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявлениеОВозмещенииПособийНаПогребение(Команда)
	ОткрытьФорму("Документ.ЗаявлениеВФССОВозмещенииРасходовНаПогребение.Форма.ФормаДокумента");	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьВТРеестрыВРаботе(МенеджерВременныхТаблиц)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	МАКСИМУМ(РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Дата) КАК Дата,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ПОМЕСТИТЬ МаксимальныеДатыРеестров
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|ГДЕ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра = ЗНАЧЕНИЕ(Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ЕжемесячныеПособияПоУходуЗаРебенком)
	|	И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Дата),
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|ГДЕ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра = ЗНАЧЕНИЕ(Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПособияПоНетрудоспособности)
	|	И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Дата),
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|ГДЕ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра = ЗНАЧЕНИЕ(Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ЕдиновременныеПособияПриРожденииРебенка)
	|	И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МАКСИМУМ(РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Дата),
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|ГДЕ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра = ЗНАЧЕНИЕ(Перечисление.ВидыРеестровСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПособияВставшимНаУчетВРанниеСроки)
	|	И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе)
	|
	|СГРУППИРОВАТЬ ПО
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Ссылка,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ПОМЕСТИТЬ ВТРеестрыВРаботе
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимальныеДатыРеестров КАК МаксимальныеДатыРеестров
	|		ПО РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Дата = МаксимальныеДатыРеестров.Дата
	|			И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра = МаксимальныеДатыРеестров.ВидРеестра
	|			И РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация = МаксимальныеДатыРеестров.Организация";
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
КонецПроцедуры

&НаСервере
Процедура ОформитьНедостающиеЗаявленияПоСпискуДокументов(СписокДокументов = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТРеестрыВРаботе(Запрос.МенеджерВременныхТаблиц);
	
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Ссылка,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ВидРеестра,
	|	РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.Организация
	|ИЗ
	|	ВТРеестрыВРаботе КАК РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Ссылка,
	|	0 КАК ИдентификаторСтроки
	|ИЗ
	|	Документ.БольничныйЛист КАК Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудникаНаВыплатуПособия
	|		ПО (ЗаявлениеСотрудникаНаВыплатуПособия.ДокументОснование = Документы.Ссылка)
	|ГДЕ
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка ЕСТЬ NULL 
	|	И Документы.ПособиеВыплачиваетсяФСС
	|	И Документы.Ссылка В(&СписокДокументов)
	|	И НЕ Документы.ПометкаУдаления
	|	И Документы.ПричинаНетрудоспособности <> ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ТравмаНаПроизводстве)";
	
	Если СписокДокументов = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Документы.Ссылка В(&СписокДокументов)", "ИСТИНА")
	Иначе	 
		Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	Результат = ПакетРезультатов[1];
	ВыборкаРеестров = ПакетРезультатов[0].Выбрать();
	
	СписокПроведенныхЗаявлений = Новый ТаблицаЗначений;
	СписокПроведенныхЗаявлений.Колонки.Добавить("Заявление");
	СписокПроведенныхЗаявлений.Колонки.Добавить("ВидРеестра");
	СписокПроведенныхЗаявлений.Колонки.Добавить("Организация");
	СписокПроведенныхЗаявлений.Колонки.Добавить("Основание");
	
	СписокРеестров = Новый ТаблицаЗначений;
	СписокРеестров.Колонки.Добавить("ВидРеестра");
	СписокРеестров.Колонки.Добавить("Организация");
	СписокРеестров.Колонки.Добавить("Реестр");
	
	ОтборРеестров =  Новый Структура("ВидРеестра, Организация");
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НовоеЗаявление = Документы.ЗаявлениеСотрудникаНаВыплатуПособия.СоздатьДокумент();
			НовоеЗаявление.Дата = ТекущаяДатаСеанса();
			НовоеЗаявление.Заполнить(Новый Структура("Основание, ИдентификаторСтроки", Выборка.Ссылка, Выборка.ИдентификаторСтроки));
			
			НовоеЗаявление.Записать(РежимЗаписиДокумента.Запись);
			
			Если НовоеЗаявление.ПроверитьЗаполнение() Тогда
				
				НовоеЗаявление.Записать(РежимЗаписиДокумента.Проведение);
				
				НовоеПроведенноеЗаявление = СписокПроведенныхЗаявлений.Добавить();
				НовоеПроведенноеЗаявление.Заявление = НовоеЗаявление.Ссылка;
				НовоеПроведенноеЗаявление.ВидРеестра = НовоеЗаявление.ВидРеестра;
				НовоеПроведенноеЗаявление.Организация = НовоеЗаявление.Организация;
				НовоеПроведенноеЗаявление.Основание = Выборка.Ссылка;
				
				ОтборРеестров.Вставить("ВидРеестра", НовоеЗаявление.ВидРеестра);
				ОтборРеестров.Вставить("Организация", НовоеЗаявление.Организация);
				
				СтрокиРеестра = СписокРеестров.НайтиСтроки(ОтборРеестров);
				
				Если СтрокиРеестра.Количество() = 0 Тогда
					
					ВыборкаРеестров.Сбросить();
					
					Если ВыборкаРеестров.НайтиСледующий(ОтборРеестров) Тогда
						Реестр = ВыборкаРеестров.Ссылка;
					Иначе
						НовыйРеестр = Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СоздатьДокумент();
						НовыйРеестр.Дата = ТекущаяДатаСеанса();
						НовыйРеестр.Организация = НовоеЗаявление.Организация;
						НовыйРеестр.ВидРеестра = НовоеЗаявление.ВидРеестра;
						НовыйРеестр.СтатусДокумента = Перечисления.СтатусыЗаявленийИРеестровНаВыплатуПособий.ВРаботе;
						НовыйРеестр.ОбновитьВторичныеДанныеДокумента(Истина, Ложь);
						НовыйРеестр.Записать(РежимЗаписиДокумента.Запись);
						
						Реестр = НовыйРеестр.Ссылка;
						
					КонецЕсли;
					
					НовыйЭлементСпискаРеестров = СписокРеестров.Добавить();
					НовыйЭлементСпискаРеестров.ВидРеестра = НовоеЗаявление.ВидРеестра;
					НовыйЭлементСпискаРеестров.Организация = НовоеЗаявление.Организация;
					НовыйЭлементСпискаРеестров.Реестр = Реестр;
					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементСпискаРеестров Из СписокРеестров Цикл
			
			ОтборРеестров.Вставить("ВидРеестра", ЭлементСпискаРеестров.ВидРеестра);
			ОтборРеестров.Вставить("Организация", ЭлементСпискаРеестров.Организация);
			
			ПроведенныеЗаявления = СписокПроведенныхЗаявлений.НайтиСтроки(ОтборРеестров);
			Если ПроведенныеЗаявления.Количество() > 0 Тогда
				РеестрДокумент = ЭлементСпискаРеестров.Реестр.ПолучитьОбъект();
				
				Для Каждого ПроведенноеЗаявление Из ПроведенныеЗаявления Цикл
					НоваяСтрокаРеестра = РеестрДокумент.СведенияНеобходимыеДляНазначенияПособий.Добавить();
					НоваяСтрокаРеестра.Заявление = ПроведенноеЗаявление.Заявление;
					НоваяСтрокаРеестра.ПервичныйДокумент = ПроведенноеЗаявление.Основание;
				КонецЦикла;
				
				РеестрДокумент.Записать();
				
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	ОбновитьВсеНаСервере();
	
КонецПроцедуры

#Область ВключитьВРеестрНаСервере

&НаСервере
Процедура ВключитьВРеестрНаСервере(СписокДокументов)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТРеестрыВРаботе(Запрос.МенеджерВременныхТаблиц);
	
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка КАК Заявление,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ДокументОснование КАК Основание,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Организация,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.ВидРеестра,
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Проведен,
	|	ВЫБОР
	|		КОГДА Реестры.Ссылка ЕСТЬ NULL 
	|				И Описи.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Использовано,
	|	ЕСТЬNULL(Реестры.Ссылка, Описи.Ссылка) КАК ИспользованныйРеестр,
	|	РеестрыВРаботе.Ссылка КАК ПодходящийРеестр
	|ИЗ
	|	Документ.ЗаявлениеСотрудникаНаВыплатуПособия КАК ЗаявлениеСотрудникаНаВыплатуПособия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРеестрыВРаботе КАК РеестрыВРаботе
	|		ПО ЗаявлениеСотрудникаНаВыплатуПособия.Организация = РеестрыВРаботе.Организация
	|			И ЗаявлениеСотрудникаНаВыплатуПособия.ВидРеестра = РеестрыВРаботе.ВидРеестра
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СведенияНеобходимыеДляНазначенияПособий КАК Реестры
	|		ПО ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка = Реестры.Заявление
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОписьЗаявленийСотрудниковНаВыплатуПособий.Заявления КАК Описи
	|		ПО ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка = Описи.Заявление
	|ГДЕ
	|	ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка В(&СписокДокументов)";
	
	Если СписокДокументов = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЗаявлениеСотрудникаНаВыплатуПособия.Ссылка В(&СписокДокументов)", "ИСТИНА")
	Иначе	 
		Запрос.УстановитьПараметр("СписокДокументов", СписокДокументов);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
	    Возврат;
	КонецЕсли;
	
	СписокЗаявлений = ПустаяТаблицаЗаявленияДляДобавления();
	
	СписокРеестров = Новый ТаблицаЗначений;
	СписокРеестров.Колонки.Добавить("ВидРеестра");
	СписокРеестров.Колонки.Добавить("Организация");
	СписокРеестров.Колонки.Добавить("Реестр");
	
	ОтборРеестров = Новый Структура("ВидРеестра, Организация");
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не Выборка.Проведен Тогда
			ТекстСообщения = НСтр("ru = 'Заявление %1 не проведено и не будет включено в реестр.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Заявление);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		Если Выборка.Использовано Тогда
			ТекстСообщения = НСтр("ru = 'Заявление %1 уже включено в реестр %2.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Выборка.Заявление, Выборка.ИспользованныйРеестр);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СписокЗаявлений.Добавить(), Выборка);
		
		ОтборРеестров.Вставить("ВидРеестра", Выборка.ВидРеестра);
		ОтборРеестров.Вставить("Организация", Выборка.Организация);
		УжеСозданныеРеестры = СписокРеестров.НайтиСтроки(ОтборРеестров);
		
		Если УжеСозданныеРеестры.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ПодходящийРеестр) Тогда
			Реестр = Выборка.ПодходящийРеестр;
		Иначе       
			
			НовыйРеестр = Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СоздатьДокумент();
			
			ДанныеЗаполнения 				= Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СтруктураДанныхЗаполнения();
			ДанныеЗаполнения.Дата 			= ТекущаяДатаСеанса();
			ДанныеЗаполнения.Организация 	= Выборка.Организация;
			ДанныеЗаполнения.ВидРеестра 	= Выборка.ВидРеестра;
			НовыйРеестр.Заполнить(ДанныеЗаполнения);
			
			НовыйРеестр.Записать(РежимЗаписиДокумента.Запись);
			
			Реестр = НовыйРеестр.Ссылка;
			
		КонецЕсли;
		
		НовыйЭлементСпискаРеестров = СписокРеестров.Добавить();
		НовыйЭлементСпискаРеестров.ВидРеестра = Выборка.ВидРеестра;
		НовыйЭлементСпискаРеестров.Организация = Выборка.Организация;
		НовыйЭлементСпискаРеестров.Реестр = Реестр;   
		
	КонецЦикла;
	
	Для Каждого ЭлементСпискаРеестров Из СписокРеестров Цикл
		
		ОтборРеестров.Вставить("ВидРеестра", ЭлементСпискаРеестров.ВидРеестра);
		ОтборРеестров.Вставить("Организация", ЭлементСпискаРеестров.Организация);
		
		ПроведенныеЗаявления = СписокЗаявлений.НайтиСтроки(ОтборРеестров);
		
		Если ПроведенныеЗаявления.Количество() > 0 Тогда
			
			ДобавитьЗаявленияВРеестр(ЭлементСпискаРеестров.Реестр, ПроведенныеЗаявления)	
			
		КонецЕсли;
	КонецЦикла;		
	
	ОбновитьВсеНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПустаяТаблицаЗаявленияДляДобавления()
	
	ПустаяТаблицаЗаявленияДляДобавления = Новый ТаблицаЗначений;
	ПустаяТаблицаЗаявленияДляДобавления.Колонки.Добавить("Заявление");
	ПустаяТаблицаЗаявленияДляДобавления.Колонки.Добавить("ВидРеестра");
	ПустаяТаблицаЗаявленияДляДобавления.Колонки.Добавить("Организация");
	ПустаяТаблицаЗаявленияДляДобавления.Колонки.Добавить("Основание");
	
	Возврат ПустаяТаблицаЗаявленияДляДобавления;
	
КонецФункции

&НаСервере
Процедура ДобавитьЗаявленияВРеестр(Реестр, ЗаявленияДляДобавления)
	
	Если ЗаявленияДляДобавления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	РеестрДокумент = Реестр.ПолучитьОбъект();
	
	Для Каждого ЗаявлениеДляДобавления Из ЗаявленияДляДобавления Цикл
		НоваяСтрокаРеестра 						= РеестрДокумент.СведенияНеобходимыеДляНазначенияПособий.Добавить();
		НоваяСтрокаРеестра.Заявление 			= ЗаявлениеДляДобавления.Заявление;
		НоваяСтрокаРеестра.ПервичныйДокумент 	= ЗаявлениеДляДобавления.Основание;
	КонецЦикла;
	
	РеестрДокумент.Записать();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьНовыйСтатусРеестру(МассивСсылок, Статус)
	Для Каждого Реестр Из МассивСсылок Цикл
		ДокументРеестр = Реестр.ПолучитьОбъект();
		ДокументРеестр.СтатусДокумента = Статус;
		ДокументРеестр.Записать(РежимЗаписиДокумента.Запись);
	КонецЦикла;	
	ОбновитьВсеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьВсеНаСервере()
	Элементы.БольничныеЛисты.Обновить();
	Элементы.ЗаявленияНаВыплатуПособия.Обновить();
	Элементы.Реестры.Обновить();
	Элементы.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлРеестраНаДиск(Команда)
	
	МассивСсылок = ЭтаФорма.Элементы.Реестры.ВыделенныеСтроки;
	МассивРеестров = Новый Массив;
	
	Для Каждого Реестр Из МассивСсылок Цикл
		Если ТипЗнч(Реестр) = Тип("ДокументСсылка.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий") Тогда
			МассивРеестров.Добавить(Реестр);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивРеестров.Количество() = 0 Тогда
		Возврат	
	КонецЕсли;
	
	ПараметрыВыгрузки = Новый Структура("МассивРеестров", МассивРеестров);
	
	ТекстСообщения = НСтр("ru = 'Для записи файлов рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	Обработчик = Новый ОписаниеОповещения("ЗаписатьФайлРеестраНаДискПослеПодключенияРасширения", ЭтотОбъект, ПараметрыВыгрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлРеестраНаДискПослеПодключенияРасширения(Подключено, ПараметрыВыгрузки) Экспорт
	
	ПолучаемыеФайлы = МассивОписанийРеестров(ПараметрыВыгрузки.МассивРеестров);
	
	Если Не Подключено Тогда
		Для Каждого ОписаниеФайла Из ПолучаемыеФайлы Цикл
			ПолучитьФайл(ОписаниеФайла.Хранение, ОписаниеФайла.Имя, Истина);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Выберите каталог для сохранения файлов'");
	
	Обработчик = Новый ОписаниеОповещения("ЗаписатьФайлРеестраНаДискЗавершение", ЭтотОбъект, ПараметрыВыгрузки);
	НачатьПолучениеФайлов(Обработчик, ПолучаемыеФайлы, ДиалогВыбораКаталога, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлРеестраНаДискЗавершение(ПолученныеФайлы, ПараметрыВыгрузки) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолученныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файлы реестров (%1) были записаны на диск'"), ПолученныеФайлы.Количество());
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

&НаСервере
Функция МассивОписанийРеестров(СписокРеестров)
	
	МассивОписаний = Новый Массив;
	Для Каждого Реестр Из СписокРеестров Цикл
		Отказ = Ложь;
		ОписаниеФайла = Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПолучитьОписаниеФайла(Реестр, Отказ);
		Если Не Отказ Тогда
			МассивОписаний.Добавить(ОписаниеФайла.Описание);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	УстановитьОтборыВДинамическихСписках();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыВДинамическихСписках()
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(БольничныеЛисты);
	МассивСписков.Добавить(ЗаявленияНаВыплатуПособия);
	МассивСписков.Добавить(Реестры);
	МассивСписков.Добавить(ЗаявлениеВФССОВозмещенииПособий);
	
	Для Каждого Список Из МассивСписков Цикл
		УстановитьОтборыПоОрганизацииВТаблице(Список);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоОрганизацииВТаблице(Список)
	Параметр = Список.Параметры.Элементы.Найти("Организация");
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Организация;
		Параметр.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РеестрыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	МассивСсылок = Новый Массив;
		
	ВключитьВРеестрНаСервере(ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

#КонецОбласти

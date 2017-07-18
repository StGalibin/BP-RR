﻿#Область ОбъявлениеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация;
	Иначе
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ПравоРедактированияНастроек = 
		ПравоДоступа("Изменение", Метаданные.РегистрыСведений.НалогиОтчеты)
		И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПорядокУплатыАкцизов)
		И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПорядокУплатыНалоговНаМестах)
		И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ВариантыПримененияТребованийЗаконодательства);
	
	КалендарьБухгалтера.ЗапланироватьОбновлениеЗадачБухгалтера();
	
	ПодготовитьФормуНастройкиСписка();
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(РезультатБлокировки) Тогда
		ПоказатьПредупреждение( , РезультатБлокировки);
		РезультатБлокировки = "";
		
	Иначе
		Если ЗначениеЗаполнено(Организация) Тогда
			ЗаполнитьСписокНастройкиНалоговОтчетов();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Организации" Тогда
		Если Организация = Источник Тогда
			
			Если Модифицированность Тогда
				ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОбновилисьДанныеОрганизацииЗавершение", ЭтотОбъект);
				ТекстВопроса = НСтр("ru='Данные организации были изменены. Требуется обновить список налогов. Сохранить изменения?'");
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Иначе
				ПодготовитьФормуНастройкиСписка();
				ЗаполнитьСписокНастройкиНалоговОтчетов();
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_НастройкиУчетаНалогаНаПрибыль" И Параметр.Организация = Организация Тогда
		
		ОбновитьНастройкиУчетаНалогаНаПрибыль();
		
	ИначеЕсли ИмяСобытия = "Запись_УчетнаяПолитика" И Параметр.Организация = Организация Тогда
		
		ОбновитьНастройкиУчетнойПолитики();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
	Если Не ПустаяСтрока(РезультатБлокировки) Тогда
		ПоказатьПредупреждение( , РезультатБлокировки);
		РезультатБлокировки = "";
	Иначе
		ЗаполнитьСписокНастройкиНалоговОтчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь; // Незачем очищать
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокИспользованиеПриИзменении(Элемент)
	
	Строка = Список.НайтиПоИдентификатору(Элементы.Список.ТекущаяСтрока);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строки = Строка.ПолучитьЭлементы();
	
	// Подчиненные строки
	Для Каждого ПодСтрока Из Строки Цикл
		ПодСтрока.Включен = Строка.Включен;
	КонецЦикла;
	
	// Вышележащая строка
	Родитель = Строка.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		Родитель.Включен = Ложь;
		Строки = Родитель.ПолучитьЭлементы();
		Для Каждого ПодСтрока Из Строки Цикл
			Родитель.Включен = Родитель.Включен Или ПодСтрока.Включен;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя <> "ДетальнаяНастройка" Тогда
		Возврат
	КонецЕсли;
	
	Строка = Список.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Строка = Неопределено Или Не Строка.ЕстьДетальнаяНастройка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если Строка.Ключ <> "" Тогда
		Родитель = Строка.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПредметНастройки = Строка.Ключ;
		НалогОтчет = Родитель.Наименование + " (" + Строка.Наименование + ")";
	ИначеЕсли ТипЗнч(Строка.Ссылка) = Тип("ПеречислениеСсылка.ВидыПодакцизныхТоваров") Тогда
		Родитель = Строка.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПредметНастройки = Строка.Ссылка;
		НалогОтчет = Родитель.Ссылка;
	Иначе
		ПредметНастройки = Строка.Ссылка;
		НалогОтчет = Строка.Ссылка;
	КонецЕсли;
	
	Если Строка.Идентификатор = "БухгалтерскаяОтчетность" Тогда
		
		ПараметрыФормы.Вставить("Ключ",            КлючЗаписиРегистраСведений("УчетнаяПолитика", Организация));
		ПараметрыФормы.Вставить("АктивныйЭлемент", "ВариантБухгалтерскойОтчетности");
		
		ОткрытьФорму("РегистрСведений.УчетнаяПолитика.ФормаЗаписи", ПараметрыФормы);
		
	ИначеЕсли Строка.Идентификатор = "НалогНаПрибыль" Тогда
		
		ПараметрыФормы.Вставить("Ключ",            КлючЗаписиРегистраСведений("НастройкиУчетаНалогаНаПрибыль", Организация));
		ПараметрыФормы.Вставить("АктивныйЭлемент", "ПорядокУплатыАвансов");
		
		ОткрытьФорму("РегистрСведений.НастройкиУчетаНалогаНаПрибыль.ФормаЗаписи", ПараметрыФормы);
		
	Иначе
		
		ПараметрыФормы.Вставить("ПредметНастройки",                 ПредметНастройки);
		ПараметрыФормы.Вставить("НалогОтчет",                       НалогОтчет);
		ПараметрыФормы.Вставить("АдресЗначенияДетальнойНастройки",  АдресЗначенияДетальнойНастройки);
		ПараметрыФормы.Вставить("АдресПараметрыДетальнойНастройки", АдресПараметрыДетальнойНастройки);
		ПараметрыФормы.Вставить("ТолькоПросмотр",                   Элементы.Список.ТолькоПросмотр);
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
		
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("СписокВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("РегистрСведений.НалогиОтчеты.Форма.ДетальнаяНастройка", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.НалогУплачиваетсяНаМестах Тогда
		
		ЕстьОшибки = Ложь;
		
		Строка = Список.НайтиПоИдентификатору(Элементы.Список.ТекущаяСтрока);
		Если Строка = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Строки = Строка.ПолучитьЭлементы();
		
		Для Каждого Подстрока Из Строки Цикл
			Если НЕ ЗначениеЗаполнено(Подстрока.РегистрацияВНалоговомОргане) Тогда
				Подстрока.Включен = Ложь;
				ЕстьОшибки = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьОшибки Тогда
			ШаблонСообщения = НСтр("ru='Не заполнен код налоговой инспекции для организации %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Организация);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Организация, "КодНалоговогоОргана");
			ТекущиеДанные.Включен = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	Если Модифицированность Тогда
		
		СохранитьСписокНастройкиНалоговОтчетов();
		ОповеститьОбИзмененииНастроек();
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	Если Модифицированность Тогда
		
		СохранитьСписокНастройкиНалоговОтчетов();
		ОповеститьОбИзмененииНастроек();
		ПодготовитьФормуНастройкиСписка();
		ЗаполнитьСписокНастройкиНалоговОтчетов();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

&НаСервере
Процедура ПодготовитьФормуНастройкиСписка()
	
	Модифицированность = Ложь;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Элементы.Список.ТолькоПросмотр = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ПравоРедактированияНастроек Тогда
		Элементы.Список.ТолькоПросмотр = Истина;
	Иначе
	
		Элементы.Список.ТолькоПросмотр = Ложь;
		
		// Так как изменяем данные разных записей в одной форме, 
		// то наложим пессимистическую объектную блокировку вручную - 
		// по специальному набору измерений, который никогда не будет записан в регистр.
		ОписаниеКлюча = Новый Структура("Организация", Организация); 
		РезультатБлокировки = "";
		Попытка 
			ЗаблокироватьДанныеДляРедактирования(
				РегистрыСведений.НалогиОтчеты.СоздатьКлючЗаписи(ОписаниеКлюча),
				, // Данные не хранятся в ИБ
				УникальныйИдентификатор); // На все время жизни формы
		Исключение
			Элементы.Список.ТолькоПросмотр = Истина;
			РезультатБлокировки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокНастройкиНалоговОтчетов()
	
	Результат = ВыполнитьПолучениеДанныхНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ЗагрузитьРезультат();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиНалогОтчетВСписке(Список, Ссылка) 
	
	Для Каждого ЭлементСписка Из Список.ПолучитьЭлементы() Цикл
		
		Если ЭлементСписка.Ссылка = Ссылка Тогда
			Возврат ЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
		
		РезультатПоискаНиже = НайтиНалогОтчетВСписке(ЭлементСписка, Ссылка);
		Если РезультатПоискаНиже <> Неопределено Тогда
			Возврат РезультатПоискаНиже;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область РаботаСКоллекциямиДетальныхНастроек

&НаСервере
Процедура ОбработатьРезультатДетальнойНастройки(ИдентификаторСтроки, РезультатДетальнойНастройки)
	
	Строка = Список.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Строка.Включен Тогда
		Строка.Включен     = Истина;
	КонецЕсли;
	
	ПараметрыДетальнойНастройки = ПолучитьИзВременногоХранилища(АдресПараметрыДетальнойНастройки);
	Если Строка.Ключ = "" Тогда
		ОписаниеПараметров = ПараметрыДетальнойНастройки[Строка.Ссылка];
	Иначе
		ОписаниеПараметров = ПараметрыДетальнойНастройки[Строка.Ключ];
	КонецЕсли;
	
	// Обновим описание порядка уплаты налогов на местах
	Для ИндексПараметра = 0 По ОписаниеПараметров.ВГраница() Цикл
		Если ОписаниеПараметров[ИндексПараметра] = "ПорядокУплатыНалоговНаМестах" Тогда
			НастройкиУплатыНалога = РезультатДетальнойНастройки[ИндексПараметра];
			Если ТипЗнч(НастройкиУплатыНалога) = Тип("Структура") Тогда
				НастройкиУплатыНалога.Вставить("Описание", "");
				РегистрыСведений.ПорядокУплатыНалоговНаМестах.УстановитьОписание(НастройкиУплатыНалога);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Изменим значения во временном хранилище значений.
	ЗначенияДетальнойНастройки = ПолучитьИзВременногоХранилища(АдресЗначенияДетальнойНастройки);
	Если ЗначенияДетальнойНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Строка.Ключ = "" Тогда
		ЗначенияДетальнойНастройки.Вставить(Строка.Ссылка, РезультатДетальнойНастройки);
	Иначе
		ЗначенияДетальнойНастройки.Вставить(Строка.Ключ, РезультатДетальнойНастройки);
	КонецЕсли;
	АдресЗначенияДетальнойНастройки = ПоместитьВоВременноеХранилище(ЗначенияДетальнойНастройки, УникальныйИдентификатор);
	
	// Обновим представление детальной настройки
	Строка.ДетальнаяНастройкаПредставление = РегистрыСведений.НалогиОтчеты.ПредставлениеДетальнойНастройки(
		ОписаниеПараметров,
		РезультатДетальнойНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область СохранениеРезультатовРаботы

&НаКлиенте
Процедура СохранитьСписокНастройкиНалоговОтчетов()
	
	Результат = ВыполнитьЗаписьДанныхНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданияПриЗаписи", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		Модифицированность = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Включен
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Включен");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.ВключаетсяПользователем", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбИзмененииНастроек()
	
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НалогиОтчеты"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ПорядокУплатыАкцизов"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ПорядокУплатыНалоговНаМестах"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ВариантыПримененияТребованийЗаконодательства"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.ЗадачиБухгалтера"));
	Оповестить("Обновить дерево отчетов", "Обновить дерево отчетов", ЭтаФорма); // На языке регламентированной отчетности
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КлючЗаписиРегистраСведений(ИмяРегистра, Организация)
	
	Возврат НастройкиУчета.КлючЗаписиДействующейУчетнойПолитики(ИмяРегистра, Организация);
	
КонецФункции

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		СохранитьСписокНастройкиНалоговОтчетов();
		ОповеститьОбИзмененииНастроек();
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиУчетаНалогаНаПрибыль()
	
	Для Каждого ЭлементДерева Из Список.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.Наименование = "Налог на прибыль" Тогда
			
			ЭлементДерева.ДетальнаяНастройкаПредставление = НСтр("ru = 'Уплата авансов: '") +
				Строка(РегистрыСведений.НастройкиУчетаНалогаНаПрибыль.ПорядокУплатыАвансовДействующейНастройки(Организация));
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиУчетнойПолитики()
	
	Для Каждого ЭлементДерева Из Список.ПолучитьЭлементы() Цикл
		Если ЭлементДерева.Наименование = "Бухгалтерская отчетность" Тогда
			
			ЭлементДерева.ДетальнаяНастройкаПредставление = НСтр("ru = 'Состав форм: '") +
				Строка(РегистрыСведений.УчетнаяПолитика.ВариантБухгалтерскойОтчетностиДействующейУчетнойПолитики(Организация));
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбновилисьДанныеОрганизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьСписокНастройкиНалоговОтчетов();
		ОповеститьОбИзмененииНастроек();
	КонецЕсли;
	
	ПодготовитьФормуНастройкиСписка();
	ЗаполнитьСписокНастройкиНалоговОтчетов();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	РазблокироватьДанныеДляРедактирования(, УникальныйИдентификатор); // Все разблокируем
	Если ПустаяСтрока(РезультатБлокировки) Тогда
		ПодготовитьФормуНастройкиСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
	
	РезультатДетальнойНастройки = РезультатЗакрытия;
	
	Если ТипЗнч(РезультатДетальнойНастройки) = Тип("Массив") Тогда
		Модифицированность = Истина;
		ОбработатьРезультатДетальнойНастройки(ВыбраннаяСтрока, РезультатДетальнойНастройки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДлительныеОперации

&НаСервере
Функция ВыполнитьПолучениеДанныхНаСервере()
	
	// Запомним, на какой строке стоял курсор - потом оставим его на этой же
	ТекущаяСтрока = Неопределено;
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		Строка = Список.НайтиПоИдентификатору(Элементы.Список.ТекущаяСтрока);
		Если Строка <> Неопределено Тогда
			ТекущаяСтрока = Строка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация", Организация);
	ПараметрыЗаполнения.Вставить("Дерево",      РеквизитФормыВЗначение("Список"));
	
	НаименованиеЗадания = НСтр("ru = 'Настройка списка налогов и отчетов: получение данных'");
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"РегистрыСведений.НалогиОтчеты.ПодготовитьДанные", 
			ПараметрыЗаполнения, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВыполнитьЗаписьДанныхНаСервере()
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация",                 Организация);
	ПараметрыЗаполнения.Вставить("Дерево",                      РеквизитФормыВЗначение("Список"));
	ПараметрыЗаполнения.Вставить("ЗначенияДетальнойНастройки",  ПолучитьИзВременногоХранилища(АдресЗначенияДетальнойНастройки));
	ПараметрыЗаполнения.Вставить("ПараметрыДетальнойНастройки", ПолучитьИзВременногоХранилища(АдресПараметрыДетальнойНастройки));
	
	НаименованиеЗадания = НСтр("ru = 'Настройка списка налогов и отчетов: запись данных'");
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"РегистрыСведений.НалогиОтчеты.ЗаписатьДанные", 
			ПараметрыЗаполнения, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии()
	
	Попытка
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗаданияПриОткрытии", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияПриЗаписи()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			Модифицированность = Ложь;
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗаданияПриЗаписи", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ЗначениеВРеквизитФормы(Результат.Дерево, "Список");
		
		АдресПараметрыДетальнойНастройки = ПоместитьВоВременноеХранилище(Результат.ПараметрыДетальнойНастройки, УникальныйИдентификатор);
		АдресЗначенияДетальнойНастройки  = ПоместитьВоВременноеХранилище(Результат.ЗначенияДетальнойНастройки,  УникальныйИдентификатор);
		
		// Восстановим положение курсора
		Если ТекущаяСтрока <> Неопределено Тогда
			// Поиск по коллекции рекурсивным перебором
			ИдентификаторСтроки = НайтиНалогОтчетВСписке(Список, ТекущаяСтрока);
			Если ИдентификаторСтроки <> Неопределено Тогда
				Строка = Список.НайтиПоИдентификатору(ИдентификаторСтроки);
				Элементы.Список.ТекущаяСтрока = ИдентификаторСтроки;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

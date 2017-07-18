﻿#Область ОбработчикиСобытийФормы

// Заполняет поля формы по переданным в форму параметрам.
//
// В форму могут передаваться следующие параметры:
// УчетнаяЗапись* - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты, список - 
//               ссылка на учетную запись, которая будет использоваться
//               при отправке сообщения, либо список из учетных записей (для выбора).
// Вложения      - соответствие - вложения в письмо, где
//                 ключ     - имя файла
//                 значение - двоичные данные файла.
// Тема          - строка - тема письма.
// Тело          - строка - тело письма.
// Кому          - соответствие/строка - адресаты письма
//                 если тип соответствие, то
//                 ключ     - строка - Имя адресата
//                 значение - строка - электронный адрес в формате addr@server.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВложенияДляПисьма = Новый Структура;
	
	Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Или ТипЗнч(Параметры.Вложения) = Тип("Массив") Тогда
		Для Каждого Вложение Из Параметры.Вложения Цикл
			Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Тогда
				ОписаниеВложения = Вложения.Добавить();
				ОписаниеВложения.Представление = Вложение.Представление;
				Если ТипЗнч(Вложение.Значение) = Тип("ДвоичныеДанные") Тогда
					ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Вложение.Значение, УникальныйИдентификатор);
				Иначе
					Если ЭтоАдресВременногоХранилища(Вложение.Значение) Тогда
						ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(Вложение.Значение), УникальныйИдентификатор);
					Иначе
						ОписаниеВложения.ПутьКФайлу = Вложение.Значение;
					КонецЕсли;
				КонецЕсли;
			Иначе // ТипЗнч(Параметры.Вложения) = "массив структур"
				Если Вложение.Свойство("Идентификатор") И ЗначениеЗаполнено(Вложение.Идентификатор) Тогда
					КартинкаВложение = Новый Картинка(ПолучитьИзВременногоХранилища(Вложение.АдресВоВременномХранилище));
					ВложенияДляПисьма.Вставить(Вложение.Представление, КартинкаВложение);
				Иначе
					ОписаниеВложения = Вложения.Добавить();
					ЗаполнитьЗначенияСвойств(ОписаниеВложения, Вложение);
					Если Не ПустаяСтрока(ОписаниеВложения.АдресВоВременномХранилище) Тогда
						ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
							ПолучитьИзВременногоХранилища(ОписаниеВложения.АдресВоВременномХранилище), УникальныйИдентификатор);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТемаПисьма = Параметры.Тема;
	ТелоПисьма.УстановитьHTML(ТекстВHTML(Параметры.Тело), ВложенияДляПисьма);
	АдресОтвета = Параметры.АдресОтвета;
	
	// Обработка сложных параметров формы (составного типа).
	// УчетнаяЗапись, Кому.
	
	Если НЕ ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Тогда
		// Учетная запись не передана - выбираем первую доступную.
		ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
		Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			Возврат;
		КонецЕсли;
		
		УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка;
		
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		УчетнаяЗапись = Параметры.УчетнаяЗапись;
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СписокЗначений") Тогда
		НаборУчетныхЗаписей = Параметры.УчетнаяЗапись;
		
		Если НаборУчетныхЗаписей.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны учетные записи для отправки сообщения, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементУчетнаяЗапись Из НаборУчетныхЗаписей Цикл
			Элементы.УчетнаяЗапись.СписокВыбора.Добавить(
										ЭлементУчетнаяЗапись.Значение,
										ЭлементУчетнаяЗапись.Представление);
			Если ЭлементУчетнаяЗапись.Значение.ИспользоватьДляПолучения Тогда
				АдресаОтветаПоУчетнымЗаписям.Добавить(ЭлементУчетнаяЗапись.Значение,
														ПолучитьПочтовыйАдресПоУчетнойЗаписи(ЭлементУчетнаяЗапись.Значение));
			КонецЕсли;
		КонецЦикла;
		
		Элементы.УчетнаяЗапись.СписокВыбора.СортироватьПоПредставлению();
		УчетнаяЗапись = НаборУчетныхЗаписей[0].Значение;
		
		// Для переданного списка учетных записей выбираем их из списка выбора.
		Элементы.УчетнаяЗапись.КнопкаВыпадающегоСписка = Истина;
	
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Кому) = Тип("СписокЗначений") Тогда
		ПочтовыйАдресПолучателя = "";
		Для Каждого ЭлементПочтовыйАдрес Из Параметры.Кому Цикл
			Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) Тогда 
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя
										+ ЭлементПочтовыйАдрес.Представление
										+ " <"
										+ ЭлементПочтовыйАдрес.Значение
										+ ">; "
			Иначе
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя 
										+ ЭлементПочтовыйАдрес.Значение
										+ "; ";
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Строка") Тогда
		ПочтовыйАдресПолучателя = Параметры.Кому;
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Массив") Тогда
		Если Параметры.Кому.Количество() > 1 Тогда
			Элементы.ЭлектронныйАдресКому.КнопкаВыбора = Истина;
		КонецЕсли;
		Для Каждого СтруктураПолучателя Из Параметры.Кому Цикл
			ЕстьСвойствоВыбран = СтруктураПолучателя.Свойство("Выбран");
			МассивАдресов = СтрРазделить(СтруктураПолучателя.Адрес, ";");
			Для Каждого Адрес Из МассивАдресов Цикл
				Если ПустаяСтрока(Адрес) Тогда 
					Продолжить;
				КонецЕсли;
				Если (ЕстьСвойствоВыбран И СтруктураПолучателя.Выбран) ИЛИ (НЕ ЕстьСвойствоВыбран) Тогда
					ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя + СтруктураПолучателя.Представление + " <" + СокрЛП(Адрес) + ">; ";
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Кому) = Тип("Массив") Тогда
		ПолучателиСообщения = ПоместитьВоВременноеХранилище(Параметры.Кому, УникальныйИдентификатор);
	Иначе
		ПолучателиСообщения = ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор);
	КонецЕсли;
	
	Параметры.Свойство("АдресПолучателяСкрытойКопии", АдресПолучателяСкрытойКопии);
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма", 
		"СписокАдресовОтвета");
	
	Если СписокАдресовОтвета <> Неопределено И СписокАдресовОтвета.Количество() > 0 Тогда
		Для Каждого ЭлементаАдресОтвета Из СписокАдресовОтвета Цикл
			Элементы.АдресОтвета.СписокВыбора.Добавить(ЭлементаАдресОтвета.Значение, ЭлементаАдресОтвета.Представление);
		КонецЦикла;
		
		Элементы.АдресОтвета.КнопкаВыпадающегоСписка = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	Иначе
		Если УчетнаяЗапись.ИспользоватьДляПолучения Тогда
			// Устанавливаем почтовый адрес по умолчанию.
			Если ЗначениеЗаполнено(УчетнаяЗапись.ИмяПользователя) Тогда 
				АдресОтвета = УчетнаяЗапись.ИмяПользователя + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">";
			Иначе
				АдресОтвета = УчетнаяЗапись.АдресЭлектроннойПочты;
			КонецЕсли;
		КонецЕсли;
		
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтаФорма,
		"БП.ОбщаяФорма.ОтправкаСообщения",
		"Форма",
		НСтр("ru='Новости: Работа с электронной почтой'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	ЗагрузитьВложенияИзФайлов();
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ВыборПолучателейСообщения" И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПочтовыйАдресПолучателя = ВыбранноеЗначение.ПочтовыйАдресПолучателя;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Не ТребуетсяПодтверждениеЗакрытияФормы Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПоказатьВопросПередЗакрытиемФормы", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Подставляет адрес ответа, если флаг автоматической подстановки ответа установлен.
//
&НаКлиенте
Процедура УчетнаяЗаписьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ПустаяСтрока(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
			АдресОтвета = АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение).Представление;
		Иначе
			АдресОтвета = ПолучитьПочтовыйАдресПоУчетнойЗаписи(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектронныйАдресКомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПолучателиСообщения", ПолучателиСообщения);
	ПараметрыФормы.Вставить("ПочтовыйАдресПолучателя", Элемент.ТекстРедактирования);
	ОткрытьФорму("ОбщаяФорма.ВыборПолучателейСообщения", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПризнакМодифицированностиФормы(Элемент)
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

// Удаляет вложение из списка, а так же вызывает функцию
// обновления таблицы представления вложений.
//
&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	НаименованиеВложения = Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя];
	
	Для Каждого Вложение Из Вложения Цикл
		Если Вложение.Представление = НаименованиеВложения Тогда
			Вложения.Удалить(Вложение);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияПеретаскиваниеЗавершение", ЭтотОбъект, Новый Структура("Имя", ПараметрыПеретаскивания.Значение.Имя));
		НачатьПомещениеФайла(ОписаниеОповещения, , ПараметрыПеретаскивания.Значение.ПолноеИмя, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	АдресОтвета = ПолучитьПриведенныйПочтовыйАдресВФормате(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета, Ложь);
	
	Для Каждого ЭлементаАдресОтвета Из Элементы.АдресОтвета.СписокВыбора Цикл
		Если ЭлементаАдресОтвета.Значение = АдресОтвета
		   И ЭлементаАдресОтвета.Представление = АдресОтвета Тогда
			Элементы.АдресОтвета.СписокВыбора.Удалить(ЭлементаАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	АдресОтвета = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмо()
	
	ОчиститьСообщения();
	
	Если ОтправитьПочтовоеСообщение() Тогда
		СохранитьАдресОтвета(АдресОтвета);
		Состояние(НСтр("ru = 'Сообщение успешно отправлено'"));
		ТребуетсяПодтверждениеЗакрытияФормы = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложитьФайлВыполнить()
	
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОтправитьПочтовоеСообщение()
	ПараметрыПисьма = СформироватьПараметрыПисьма();
	Если ПараметрыПисьма = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПочтовыйАдресПоУчетнойЗаписи(Знач УчетнаяЗапись)
	
	Возврат СокрЛП(УчетнаяЗапись.ИмяПользователя)
			+ ? (ПустаяСтрока(СокрЛП(УчетнаяЗапись.ИмяПользователя)),
					УчетнаяЗапись.АдресЭлектроннойПочты,
					" <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">");
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВложение()
	
	ВыбранноеВложение = ВыбранноеВложение();
	Если ВыбранноеВложение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ПолучитьФайл(ВыбранноеВложение.АдресВоВременномХранилище, ВыбранноеВложение.Представление, Истина);
	#Иначе
		ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ИмяВременнойПапки);
		
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ВыбранноеВложение.Представление;
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВыбранноеВложение.АдресВоВременномХранилище);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		Файл = Новый Файл(ИмяВременногоФайла);
		Файл.УстановитьТолькоЧтение(Истина);
		Если Файл.Расширение = ".mxl" Тогда
			ТабличныйДокумент = ПолучитьТабличныйДокументПоДвоичнымДанным(ВыбранноеВложение.АдресВоВременномХранилище);
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("ИмяДокумента", ВыбранноеВложение.Представление);
			ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
			ПараметрыОткрытия.Вставить("ПутьКФайлу", ИмяВременногоФайла);
			ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Иначе
			ЗапуститьПриложение(ИмяВременногоФайла);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранноеВложение()
	
	Результат = Неопределено;
	Если Элементы.Вложения.ТекущиеДанные <> Неопределено Тогда
		НаименованиеВложения = Элементы.Вложения.ТекущиеДанные[Элементы.Вложения.ТекущийЭлемент.Имя];
		Для Каждого Вложение Из Вложения Цикл
			Если Вложение.Представление = НаименованиеВложения Тогда
				Результат = Вложение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТабличныйДокументПоДвоичнымДанным(Знач ДвоичныеДанные)
	
	Если ТипЗнч(ДвоичныеДанные) = Тип("Строка") Тогда
		// Передан адрес двоичных данных во временном хранилище.
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДвоичныеДанные);
	КонецЕсли;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение табличного документа'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьФайлВоВложения()
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Открытие);
	ПараметрыДиалога.Вставить("МножественныйВыбор", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);
	СтандартныеПодсистемыКлиент.ПоказатьПомещениеФайла(ОписаниеОповещения, УникальныйИдентификатор, "", ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ДобавитьФайлыВСписок(ПомещенныеФайлы);
	ОбновитьПредставлениеВложений();
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписок(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		Файл = Новый Файл(ОписаниеФайла.Имя);
		Вложение = Вложения.Добавить();
		Вложение.Представление = Файл.Имя;
		Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение), УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеВложений()
	
	ПредставлениеВложений.Очистить();
	
	Индекс = 0;
	
	Для Каждого Вложение Из Вложения Цикл
		Если Индекс = 0 Тогда
			СтрокаПредставления = ПредставлениеВложений.Добавить();
		КонецЕсли;
		
		СтрокаПредставления["Вложение" + Строка(Индекс + 1)] = Вложение.Представление;
		
		Индекс = Индекс + 1;
		Если Индекс = 2 Тогда 
			Индекс = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет возможность отправления письма и если
// это возможно - формирует параметры отправки.
//
&НаСервере
Функция СформироватьПараметрыПисьма()
	
	ПараметрыПисьма = Новый Структура;
	
	СписокПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(ПочтовыйАдресПолучателя);
	Кому = Новый Массив;
	Для Каждого Получатель Из СписокПолучателей Цикл
		Если Не ПустаяСтрока(Получатель.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Получатель.ОписаниеОшибки, , "ПочтовыйАдресПолучателя");
			Возврат Неопределено;
		КонецЕсли;
		Кому.Добавить(Новый Структура("Адрес, Представление", Получатель.Адрес, Получатель.Псевдоним));
	КонецЦикла;
		
	Если ЗначениеЗаполнено(Кому) Тогда
		ПараметрыПисьма.Вставить("Кому", Кому);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Необходимо заполнить получателя письма'"), , "ПочтовыйАдресПолучателя");
		Возврат Неопределено;
	КонецЕсли;
	
	СписокПолучателей = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(АдресОтвета);
	Кому = Новый Массив;
	Для Каждого Получатель Из СписокПолучателей Цикл
		Если Не ПустаяСтрока(Получатель.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Получатель.ОписаниеОшибки, , "АдресОтвета");
			Возврат Неопределено;
		КонецЕсли;
		Кому.Добавить(Новый Структура("Адрес, Представление", Получатель.Адрес, Получатель.Псевдоним));
	КонецЦикла;
	
	Если ЗначениеЗаполнено(АдресПолучателяСкрытойКопии) Тогда
		ПараметрыПисьма.Вставить("СлепыеКопии", АдресПолучателяСкрытойКопии);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		ПараметрыПисьма.Вставить("АдресОтвета", АдресОтвета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТемаПисьма) Тогда
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПолучателиСообщения) Тогда
		ПараметрыПисьма.Вставить("ПолучателиСообщения", ПолучитьИзВременногоХранилища(ПолучателиСообщения));
	КонецЕсли;
	
	СодержимоеПисьма = ПолучитьHTMLФорматированногоДокументаДляПисьма(ТелоПисьма);
	ТекстHTML = СодержимоеПисьма.ТекстHTML;
	Картинки = СодержимоеПисьма.Картинки;
	
	ПараметрыПисьма.Вставить("Тело", ТекстHTML);
	ПараметрыПисьма.Вставить("ТипТекста", "HTML");
	ПараметрыПисьма.Вставить("Вложения", Вложения());
	
	Для Каждого Картинка Из Картинки Цикл
		ИмяКартинки = Картинка.Ключ;
		ДанныеКартинки = Картинка.Значение;
		
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", ИмяКартинки);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", ПоместитьВоВременноеХранилище(ДанныеКартинки.ПолучитьДвоичныеДанные()));
		ОписаниеВложения.Вставить("Кодировка", "");
		ОписаниеВложения.Вставить("Идентификатор", ИмяКартинки);
		ПараметрыПисьма.Вложения.Добавить(ОписаниеВложения);
	КонецЦикла;
	
	Возврат ПараметрыПисьма;
	
КонецФункции

&НаСервере
Функция ПолучитьHTMLФорматированногоДокументаДляПисьма(ФорматированныйДокумент)
	
	// Выгрузка форматированного документа в HTML текст и картинки.
	ТекстHTML = "";
	Картинки = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, Картинки);
	
	// Конвертация HTML текста в ДокументHTML.
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	
	// Замена имен картинок в документе HTML на идентификаторы.
	Для Каждого Картинка Из ДокументHTML.Картинки Цикл
		АтрибутИсточникКартинки = Картинка.Атрибуты.ПолучитьИменованныйЭлемент("src");
		АтрибутИсточникКартинки.ТекстовоеСодержимое = "cid:" + АтрибутИсточникКартинки.ТекстовоеСодержимое;
	КонецЦикла;
	
	// Конвертация ДокументHTML обратно в текст HTML.
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML, ЗаписьHTML);
	ТекстHTML = ЗаписьHTML.Закрыть();
	
	// Подготовка результата.
	Результат = Новый Структура;
	Результат.Вставить("ТекстHTML", ТекстHTML);
	Результат.Вставить("Картинки", Картинки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТекстВHTML(Текст)
	
	Если СтрНайти(НРег(Текст), "</html>", НаправлениеПоиска.СКонца) > 0 Тогда
		Возврат Текст;
	КонецЕсли;
	
	ДокументHTML = Новый ДокументHTML;
	
	ЭлементТело = ДокументHTML.СоздатьЭлемент("body");
	ДокументHTML.Тело = ЭлементТело;
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(Текст) Цикл
		Строка = СтрПолучитьСтроку(Текст, НомерСтроки);
		
		ЭлементБлок = ДокументHTML.СоздатьЭлемент("p");
		ЭлементТело.ДобавитьДочерний(ЭлементБлок);
		
		ЭлементТекст = ДокументHTML.СоздатьТекстовыйУзел(Строка);
		ЭлементБлок.ДобавитьДочерний(ЭлементТекст);
	КонецЦикла;
	
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьHTML = Новый ЗаписьHTML;
	ЗаписьHTML.УстановитьСтроку();
	ЗаписьDOM.Записать(ДокументHTML, ЗаписьHTML);
	Результат = ЗаписьHTML.Закрыть();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция Вложения()
	
	Результат = Новый Массив;
	Для Каждого Вложение Из Вложения Цикл
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", Вложение.Представление);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", Вложение.АдресВоВременномХранилище);
		ОписаниеВложения.Вставить("Кодировка", Вложение.Кодировка);
		ОписаниеВложения.Вставить("Идентификатор", Вложение.Идентификатор);
		Результат.Добавить(ОписаниеВложения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений.
//
&НаСервереБезКонтекста
Функция СохранитьАдресОтвета(Знач АдресОтвета)
	
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета);
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений.
//
&НаСервереБезКонтекста
Функция АктуализироватьАдресОтветаВХранимомСписке(Знач АдресОтвета,
                                                   Знач ДобавлятьАдресВСписок = Истина)
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета");
	
	Если СписокАдресовОтвета = Неопределено Тогда
		СписокАдресовОтвета = Новый СписокЗначений();
	КонецЕсли;
	
	Для Каждого ЭлементАдресОтвета Из СписокАдресовОтвета Цикл
		Если ЭлементАдресОтвета.Значение = АдресОтвета
		   И ЭлементАдресОтвета.Представление = АдресОтвета Тогда
			СписокАдресовОтвета.Удалить(ЭлементАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавлятьАдресВСписок
	   И ЗначениеЗаполнено(АдресОтвета) Тогда
		СписокАдресовОтвета.Вставить(0, АдресОтвета, АдресОтвета);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета",
		СписокАдресовОтвета);
	
КонецФункции

&НаКлиенте
Функция ПолучитьПриведенныйПочтовыйАдресВФормате(Текст)
	АдресаСтрокой = "";
	Адреса = ОбщегоНазначенияКлиентСервер.АдресаЭлектроннойПочтыИзСтроки(Текст);
	
	Если Адреса.Количество() > 1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Можно указывать только один адрес для ответа.'"), , "АдресОтвета");
		СтандартнаяОбработка = Ложь;
		Возврат Текст;
	КонецЕсли;
	
	Для Каждого ОписаниеАдреса Из Адреса Цикл
		Если Не ПустаяСтрока(ОписаниеАдреса.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеАдреса.ОписаниеОшибки, , "АдресОтвета");
		КонецЕсли;
		
		Если Не ПустаяСтрока(АдресаСтрокой) Тогда
			АдресаСтрокой = АдресаСтрокой + "; ";
		КонецЕсли;
		АдресаСтрокой = АдресаСтрокой + АдресСтрокой(ОписаниеАдреса);
	КонецЦикла;
	
	Возврат АдресаСтрокой;
КонецФункции

&НаКлиенте
Функция АдресСтрокой(ОписаниеАдреса)
	Результат = "";
	Если ПустаяСтрока(ОписаниеАдреса.Псевдоним) Тогда
		Результат = ОписаниеАдреса.Адрес;
	Иначе
		Если ПустаяСтрока(ОписаниеАдреса.Адрес) Тогда
			Результат = ОписаниеАдреса.Псевдоним;
		Иначе
			Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1 <%2>", ОписаниеАдреса.Псевдоним, ОписаниеАдреса.Адрес);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ВложенияПеретаскиваниеЗавершение(Результат, АдресВременногоХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	Файлы = Новый Массив;
	ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.Имя, АдресВременногоХранилища);
	Файлы.Добавить(ПередаваемыйФайл);
	ДобавитьФайлыВСписок(Файлы);
	ОбновитьПредставлениеВложений();
	ТребуетсяПодтверждениеЗакрытияФормы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВложенияИзФайлов()
	
	Для Каждого Вложение Из Вложения Цикл
		Если Не ПустаяСтрока(Вложение.ПутьКФайлу) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(Вложение.ПутьКФайлу);
			Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПередЗакрытиемФормы()
	ТекстВопроса = НСтр("ru = 'Сообщение еще не отправлено. Закрыть форму?'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакрытиеФормыПодтверждено", ЭтотОбъект);
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Не закрывать'"));
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,,
		КодВозвратаДиалога.Отмена, НСтр("ru = 'Отправка сообщения'"));
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФормыПодтверждено(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ТребуетсяПодтверждениеЗакрытияФормы = Ложь;
	Закрыть();
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);
	
КонецПроцедуры

#КонецОбласти

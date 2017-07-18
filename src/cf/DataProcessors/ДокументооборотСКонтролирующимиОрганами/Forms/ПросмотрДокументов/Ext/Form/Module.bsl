﻿&НаСервере
Перем Макет;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Документ = Параметры.Документ;
	Идентификатор = Параметры.Идентификатор;
	МаксимальныйРазмерФайла = Параметры.МаксимальныйРазмерФайла;
	МаксимальныйРазмерВсехФайлов = Параметры.МаксимальныйРазмерВсехФайлов;
	ДопустимыеТипыФайлов = Параметры.ДопустимыеТипыФайлов;
	РежимТолькоПросмотр = Параметры.РежимТолькоПросмотр;
	ИспользоватьСтраницы = Параметры.ИспользоватьСтраницы;
	Требования = Параметры.Требования;
	
	Для Каждого Файл Из Параметры.Файлы Цикл
		НоваяСтрока = Файлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Файл);
		НоваяСтрока.Состояние = "Пусто";
	КонецЦикла;
	НоваяСтрока = Файлы.Добавить();
	НоваяСтрока.Состояние = "Пусто";
	
	ОбновитьПревью();
	
	Заголовок = Документ;
	
	Превью.ТолькоПросмотр = Ложь;
	
	Элементы.КоманднаяПанель.Видимость = Не РежимТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПревьюВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если ТипЗнч(Область) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		Ячейка = ОпределитьЯчейкуПоКоординатам(Область.Верх, Область.Лево);
			
		Если Область.Текст = "удалить" Тогда
			Файлы.Удалить(Ячейка);
			ОбновитьПревью();
		ИначеЕсли СтрНайти(Область.Текст, "добавить") Тогда
			ДобавитьФайлы(Ячейка);
		ИначеЕсли СтрНайти(Область.Текст, "открыть") Тогда
			ПолучитьФайл(Файлы[Ячейка].Адрес, Файлы[Ячейка].ИсходноеИмя, Истина);			
		КонецЕсли;
	ИначеЕсли ТипЗнч(Область) = Тип("РисунокТабличногоДокумента") Тогда
		ПоказатьЗначение(, Область.Картинка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПревьюПриИзмененииСодержимогоОбласти(Элемент, Область)
	
	Ячейка = ОпределитьЯчейкуПоКоординатам(Область.Верх, Область.Лево);
	Если Область.Лево = 5 ИЛИ Область.Лево = 17 Тогда
		Файлы[Ячейка].Страница1 = Область.Значение;	
	ИначеЕсли Область.Лево = 7 ИЛИ Область.Лево = 19 Тогда
		Файлы[Ячейка].Страница2 = Область.Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьФайл(Команда)

	ДобавитьФайлы(Файлы.Количество() - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьТребованияКИзображениямНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ДокументооборотСКонтролирующимиОрганами.Форма.ТребованияКИзображениямУниверсальная", Требования, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если РежимТолькоПросмотр Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	КоличествоЗаполненныхСтраниц = 0;
	ВсегоЯчеек = 0;
	
	ПараметрыФайлов = Новый Массив;
	Файлы.Сортировать("Страница1 Возр");
	Для Каждого Файл Из Файлы Цикл
		Если Файл.Состояние = "Отображение" Тогда
			ПараметрыФайла = Новый Структура("Файл,Адрес,ИсходноеИмя,Размер,Страница1,Страница2,Расширение");
			ЗаполнитьЗначенияСвойств(ПараметрыФайла, Файл);
			
			ПараметрыФайлов.Добавить(ПараметрыФайла);
			КоличествоЗаполненныхСтраниц = КоличествоЗаполненныхСтраниц + ЗначениеЗаполнено(Файл.Страница1);
			ВсегоЯчеек = ВсегоЯчеек + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если ВсегоЯчеек > 1 И ВсегоЯчеек <> КоличествоЗаполненныхСтраниц И ИспользоватьСтраницы Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнены номера страниц'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Закрыть(ПараметрыФайлов);		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьПревью()
	
	Превью.Очистить();
	ВывестиПустыеЯчейки();
	
	Для Ячейка = 0 По Файлы.Количество() - 2 Цикл
		ПерейтиВСостояниеОтображение(Ячейка);
	КонецЦикла;
	
	Если Не РежимТолькоПросмотр Тогда
		ПерейтиВСостояниеДобавление(Файлы.Количество() - 1);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлы(Ячейка)
	
	Контекст = Новый Структура("Ячейка", Ячейка);
	
	ПараметрыДобавления = Новый Структура;
	ПараметрыДобавления.Вставить("МаксимальныйРазмерФайла", МаксимальныйРазмерФайла);
	ПараметрыДобавления.Вставить("ВозвращатьРазмер", Истина);
	ПараметрыДобавления.Вставить("ДопустимыеТипыФайлов", ДопустимыеТипыФайлов);
	
	Оповещение = Новый ОписаниеОповещения("ДобавитьФайлыПослеПомещенияФайлов", ЭтотОбъект, Контекст);
	ОперацииСФайламиЭДКОКлиент.ДобавитьФайлы(Оповещение, Идентификатор,
		СтрШаблон(НСтр("ru = 'Выберите сканы документа <%1> '"), Документ), ПараметрыДобавления);

КонецПроцедуры
	
&НаКлиенте
Процедура ДобавитьФайлыПослеПомещенияФайлов(Результат, ВходящийКонтекст) Экспорт

	ДопустимыеТипы = СтрРазделить(ДопустимыеТипыФайлов, ";");
	Если Результат.Выполнено И ЗначениеЗаполнено(Результат.ОписанияФайлов) Тогда
		Файлы.Удалить(Файлы.Количество() - 1);
		Для Каждого ОписаниеФайла Из Результат.ОписанияФайлов Цикл
			НоваяСтрока = Файлы.Добавить();
			НоваяСтрока.Адрес       = ОписаниеФайла.Адрес;
			НоваяСтрока.ИсходноеИмя = ОписаниеФайла.Имя;
			НоваяСтрока.Размер      = ОписаниеФайла.Размер;
			НоваяСтрока.Состояние   = "Отображение";
		КонецЦикла;
		
		НоваяСтрока = Файлы.Добавить();
		НоваяСтрока.Состояние = "Добавление";
		ОбновитьПревью();
	КонецЕсли;     	
	
КонецПроцедуры
	
&НаСервере
Функция ПолучитьОсновнойМакет()
	
	Если Макет = Неопределено Тогда
		Макет = Обработки.ДокументооборотСКонтролирующимиОрганами.ПолучитьМакет("ЯчейкиПросмотраФайлов");
	КонецЕсли;
	
	Возврат Макет;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ШиринаЯчейки()
	
	Возврат 12;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВысотаЯчейки()
	
	Возврат 23;
	
КонецФункции

&НаСервере
Процедура ПерейтиВСостояниеДобавление(Ячейка)
	
	ПараметрыЯчейки = Файлы[Ячейка];

	Строка = ?(ИспользоватьСтраницы, "Ячейки", "ЯчейкиБезСтраниц");
	ОбластьДляВывода = ПолучитьОсновнойМакет().ПолучитьОбласть(Строка + "|Добавление");
	ПоместитьЯчейкуВТабличныйДокумент(Ячейка, ОбластьДляВывода.Область(1, 1, ВысотаЯчейки(), ШиринаЯчейки()));
	
	ПараметрыЯчейки.Состояние = "Добавление";
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиВСостояниеОтображение(Ячейка)
	
	ПараметрыЯчейки = Файлы[Ячейка];

	ДвоичныеДанныеКартинки = ПолучитьИзВременногоХранилища(ПараметрыЯчейки.Адрес);
	ПараметрыЯчейки.Размер = ДвоичныеДанныеКартинки.Размер();
	Картинка = Новый Картинка(ДвоичныеДанныеКартинки);	
	ПараметрыЯчейки.Формат = Картинка.Формат();
	
	Строка = ?(ИспользоватьСтраницы, "Ячейки", "ЯчейкиБезСтраниц");

	Если Картинка.Формат() = ФорматКартинки.НеизвестныйФормат Тогда
		ОбластьДляВывода = ПолучитьОсновнойМакет().ПолучитьОбласть(Строка + "|ОтображениеНедоступно");
	Иначе
		ОбластьДляВывода = ПолучитьОсновнойМакет().ПолучитьОбласть(Строка + "|Отображение");
	КонецЕсли;
			
	Если Картинка.Формат() <> ФорматКартинки.НеизвестныйФормат Тогда
		НовыйРисунок = ОбластьДляВывода.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		НовыйРисунок.Картинка = Картинка;
		НовыйРисунок.РазмерКартинки = РазмерКартинки.АвтоРазмер;
		НовыйРисунок.ЦветЛинии = Новый Цвет(192, 192, 192);
		НовыйРисунок.Расположить(ОбластьДляВывода.Область("R5C2:R22C11"));		
	КонецЕсли;
	ОбластьДляВывода.Параметры.Заполнить(Новый Структура("ИсходноеИмя", ПараметрыЯчейки.ИсходноеИмя));	
	ОбластьДляВывода.Область("R3C5").АвтоОтметкаНезаполненного = Файлы.Количество() > 2;	
		
	ОбластьДляВывода.Параметры.Размер = ОбщегоНазначенияЭДКОКлиентСервер.ТекстовоеПредставлениеРазмераФайла(ПараметрыЯчейки.Размер);
	ОбластьДляВывода.Параметры.ПорядковыйНомер = Ячейка + 1;
	
	Если ИспользоватьСтраницы Тогда
		ОбластьДляВывода.Область("R3C5").Значение = ПараметрыЯчейки.Страница1; 
		ОбластьДляВывода.Область("R3C7").Значение = ПараметрыЯчейки.Страница2;
	КонецЕсли;

	Если РежимТолькоПросмотр Тогда
		ОбластьДляВывода.Область("R3C5").Защита = Истина;
		ОбластьДляВывода.Область("R3C7").Защита = Истина;
		ОбластьДляВывода.Область("R2C8:R4C11").Объединить();
	КонецЕсли;
		
	ПоместитьЯчейкуВТабличныйДокумент(Ячейка, ОбластьДляВывода.Область(1, 1, ВысотаЯчейки(), ШиринаЯчейки()));
	
	ПараметрыЯчейки.Состояние = "Отображение";
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьЯчейкуВТабличныйДокумент(Ячейка, Область)
	
	Строка = ?((Ячейка + 1) % 2 = 0, (Ячейка + 1) / 2, (Ячейка + 2) / 2);
	НомерСтроки = ВысотаЯчейки() * (Строка - 1) + 1;
	Если Ячейка % 2 = 0 Тогда
		НомерКолонки = 1;
	Иначе
		НомерКолонки = ШиринаЯчейки() + 1;
	КонецЕсли;
	
	Приемник = Превью.Область(НомерСтроки, НомерКолонки, 
		НомерСтроки + ВысотаЯчейки(), НомерКолонки + ШиринаЯчейки());
	Превью.ВставитьОбласть(Область, Приемник, ТипСмещенияТабличногоДокумента.БезСмещения, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьЯчейкуПоКоординатам(Верх, Лево)
	
	КоличествоСтрок = (Верх - Верх % ВысотаЯчейки()) / ВысотаЯчейки();
	Строка = ?(Верх % ВысотаЯчейки() = 0, КоличествоСтрок, КоличествоСтрок + 1);
	Колонка = ?(Лево > ШиринаЯчейки(), 2, 1);
	
	Если Колонка = 1 Тогда
		Ячейка = Строка * 2 - 2;
	Иначе
		Ячейка = Строка * 2 - 1;
	КонецЕсли;
	
	Возврат Ячейка;
	
КонецФункции

&НаСервере
Процедура ВывестиПустыеЯчейки()
	
	ОбластьСтрока = ПолучитьОсновнойМакет().ПолучитьОбласть("Строка|ПустыеЯчейки");
	
	КоличествоСтрок = ?(Файлы.Количество() % 2 = 0, Файлы.Количество() / 2, Файлы.Количество() / 2 + 1); 
	Для Индекс = 1 По КоличествоСтрок Цикл
		Превью.Вывести(ОбластьСтрока);	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
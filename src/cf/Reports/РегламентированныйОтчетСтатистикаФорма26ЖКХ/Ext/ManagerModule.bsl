﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 03.08.2011 № 343.";
	НоваяФорма.РедакцияФормы	  = "от 03.08.2011 № 343.";
	НоваяФорма.ДатаНачалоДействия = '20120101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "609255", '20110803', "343", "ФормаОтчета2012Кв1");
	
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма26ЖКХ", "ФормаОтчета2012Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20120101, ВерсияВыгрузки);
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#Если Не ВнешнееСоединение Тогда
#Область ФормированиеТекстаВыгрузки

Функция ТекстВыгрузкиОтчетаСтатистики(мСохраненныйДок, ВыбраннаяФорма) Экспорт 
	ТекстВыгрузки = "";
	Если ВыбраннаяФорма = "ФормаОтчета2012Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2012Кв1");
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2012Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	КонецЕсли;
	
	Возврат ТекстВыгрузки;
КонецФункции

#КонецОбласти
#КонецЕсли


#КонецЕсли
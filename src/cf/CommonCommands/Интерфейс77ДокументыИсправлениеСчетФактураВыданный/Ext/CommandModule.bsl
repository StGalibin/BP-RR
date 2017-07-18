﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ПараметрыВыполненияКоманды.Окно <> Неопределено Тогда
		ВариантОткрытияОкнаФормы = ВариантОткрытияОкна.ОтдельноеОкно;
		Уникальность = Истина;
		Источник = Неопределено;
	Иначе
		ВариантОткрытияОкнаФормы = ПараметрыВыполненияКоманды.Окно;
		Уникальность = ПараметрыВыполненияКоманды.Уникальность;
		Источник = ПараметрыВыполненияКоманды.Источник;
	КонецЕсли;	
	ЗначенияЗаполнения = Новый Структура("ВидСчетаФактуры, Исправление", ПредопределенноеЗначение("Перечисление.ВидСчетаФактурыВыставленного.НаРеализацию"), Истина);
	ОткрытьФорму("Документ.СчетФактураВыданный.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), Источник, Уникальность, ВариантОткрытияОкнаФормы);
КонецПроцедуры
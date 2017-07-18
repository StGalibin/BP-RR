﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Если ПараметрыВыполненияКоманды.Окно <> Неопределено Тогда
		ВариантОткрытияОкнаФормы = ПараметрыВыполненияКоманды.Окно;
		Уникальность = Истина;
		Источник = Неопределено;
	Иначе
		ВариантОткрытияОкнаФормы = ПараметрыВыполненияКоманды.Окно;
		Уникальность = ПараметрыВыполненияКоманды.Уникальность;
		Источник = ПараметрыВыполненияКоманды.Источник;
	КонецЕсли;
	ОткрытьФорму("ЖурналДокументов.ДокументыПоНМА.ФормаСписка",, Источник, Уникальность, ВариантОткрытияОкнаФормы);
КонецПроцедуры

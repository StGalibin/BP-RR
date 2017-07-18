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
	ОткрытьФорму("Отчет.ГлавнаяКнига.ФормаОбъекта",, Источник, Уникальность, ВариантОткрытияОкнаФормы);
КонецПроцедуры

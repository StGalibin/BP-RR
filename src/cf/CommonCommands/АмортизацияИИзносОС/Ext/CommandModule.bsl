﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Отбор = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыРегламентныхОпераций.АмортизацияИИзносОС"));
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("Документ.РегламентнаяОперация.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, "ФормаСписка_АмортизацияИИзносОС", ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

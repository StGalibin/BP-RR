﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УИДЗамера", УИДЗамера);
	ОткрытьФорму("ЖурналДокументов.ЖурналОпераций.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

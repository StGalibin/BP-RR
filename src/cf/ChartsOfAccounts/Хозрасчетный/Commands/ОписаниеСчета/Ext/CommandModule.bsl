﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Счет", ПараметрКоманды);
	
	ОткрытьФорму("ПланСчетов.Хозрасчетный.Форма.ФормаОписанияСчета", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
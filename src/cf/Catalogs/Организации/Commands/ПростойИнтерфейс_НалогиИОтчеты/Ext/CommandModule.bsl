﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",      ПараметрКоманды);
	ПараметрыФормы.Вставить("КонтекстныйВызов", Истина);
	ОткрытьФорму("ОбщаяФорма.НалогиИОтчеты", ПараметрыФормы,,, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

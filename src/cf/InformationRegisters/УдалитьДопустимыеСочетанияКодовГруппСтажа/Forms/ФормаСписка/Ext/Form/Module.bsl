﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания Экспорт;

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОжиданиеВыполненияДлительнойОперации()
	
	Если ЗарплатаКадрыКлиент.ВосстановлениеНачальныхЗначенийВыполнено(ЭтаФорма) Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

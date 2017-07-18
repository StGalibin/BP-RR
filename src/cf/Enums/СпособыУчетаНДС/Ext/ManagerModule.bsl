﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДоступноСписание = Ложь;
	Если Параметры.Свойство("ОграничениеСпискаВыбора") Тогда
		Если Параметры.ОграничениеСпискаВыбора = "НеОграничивать" Тогда
			Возврат;
		ИначеЕсли Параметры.ОграничениеСпискаВыбора = "ДляАвансовогоОтчета" Тогда 
			ДоступноСписание = Истина;			
		КонецЕсли;	
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Перечисления.СпособыУчетаНДС.ПринимаетсяКВычету);
	ДанныеВыбора.Добавить(Перечисления.СпособыУчетаНДС.УчитываетсяВCтоимости);
	ДанныеВыбора.Добавить(Перечисления.СпособыУчетаНДС.ДляОперацийПо0);
	ДанныеВыбора.Добавить(Перечисления.СпособыУчетаНДС.Распределяется);
	
	Если ДоступноСписание Тогда
		ДанныеВыбора.Добавить(Перечисления.СпособыУчетаНДС.Списывается);
	КонецЕсли;
		 
КонецПроцедуры

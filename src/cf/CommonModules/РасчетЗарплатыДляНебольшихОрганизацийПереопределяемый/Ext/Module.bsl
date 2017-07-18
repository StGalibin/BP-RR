﻿////////////////////////////////////////////////////////////////////////////////
// РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый: 
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текст сообщения, которое будет показано пользователю при приближении 
// количества работающих сотрудников к количеству при котором расчет зарплаты для небольших организаций становится
// невозможен.
// В текст сообщения подставляются следующие параметры:
//		%1	- максимально допустимое количество работающих сотрудников
//		%2	- краткое наименование организации
//		%3	- текущее количество работающих сотрудников.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОПриближенииКМаксимальноДопустимомуКоличествуРаботающихСотрудников() Экспорт
	
	Возврат НСтр("ru='При использовании режима учета больничных, отпусков и исполнительных документов работников количество работающих сотрудников не может превышать %1.
		|Сейчас в организации %2 работает %3.'");
	
КонецФункции

// Возвращает текст сообщения, которое будет показано пользователю при попытке создать документ,
// когда отключен режим расчета зарплаты для небольших организаций.
// В текст сообщения подставляются следующие параметры:
//		%1	- представление документа, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОНевозможностиСоздаватьДокументыПриОтключеннойНастройке() Экспорт
	
	Возврат НСтр("ru='Создавать документ ""%1"" можно при включенном режиме учета больничных, отпусков и исполнительных документов работников'");
	
КонецФункции

// Возвращает текст сообщения, которое будет показано пользователю при попытке создать документ,
// когда отключен режим расчета зарплаты для небольших организаций.
// В текст сообщения подставляются следующие параметры:
//		%1	- максимально допустимое количество работающих сотрудников
//		%2	- представление документа, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОНевозможностиСоздаватьДокументыПриПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников() Экспорт
	
	Возврат НСтр("ru='Количество работающих сотрудников превышает %1, нельзя создавать документы ""%2""'");
	
КонецФункции

// Возвращает текст сообщения о превышении максимально допустимого количества работающих сотрудников.
//
// Возвращаемое значение:
//		Строка
//
Функция ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников() Экспорт
	
	Возврат НСтр("ru='При использовании режима учета больничных, отпусков и исполнительных документов работников количество работающих сотрудников не может превышать %1.'");
	
КонецФункции

#КонецОбласти

﻿
#Область СлужебныйПрограммныйИнтерфейс

// Процедура предназначена для выполнения действия, сопряженных с регистрацией отработанного времени.
//
Процедура ПриРегистрацииОтработанногоВремени(Движения, ЗаписыватьДвижения = Ложь) Экспорт
	
КонецПроцедуры

Процедура ПриРегистрацииНачисленийУдержанийПоСотрудникам(Движения, Отказ, ДобавленныеСтрокиНачислений, ХарактерВыплаты, ПериодРегистрации) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПравилаУчетаНачисленийСотрудников() Экспорт

	Возврат УчетНачисленнойЗарплатыБазовый.ПравилаУчетаНачисленийСотрудников();

КонецФункции 

Функция ПрименениеОбособленныхТерриторий() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПрименениеОбособленныхТерриторий();
КонецФункции

Процедура СкорректироватьДатыНачисленийБезПериодаДействия(ТаблицаНачислений, ПериодРегистрации, ИмяПоляНачисления = "НачислениеУдержание") Экспорт
	
КонецПроцедуры

#Область ПроцедурыИФункцииРаботыСОтчетами

// Процедура формирования отчетов анализа начислений и удержаний.
//
Процедура ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Объект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, КлючВарианта, НаАванс) Экспорт
	
КонецПроцедуры

Процедура ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисленияИУдержания, НастройкиОтчета, КоличествоНачисленийУдержаний, ВидПолей = "Начисления") Экспорт
	
КонецПроцедуры

// Возвращает начисления в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхНачислений(Начисления, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

// Возвращает удержания в том порядке, в котором они должны быть выведены в отчете.
//
Функция ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки) Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ПорядокДополнительныхУдержаний(Удержания, ДанныеОтчета, СоответствиеПользовательскихПолей, НачальныйНомерКолонки);
КонецФункции

Функция ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Функция ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49() Экспорт
	Возврат УчетНачисленнойЗарплатыБазовый.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийТ49();
КонецФункции

Процедура ДополнитьАнализНачисленийИУдержаний(ОтчетОбъект) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

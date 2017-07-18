﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Раздел", ПредопределенноеЗначение("Перечисление.СтраницыЖурналаОтчетность.Отчеты"));
	// Вид отчета: Строка - как она представлена в реквизите "НаименованиеОтчета" регистра сведений "ЖурналОтчетовСтатусы"
	// Для РО - соответствует синониму основной формы отчета
	ПараметрыОткрытия.Вставить("ВидОтчета", "4-ФСС");
	ОткрытьФорму("ОбщаяФорма.РегламентированнаяОтчетность", ПараметрыОткрытия, ПараметрыВыполненияКоманды.Источник, "1С-Отчетность", ПараметрыВыполненияКоманды.Окно);
	
	Оповестить("Открытие формы 1С-Отчетность", ПараметрыОткрытия);
	
КонецПроцедуры

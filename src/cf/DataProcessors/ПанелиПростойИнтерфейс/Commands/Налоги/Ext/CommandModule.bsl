﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПростойИнтерфейсНалоги");
	
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Обработка.МониторНалоговИОтчетности.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

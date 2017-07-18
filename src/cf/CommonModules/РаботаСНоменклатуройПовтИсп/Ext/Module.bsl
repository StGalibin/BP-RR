﻿////////////////////////////////////////////////////////////////////////////////
// Работа с номенклатурой (повт. исп.).
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ВидыНоменклатурыДляВыбора(ОсновнойВидНоменклатуры, СписокВидовНоменклатуры) Экспорт
	
	ВидыНоменклатурыДляВыбора = Новый СписокЗначений;
	
	ВидыНоменклатуры = СтрРазделить(СписокВидовНоменклатуры, " ,", Ложь);
	
	Если ВидыНоменклатуры.Количество() = 0 Тогда
		Возврат ВидыНоменклатурыДляВыбора;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновнойВидНоменклатуры", ОсновнойВидНоменклатуры);
	
	ЗапросыДляОбъединения = Новый Массив;
	
	Для Каждого ВидНоменклатуры Из ВидыНоменклатуры Цикл
		Если ВРег(ВидНоменклатуры) = ВРег("Товары") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапроса("ТоварыНаСкладах"));
		ИначеЕсли ВРег(ВидНоменклатуры) = ВРег("Материалы") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапроса("СырьеИМатериалы"));
		ИначеЕсли ВРег(ВидНоменклатуры) = ВРег("ВозвратнаяТара") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапроса("ТараПодТоваромИПорожняя"));
		ИначеЕсли ВРег(ВидНоменклатуры) = ВРег("Оборудование") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапроса("ПриобретениеКомпонентовОсновныхСредств"));
		ИначеЕсли ВРег(ВидНоменклатуры) = ВРег("ТоварыНаКомиссии") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапроса("ТоварыНаСкладе"));
		ИначеЕсли ВРег(ВидНоменклатуры) = ВРег("Услуги") Тогда
			ЗапросыДляОбъединения.Добавить(ТекстЗапросаУслуги());
		КонецЕсли;
	КонецЦикла;
	
	Запрос.Текст = СтрСоединить(ЗапросыДляОбъединения, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	Запрос.Текст = Запрос.Текст + Символы.ПС +
	"УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ВидыНоменклатурыДляВыбора.Добавить(Выборка.Ссылка, Выборка.Наименование);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ВидыНоменклатурыДляВыбора;
	
КонецФункции

Функция ТекстЗапроса(ИмяСчета)
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СчетаУчетаНоменклатуры.ВидНоменклатуры) КАК Ссылка,
	|	МАКСИМУМ(СчетаУчетаНоменклатуры.ВидНоменклатуры.Наименование) КАК Наименование
	|ИЗ
	|	РегистрСведений.СчетаУчетаНоменклатуры КАК СчетаУчетаНоменклатуры
	|ГДЕ
	|	СчетаУчетаНоменклатуры.ВидНоменклатуры <> ЗНАЧЕНИЕ(Справочник.ВидыНоменклатуры.ПустаяСсылка)
	|	И СчетаУчетаНоменклатуры.ВидНоменклатуры <> &ОсновнойВидНоменклатуры
	|	И СчетаУчетаНоменклатуры.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.%1)
	|
	|СГРУППИРОВАТЬ ПО
	|	СчетаУчетаНоменклатуры.СчетУчета
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(*) = 1";
	
	Возврат СтрШаблон(ШаблонЗапроса, ИмяСчета);
	
КонецФункции

Функция ТекстЗапросаУслуги()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	СчетаУчетаНоменклатуры.ВидНоменклатуры КАК Ссылка,
	|	СчетаУчетаНоменклатуры.ВидНоменклатуры.Наименование КАК Наименование
	|ИЗ
	|	РегистрСведений.СчетаУчетаНоменклатуры КАК СчетаУчетаНоменклатуры
	|ГДЕ
	|	СчетаУчетаНоменклатуры.ВидНоменклатуры <> &ОсновнойВидНоменклатуры
	|	И СчетаУчетаНоменклатуры.ВидНоменклатуры.Услуга";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

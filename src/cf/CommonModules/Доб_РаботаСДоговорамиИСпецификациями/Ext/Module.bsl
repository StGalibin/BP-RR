﻿
Процедура ДоговорОбработкаПроверкиЗаполненияОбработкаПроверкиЗаполнения(Источник, Отказ, ПроверяемыеРеквизиты) Экспорт
	
ПроверяемыеРеквизиты.Добавить ("СрокДействия");

КонецПроцедуры

Процедура ДокументыРеализацииПриПроведенииОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Движения = Источник.Движения;
	
	Движения.СпецификацииДоговоров.Записывать = Истина;
	
	Если ТипЗнч(Источник) = Тип ("ДокументОбъект.РеализацияТоваровУслуг") и ЗначениеЗаполнено(Источник.СпецификацияКДоговору) Тогда
		
	Для Каждого ТекСтрокаТовары Из Источник.Товары Цикл
		
		Движение = Движения.СпецификацииДоговоров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Источник.Дата;
		Движение.Спецификация = Источник.СпецификацияКДоговору;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Цена= ТекСтрокаТовары.Цена;
		Движение.Количество = ТекСтрокаТовары.Количество;
		
	КонецЦикла;
	
	КонецЕсли;

	
КонецПроцедуры

Процедура РеализацияТоваровУслугОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СпецификацияКДоговору") Тогда
		
		// Заполним реквизиты шапки по документу основанию.
		Источник.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары;
		Источник.Грузополучатель = ? (ЗначениеЗаполнено (ДанныеЗаполнения.Грузополучатель), ДанныеЗаполнения.Грузополучатель, ДанныеЗаполнения.Контрагент);
		СведенияОГрузополучателе = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Источник.Грузополучатель, ДанныеЗаполнения.Дата);
		Источник.АдресДоставки = СведенияОГрузополучателе.ФактическийАдрес;
		Источник.СпецификацияКДоговору = ДанныеЗаполнения.Ссылка;
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(Источник, ДанныеЗаполнения, Истина);
		
				
		ИменаТабличныхЧастей = "Товары";
		ЗаполнитьТоварыПоОстаткам (Источник, ДанныеЗаполнения.Ссылка);

КонецЕсли;
	
	
КонецПроцедуры


Процедура ЗаполнитьТоварыПоОстаткам(Источник, Ссылка)

		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпецификацииДоговоровОстатки.Номенклатура,
		|	СпецификацииДоговоровОстатки.КоличествоОстаток КАК Количество,
		|	СпецификацииДоговоровОстатки.Цена
		|ИЗ
		|	РегистрНакопления.СпецификацииДоговоров.Остатки КАК СпецификацииДоговоровОстатки
		|ГДЕ
		|	СпецификацииДоговоровОстатки.Спецификация = &Ссылка
		|	И СпецификацииДоговоровОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	СтрокиДляЗаполненияСчетов = Новый Массив;

	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, ДеятельностьНаПатенте, Склад,
		|ЭтоКомиссия, Реализация, ТипЦен, СуммаВключаетНДС, ДокументБезНДС");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Источник);
	ДанныеОбъекта.Реализация	= Истина;

	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(РезультатЗапроса.Выгрузить(), "Номенклатура", Истина), ДанныеОбъекта, Ложь);

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
	НоваяСтрока = Источник.Товары.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
	СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(НоваяСтрока.Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
				
	НоваяСтрока.ЕдиницаИзмерения	= СведенияОНоменклатуре.ЕдиницаИзмерения;
	НоваяСтрока.Коэффициент		= СведенияОНоменклатуре.Коэффициент;
	НоваяСтрока.СтавкаНДС			= СведенияОНоменклатуре.СтавкаНДС;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(НоваяСтрока);
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, Истина);
			
		
	СтрокиДляЗаполненияСчетов.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
		СчетаУчетаВДокументах.ЗаполнитьСтроки(
			СтрокиДляЗаполненияСчетов, "Товары", Источник, Документы.РеализацияТоваровУслуг);
	
			
	

КонецПроцедуры

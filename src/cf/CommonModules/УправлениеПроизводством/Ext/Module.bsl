﻿
// Процедура устанавливает видимость ячеек для ввода аналитики в зависимости от указанной статьи затрат.
//
Процедура НастроитьВидимостьЯчеекАналитикиЗатрат(СчетЗатрат = НЕОПРЕДЕЛЕНО, СчетЗатратНУ = НЕОПРЕДЕЛЕНО, ОформлениеСтроки, ОтражатьВБухгалтерскомУчете, ОтражатьВНалоговомУчете) Экспорт

	Если НЕ ОформлениеСтроки.Ячейки.Найти("Аналитика") = НЕОПРЕДЕЛЕНО Тогда
		ОформлениеСтроки.Ячейки.Аналитика.Видимость    = Ложь;
	КонецЕсли;

	Если НЕ ОформлениеСтроки.Ячейки.Найти("ВидАналитики") = НЕОПРЕДЕЛЕНО Тогда
		ОформлениеСтроки.Ячейки.ВидАналитики.Видимость = Ложь;
	КонецЕсли;

	Если НЕ ОформлениеСтроки.Ячейки.Найти("ВидСубконто3") = НЕОПРЕДЕЛЕНО Тогда

		Если ЗначениеЗаполнено(СчетЗатрат) Тогда

			КоличествоСубконто = СчетЗатрат.ВидыСубконто.Количество();

			Если КоличествоСубконто > 0 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконто1.УстановитьТекст(СчетЗатрат.ВидыСубконто.Получить(0).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконто1.УстановитьТекст("");
			КонецЕсли;

			Если КоличествоСубконто > 1 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконто2.УстановитьТекст(СчетЗатрат.ВидыСубконто.Получить(1).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконто2.УстановитьТекст("");
			КонецЕсли;

			Если КоличествоСубконто > 2 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконто3.УстановитьТекст(СчетЗатрат.ВидыСубконто.Получить(2).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконто3.УстановитьТекст("");
			КонецЕсли;

		Иначе
			ОформлениеСтроки.Ячейки.ВидСубконто1.УстановитьТекст("");
			ОформлениеСтроки.Ячейки.ВидСубконто2.УстановитьТекст("");
			ОформлениеСтроки.Ячейки.ВидСубконто3.УстановитьТекст("");
		КонецЕсли;

	КонецЕсли;

	Если НЕ ОформлениеСтроки.Ячейки.Найти("ВидСубконтоНУ3") = НЕОПРЕДЕЛЕНО Тогда

		ОформлениеСтроки.Ячейки.ВидСубконтоНУ1.Видимость = ОтражатьВНалоговомУчете;
		ОформлениеСтроки.Ячейки.ВидСубконтоНУ2.Видимость = ОтражатьВНалоговомУчете;
		ОформлениеСтроки.Ячейки.ВидСубконтоНУ3.Видимость = ОтражатьВНалоговомУчете;

		Если ЗначениеЗаполнено(СчетЗатратНУ) Тогда

			КоличествоСубконто = СчетЗатратНУ.ВидыСубконто.Количество();

			Если КоличествоСубконто > 0 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ1.УстановитьТекст( СчетЗатратНУ.ВидыСубконто.Получить(0).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ1.УстановитьТекст("");
			КонецЕсли;

			Если КоличествоСубконто > 1 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ2.УстановитьТекст(СчетЗатратНУ.ВидыСубконто.Получить(1).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ2.УстановитьТекст("");
			КонецЕсли;

			Если КоличествоСубконто > 2 Тогда
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ3.УстановитьТекст(СчетЗатратНУ.ВидыСубконто.Получить(2).ВидСубконто);
			Иначе
				ОформлениеСтроки.Ячейки.ВидСубконтоНУ3.УстановитьТекст("");
			КонецЕсли;

		Иначе
			ОформлениеСтроки.Ячейки.ВидСубконтоНУ1.УстановитьТекст("");
			ОформлениеСтроки.Ячейки.ВидСубконтоНУ2.УстановитьТекст("");
			ОформлениеСтроки.Ячейки.ВидСубконтоНУ3.УстановитьТекст("");
		КонецЕсли;

	КонецЕсли;

	Если НЕ ОформлениеСтроки.Ячейки.Найти("Субконто1") = НЕОПРЕДЕЛЕНО Тогда

		ОформлениеСтроки.Ячейки.Субконто1.ТолькоПросмотр = ОформлениеСтроки.Ячейки.Субконто1.ТолькоПросмотр;
		ОформлениеСтроки.Ячейки.Субконто2.ТолькоПросмотр = ОформлениеСтроки.Ячейки.Субконто2.ТолькоПросмотр;
		ОформлениеСтроки.Ячейки.Субконто3.ТолькоПросмотр = ОформлениеСтроки.Ячейки.Субконто3.ТолькоПросмотр;

		Если НЕ ОформлениеСтроки.Ячейки.Найти("СубконтоНУ1") = НЕОПРЕДЕЛЕНО Тогда
			ОформлениеСтроки.Ячейки.СубконтоНУ1.Видимость = ОтражатьВНалоговомУчете;
			ОформлениеСтроки.Ячейки.СубконтоНУ2.Видимость = ОтражатьВНалоговомУчете;
			ОформлениеСтроки.Ячейки.СубконтоНУ3.Видимость = ОтражатьВНалоговомУчете;

			ОформлениеСтроки.Ячейки.СубконтоНУ1.ТолькоПросмотр = ОформлениеСтроки.Ячейки.СубконтоНУ1.ТолькоПросмотр ИЛИ НЕ ОтражатьВНалоговомУчете;
			ОформлениеСтроки.Ячейки.СубконтоНУ2.ТолькоПросмотр = ОформлениеСтроки.Ячейки.СубконтоНУ2.ТолькоПросмотр ИЛИ НЕ ОтражатьВНалоговомУчете;
			ОформлениеСтроки.Ячейки.СубконтоНУ3.ТолькоПросмотр = ОформлениеСтроки.Ячейки.СубконтоНУ3.ТолькоПросмотр ИЛИ НЕ ОтражатьВНалоговомУчете;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // НастроитьВидимостьЯчеекАналитикиЗатрат()

// Процедура удаляет из строки имен реквизитов, проверяемых на заполненность
// реквизиты, которые зависят от типа учета документа
//
// Параметры:
//		ДокОбъект - проверяемый документ
//		СтрокаРекв   - Строка с именами реквизитов, которые надо проверять на заполненность
//      УпрРеквизиты - строка, с именами реквизитов имеющих смысл
// 					   только в случае если документ отражается в упр.учете
//      БухРеквизиты - строка, с именами реквизитов имеющих смысл
// 					   только в случае если документ отражается в регл.(бух.) учете
//      НалРеквизиты - строка, с именами реквизитов имеющих смысл
// 					   только в случае если документ отражается в регл.(нал.) учете
//		ИмяТабЧасти  - имя проверяемой табл. части документа
//
Процедура НепроверятьРеквизитыПоТипуУчета(ДокОбъект, СтрокаРекв, Знач УпрРеквизиты, Знач БухРеквизиты, Знач НалРеквизиты, ИмяТабЧасти = "", СтруктураШапкиДокумента = Неопределено) Экспорт

	Стр = СтрЗаменить(СтрокаРекв, " ", "");
	СтруктРекв = Новый Структура(Стр);
	СтрокаРекв = "";

	БухРекв = СтрЗаменить(БухРеквизиты, " ", "");
	БухРекв = СтрЗаменить(БухРекв, Символы.ПС,  "");
	БухРекв = "," + СтрЗаменить(БухРекв, Символы.Таб, "") + ",";

	НалРекв = СтрЗаменить(НалРеквизиты, " ", "");
	НалРекв = СтрЗаменить(НалРекв, Символы.ПС,  "");
	НалРекв = "," + СтрЗаменить(НалРекв, Символы.Таб, "") + ",";

	Если СтруктураШапкиДокумента = Неопределено Тогда
		БухУчет = ИСТИНА;
		НалУчет = ?(ОбщегоНазначения.ЕстьРеквизитОбъекта("ОтражатьВНалоговомУчете",      ДокОбъект.Метаданные()),ДокОбъект.ОтражатьВНалоговомУчете,Ложь);
	Иначе
		БухУчет = ИСТИНА;
		НалУчет = СтруктураШапкиДокумента.ОтражатьВНалоговомУчете;
	КонецЕсли;

	// Исключим из списка проверяемых реквизитов, те которые относятся к конкретному
	// виду учета и этот вид учета выключен
	Для Каждого Рекв Из СтруктРекв Цикл

		ИмяРекв = ?(ПустаяСтрока(ИмяТабЧасти), "", ИмяТабЧасти + ".") + Рекв.Ключ;

		Если Не БухУчет И СтрНайти(БухРекв, "," + ИмяРекв + ",") > 0 Тогда
			Продолжить;
		КонецЕсли;

		Если Не НалУчет И СтрНайти(НалРекв, "," + ИмяРекв + ",") > 0 Тогда
			Продолжить;
		КонецЕсли;

		СтрокаРекв = ?(ПустаяСтрока(СтрокаРекв), "", СтрокаРекв + ", ") + Рекв.Ключ;

	КонецЦикла;

КонецПроцедуры // НепроверятьРеквизитыПоТипуУчета()

// Возвращает текст запроса, рассчитывающий затраты сырья по спецификации и количеству продукции.
//
// Исходные данные выбираются из временной таблицы Выпуск, которая
// - должна содержать поля Спецификация и КоличествоПродукции 
// - не должна содержать поля Номенклатура, Количество, ЕдиницаИзмерения, СтатьяЗатрат
//
// Результат помещается во временную таблицу ЗатратыСырья, которая содержит:
// - сведения о потребном сырье: 
//   поля Номенклатура, Количество, ЕдиницаИзмерения, СтатьяЗатрат
// - все поля исходной таблицы Выпуск
//
Функция ТекстЗапросаВременнаяТаблицаЗатратыСырья() Экспорт
	
	// Для редактирования конструктором запроса следует заменить * на любое имя поля 
	// (например, "ВсеПоля"), после редактирования выполнить обратную замену
	Возврат
	"ВЫБРАТЬ
	|	Выпуск.*,
	|	ИсходныеКомплектующие.НомерСтроки КАК НомерСтрокиСпецификации,
	|	ИсходныеКомплектующие.Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат,
	|	ИсходныеКомплектующие.Номенклатура КАК Номенклатура,
	|	ИсходныеКомплектующие.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА ИсходныеКомплектующие.Ссылка.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ Выпуск.КоличествоПродукции * ИсходныеКомплектующие.Количество / ИсходныеКомплектующие.Ссылка.Количество
	|	КОНЕЦ КАК Количество
	|ПОМЕСТИТЬ ЗатратыСырья
	|ИЗ
	|	Выпуск КАК Выпуск
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК ИсходныеКомплектующие
	|		ПО Выпуск.Спецификация = ИсходныеКомплектующие.Ссылка" 
	+ ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции
	
Функция ВыводНаименованияВыпуска(Наименование, ВыводитьЕдиницыИзмерения = Истина, ЭтоВыпуск = Ложь) Экспорт
	
	Если ТипЗнч(Наименование) = Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат Наименование.НаименованиеПолное + ?(ВыводитьЕдиницыИзмерения, " (" + Наименование.ЕдиницаИзмерения + ")", "");
	ИначеЕсли ТипЗнч(Наименование) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда
		Возврат "Услуги производственного характера";
	ИначеЕсли ТипЗнч(Наименование) = БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения() Тогда
		Возврат "Услуги" + ?(ЭтоВыпуск, ", оказанные подразделению ", " подразделения ") + Наименование.Наименование;
    Иначе
		Возврат Наименование;
		
	КонецЕсли;
		
КонецФункции

Функция ПредставлениеОсновнойСпецификации(ОсновнаяСпецификацияНоменклатуры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ОсновнаяСпецификацияНоменклатуры);
	
	// В запросе получаем значения единицы измерения при помощи функций Максимум и Минимум, чтобы найти различные ед.изм.
	// Затем сравниваем их, если они будут различны, то отображать итог по колонке Количество в карточке номенклатуры не будем
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ИсходныеКомплектующие.Ссылка) КАК КоличествоСтрок,
	|	СУММА(ИсходныеКомплектующие.Количество) КАК КоличествоИтого,
	|	МИНИМУМ(ИсходныеКомплектующие.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияМинимум,
	|	МАКСИМУМ(ИсходныеКомплектующие.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияМаксимум
	|ИЗ
	|	Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК ИсходныеКомплектующие
	|ГДЕ
	|	ИсходныеКомплектующие.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат "";
	КонецЕсли;
	                                                                                                                          
	КоличествоСтрокНадпись = СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
		Выборка.КоличествоСтрок,
		НСтр("ru = 'позиция, позиции, позиций'"));
	Если Выборка.ЕдиницаИзмеренияМаксимум = Выборка.ЕдиницаИзмеренияМинимум Тогда
		НадписьНаФорме = СтрШаблон(НСтр("ru = '%1 (%2 %3)'"), КоличествоСтрокНадпись, Выборка.КоличествоИтого, Выборка.ЕдиницаИзмеренияМаксимум);	
	Иначе
		НадписьНаФорме = КоличествоСтрокНадпись;
	КонецЕсли;
	
	Возврат НадписьНаФорме;
	
КонецФункции

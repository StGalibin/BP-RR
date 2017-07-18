﻿

#Область ПрограммныйИнтерфейс

Функция ПолучитьКомандуВыгрузитьвГИСМ(Основание) Экспорт
	
	ИмяФормы = "";
	
	ТипДокумента = ТипЗнч(Основание);
	
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЕстьМаркируемаяПродукцияГИСМ") Тогда
		Возврат Нстр("ru = 'В документе отсутствуют данные о маркируемой продукции'");
	КонецЕсли;
	
	Если ТипДокумента = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		Если НЕ ВведеноУведомление(Основание, "УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ")
			И НЕ ВведеноУведомление(Основание, "УведомлениеОбИмпортеМаркированныхТоваровГИСМ") Тогда
			
			СтранаКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "Контрагент.СтранаРегистрации");
			Если СтранаКонтрагента = Справочники.СтраныМира.Россия Тогда

				Возврат Нстр("ru = 'Не удалось создать ""Уведомление об импорте"". Страна регистрации контрагента: '") + СтранаКонтрагента;
				
			ИначеЕсли УчетНДС.ГосударствоЧленТаможенногоСоюза(СтранаКонтрагента) Тогда
				ИмяФормы = "Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.ФормаОбъекта";
			Иначе
				ИмяФормы = "Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.ФормаОбъекта";
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли (ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		ИЛИ ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровПоставщику"))
		И НЕ ВведеноУведомлениеОбОтгрузкеМаркированныхТоваровГИСМ(Основание) Тогда
		
		ИмяФормы = "Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.ФормаОбъекта";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.СписаниеТоваров")
		И НЕ ВведеноУведомление(Основание, "УведомлениеОСписанииКиЗГИСМ")Тогда
		
		ИмяФормы = "Документ.УведомлениеОСписанииКиЗГИСМ.ФормаОбъекта";
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		Действие = "ОткрытьПротоколОбмена";
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "Контрагент.ЮридическоеФизическоеЛицо")
			<> Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			Возврат Нстр("ru = 'Не удалось отправить в ГИСМ ""Уведомление о возврате от розничного покупателя"". Контрагент не является физическим лицом '");
		КонецЕсли;
		
		Действие = "ОткрытьПротоколОбмена";
		
	КонецЕсли;
	
	Возврат Новый Структура("Действие, ИмяФормы", ?(ИмяФормы = "", "ОткрытьПротоколОбмена", "СоздатьУведомление"), ИмяФормы);
	
КонецФункции

Функция ДанныеВыбораНомераКиЗ(Параметры, ОкончаниеВводаТекста = Ложь) Экспорт
	
	КоличествоВопросов = 0;
	ДанныеВыбора = Новый СписокЗначений;
	СтрокаПоиска = СокрЛП(Параметры.СтрокаПоиска);
	ДлинаСтроки  = СтрДлина(СтрокаПоиска);
	МассивПодстрок   = Новый Массив;
	МассивПодстрок.Добавить(НСтр("ru='Создать: '"));
	
	ТекстДополнения = "";
	//проверим на соответствие маске "ZZ-UUUUUU-UUUUUUUUUU"
	ОшибочныйСимволВНомерКиЗ = ИнтеграцияГИСМКлиентСерверБП.ОшибочныйСимволВНомерКиЗ(СтрокаПоиска);
	Если ОшибочныйСимволВНомерКиЗ = 0 Тогда
		ЖирныйШрифт  = Новый Шрифт(, , Истина);
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(СтрокаПоиска, ЖирныйШрифт, ЦветаСтиля.РезультатУспехЦвет));
	ИначеЕсли ОшибочныйСимволВНомерКиЗ < 20 Тогда
		МассивПодстрок.Добавить(Лев(СтрокаПоиска, ОшибочныйСимволВНомерКиЗ-1));
		МассивПодстрок.Добавить(
			Новый ФорматированнаяСтрока(Сред(СтрокаПоиска, ОшибочныйСимволВНомерКиЗ), , ЦветаСтиля.ЦветТекстаНекорректныйНомерКиЗ));
	Иначе
		МассивПодстрок.Добавить(Лев(СтрокаПоиска, 20));
	КонецЕсли;
	
	Если ДлинаСтроки <20 Тогда
		ТекстДополнения = Прав("??-??????-??????????", 20 - ДлинаСтроки);
	Иначе
		ТекстДополнения = Сред(СтрокаПоиска,21);
	КонецЕсли;
	МассивПодстрок.Добавить(
		Новый ФорматированнаяСтрока(ТекстДополнения, ,ЦветаСтиля.ЦветТекстаНекорректныйНомерКиЗ));
		
	ПредставлениеНового = Новый ФорматированнаяСтрока(МассивПодстрок);
	ДанныеВыбора.Добавить(СтрокаПоиска, ПредставлениеНового);
	Если ОкончаниеВводаТекста Тогда
		// Добавляем вторую строку, чтобы в этом режиме не срабатывал автовыбор единственной строки.
		ДанныеВыбора.Добавить(""); 
	КонецЕсли;
	
	Возврат ДанныеВыбора;

КонецФункции 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВведеноУведомлениеОбОтгрузкеМаркированныхТоваровГИСМ(Основание)
	
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ Первые 1
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке КАК ТекущееУведомлениеОбОтгрузке
		|ИЗ
		|	РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ
		|ГДЕ
		|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Документ = &Основание
		|	И НЕ СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Статус В (
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоКлиентом),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ОтклоненоГИСМ),
		|		ЗНАЧЕНИЕ(Перечисление.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Отсутствует)
		|		)
		|	И НЕ СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке = ЗНАЧЕНИЕ(Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("Основание", Основание);
		
		Возврат НЕ Запрос.Выполнить().Пустой();
		
КонецФункции

Функция ВведеноУведомление(Основание, ИмяУведомления)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтатусыИнформированияГИСМ.ТекущееУведомление
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ГДЕ
	|	СтатусыИнформированияГИСМ.Документ = &Основание
	|	И НЕ СтатусыИнформированияГИСМ.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияГИСМ.ОтклоненоГИСМ),
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияГИСМ.Отсутствует)
	|		)
	|	И НЕ СтатусыИнформированияГИСМ.ТекущееУведомление = &ПустоеУведомление
	|	И  СтатусыИнформированияГИСМ.ТекущееУведомление <> НЕОПРЕДЕЛЕНО ";
	
	Запрос.УстановитьПараметр("Основание", Основание);
	Запрос.УстановитьПараметр("ПустоеУведомление", Документы[ИмяУведомления].ПустаяСсылка());
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

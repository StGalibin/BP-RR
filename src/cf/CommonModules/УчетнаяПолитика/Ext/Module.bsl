﻿
Функция Существует(Организация, Период, ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Ложь, ДокументСсылка = Неопределено) Экспорт
	
	СпособОценкиТоваровВРознице = ПолучитьФункциональнуюОпцию("СпособОценкиТоваровВРознице", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
		
	УчетнаяПолитикаСуществует = НЕ (СпособОценкиТоваровВРознице = Ложь);
	
	Если НЕ УчетнаяПолитикаСуществует
		И ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Истина Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Для организации %1 на %2 не заполнена учетная политика.'"),
			Организация,
			Формат(НачалоМесяца(Период), "ДФ='MMMM yyyy'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументСсылка, , "Объект");
	КонецЕсли;

	СистемаНалогообложения = ПолучитьФункциональнуюОпцию("СистемаНалогообложения", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	НалоговыеНастройкиСуществуют = НЕ (СистемаНалогообложения = Ложь);
	
	Если НЕ НалоговыеНастройкиСуществуют
		И ВыводитьСообщениеОбОтсутствииУчетнойПолитики = Истина Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Для организации %1 на %2 не задана система налогообложения.'"),
			Организация,
			Формат(НачалоМесяца(Период), "ДФ='MMMM yyyy'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ДокументСсылка, , "Объект");
	КонецЕсли;
	
	Возврат УчетнаяПолитикаСуществует И НалоговыеНастройкиСуществуют;

КонецФункции

Функция СистемаНалогообложения(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СистемаНалогообложения", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СистемыНалогообложения.Общая;
	КонецЕсли;

	Возврат Результат;

КонецФункции 

// Параметры учетной политики по налогу на прибыль

Функция ПлательщикНалогаНаПрибыль(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ПоддержкаПБУ18(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПоддержкаПБУ18", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция МетодНачисленияАмортизацииНУ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("МетодНачисленияАмортизации", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

// Параметры учетной политики по НДС

Функция ПлательщикНДС(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНДС", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция РаздельныйУчетНДС(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("РаздельныйУчетНДС", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция УпрощенныйУчетНДС(Организация, Период) Экспорт
	
	Если Период < '20120101' Тогда
	
		Результат = ПолучитьФункциональнуюОпцию("УпрощенныйУчетНДС", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
			
	Иначе
		
		Результат = Ложь;
			
	КонецЕсли;

	Возврат Результат;

КонецФункции 

Функция ПорядокРегистрацииСчетовФактурНаАванс(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокРегистрацииСчетовФактурНаАванс", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция НачислятьНДСПриПередачеНедвижимости(Организация, Период) Экспорт
	
	ОтгрузкаНеплательщикомНДС = УчетНДС.ВедетсяУчетНДСПоФЗ134(Период) И НЕ ПлательщикНДС(Организация, Период);
	
	Результат = ПолучитьФункциональнуюОпцию("НачислятьНДСПриПередачеНедвижимости", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат ИЛИ ОтгрузкаНеплательщикомНДС ИЛИ УчетНДС.ВедетсяУчетНДСПоФЗ81(Период);

КонецФункции

Функция НачислятьНДСПоОтгрузке(Организация, Период) Экспорт

	ОтгрузкаНеплательщикомНДС = УчетНДС.ВедетсяУчетНДСПоФЗ134(Период) И НЕ ПлательщикНДС(Организация, Период);
	
	Результат = ПолучитьФункциональнуюОпцию("НачислятьНДСПоОтгрузке", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат ИЛИ ОтгрузкаНеплательщикомНДС;

КонецФункции 

Функция РаздельныйУчетНДСНаСчете19(Организация, Период) Экспорт
	
	Если Период < '20120101' Тогда
		
		Возврат Ложь;
		
	Иначе
	
		Результат = ПолучитьФункциональнуюОпцию("РаздельныйУчетНДСНаСчете19", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
			
    КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция РаздельныйУчетНДСДо2014Года(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("РаздельныйУчетНДСДо2014Года", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;	

КонецФункции

Функция ПрименяетсяОсвобождениеОтУплатыНДС(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяОсвобождениеОтУплатыНДС", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;	

КонецФункции

// Параметры учетной политики по УСН

Функция ПрименяетсяУСНДоходыМинусРасходы(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходыМинусРасходы", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;
	
КонецФункции 

Функция ПрименяетсяУСНДоходыМинусРасходыЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт

	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПрименяетсяУСНДоходыМинусРасходы", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ПрименяетсяУСНДоходы(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходы", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ПрименяетсяУСНДоходыЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПрименяетсяУСНДоходы", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ПрименяетсяУСН(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяУСН", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;

КонецФункции 

Функция ПрименяетсяУСНЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПрименяетсяУСН", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ПорядокПризнанияМатериальныхРасходов(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокПризнанияМатериальныхРасходов", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.ПорядокПризнанияМатериальныхРасходов.ПоОплатеПоставщику;
		ИначеЕсли Период >= '20160101' И Результат = Перечисления.ПорядокПризнанияМатериальныхРасходов.УменьшатьРасходыНаОстатокНЗП Тогда
			// С 1 января 2016 уменьшение материальных расходов на остаток НЗП не поддерживается
			Результат = Перечисления.ПорядокПризнанияМатериальныхРасходов.ПоФактуСписания;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ПорядокПризнанияРасходовПоТоварам(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокПризнанияРасходовПоТоварам",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.ПорядокПризнанияРасходовПоТоварам.ПоОплатеПоставщику;
		ИначеЕсли Период >= '20160101' И Результат = Перечисления.ПорядокПризнанияРасходовПоТоварам.ПоОплатеПоставщику Тогда
			// С 1 января 2016 признание расходов на товары по оплате поставщику не допускается.
			Результат = Перечисления.ПорядокПризнанияРасходовПоТоварам.ПоФактуРеализации;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ПорядокПризнанияРасходовПоНДС(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокПризнанияРасходовПоНДС", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.ПорядокПризнанияРасходовПоНДС.ПоОплатеПоставщику;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции 

Функция ПорядокПризнанияДопРасходов(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ПорядокПризнанияДопРасходов", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.ПорядокПризнанияДопРасходов.ПоОплатеПоставщику;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ПорядокПризнанияТаможенныхПлатежей(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ПорядокПризнанияТаможенныхПлатежей",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.ПорядокПризнанияТаможенныхПлатежей.ПоОплате;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ДатаПереходаНаУСН(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ДатаПереходаНаУСН", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Дата('20020101');
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция МетодРаспределенияРасходовУСНПоВидамДеятельности(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("МетодРаспределенияРасходовУСНПоВидамДеятельности", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

		Если Результат = Ложь Тогда
			Результат = Перечисления.МетодыРаспределенияРасходовУСНПоВидамДеятельности.ЗаКвартал;
		КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция БазаРаспределенияРасходовУСНПоВидамДеятельности(Организация, Период) Экспорт

	Если Период >= '20160101' Тогда
		Результат = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыПринимаемыеНУ;
	Иначе
		Результат = ПолучитьФункциональнуюОпцию("БазаРаспределенияРасходовУСНПоВидамДеятельности",
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
		Если Результат = Ложь Тогда
			Результат = Перечисления.БазаРаспределенияРасходовУСНПоВидамДеятельности.ДоходыОтРеализацииБУ;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОбъектНалогообложенияУСН(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ОбъектНалогообложенияУСН", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПорядокОтраженияАвансаУСН(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокОтраженияАванса", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;

КонецФункции

Функция ПатентУСН(Организация, Период) Экспорт

	ПорядокОтраженияАвансаУСН = ПолучитьФункциональнуюОпцию("ПорядокОтраженияАванса", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
		
	Если ПорядокОтраженияАвансаУСН <> Перечисления.ПорядокОтраженияАвансов.ДоходПатент Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ПолучитьФункциональнуюОпцию("Патент", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;

КонецФункции

Функция УведомлениеДата(Организация, Период) Экспорт
	
	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиУчетаУСН", "УведомлениеДата", Организация, Период, Период);
	
	Результат = "";
	Если МассивЗначений.Количество() > 0 Тогда
		Результат = МассивЗначений[0];
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция УведомлениеНомер(Организация, Период) Экспорт
	
	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиУчетаУСН", "УведомлениеНомер", Организация, Период, Период);
	
	Результат = "";
	Если МассивЗначений.Количество() > 0 Тогда
		Результат = МассивЗначений[0];
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ПереходНаУСН(Организация, Период) Экспорт
	
	ПериодПрошл = КонецГода(ДобавитьМесяц(Период, -12));
	
	ТекПрименяетсяУСН   = ПрименяетсяУСН(Организация, Период);
	ДатаПереходаНаУСН   = ДатаПереходаНаУСН(Организация, Период);
	РанееПрименяласьОСН = ПлательщикНалогаНаПрибыль(Организация, ПериодПрошл) ИЛИ ПлательщикНДФЛ(Организация, ПериодПрошл);
		
	Результат = РанееПрименяласьОСН И ТекПрименяетсяУСН И ЗначениеЗаполнено(ДатаПереходаНаУСН);
	
	Возврат Результат;

КонецФункции // ПереходНаУСН()

Функция СтавкаНалогаУСН(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СтавкаНалогаУСН",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция НалоговыеКаникулыУСН(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("НалоговыеКаникулы",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

// Параметры учетной политики по Патентной системе налогообложения и ЕНВД
Функция ПрименяетсяУСНПатент(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНПатент", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ПрименяетсяУСНПатентЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПрименяетсяУСНПатент", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ПлательщикЕНВД(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикЕНВД", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПлательщикЕНВДЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт

	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПлательщикЕНВД", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция РозничнаяТорговляОблагаетсяЕНВД(Организация, Период) Экспорт
	
	Возврат ПрименяетсяОсобыйПорядокНалогообложения(Организация, Период);
	
КонецФункции 

Функция ПрименяетсяОсобыйПорядокНалогообложения(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяетсяОсобыйПорядокНалогообложения", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;

КонецФункции

Функция ТолькоОсновнаяСистемаНалогообложения(Организация, Период) Экспорт
	
	Возврат Не ПлательщикЕНВД(Организация, Период)
		И Не ПрименяетсяУСНПатент(Организация, Период);
	
КонецФункции

Функция ТолькоОсобыйПорядокНалогообложения(Организация, Период) Экспорт
	
	Возврат ПрименяетсяОсобыйПорядокНалогообложения(Организация, Период);
	
КонецФункции

Функция ТолькоОсновнаяСистемаНалогообложенияЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт
	
	Возврат Не ПлательщикЕНВДЗаПериод(Организация, НачалоПериода, КонецПериода)
		И Не ПрименяетсяУСНПатентЗаПериод(Организация, НачалоПериода, КонецПериода);
	
КонецФункции

// Параметры учетной политики по ИП

Функция ПлательщикНДФЛ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикНДФЛ", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПлательщикНДФЛЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт

	МассивЗначений = НастройкиУчета.ЗначенияРесурсаУчетнойПолитикиЗаПериод(
		"НастройкиСистемыНалогообложения", "ПлательщикНДФЛ", Организация, НачалоПериода, КонецПериода);
	
	Результат = Ложь;
	Для Каждого Значение Из МассивЗначений Цикл
		Результат = Результат ИЛИ Значение;
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ОсновнойВидДеятельности(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ОсновнойВидДеятельности", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;
	
КонецФункции

Функция ОсновнойХарактерДеятельности(Организация, Период) Экспорт
	
	ВидДеятельности = ОсновнойВидДеятельности(Организация, Период);
	
	Если ВидДеятельности <> Ложь Тогда // Если значения не найдено, то значение функциональной опции будет Ложь
		ХарактерДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДеятельности, "ХарактерДеятельности");
	Иначе
		ХарактерДеятельности = Перечисления.ХарактерДеятельности.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ХарактерДеятельности;
	
КонецФункции

Функция ОсновнаяНоменклатурнаяГруппа(Организация, Период) Экспорт

	ВидДеятельности = ОсновнойВидДеятельности(Организация, Период);
	
	Если ВидДеятельности <> Ложь Тогда // Если значения не найдено, то значение функциональной опции будет Ложь
		НоменклатурнаяГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДеятельности, "НоменклатурнаяГруппа");
	Иначе
		НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат НоменклатурнаяГруппа;
	
КонецФункции

Функция ВестиУчетПоВидамДеятельностиИП(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ВестиУчетПоВидамДеятельности", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция АвансыВключаютсяВДоходыВПериодеПолученияИП(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("АвансыВключаютсяВДоходыВПериодеПолучения",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;
	
КонецФункции

Функция ВидДеятельностиДоходовПоАвансамИП(Организация, Период) Экспорт
	
	ВестиУчетПоВидамДеятельностиИП = ВестиУчетПоВидамДеятельностиИП(Организация, Период);
		
	Если ВестиУчетПоВидамДеятельностиИП Тогда
		Результат = ПолучитьФункциональнуюОпцию("ВидДеятельностиДоходовПоАвансам", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	Иначе
		Результат = ПолучитьФункциональнуюОпцию("ОсновнойВидДеятельности", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

Функция ХарактерДеятельностиДоходовПоАвансамИП(Организация, Период) Экспорт
	
	ВидДеятельности = ВидДеятельностиДоходовПоАвансамИП(Организация, Период);
	
	Если ВидДеятельности <> Ложь Тогда // Если значения не найдено, то значение функциональной опции будет Ложь
		ХарактерДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДеятельности, "ХарактерДеятельности");
	Иначе
		ХарактерДеятельности = Перечисления.ХарактерДеятельности.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ХарактерДеятельности;
	
КонецФункции

Функция НоменклатурнаяГруппаДоходовПоАвансамИП(Организация, Период) Экспорт
	
	ВидДеятельности = ВидДеятельностиДоходовПоАвансамИП(Организация, Период);
	
	Если ВидДеятельности <> Ложь Тогда // Если значения не найдено, то значение функциональной опции будет Ложь
		НоменклатурнаяГруппа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидДеятельности, "НоменклатурнаяГруппа");
	Иначе
		НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат НоменклатурнаяГруппа;
	
КонецФункции

Функция ДляПризнанияРасходовТребуетсяПолучениеДоходаИП(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ДляПризнанияРасходовТребуетсяПолучениеДохода", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;

КонецФункции

Функция ПризнаватьРасходыПоОперациямПрошлогоГодаИП(Организация, Период) Экспорт

	ПризнаватьРасходыПоОперациямПрошлогоГодаИП = ПолучитьФункциональнуюОпцию("ПризнаватьРасходыПоОперациямПрошлогоГода", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Результат = ПризнаватьРасходыПоОперациямПрошлогоГодаИП
		И ДляПризнанияРасходовТребуетсяПолучениеДоходаИП(Организация, Период);
	
	Возврат Результат;

КонецФункции

// Параметры учетной политики по фиксированным страховым взносам

Функция УплачиватьДобровольныеВзносыВФСС(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("УплачиватьДобровольныеВзносыВФСС", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;
	
КонецФункции

// Параметры учетной политики по затратам на производство

Функция ЗначениеУчетнойПолитики(ИмяРесурса, Организация, Период)
	
	Параметры = Новый Структура;
	Параметры.Вставить("Организация", Организация);
	Параметры.Вставить("Период",      НачалоМесяца(Период));
	
	Возврат ПолучитьФункциональнуюОпцию(ИмяРесурса, Параметры);
	
КонецФункции	

Функция ВедетсяПроизводственнаяДеятельность(Организация, Период) Экспорт

	Возврат ВыпускПродукции(Организация, Период) Или ОказаниеУслуг(Организация, Период);
	
КонецФункции 

Функция ВыпускПродукции(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("ВыпускПродукции", Организация, Период);
	
КонецФункции

Функция ОказаниеУслуг(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("ОказаниеУслуг", Организация, Период);
	
КонецФункции

Функция РассчитыватьСебестоимостьПолуфабрикатов(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("РассчитыватьСебестоимостьПолуфабрикатов", Организация, Период);
	
КонецФункции

Функция РассчитыватьСебестоимостьУслугСобственнымПодразделениям(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("РассчитыватьСебестоимостьУслугСобственнымПодразделениям", Организация, Период);
	
КонецФункции		

Функция ПорядокСписанияРасходовНаСебестоимостьУслуг(Организация, Период) Экспорт
	
	Возврат ЗначениеУчетнойПолитики("ПорядокСписанияРасходовНаСебестоимостьУслуг", Организация, Период);
	
КонецФункции

Функция ДиректКостинг(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ДиректКостинг", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция СпособРасчетаСебестоимостиПроизводства(Организация, Период) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетЗатратПоПодразделениям") Тогда
	
		Результат = ПолучитьФункциональнуюОпцию("СпособРасчетаСебестоимостиПроизводства", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
			
	Иначе
		Результат = Перечисления.СпособыРасчетаСебестоимостиПродукции.ПоПеределам;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция СпособУчетаВыпускаГотовойПродукции(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СпособУчетаВыпускаГотовойПродукции", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СпособыУчетаВыпускаГотовойПродукции.БезИспользованияСчета40;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция БазаРаспределенияКосвенныхРасходовПоВидамДеятельности(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("БазаРаспределенияКосвенныхРасходовПоВидамДеятельности", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ОсновнойСчетУчетаЗатрат(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ОсновнойСчетУчетаЗатрат", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
		
	Если Результат = Ложь Тогда
		Результат = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	КонецЕсли;

	Возврат Результат;

КонецФункции 

// Параметры учетной политики по резервам по сомнительным долгам

Функция ФормироватьРезервыПоСомнительнымДолгамБУ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ФормироватьРезервыПоСомнительнымДолгамВБухгалтерскомУчете", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

Функция ФормироватьРезервыПоСомнительнымДолгамНУ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ФормироватьРезервыПоСомнительнымДолгамВНалоговомУчете", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции 

// Прочие параметры учетной политики

Функция СпособОценкиМПЗ(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СпособОценкиМПЗ", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СпособыОценки.ПоСредней;
	КонецЕсли;

	Возврат Результат;

КонецФункции 

Функция СпособОценкиТоваровВРознице(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("СпособОценкиТоваровВРознице", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Если Результат = Ложь Тогда
		Результат = Перечисления.СпособыОценкиТоваровВРознице.ПоСтоимостиПриобретения;
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция СпособПогашенияСтоимостиСпецодеждыНУ(Организация, Период) Экспорт

	Если Период < '20150101' Тогда

		Результат = ПредопределенноеЗначение(
			"Перечисление.СпособыПогашенияСтоимостиНУ.ПриПередачеВЭксплуатацию");

	Иначе

		Результат = ПолучитьФункциональнуюОпцию("СпособПогашенияСтоимостиСпецодежды", 
			Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Параметры учетной политики по МСФО

Функция ПоддерживаетсяУчетПоЭлементамЗатрат() Экспорт
	
	УчетПоддерживается = Ложь;
	ЭлементыЗатрат.ОпределитьПоддержкуУчетаПоЭлементамЗатрат(УчетПоддерживается);
	Возврат УчетПоддерживается;
	
КонецФункции

Функция УчитыватьРасходыПоЭлементамЗатрат(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("УчитыватьРасходыПоЭлементамЗатрат", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция УчитыватьРасходыПоСтатьямЗатрат(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("УчитыватьРасходыПоСтатьямЗатрат", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

// Параметры учетной политики по банку и кассе

Функция ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств(Организация, Период) Экспорт
	
	Результат = ПолучитьФункциональнуюОпцию("ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));
	
	Возврат Результат;
	
КонецФункции

Функция РаздельныйУчетТорговыйСборПриУСН(Организация, Период) Экспорт
	
	ПрименяетсяУСНДоходы = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходы",
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));
	
	Если Не ПрименяетсяУСНДоходы Тогда
		Возврат Ложь;
	Иначе
		Возврат УчетнаяПолитика.ПлательщикТорговогоСбора(Организация, Период);
	КонецЕсли;
	
КонецФункции

// Параметры учетной политики по торговому сбору

Функция ПлательщикТорговогоСбора(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПлательщикТорговогоСбора", 
		Новый Структура("Организация,Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПлательщикТорговогоСбораЗаПериод(Организация, НачалоПериода, КонецПериода) Экспорт

	Возврат ТорговыйСбор.ИспользуютсяТорговыеТочкиЗаПериод(Организация, НачалоПериода, КонецПериода);

КонецФункции

Функция ПрименяютсяРазныеСтавкиНалогаНаПрибыль(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПрименяютсяРазныеСтавкиНалогаНаПрибыль", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ПорядокУплатыАвансов(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ПорядокУплатыАвансов", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

Функция ВариантБухгалтерскойОтчетности(Организация, Период) Экспорт

	Результат = ПолучитьФункциональнуюОпцию("ВариантБухгалтерскойОтчетности", 
		Новый Структура("Организация, Период", Организация, НачалоМесяца(Период)));

	Возврат Результат;

КонецФункции

﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Участник) <> Тип("Структура") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	РеквизитыУчастника = Параметры.Участник;
	
	Если РеквизитыУчастника.КПП = "0" Тогда
		РеквизитыУчастника.КПП = "";
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(РеквизитыУчастника.ИНН) И НЕ ЗначениеЗаполнено(РеквизитыУчастника.Ссылка) Тогда
		РеквизитыУчастника.Ссылка = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП("Контрагенты", РеквизитыУчастника.ИНН, РеквизитыУчастника.КПП);
	КонецЕсли;
	
	Если РеквизитыУчастника.Свойство("ДатаПодключения") Тогда
		РеквизитыУчастника.ДатаПодключения = БизнесСетьКлиентСервер.ДатаИзUnixTime(РеквизитыУчастника.ДатаПодключения);
	КонецЕсли;
	
	ЭтаФорма.ТекущийЭлемент = Элементы.Логотип;
	
	ЗаполнитьПрофиль();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбзорHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) <> "v8doc:" Тогда 
		Возврат;
	КонецЕсли;	
	НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
	
	ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьПрофиль(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СформироватьТекстПрофиляHTML(Реквизиты)
	
	ШаблонПрофиляHTML = ПолучитьШаблонПрофиляHTML();
	
	ЗаголовокHTML =
	"<div class=v8doc-header><b>[Наименование]</b></div>
	|<div class=v8doc-mail-information>[НадписьИНН] [ИНН] [НадписьКПП] [КПП]</div>
	|<div class=v8doc-information-date>[НадписьДатаПодключения] [ДатаПодключения]</div>
	|<hr>";
	
	ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[Наименование]", ПолучитьСсылкуHTML(Реквизиты.Ссылка, Реквизиты.Наименование));
	ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[НадписьИНН]", НСтр("ru = 'ИНН'"));
	ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[ИНН]", Реквизиты.ИНН);
	Если ЗначениеЗаполнено(Реквизиты.КПП) Тогда
		ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[НадписьКПП]", НСтр("ru = 'КПП'"));
		ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[КПП]", Реквизиты.КПП);
	Иначе
		ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[НадписьКПП]", "");
		ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[КПП]", "");
	КонецЕсли;
	ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[НадписьДатаПодключения]", НСтр("ru = 'Дата подключения:'"));
	ЗаголовокHTML = СтрЗаменить(ЗаголовокHTML, "[ДатаПодключения]", Формат(Реквизиты.ДатаПодключения,
	"ДЛФ=DD"));
	
	ШаблонПрофиляHTML = СтрЗаменить(ШаблонПрофиляHTML, "[Заголовок]", ЗаголовокHTML);
	
	ТелоHTML = "";
	
	ШаблонОбщий = "%1: <b>%2</b><br>";
	
	Если ЗначениеЗаполнено(Реквизиты.НаименованиеЕГРН) Тогда
		Строка1 = НСтр("ru = 'Наименование в едином государственном реестре налогоплательщиков'");
		Строка2 = "<br>" + Реквизиты.НаименованиеЕГРН + "<br>";
		ТелоHTML = ТелоHTML + СтрШаблон(ШаблонОбщий, Строка1, Строка2);
	КонецЕсли; 
	
	ШаблонПрофиляHTML = СтрЗаменить(ШаблонПрофиляHTML, "[Тело]", ТелоHTML);
	
	Возврат ШаблонПрофиляHTML;
	
КонецФункции

&НаСервере
Функция ПолучитьШаблонПрофиляHTML()
	
	ШаблонHTML =
	"<html>
	|<head><style class=v8doc-style type=text/css>
	|body{
	|	font-family:Arial;
	|	font-size:10pt;
	|   overflow: auto;
	|}
	|.v8doc-header{
	|	font-size=12pt;
	|	font-family=Arial;
	|	line-height:15pt;
	|	margin-bottom: 5pt;
	|}
	|.v8doc-information{
	|	font-size=8pt;
	|	font-family=Arial;
	|	line-height:12pt;
	|}
	|.v8doc-information-date{
	|	font-size=8pt;
	|	font-family=Arial;
	|	line-height:12pt;
	|   color:#7a7a7a;
	|}
	|blockquote{
	|	border:none;
	|	border-left:solid #7eaae3 1.5pt;
	|	padding:0cm 0cm 0cm 4pt;
	|	margin:0cm;
	|}
	|</style>
	|<meta content=""text/html; charset=utf-8"" http-equiv=""Content-Type"">
	|</head>
	|<body style=""margin-top:1px; padding-top:1px; overflow:auto; "">
	|<div>[Заголовок]</div>
	|<div>
	|[Тело]
	|</div>
	|</body>
	|</html>";
	
	Возврат ШаблонHTML;
	
КонецФункции

&НаСервере
Функция ПолучитьСсылкуHTML(Ссылка, ПредставлениеСсылки = "")
	
	СсылкаНаПредмет = "";
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат ПредставлениеСсылки;
	КонецЕсли;
	
	Если ПустаяСтрока(ПредставлениеСсылки) Тогда
		ПредставлениеСсылки = Ссылка.Наименование;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеСсылки) Тогда
		НавигационноеПредставлениеСсылки = "v8doc:" + ПолучитьНавигационнуюСсылку(Ссылка);
		СсылкаНаПредмет = СтрШаблон("<a href=""%1"">%2</a>", 
			НавигационноеПредставлениеСсылки, ПредставлениеСсылки);
	КонецЕсли;
	
	Возврат СсылкаНаПредмет;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПрофиль(ПерезаполнитьДанные = Ложь)
	
	Если ПерезаполнитьДанные Тогда
		ПовторноПолучитьДанныеСервиса();
	КонецЕсли;
	
	Заголовок = НСтр("ru = '%1 (профиль 1С:Бизнес-сеть)'");
	Заголовок = СтрШаблон(Заголовок, РеквизитыУчастника.Наименование);
	ТекстПрофиля = СформироватьТекстПрофиляHTML(РеквизитыУчастника);
	
КонецПроцедуры

&НаСервере
Процедура ПовторноПолучитьДанныеСервиса()
	
	Результат = Неопределено;
	Отказ = Ложь;
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Ссылка", Ссылка);
	ПараметрыКоманды.Вставить("ИНН", Параметры.ИНН);
	ПараметрыКоманды.Вставить("КПП", Параметры.КПП);
	БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ПараметрыКоманды, Результат, Отказ);
	Если Не Отказ И Результат.КодСостояния = 200 Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыУчастника, Результат.Данные,, "ИНН, КПП, ДатаПодключения");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

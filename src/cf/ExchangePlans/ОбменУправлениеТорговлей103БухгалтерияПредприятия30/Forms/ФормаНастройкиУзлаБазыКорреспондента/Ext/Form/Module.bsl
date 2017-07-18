﻿
&НаКлиенте
Процедура КомандаОК(Команда)
	ПодготовитьДанныеДляЗакрытияФормы();
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаБазыКорреспондентаПриСозданииНаСервере(ЭтаФорма, "ОбменУправлениеТорговлей103БухгалтерияПредприятия30");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтотОбъект, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура Кассы1ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(Элемент, ВыбранноеЗначение, Кассы);
КонецПроцедуры

&НаКлиенте
Процедура Кассы1КассаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора("Касса", "Справочник.Кассы", Элементы.Кассы, СтандартнаяОбработка, ПараметрыВнешнегоСоединения);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОрганизацииОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора("Организация", "Справочник.Организации", Элементы.ОбъектОрганизации, СтандартнаяОбработка, ПараметрыВнешнегоСоединения);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСкладыСкладНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора("Склад", "Справочник.Склады", Элементы.ОбъектСклады, СтандартнаяОбработка, ПараметрыВнешнегоСоединения);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПодразделенияПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаНачалоВыбора("Подразделение", "Справочник.Подразделения", Элементы.ОбъектПодразделения, СтандартнаяОбработка, ПараметрыВнешнегоСоединения);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПодразделенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(Элемент, ВыбранноеЗначение, Организации);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектСкладыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(Элемент, ВыбранноеЗначение, Склады);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ОбработчикВыбораЭлементовБазыКорреспондентаОбработкаВыбора(Элемент, ВыбранноеЗначение, Подразделения);
КонецПроцедуры

Процедура ПодготовитьДанныеДляЗакрытияФормы()
	Если ИспользоватьОтборПоОрганизациям = Ложь Тогда
		Организации.Очистить();
	КонецЕсли;
	Если ИспользоватьОтборПоСкладам = Ложь Тогда
		Склады.Очистить();
	КонецЕсли;
	Если ИспользоватьОтборПоПодразделениям = Ложь Тогда
		Подразделения.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоОрганизациямПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоСкладамПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПоПодразделениямПриИзменении(Элемент)
	УстановитьДоступностьЭлементамФормы();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементамФормы()
	
	Элементы.ОбъектОрганизации.Доступность   = ИспользоватьОтборПоОрганизациям;
	Элементы.ОбъектПодразделения.Доступность = ИспользоватьОтборПоПодразделениям;
	Элементы.ОбъектСклады.Доступность        = ИспользоватьОтборПоСкладам;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементамФормы();
КонецПроцедуры



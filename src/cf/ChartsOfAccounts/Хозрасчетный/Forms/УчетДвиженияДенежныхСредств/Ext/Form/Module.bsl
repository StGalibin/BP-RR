﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.ПланыСчетов.Хозрасчетный);
	Элементы.ЗаписатьИЗакрыть.Видимость = НЕ ТолькоПросмотр;
	
	ПараметрыУчета = ОбщегоНазначенияБП.ОпределитьПараметрыУчета();
	
	ИспользоватьСтатьиДвиженияДенежныхСредств                  	= ПараметрыУчета.ВестиУчетПоСтатьямДДС;
	ИспользоватьСтатьиДвиженияДенежныхСредствИсходноеЗначение 	= ИспользоватьСтатьиДвиженияДенежныхСредств;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВестиУчетПоСтатьямДДСПриИзменении(Элемент)
	
	Если НЕ ИспользоватьСтатьиДвиженияДенежныхСредств
		И ВедетсяУчетНФО() Тогда
		ТекстПредупреждения = НСтр("ru='Нельзя отключить аналитику по статьям движения денежных средств,
			|так как ведется учет некредитных финансовых организаций.'");
		ИспользоватьСтатьиДвиженияДенежныхСредств = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИзменения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗаписьюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПрименитьНастройкуСубконто();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаписатьИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если (Форма.ИспользоватьСтатьиДвиженияДенежныхСредств <> Форма.ИспользоватьСтатьиДвиженияДенежныхСредствИсходноеЗначение)
		И Форма.ИспользоватьСтатьиДвиженияДенежныхСредствИсходноеЗначение Тогда
		Форма.Элементы.ГруппаИспользоватьСтатьиДвиженияДенежныхСредствПредупреждениеАктивно.Видимость = Истина;
	Иначе
		Форма.Элементы.ГруппаИспользоватьСтатьиДвиженияДенежныхСредствПредупреждениеАктивно.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения()
	
	ПараметрыУчета.ВестиУчетПоСтатьямДДС = ИспользоватьСтатьиДвиженияДенежныхСредств;
	
	ТекстВопроса = ОбщегоНазначенияБПВызовСервера.ПолучитьТекстВопросаПриУдаленииСубконто(ПараметрыУчета);
	Если ПустаяСтрока(ТекстВопроса) Тогда
		ПрименитьНастройкуСубконто();
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ВопросПередЗаписьюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройкуСубконто(Отказ = Ложь)
	
	ПрименитьНастройкуСубконтоНаСервере(Отказ);
	
	Если НЕ Отказ Тогда
		Модифицированность = Ложь;
		Оповестить("ИзменениеНастройкиПланаСчетов");
		Оповестить("ИзменениеНастроекПараметровУчета");
		ОповеститьОбИзменении(Тип("ПланСчетовСсылка.Хозрасчетный"));
		ОбновитьИнтерфейс();
		ПоказатьОповещениеПользователя(НСтр("ru = 'Изменены параметры субконто'"), 
			"e1cib/app/Обработка.ЖурналРегистрации", "Журнал регистрации");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьНастройкуСубконтоНаСервере(Отказ = Ложь)
	
	ОбщегоНазначенияБП.ПрименитьПараметрыУчета(ПараметрыУчета, Истина, Отказ);
	
	Если НЕ Отказ Тогда
		Константы.ИспользоватьСтатьиДвиженияДенежныхСредств.Установить(ИспользоватьСтатьиДвиженияДенежныхСредств);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВедетсяУчетНФО()

	Возврат ПолучитьФункциональнуюОпцию("ВедетсяУчетНФО");

КонецФункции

#КонецОбласти

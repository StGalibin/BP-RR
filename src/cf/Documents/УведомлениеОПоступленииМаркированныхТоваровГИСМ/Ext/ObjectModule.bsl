﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("НомераКиЗ.ДокументПоступления");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
	Если НомераКиЗ.Количество() > 0 Тогда
		
		Для Каждого СтрокаТЧ Из НомераКиЗ Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ДокументПоступления) 
				И (СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить 
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.КПередаче
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Передано
				Или СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ) Тогда
				
				НомерСтроки = СтрокаТЧ.НомерСтроки;
				
				ТекстОшибки = НСтр("ru='Не указан документ поступления в строке %НомерСтроки% списка ""Выпущенные КиЗ""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ВыпущенныеКиЗ", НомерСтроки, "ДокументПоступления"),
					,
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
		Запрос = ИнтеграцияГИСМПереопределяемый.ЗапросПоПоступившимКиЗ(ЭтотОбъект);
		
		Результат = Запрос.Выполнить();
		ВыборкаНомераКиЗ = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаНомераКиЗ.Следующий() Цикл
			
			ТекущийДокументПоступленияПравильный = Ложь;
			
			ВыборкаДетали = ВыборкаНомераКиЗ.Выбрать();
			Пока ВыборкаДетали.Следующий() Цикл
				
				НомерСтроки = ВыборкаДетали.НомерСтроки;
				Если ВыборкаДетали.ДокументПоступления = ВыборкаДетали.ДокументПоступленияКандидат Тогда
					ТекущийДокументПоступленияПравильный = Истина;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступления) 
					И (ВыборкаДетали.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление
					   Или ВыборкаДетали.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление) Тогда
					
					ТекущийДокументПоступленияПравильный = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ТекущийДокументПоступленияПравильный Тогда
				
				ТекстОшибки = НСтр("ru='Указан некорректный документ поступления в строке %НомерСтроки% списка ""Номера КиЗ""'");
				ТекстОшибки =  СтрЗаменить(ТекстОшибки, "%НомерСтроки%", НомерСтроки);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НомераКиЗ", НомерСтроки, "ДокументПоступления"),
					,
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Копирование не поддерживается.'")
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
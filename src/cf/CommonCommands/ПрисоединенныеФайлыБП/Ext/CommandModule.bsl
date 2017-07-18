﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	
	ШаблонЗаголовка = НСтр("ru='Присоединенные файлы: %1'");
	ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  ПараметрКоманды);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ПараметрыВыполненияКоманды.Источник.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ПростаяФорма", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", ТекстЗаголовка);
	
	// ИнтеграцияС1СДокументооборотом
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтеграцияС1СДокументооборотом") Тогда
		
		МодульИнтеграцияС1СДокументооборотКлиентПовтИсп = 
			ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияС1СДокументооборотКлиентПовтИсп");
		Если МодульИнтеграцияС1СДокументооборотКлиентПовтИсп.
				ИспользоватьПрисоединенныеФайлы1СДокументооборота() Тогда
				
			МодульИнтеграцияС1СДокументооборотВызовСервера = 
				ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтеграцияС1СДокументооборотВызовСервера");
			Если МодульИнтеграцияС1СДокументооборотВызовСервера.
				ИспользоватьПрисоединенныеФайлы1СДокументооборотаДляОбъекта(ПараметрКоманды) Тогда
				
				ИмяФормы = "Обработка.ИнтеграцияС1СДокументооборот.Форма.ПрисоединенныеФайлы";
				ОткрытьФорму(ИмяФормы,
					ПараметрыФормы,
					ПараметрыВыполненияКоманды.Источник,
					ПараметрыВыполненияКоманды.Уникальность,
					ПараметрыВыполненияКоманды.Окно);
			
				Возврат;
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	// Конец ИнтеграцияС1СДокументооборотом
		
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлыБП",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти


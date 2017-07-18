﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Меняет даты следующего счета для переданных правил.
//  Параметры:
//   Правила - Массив со значениями СправочникСсылка.ПравилаРегулярныхСчетовПокупателям.
//   ДатаСледующего - Дата.
//
Процедура ИзменитьДатуСледующего(Правила, ДатаСледующего) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Правила", Правила);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегулярныеСчетаПокупателямСрезПоследних.Период,
	|	РегулярныеСчетаПокупателямСрезПоследних.Правило,
	|	РегулярныеСчетаПокупателямСрезПоследних.Организация,
	|	РегулярныеСчетаПокупателямСрезПоследних.Шаблон
	|ИЗ
	|	РегистрСведений.РегулярныеСчетаПокупателям.СрезПоследних(, Правило В (&Правила)) КАК РегулярныеСчетаПокупателямСрезПоследних";
	
	Запись = РегистрыСведений.РегулярныеСчетаПокупателям.СоздатьМенеджерЗаписи();
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Запись.Период      = Выборка.Период;
		Запись.Организация = Выборка.Организация;
		Запись.Правило     = Выборка.Правило;
		
		Запись.Прочитать();
		
		Запись.Период = ДатаСледующего;
		
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает новый шаблон либо меняет существующий.
//
// Параметры:
//  Правило       - СправочникСсылка.ПравилаПовторенияСчетовПокупателей
//  Шаблон        - ДокументСсылка.СчетНаОплатуПокупателю - Новый шаблон.
//  ПериодСобытия - Дата - Дата следующего повторения счета, по умолчанию Неопределено.
//                  В таком случае добавляется период указанный в правиле.
//  ОбновитьСуществующийШаблон - Булево - признак того, нужно ли проверять период события.
//
// Возвращаемое значение:
//  Булево - Истина, если изменен шаблон или добавлен новый
//
Функция УстановитьШаблон(Правило, Шаблон, ПериодСобытия = Неопределено, ОбновитьСуществующийШаблон = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Правило",     Правило);
	Запрос.УстановитьПараметр("НовыйШаблон", Шаблон);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.Организация
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.Ссылка = &НовыйШаблон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегулярныеСчетаПокупателямСрезПоследних.Период,
	|	РегулярныеСчетаПокупателямСрезПоследних.Правило.Периодичность КАК Периодичность,
	|	РегулярныеСчетаПокупателямСрезПоследних.Организация,
	|	РегулярныеСчетаПокупателямСрезПоследних.Шаблон
	|ИЗ
	|	РегистрСведений.РегулярныеСчетаПокупателям.СрезПоследних(, Правило = &Правило) КАК РегулярныеСчетаПокупателямСрезПоследних";
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Выборка = Результаты[0].Выбрать();
	
	Выборка.Следующий();
	Организация = Выборка.Организация;
	
	Выборка = Результаты[1].Выбрать();
	
	Запись = РегистрыСведений.РегулярныеСчетаПокупателям.СоздатьМенеджерЗаписи();
	
	Если Выборка.Следующий() Тогда
		
		Если ПериодСобытия = Неопределено Тогда
			Если ОбновитьСуществующийШаблон Тогда
				ПериодСобытия = Выборка.Период;
			Иначе
				ПериодСобытия = ИнтерфейсыВзаимодействияБРОКлиентСервер.ДобавитьПериод(Выборка.Период, Выборка.Периодичность);
			КонецЕсли;
		КонецЕсли;
		
		Если Выборка.Шаблон = Шаблон Тогда
			
			Если Выборка.Организация <> Организация Тогда
				ПравилоОбъект = Правило.ПолучитьОбъект();
				ПравилоОбъект.Организация = Организация;
				ПравилоОбъект.Записать();
			КонецЕсли;
			
			Если Выборка.Организация = Организация И Выборка.Период = ПериодСобытия Тогда
				
				Возврат Ложь;
				
			Иначе
				
				Запись.Период      = Выборка.Период;
				Запись.Организация = Выборка.Организация;
				Запись.Правило     = Правило;
				
				Запись.Прочитать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запись.Период      = ПериодСобытия;
	Запись.Организация = Организация;
	Запись.Правило     = Правило;
	Запись.Шаблон      = Шаблон;
	
	Запись.Записать();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли

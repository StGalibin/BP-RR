﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Процедура ПриИнициализацииФормыРегламентированногоОтчета(Форма, КонтролирующийОрган = "ФНС") Экспорт
	
	Если КонтролирующийОрган = "ФСС" Тогда
		
		// регулируем видимость ЭУ отправки ФСС
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		ДокументооборотСФССКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовки);
		
	ИначеЕсли КонтролирующийОрган = "ФСРАР" Тогда
		
		// регулируем видимость ЭУ отправки ФСРАР
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		ДокументооборотСФСРАРКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовки);
		
	ИначеЕсли КонтролирующийОрган = "РПН" Тогда
		
		// регулируем видимость ЭУ отправки РПН
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		ДокументооборотСРПНКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовки);
		
	ИначеЕсли КонтролирующийОрган = "ФТС" Тогда
		
		// регулируем видимость ЭУ отправки ФТС
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		ДокументооборотСФТСКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовки);
		
	ИначеЕсли КонтролирующийОрган = "БанкРоссии" Тогда
		
		// регулируем видимость ЭУ отправки в Банк России
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		
		#Если Клиент Тогда
			МодульДокументооборотСБанкомРоссииКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСБанкомРоссииКлиентСервер");
		#Иначе
			МодульДокументооборотСБанкомРоссииКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ДокументооборотСБанкомРоссииКлиентСервер");
		#КонецЕсли
		МодульДокументооборотСБанкомРоссииКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовки);
		
	Иначе
		
		// убираем видимость меню отправки через сервис спецоператора
		СдачаОтчетностиЧерезСервисСпецоператораКлиентСервер.УстановитьВидимостьКнопкиОтправкиЧерезПредставителя(Форма);
		
		// регулируем видимость ЭУ отправки с использованием встроенного механизма
		// и одновременно получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = Неопределено;
		ДокументооборотСКОКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(Форма, КонтролирующийОрган, ПараметрыПрорисовки);
		
	КонецЕсли;
	
	// применяем параметры прорисовки
	ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовки);
	
КонецПроцедуры

Процедура ОбновитьПанельСостоянияОтправкиВРегламентированномОтчете(Форма, КонтролирующийОрган) Экспорт
	
	Если КонтролирующийОрган = "ФСС" Тогда
		
		//получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = ДокументооборотСФССКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
		
	ИначеЕсли КонтролирующийОрган = "ФСРАР" Тогда
		
		//получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = ДокументооборотСФСРАРКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
		
	ИначеЕсли КонтролирующийОрган = "РПН" Тогда
		
		//получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = ДокументооборотСРПНКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
		
	ИначеЕсли КонтролирующийОрган = "ФТС" Тогда
		
		//получаем параметры прорисовки панели отправки
		ПараметрыПрорисовки = ДокументооборотСФТСКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
		
	ИначеЕсли КонтролирующийОрган = "БанкРоссии" Тогда
		
		#Если Клиент Тогда
			МодульДокументооборотСБанкомРоссииКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСБанкомРоссииКлиентСервер");
		#Иначе
			МодульДокументооборотСБанкомРоссииКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ДокументооборотСБанкомРоссииКлиентСервер");
		#КонецЕсли
		ПараметрыПрорисовки = МодульДокументооборотСБанкомРоссииКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
		
	Иначе
		
		ПараметрыПрорисовки = ДокументооборотСКОКлиентСервер.ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма, КонтролирующийОрган);
		
	КонецЕсли;
	
	// применяем параметры прорисовки
	ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовки);
	
КонецПроцедуры

Процедура ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовки) Экспорт
	
	// Находим панель отправки
	ГруппаПанельОтправки = Форма.Элементы.Найти("ГруппаПанельОтправки");
	Если ГруппаПанельОтправки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	// Если ПараметрыПрорисовки не удалось определить, скрываем панель
	Если ПараметрыПрорисовки = Неопределено Тогда
		ГруппаПанельОтправки.Видимость = Ложь;
		Возврат;
	Иначе
		ГруппаПанельОтправки.Видимость = Истина;
	КонецЕсли;
	
	// Если нет доступа к контексту ЭДО, то скрываем панель
	Если НЕ ДокументооборотСКОВызовСервера.ЕстьДоступККонтекстуЭДО() Тогда
		ГруппаПанельОтправки.Видимость = Ложь;
		Возврат;
	Иначе
		ГруппаПанельОтправки.Видимость = Истина;
	КонецЕсли;
	
	СостояниеОтправки 			= ПараметрыПрорисовки.ТекущийЭтапОтправки;
	ЕстьНеотправленныеИзвещения = ПараметрыПрорисовки.НеотправленныеИзвещения.ЕстьНеотправленныеИзвещения;
	ЕстьКритическиеОшибки 		= ПараметрыПрорисовки.ЕстьКритическиеОшибки;
	КонтролирующийОрган			= ПараметрыПрорисовки.КонтролирующийОрган;
	
	СостояниеСдачиОтчетности = СостояниеОтправки.СостояниеСдачиОтчетности;
	
	// Находим блок состояния отправки
	БлокСостоянияОтправки = Форма.Элементы.Найти("БлокСостоянияОтправки");
	Если БлокСостоянияОтправки = Неопределено Тогда
		
		// Поддерживаем старую панель 
		ЭлементФормыНаименованиеЭтапа = Форма.Элементы.Найти("НадписьСостояниеОтправки");
		Если ЭлементФормыНаименованиеЭтапа <> Неопределено Тогда
			ЭлементФормыНаименованиеЭтапа.Заголовок = СостояниеОтправки.ТекстНадписи;
		КонецЕсли;
		
	Иначе
		
		// Находим блок критических ошибок отправки
		БлокКритическихОшибок = Форма.Элементы.Найти("БлокКритическихОшибок");
		Если БлокКритическихОшибок = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		// Находим блок неотправленных извещений
		БлокНеотправленныхИзвещений = Форма.Элементы.Найти("БлокНеотправленныхИзвещений");
		Если БлокНеотправленныхИзвещений = Неопределено Тогда
			Возврат;
		КонецЕсли;

		// Определяем цвет фона
		БлокСостоянияОтправки.ЦветФона = ДокументооборотСКОВызовСервера.ЦветФонаПанелиОтправкиПоСтатусу(СостояниеСдачиОтчетности);
		
		// Наименование протокола
		ЭлементФормыГиперссылкаПротокол = Форма.Элементы.Найти("ГиперссылкаПротокол");
		Если ЭлементФормыГиперссылкаПротокол <> Неопределено Тогда
			Если ЗначениеЗаполнено(СостояниеОтправки.НаименованиеПротокола) Тогда
				ЭлементФормыГиперссылкаПротокол.Видимость = Истина;
				ЭлементФормыГиперссылкаПротокол.Заголовок = СостояниеОтправки.НаименованиеПротокола;
			Иначе
				ЭлементФормыГиперссылкаПротокол.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		// Наименование текущего этапа
		ЭлементФормыНаименованиеЭтапа = Форма.Элементы.Найти("НаименованиеЭтапа");
		Если ЭлементФормыНаименованиеЭтапа <> Неопределено Тогда
			ЭлементФормыНаименованиеЭтапа.Заголовок = СостояниеОтправки.ТекстНадписи;
		КонецЕсли;
			
		// Этапы отправки
		ЭлементФормыЭтапыОтправки = Форма.Элементы.Найти("ЭтапыОтправки");
		Если ЭлементФормыЭтапыОтправки <> Неопределено Тогда
			ЭлементФормыЭтапыОтправки.Видимость = 
				СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ДокументооборотНеНачат");
		Конецесли;
		
		// Комментарий к этапу
		ЭлементФормыКомментарийЭтапа = Форма.Элементы.Найти("КомментарийЭтапа");
		Если ЭлементФормыКомментарийЭтапа <> Неопределено Тогда
			
			КомментарийКСостоянию = СостояниеОтправки.КомментарийКСостоянию;
			
			Если ЗначениеЗаполнено(КомментарийКСостоянию) Тогда
				
				ЭлементФормыКомментарийЭтапа.Заголовок 					= КомментарийКСостоянию;
				ЭлементФормыКомментарийЭтапа.Видимость 					= Истина;
				ЭлементФормыКомментарийЭтапа.РастягиватьПоГоризонтали 	= Истина;
				Если Форма.Элементы.Найти("ОтступПередКнопкойОбновитьОтправку") <> Неопределено Тогда 
					Форма.Элементы.ОтступПередКнопкойОбновитьОтправку.Видимость = Ложь;
				КонецЕсли;
				
			Иначе
				
				ЭлементФормыКомментарийЭтапа.Видимость = Ложь;
				ЭлементФормыКомментарийЭтапа.РастягиватьПоГоризонтали = Ложь;
				Если Форма.Элементы.Найти("ОтступПередКнопкойОбновитьОтправку") <> Неопределено Тогда 
					Форма.Элементы.ОтступПередКнопкойОбновитьОтправку.Видимость = Истина;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		// Кнопка Обновить
		ЭлементФормыОбновитьОтправку = Форма.Элементы.Найти("ОбновитьОтправку");
		Если ЭлементФормыОбновитьОтправку <> Неопределено Тогда
			ЭлементФормыОбновитьОтправку.Видимость = ВидимостьКнопкиОтправкаПоСостоянию(СостояниеСдачиОтчетности, КонтролирующийОрган);
		КонецЕсли;
		
		// Критические ошибки
		ЭлементФормыБлокКритическихОшибок = Форма.Элементы.Найти("БлокКритическихОшибок");
		Если ЭлементФормыБлокКритическихОшибок <> Неопределено Тогда
			
			// Форматированная строка
			ЭлементФормыКритическиеОшибки = Форма.Элементы.Найти("КритическиеОшибки");
			Если ЭлементФормыКритическиеОшибки <> Неопределено Тогда
				
				ЭлементФормыКритическиеОшибки.Видимость 			= ЕстьКритическиеОшибки;
				Форма.Элементы.ЗначокКритическойОшибки.Видимость 	= ЕстьКритическиеОшибки;

			КонецЕсли;
			
		КонецЕсли;
		
		// Поддержка старых элементов формы
		ЭлементФормыЗаголовокКритическихОшибок = Форма.Элементы.Найти("ЗаголовокКритическихОшибок");
		Если ЭлементФормыЗаголовокКритическихОшибок <> Неопределено Тогда
			ЭлементФормыЗаголовокКритическихОшибок.Видимость = ЕстьКритическиеОшибки;
		КонецЕсли;
		
		ЭлементФормыГиперссылкаНаКритическиеОшибки = Форма.Элементы.Найти("ГиперссылкаНаКритическиеОшибки");
		Если ЭлементФормыГиперссылкаНаКритическиеОшибки <> Неопределено Тогда
			ЭлементФормыГиперссылкаНаКритическиеОшибки.Видимость = ЕстьКритическиеОшибки;
		КонецЕсли;
				
		// Неотправленные извещения
		ЭлементФормыБлокНеотправленныхИзвещений = Форма.Элементы.Найти("БлокНеотправленныхИзвещений");
		Если ЭлементФормыБлокНеотправленныхИзвещений <> Неопределено Тогда
			ЭлементФормыБлокНеотправленныхИзвещений.Видимость = ЕстьНеотправленныеИзвещения;
		КонецЕсли;
		
		// Видимость панели с ошибками и неотправленными извещениями
		ЭлементФормыБлокОшибокИИзвещений = Форма.Элементы.Найти("БлокОшибокИИзвещений");
		Если ЭлементФормыБлокОшибокИИзвещений <> Неопределено Тогда
			ЭлементФормыБлокОшибокИИзвещений.Видимость = ЕстьКритическиеОшибки ИЛИ ЕстьНеотправленныеИзвещения;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВидимостьКнопкиОтправкаПоСостоянию(СостояниеСдачиОтчетности, КонтролирующийОрган = Неопределено) Экспорт
	
	Возврат ((СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ПоложительныйРезультатДокументооборота")
			И СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ОтрицательныйРезультатДокументооборота"))
			ИЛИ КонтролирующийОрган = "ФСРАР" ИЛИ КонтролирующийОрган = "ФТС")
			И СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ПриемПодтвержден")
			И СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ДокументооборотНеНачат")
			И СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ОтправленоИзКонтролирующегоОргана")
			И СостояниеСдачиОтчетности <> ПредопределенноеЗначение("Перечисление.СостояниеСдачиОтчетности.ТребуетсяПодтверждениеПриема");
	
КонецФункции

Функция СсылкаНаОтчетПоФорме(Форма) Экспорт
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "СтруктураРеквизитовФормы")
		И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.СтруктураРеквизитовФормы, "мСохраненныйДок") Тогда
		Возврат Форма.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "Объект")
		И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.Объект, "Ссылка") Тогда
		Возврат Форма.Объект.Ссылка;
	ИначеЕсли СтрНайти(Форма.ИмяФормы, "ДлительнаяОперация") <> 0
		И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "ОтчетСсылка") Тогда
		Возврат Форма.ОтчетСсылка;
	Иначе
		Возврат ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСерверПереопределяемый.ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма);
	КонецЕсли;
	
КонецФункции

Функция СтрокаОС() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux32";
	ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux64";
	ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows32";
	Иначе
		Возврат "Windows64";
	КонецЕсли;
	
КонецФункции

Функция ЭтоЛинукс() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат (СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64);
	
КонецФункции 

Функция ЭтоФайрФокс() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат СтрНайти(СисИнфо.ИнформацияПрограммыПросмотра, "Firefox") <> 0;
	
КонецФункции

Функция ЭтоФайрФоксХромИлиСафари() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Возврат (СтрНайти(СисИнфо.ИнформацияПрограммыПросмотра, "Firefox") <> 0 ИЛИ СтрНайти(СисИнфо.ИнформацияПрограммыПросмотра, "Chrome") <> 0 ИЛИ СтрНайти(СисИнфо.ИнформацияПрограммыПросмотра, "Safari") <> 0);
	
КонецФункции 

// Функция возвращает массив имен объектов метаданных.
// 
// Параметры:
//	Массив элементов справочника ВидыОтправляемыхДокументов
//
// Результат:
//	Массив соответствующих видов прочих уведомлений
//
Функция МассивВидовПрочихУведомленийПоддерживающихДокументооборот(МассивВидовОтправляемыхДокументов) Экспорт
	
	МассивВидовПрочихУведомленийПоддерживающихДокументооборот = Новый Массив;
	
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ВыборНалоговогоОрганаДляПостановкиНаУчет")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ОткрытиеЗакрытиеСчета")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.УчастиеВРоссийскихИностранныхОрганизациях")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.СозданиеОбособленныхПодразделений")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗакрытиеОбособленныхПодразделений")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.РеорганизацияЛиквидацияОрганизации")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПостановкаНаУчетОрганизацииПлательщикаЕНВД")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПостановкаНаУчетПредпринимателяПлательщикаЕНВД")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.СнятиеСУчетаОрганизацииПлательщикаЕНВД")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.СнятиеСУчетаПредпринимателяПлательщикаЕНВД")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ИзменениеОбъектаУСН")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ОтказОтУСН")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.УтратаПраваНаУСН")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПереходНаУСН")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ПрекращениеДеятельностиУСН")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН"));
	КонецЕсли;
	
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеНаПолучениеПатента")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатента"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОбУтратеПраваНаПатент")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент"));
	КонецЕсли;
	
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаУ_ИО")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаТС1")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаТС2")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаС_09_6")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаСИО")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО"));
	КонецЕсли;
	
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОЗачетеНалога")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОВозвратеНалога")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога"));
	КонецЕсли;
	
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ЗаявлениеОРегистрацииОбъектаНВОС")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.ФормаКИК")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК"));
	КонецЕсли;
	Если МассивВидовОтправляемыхДокументов.Найти(ПредопределенноеЗначение("Справочник.ВидыОтправляемыхДокументов.НаделениеОППолномочиямиПоВыплатамФизлицам")) <> Неопределено Тогда
		МассивВидовПрочихУведомленийПоддерживающихДокументооборот.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам"));
	КонецЕсли;
	
	Возврат МассивВидовПрочихУведомленийПоддерживающихДокументооборот;

КонецФункции

Функция ТелефонМобильныйБезРазделителей(Знач ТелефонМобильный) Экспорт
	
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, "+7", "");
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, "+", "");
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, "(", "");
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, ")", "");
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, "-", "");
	ТелефонМобильный = СтрЗаменить(ТелефонМобильный, " ", "");
	ТелефонМобильный = СокрЛП(ТелефонМобильный);
	
	Если ПустаяСтрока(ТелефонМобильный) Тогда
		Возврат "";
	Иначе
		Если СтрДлина(ТелефонМобильный) = 10 Тогда
			Возврат "8" + ТелефонМобильный;
		Иначе
			Возврат ТелефонМобильный;
		КонецЕсли;
	КонецЕсли;
		
КонецФункции

Функция ТелефонМобильныйЗаполнен(Знач ТелефонМобильный) Экспорт
	
	Телефон = ТелефонМобильныйБезРазделителей(ТелефонМобильный);
	
	Возврат СтрДлина(Телефон) = 11;
	
КонецФункции

Функция СтрокаВФорматеДляСравнения(Знач Текст) Экспорт
	
	Результат = Строка(Текст);
	Результат = СокрЛП(Результат);
	Результат = Врег(Результат);
	
	Возврат Результат;
	
КонецФункции


Функция ФорматированноеПредставлениеСпискаВложений(МассивЭлементов) Экспорт
	
	МассивПредставлений = Новый Массив;
	Для Каждого Элемент Из МассивЭлементов Цикл
		ПредставлениеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (%2)'"), Элемент.ИмяФайла, ТекстовоеПредставлениеРазмераФайла(Элемент.Размер));
		
		СсылкаНаФайл = ?(Элемент.Свойство("Ссылка"), Элемент.Ссылка, Элемент.ИмяФайла);
		МассивПредставлений.Добавить(Новый ФорматированнаяСтрока(ПредставлениеФайла,,,, СсылкаНаФайл));
		МассивПредставлений.Добавить(Символы.ПС);
		МассивПредставлений.Добавить("");
		МассивПредставлений.Добавить(Символы.ПС);
		
	КонецЦикла;
	
	Представление = Новый ФорматированнаяСтрока(МассивПредставлений);
	
	Возврат Представление;
	
КонецФункции

Функция ТекстовоеПредставлениеРазмераФайла(РазмерВБайтах) Экспорт
	
	Размер = 0;
	РазмерВКилобайтах = Окр(РазмерВБайтах / 1024);
	Если РазмерВБайтах = 0 Тогда
		Шаблон = НСтр("ru = '%1 Б'");
	ИначеЕсли РазмерВКилобайтах < 1000 Тогда
		Размер = РазмерВКилобайтах;
		Шаблон = НСтр("ru = '%1 КБ'");
	Иначе
		Размер = Окр(РазмерВКилобайтах / 1024);
		Шаблон = НСтр("ru = '%1 МБ'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Размер);
	
КонецФункции

Функция ЗаменитьНечитаемыеСимволы(ИсходнаяСтрока, ЗаменятьНа = "_") Экспорт
	
	СтрокаПослеЗамены = ИсходнаяСтрока;
	
	ДлинаСтроки = СтрДлина(ИсходнаяСтрока);
	Для Индекс = 1 По ДлинаСтроки Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, Индекс, 1);
		Если КодСимвола(ТекущийСимвол) < 32 Тогда
			СтрокаПослеЗамены = СтрЗаменить(СтрокаПослеЗамены, ТекущийСимвол, ЗаменятьНа);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат СтрокаПослеЗамены;
	
КонецФункции

Функция ПутьМодуляКриптографии() Экспорт
	
	ПерсональныеНастройки = ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки();
	Если ПерсональныеНастройки.Свойство("ПутиКПрограммамЭлектроннойПодписиИШифрования")
		И ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования.Количество() > 0 Тогда
		
		ОписанияПрограмм = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ОписанияПрограмм;
		
		Для ИндексПрограммы = 0 По ОписанияПрограмм.ВГраница() Цикл
			Если ОписанияПрограмм[ИндексПрограммы].ИмяПрограммы = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider" Тогда
				СсылкаНаПрограмму = ОписанияПрограмм[ИндексПрограммы].Ссылка;
				ПутьКПрограмме = ПерсональныеНастройки.ПутиКПрограммамЭлектроннойПодписиИШифрования.Получить(СсылкаНаПрограмму);
				Возврат Строка(ПутьКПрограмме);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат("");
	
КонецФункции

Функция ПолучитьПараметрыКриптопровайдера(ЗначениеПеречисления) Экспорт
	
	Криптопровайдер = Новый Структура("Тип, Имя, ОтображаемоеНазвание");
	Если ЗначениеПеречисления = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet") Тогда
		Криптопровайдер.Тип = "2";
		Криптопровайдер.Имя = "Infotecs Cryptographic Service Provider";
		Криптопровайдер.ОтображаемоеНазвание = "VipNet CSP"
	ИначеЕсли ЗначениеПеречисления = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro") Тогда
		Криптопровайдер.Тип = "75";
		Криптопровайдер.Имя = "Crypto-Pro GOST R 34.10-2001 Cryptographic Service Provider";
		Криптопровайдер.ОтображаемоеНазвание = "CryptoPro CSP"
	Иначе
		Криптопровайдер.Тип = "0";
		Криптопровайдер.Имя = "";
	КонецЕсли;
	
	Возврат Криптопровайдер;
	
КонецФункции

Процедура ЗаписьСобытияВЖурналРегистрации(Знач ТекстСообщения, ОписаниеОшибки) Экспорт
	
	#Если Клиент Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС + ОписаниеОшибки;
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ТекстСообщения, "Ошибка",,,Истина);
	#Иначе
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки);
	#КонецЕсли
	
КонецПроцедуры

Процедура СообщитьИлиПередатьВМастерОшибку(Ошибка, ВызовИзМастераПодключенияК1СОтчетности = ложь, ТекстОшибокДляМастераПодключенияК1СОтчетности = "", ВыводитьСообщения = истина) Экспорт
	
	Если ВыводитьСообщения и не ВызовИзМастераПодключенияК1СОтчетности Тогда 
		ДлительнаяОтправкаКлиентСервер.ВывестиОшибку(Ошибка);
	КонецЕсли;	
	
	Если ВызовИзМастераПодключенияК1СОтчетности Тогда 
		ТекстОшибокДляМастераПодключенияК1СОтчетности = 
			ТекстОшибокДляМастераПодключенияК1СОтчетности + 
			?(ПустаяСтрока(ТекстОшибокДляМастераПодключенияК1СОтчетности), "", Символы.ПС) + Ошибка;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДобавитьОрганизациюВЗаголовок(ЗаголовокФормы, ИспользуетсяОднаОрганизация, НаименованиеОрганизации, ИсходныйЗаголовок) Экспорт

	Если НЕ ИспользуетсяОднаОрганизация 
		И ЗначениеЗаполнено(НаименованиеОрганизации)  Тогда
		
		ЗаголовокФормы = ИсходныйЗаголовок + " (" + НаименованиеОрганизации + ")";
		
	Иначе
		
		ЗаголовокФормы = ИсходныйЗаголовок;
		
	КонецЕсли;

КонецПроцедуры

Функция ЭтоФайлВыгрузкиРеестраНДС(КороткоеИмяФайла) Экспорт
	
	Префиксы = Новый Массив;
	Префиксы.Добавить("KO_RRTDNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение1
	Префиксы.Добавить("KO_RRNFTSNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение2
	Префиксы.Добавить("KO_RRGAZNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение3
	Префиксы.Добавить("KO_RRNEFTNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение4
	Префиксы.Добавить("KO_RRTRDNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение5
	Префиксы.Добавить("KO_RRDPRNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение6
	Префиксы.Добавить("KO_RRZDNNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение7
	Префиксы.Добавить("KO_RRTRINNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение8
	Префиксы.Добавить("KO_RRAVNNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение9
	Префиксы.Добавить("KO_RRMORNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение10
	Префиксы.Добавить("KO_RRGDPRVZNDS"); // РегламентированныйОтчетРеестрНДСПриложение11
	Префиксы.Добавить("KO_RRAVPRVZNDS"); // РегламентированныйОтчетРеестрНДСПриложение12
	Префиксы.Добавить("KO_RRGDTRNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение13
	Префиксы.Добавить("KO_RRPRVZNDS"); // 	РегламентированныйОтчетРеестрНДСПриложение14
	
	Для каждого Префикс Из Префиксы Цикл
		
		ДлинаПрефикса = СтрДлина(Префикс);
		Если ВРег(Лев(КороткоеИмяФайла, ДлинаПрефикса)) = ВРег(Префикс) Тогда
			Возврат Истина;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоФайлВыгрузкиРеестраАкцизов(КороткоеИмяФайла) Экспорт
	
	Префиксы = Новый Массив;
	Префиксы.Добавить("KO_RR198.7.3TD"); // 	РегламентированныйОтчетРеестрАкцизыПриложение1
	Префиксы.Добавить("KO_RR198.7.34TD"); // 	РегламентированныйОтчетРеестрАкцизыПриложение2
	
	Для каждого Префикс Из Префиксы Цикл
		
		ДлинаПрефикса = СтрДлина(Префикс);
		Если ВРег(Лев(КороткоеИмяФайла, ДлинаПрефикса)) = ВРег(Префикс) Тогда
			Возврат Истина;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ОбновитьКоличествоНовых(Форма) Экспорт
	
	КоличествоНовых = 0;
	
	КоличествоПолученныеСообщения = 0;
	КоличествоОбработанныеЗапросы = 0;
	КоличествоЗавершенныеОтправки = 0;
	
	СтрокаБлокПолученныеСообщения = Неопределено;
	СтрокаБлокОбработанныеЗапросы = Неопределено;
	СтрокаБлокЗавершенныеОтправки = Неопределено;
	
	СтрокиДерева = Форма.Новое.ПолучитьЭлементы();
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.Группа = ПредопределенноеЗначение("Перечисление.ГруппыНовыхСобытийДокументооборотаСКонтролирующимиОрганами.ПолученныеСообщения") Тогда
			Если СтрокаДерева.ЭтоЗаголовокБлока Тогда
				СтрокаБлокПолученныеСообщения = СтрокаДерева;
			ИначеЕсли СтрокаДерева.НеПрочитано Тогда
				КоличествоПолученныеСообщения = КоличествоПолученныеСообщения + 1;
			КонецЕсли;
				
		ИначеЕсли СтрокаДерева.Группа = ПредопределенноеЗначение("Перечисление.ГруппыНовыхСобытийДокументооборотаСКонтролирующимиОрганами.ОбработанныеЗапросы") Тогда 
			Если СтрокаДерева.ЭтоЗаголовокБлока Тогда
				СтрокаБлокОбработанныеЗапросы = СтрокаДерева;
			ИначеЕсли СтрокаДерева.НеПрочитано Тогда
				КоличествоОбработанныеЗапросы = КоличествоОбработанныеЗапросы + 1;
			КонецЕсли;
			
		ИначеЕсли СтрокаДерева.Группа = ПредопределенноеЗначение("Перечисление.ГруппыНовыхСобытийДокументооборотаСКонтролирующимиОрганами.ЗавершенныеОтправки") Тогда 
			Если СтрокаДерева.ЭтоЗаголовокБлока Тогда
				СтрокаБлокЗавершенныеОтправки = СтрокаДерева;
			ИначеЕсли СтрокаДерева.НеПрочитано Тогда
				КоличествоЗавершенныеОтправки = КоличествоЗавершенныеОтправки + 1;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	КоличествоНовых = КоличествоПолученныеСообщения + КоличествоОбработанныеЗапросы + КоличествоЗавершенныеОтправки;
	
	Если КоличествоПолученныеСообщения = 0 Тогда
		СтрокаБлокПолученныеСообщения.ЗаголовокБлока = НСтр("ru = 'Полученные сообщения'");	
	Иначе
		СтрокаБлокПолученныеСообщения.ЗаголовокБлока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Полученные сообщения (%1)'"), КоличествоПолученныеСообщения);
	КонецЕсли;
	
	Если КоличествоОбработанныеЗапросы = 0 Тогда
		СтрокаБлокОбработанныеЗапросы.ЗаголовокБлока = НСтр("ru = 'Обработанные запросы'");	
	Иначе
		СтрокаБлокОбработанныеЗапросы.ЗаголовокБлока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обработанные запросы (%1)'"), КоличествоОбработанныеЗапросы);
	КонецЕсли;

	Если КоличествоЗавершенныеОтправки = 0 Тогда
		СтрокаБлокЗавершенныеОтправки.ЗаголовокБлока = НСтр("ru = 'Завершенные отправки'");	
	Иначе
		СтрокаБлокЗавершенныеОтправки.ЗаголовокБлока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Завершенные отправки (%1)'"), КоличествоЗавершенныеОтправки);
	КонецЕсли;

	Возврат КоличествоНовых;
	
КонецФункции

Функция МаксимальнойКоличествоФайловОписи() Экспорт
	
	// Приложение к приказу  ФНС  России от  «28» ноября 2016 г. №  ММВ-7-6/643@
	// Количество направленных файлов	КолФайл	A	N(2)	О
	// 
	// Разрядность 2, поэтому количество файлов не должно превышать 99
	// 
	Возврат 99;
	
КонецФункции

Функция МаксимальнойКоличествоФайловВПисьме() Экспорт
	
	// КНД="1166102"
	// Приказ ФНС России от 13.06.2013 N ММВ-7-6/196@
	// Количество направленных файлов	КолФайл	A	N(2)	О
	// 
	// Разрядность 2, поэтому количество файлов не должно превышать 99
	// 
	Возврат 99;
	
КонецФункции

#КонецОбласти
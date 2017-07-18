﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров для автозаполнения регламентированной формы уведомления о постановке на учет
// в качестве плательщика торгового сбора (форма ТС-1).
//
// Параметры:
//  ТорговаяТочка - СправочникСсылка.ТорговыеТочки - торговая точка.
//  НаДату        - Дата - дата на которую будут получены параметры.
//
// Возвращаемое значение:
//  Структура - структура параметров для автозаполнения формы ТС-1. Ключи структуры:
//   * Организация - СправочникСсылка.Организации - организация которой принадлежит торговая точка.
//   * Данные      - Структура - информация о регистрации в ИФНС и данные торговой точки. Ключи структуры:
//    ** ИФНС - СправочникСсылка.РегистрацииВНалоговомОргане - информация о регистрации в ИФНС.
//    ** ДанныеТорговойТочки - Структура - Подробнее см. НовыйДанныеТорговойТочки().
//
Функция ПараметрыФормыТС1(ТорговаяТочка, НаДату) Экспорт
	
	ПараметрыТорговойТочки = РегистрыСведений.ПараметрыТорговыхТочек.ПараметрыТорговойТочки(ТорговаяТочка, НаДату);
	ПараметрыФормы = Новый Структура;
	Данные = Новый Структура;
	Если ПараметрыТорговойТочки = Неопределено Тогда
		ПараметрыФормы.Вставить("Организация", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговаяТочка, "Организация"));
		ПараметрыФормы.Вставить("Данные"     , Данные);
		Возврат ПараметрыФормы;
	КонецЕсли;
	
	Если ПараметрыТорговойТочки.ПостановкаНаУчетВНалоговомОргане =
		Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		
		Данные.Вставить("ИФНС", ПараметрыТорговойТочки.НалоговыйОрган);
		
	КонецЕсли;
	
	ВидимостьСвойствТорговойТочки =
		ТорговыйСборКлиентСервер.ПараметрыВидимостиРеквизитовПоТипуТорговойТочки(ПараметрыТорговойТочки.ТипТорговойТочки);
	
	ДанныеТорговойТочки = НовыйДанныеТорговойТочки();
	
	ДанныеТорговойТочки.ТорговаяТочка = ТорговаяТочка;
	
	ДанныеТорговойТочки.Т_1 = ОпределитьПризнакУведомления(ПараметрыТорговойТочки.ВидОперации);
	ДанныеТорговойТочки.П_1_1 = ПараметрыТорговойТочки.Период;
	ДанныеТорговойТочки.П_1_2 = ОпределитьКодВидаДеятельности(ПараметрыТорговойТочки.ВидТорговойДеятельности);
	
	ДанныеТорговойТочки.П_2_1 = ПараметрыТорговойТочки.КодПоОКТМО;
	ДанныеТорговойТочки.П_2_2 = ОпределитьКодОбъектаОсуществленияТорговли(ПараметрыТорговойТочки.ТипТорговойТочки);
	ДанныеТорговойТочки.П_2_3 = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговаяТочка, "Наименование");
	ДанныеТорговойТочки.П_2_4 = ТорговаяТочка.КонтактнаяИнформация[0].ЗначенияПолей;
	ДанныеТорговойТочки.П_2_5 = ОпределитьКодОснованияПользования(ПараметрыТорговойТочки.ОснованиеПользования);
	ДанныеТорговойТочки.П_2_6 = ОпределитьНомерРазрешения(ПараметрыТорговойТочки.НомерРазрешения, ВидимостьСвойствТорговойТочки);
	
	ЗаполнитьКадастровыйНомер(ПараметрыТорговойТочки, ДанныеТорговойТочки);
	
	ДанныеТорговойТочки.П_2_10 = ОпределитьПлощадьТорговогоЗала(
		ПараметрыТорговойТочки.ПлощадьТорговогоЗала,
		ВидимостьСвойствТорговойТочки);
	
	Если ПараметрыТорговойТочки.ВидТорговойДеятельности =
		Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами
		И ПараметрыТорговойТочки.ПлощадьТорговогоЗала > 50 Тогда
		
		ДанныеТорговойТочки.П_3_2 = Окр(ПараметрыТорговойТочки.Ставка / ПараметрыТорговойТочки.ПлощадьТорговогоЗала, 2);
		
	Иначе
		ДанныеТорговойТочки.П_3_1 = ПараметрыТорговойТочки.Ставка;
		
	КонецЕсли;
	
	ДанныеТорговойТочки.П_3_4 = ПараметрыТорговойТочки.СуммаЛьготы;
	ДанныеТорговойТочки.П_3_5 = ОпределитьКодНалоговойЛьготы(ПараметрыТорговойТочки.КодНалоговойЛьготы);
	
	ДополнитьДаннымиРанееПоданногоУведомления(ПараметрыТорговойТочки, ДанныеТорговойТочки);
	
	Данные.Вставить("ДанныеТорговойТочки", ДанныеТорговойТочки);
	ПараметрыФормы.Вставить("Организация", ПараметрыТорговойТочки.Организация);
	ПараметрыФормы.Вставить("Данные"     , Данные);

	Возврат ПараметрыФормы;
	
КонецФункции

// Возвращает структуру параметров для автозаполнения регламентированной формы уведомления о снятии с учета
// в качестве плательщика торгового сбора (форма ТС-2).
//
// Параметры:
//  ТорговаяТочка - СправочникСсылка.ТорговыеТочки - торговая точка.
//  НаДату        - Дата - дата на которую будут получены параметры.
//
// Возвращаемое значение:
//  Структура - структура параметров для автозаполнения формы ТС-2. Ключи структуры:
//   * Организация - СправочникСсылка.Организации - организация которой принадлежит торговая точка.
//   * Данные      - Структура - информация о регистрации в ИФНС и данные торговой точки. Ключи структуры:
//    ** ИФНС - СправочникСсылка.РегистрацииВНалоговомОргане - информация о регистрации в ИФНС.
//    ** ДанныеТорговойТочки - Структура - Подробнее см. НовыйДанныеТорговойТочки().
//
Функция ПараметрыФормыТС2(ТорговаяТочка, НаДату) Экспорт
	
	ПараметрыТорговойТочки = РегистрыСведений.ПараметрыТорговыхТочек.ПараметрыТорговойТочки(ТорговаяТочка, НаДату);
	
	ПараметрыФормы = Новый Структура;
	Данные = Новый Структура;
	Если ПараметрыТорговойТочки = Неопределено Тогда
		ПараметрыФормы.Вставить("Организация", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТорговаяТочка, "Организация"));
		ПараметрыФормы.Вставить("Данные"     , Данные);
		Возврат ПараметрыФормы;
	КонецЕсли;
	
	Если ПараметрыТорговойТочки.ПостановкаНаУчетВНалоговомОргане =
		Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
	
		Данные.Вставить("ИФНС", ПараметрыТорговойТочки.НалоговыйОрган);
	
	КонецЕсли;
	
	ДанныеТорговойТочки = НовыйДанныеТорговойТочки();
	ДанныеТорговойТочки.Вставить("ТорговаяТочка", ТорговаяТочка);
	
	Данные.Вставить("ДанныеТорговойТочки", ДанныеТорговойТочки);
	
	ПараметрыФормы.Вставить("Организация", ПараметрыТорговойТочки.Организация);
	ПараметрыФормы.Вставить("Данные"     , Данные);
	
	Возврат ПараметрыФормы;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура СоздатьТорговыеТочкиПоУведомлениям() Экспорт
	
	ПлательщикиТорговогоСбора = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	УведомлениеОСпецрежимахНалогообложения.Ссылка,
	|	УведомлениеОСпецрежимахНалогообложения.Организация
	|ИЗ
	|	Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыТорговыхТочек КАК ПараметрыТорговыхТочек
	|		ПО УведомлениеОСпецрежимахНалогообложения.Ссылка = ПараметрыТорговыхТочек.Уведомление
	|ГДЕ
	|	УведомлениеОСпецрежимахНалогообложения.ВидУведомления = ЗНАЧЕНИЕ(Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1)
	|	И ПараметрыТорговыхТочек.Уведомление ЕСТЬ NULL 
	|	И НЕ УведомлениеОСпецрежимахНалогообложения.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	УведомлениеОСпецрежимахНалогообложения.Организация,
	|	УведомлениеОСпецрежимахНалогообложения.ДатаПодписи";
	
	Выборка= Запрос.Выполнить().Выбрать();
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			Если Не ЗначениеЗаполнено(Выборка.Ссылка) Тогда
				Продолжить;
			КонецЕсли;
			
			РеквизитыУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.Ссылка,
				"Организация, ДатаПодписи, РегистрацияВИФНС, ДанныеУведомления");
			СтруктураПараметров = РеквизитыУведомления.ДанныеУведомления.Получить();
			
			КодПричины = СтруктураПараметров.Титульный[0].КодПричины;
			Если КодПричины <> "1" Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПлательщикиТорговогоСбора.Найти(РеквизитыУведомления.Организация) = Неопределено Тогда
				ПлательщикиТорговогоСбора.Добавить(РеквизитыУведомления.Организация);
			КонецЕсли; 
			
			Для Каждого ОбъектТорговли Из СтруктураПараметров.Сведения Цикл
				
				// Справочник "Торговые точки"
				ТорговаяТочкаОбъект = Справочники.ТорговыеТочки.СоздатьЭлемент();
				ТорговаяТочкаОбъект.Организация = РеквизитыУведомления.Организация;
				ТорговаяТочкаОбъект.Наименование = ОбъектТорговли.НаимТоргОб;
				
				// Контактная информация
				РоссийскийАдрес = Новый Соответствие;
				РоссийскийАдрес.Вставить("Индекс",	        ОбъектТорговли.ИНДЕКС);
				РоссийскийАдрес.Вставить("КодРегиона",      ОбъектТорговли.КОД_РЕГИОНА);
				РоссийскийАдрес.Вставить("Район",           ОбъектТорговли.РАЙОН);
				РоссийскийАдрес.Вставить("Город",           ОбъектТорговли.ГОРОД);
				РоссийскийАдрес.Вставить("НаселенныйПункт", ОбъектТорговли.НАСЕЛЕННЫЙ_ПУНКТ);
				РоссийскийАдрес.Вставить("Улица",           ОбъектТорговли.УЛИЦА);
				РоссийскийАдрес.Вставить("Дом",             ОбъектТорговли.ДОМ);
				РоссийскийАдрес.Вставить("Корпус",          ОбъектТорговли.КОРПУС);
				РоссийскийАдрес.Вставить("Квартира",        ОбъектТорговли.КВАРТИРА);
				РоссийскийАдрес.Вставить("Регион",          АдресныйКлассификатор.НаименованиеРегионаПоКоду(ОбъектТорговли.КОД_РЕГИОНА));
				
				АдресВXML = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(РоссийскийАдрес, ,
					Справочники.ВидыКонтактнойИнформации.АдресТорговойТочки);
				
				ОбъектКИ = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(АдресВXML,
					Справочники.ВидыКонтактнойИнформации.АдресТорговойТочки);
				
				Если Не УправлениеКонтактнойИнформациейСлужебный.XDTOКонтактнаяИнформацияЗаполнена(ОбъектКИ) Тогда
					Возврат;
				КонецЕсли;
				
				НоваяСтрока = ТорговаяТочкаОбъект.КонтактнаяИнформация.Добавить();
				НоваяСтрока.Представление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(АдресВXML);
				НоваяСтрока.ЗначенияПолей = АдресВXML;
				НоваяСтрока.Вид           = Справочники.ВидыКонтактнойИнформации.АдресТорговойТочки;
				НоваяСтрока.Тип           = Перечисления.ТипыКонтактнойИнформации.Адрес;
				
				УправлениеКонтактнойИнформациейБП.ЗаполнитьРеквизитыТабличнойЧастиДляАдреса(НоваяСтрока, ОбъектКИ);
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТорговаяТочкаОбъект);
				
				// Регистр сведений "ПараметрыТорговыхТочек"
				
				Запись = РегистрыСведений.ПараметрыТорговыхТочек.СоздатьМенеджерЗаписи();
				Запись.Период = ?(ЗначениеЗаполнено(ОбъектТорговли.ДАТА_ПРАВА), ОбъектТорговли.ДАТА_ПРАВА, РеквизитыУведомления.ДатаПодписи);
				Запись.Организация   = РеквизитыУведомления.Организация;
				Запись.ТорговаяТочка = ТорговаяТочкаОбъект.Ссылка;
				
				КодВидаТоргОбъекта = Прав(Строка(ОбъектТорговли.КодВидаТоргОбъекта), 1);
				Если КодВидаТоргОбъекта = "1" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Магазин;
				ИначеЕсли КодВидаТоргОбъекта = "2" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Павильон;
				ИначеЕсли КодВидаТоргОбъекта = "3" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок;
				ИначеЕсли КодВидаТоргОбъекта = "4" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Киоск;
				ИначеЕсли КодВидаТоргОбъекта = "5" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговаяПалатка;
				ИначеЕсли КодВидаТоргОбъекта = "6" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговыйАвтомат;
				ИначеЕсли КодВидаТоргОбъекта = "7" Тогда
					ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.АвтолавкаАвтоприцеп;
				Иначе //"08"
					ТипТорговойТочки = ?(ОбъектТорговли.ПлощТоргЗала > 0, Перечисления.ТипыТорговыхТочек.ПрочееСТорговымЗалом, Перечисления.ТипыТорговыхТочек.ПрочееБезТорговогоЗала);
				КонецЕсли;
				
				КодВидаТорговойДеятельности = Прав(Строка(ОбъектТорговли.КодВидаПД), 1);
				Если КодВидаТорговойДеятельности = "1" Тогда
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиБезТорговыхЗалов;
				ИначеЕсли КодВидаТорговойДеятельности = "2" и ТипТорговойТочки = "7" Тогда
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.РазвознаяРазноснаяТорговля;
				ИначеЕсли КодВидаТорговойДеятельности = "2" И ТипТорговойТочки = "5" Тогда
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.НестационарныеСети;
				ИначеЕсли КодВидаТорговойДеятельности = "3" Тогда
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами;
				ИначеЕсли КодВидаТорговойДеятельности = "4" Тогда
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.ОтпускСоСклада;
				Иначе
					ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.РозничныеРынки;
				КонецЕсли;
				
				ОснИсп = Прав(Строка(ОбъектТорговли.ОснИсп), 1);
				Если ОснИсп = "1" Тогда
					ОснованиеПользования = Перечисления.ОснованияПользованияТорговойТочкой.Собственность;
				ИначеЕсли ОснИсп = "2" Тогда
					ОснованиеПользования = Перечисления.ОснованияПользованияТорговойТочкой.Аренда;
				Иначе
					ОснованиеПользования = Перечисления.ОснованияПользованияТорговойТочкой.Иное;
				КонецЕсли;
				
				РегистрацияВФНСОрганизации = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(РеквизитыУведомления.Организация);
				Если РегистрацияВФНСОрганизации = РеквизитыУведомления.РегистрацияВИФНС Тогда
					ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ПоМестуНахожденияОрганизации;
				Иначе
					ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане;
				КонецЕсли;
				
				Запись.КодПоОКТМО = ОбъектТорговли.ОКТМО;
				Запись.ТипТорговойТочки = ТипТорговойТочки;
				Запись.ВидТорговойДеятельности = ВидТорговойДеятельности;
				Запись.ОснованиеПользования = ОснованиеПользования;
				Запись.ПостановкаНаУчетВНалоговомОргане = ПостановкаНаУчетВНалоговомОргане;
				Если НЕ ПустаяСтрока(ОбъектТорговли.НомЗдание) Тогда
					Запись.ВидОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимостиОблагаемыхТорговымСбором.Здание;
					Запись.КадастровыйНомер = ОбъектТорговли.НомЗдание;
				ИначеЕсли НЕ ПустаяСтрока(ОбъектТорговли.НомПомещ) Тогда
					Запись.ВидОбъектаНедвижимости = Перечисления.ВидыОбъектовНедвижимостиОблагаемыхТорговымСбором.Помещение;
					Запись.КадастровыйНомер = ОбъектТорговли.НомПомещ;
				КонецЕсли;
				Если ПостановкаНаУчетВНалоговомОргане = Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
					Запись.НалоговыйОрган = РеквизитыУведомления.РегистрацияВИФНС;
				КонецЕсли;
				Запись.НомерРазрешения = ОбъектТорговли.НомерРазр;
				Запись.ПлощадьТорговогоЗала = ОбъектТорговли.ПлощТоргЗала;
				Запись.КодНалоговойЛьготы = ?(ЗначениеЗаполнено(ОбъектТорговли.КодЛьготы), ОбъектТорговли.КодЛьготы, "000000000000");
				Запись.ДатаПодачиУведомления = РеквизитыУведомления.ДатаПодписи;
				Запись.СуммаСбора = ОбъектТорговли.СуммаСбораИтого;
				Если НЕ ПустаяСтрока(ОбъектТорговли.СтавкаСбораРуб) Тогда
					Запись.Ставка = ОбъектТорговли.СтавкаСбораРуб;
				ИначеЕсли НЕ ПустаяСтрока(ОбъектТорговли.СтавкаСбораКвм) Тогда
					Запись.Ставка = ОбъектТорговли.СтавкаСбораКвм;
				КонецЕсли;
				Запись.СуммаЛьготы  = ОбъектТорговли.СуммаЛьготы;
				Запись.Уведомление  = Выборка.Ссылка;
				Запись.ВидОперации  = Перечисления.ВидыОперацийТорговыеТочки.Регистрация;
				
				Запись.Записать();
				
			КонецЦикла;
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось создать торговую точку по данным ""%1"" по причине:
				|%2'"), 
				Выборка.Ссылка,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,, 
				Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Если ПроблемныхОбъектов > 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре УведомлениеОСпецрежимахНалогообложения.СоздатьТорговыеТочки
			|не удалось создать торговую точку по данным %1 уведомлений'"),
			ПроблемныхОбъектов);
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, 
			ТекстСообщения);
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Процедура УведомлениеОСпецрежимахНалогообложения.СоздатьТорговыеТочки
				|обработала очередную порцию уведомлений: %1 элементов'"),
				ОбъектовОбработано));
	КонецЕсли;
	
	// Если есть хотя бы одна торговая точка то добавляем функциональность и задачу бухгалтера по организации.
	Если ОбъектовОбработано > 0 Тогда
		
		Для каждого Организация Из ПлательщикиТорговогоСбора Цикл
			Попытка
				МенеджерЗаписи = РегистрыСведений.НалогиОтчеты.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Организация = Организация;
				МенеджерЗаписи.НалогОтчет = Справочники.ЗадачиБухгалтера.НайтиПоКоду("ТорговыйСбор");
				МенеджерЗаписи.Записать();
			Исключение
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось обновить список налогов для организации ""%1"" по причине:
					|%2'"), 
					Организация,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,, 
				Организация, ТекстСообщения);
			КонецПопытки;
		КонецЦикла;
		
	КонецЕсли;
	
	ЭтоБазоваяВерсияКонфигурации = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
	УплачиваетсяТорговыйСбор = НЕ ЭтоБазоваяВерсияКонфигурации ИЛИ ОбъектовОбработано > 0;
	
	МенеджерКонстанты = Константы.УплачиваетсяТорговыйСбор.СоздатьМенеджерЗначения();
	МенеджерКонстанты.Значение = УплачиваетсяТорговыйСбор;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерКонстанты);
	
	Если ОбъектовОбработано > 0 Тогда
		Справочники.ВидыНалоговИПлатежейВБюджет.СоздатьПоставляемыеЭлементы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АвтозаполнениеУведомлений

Функция НовыйДанныеТорговойТочки()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ТорговаяТочка"); // Ссылка на торговую точку.
	Результат.Вставить("Т_1"); // Код вида операции.
	Результат.Вставить("П_1_1"); // Дата постановки на учет, изменения параметров или снятия с учета.
	Результат.Вставить("П_1_2"); // Код вида торговой деятельности.
	Результат.Вставить("П_2_1"); // ОКТМО
	Результат.Вставить("П_2_2"); // Код объекта осуществления торговли
	Результат.Вставить("П_2_3"); // Наименование торговой точки.
	Результат.Вставить("П_2_4"); // Адрес в формате БСП
	Результат.Вставить("П_2_5"); // Код основания пользования торговой точкой.
	Результат.Вставить("П_2_6"); // Номер разрешения на размещение нестационарной торговой точки.
	Результат.Вставить("П_2_7", ""); // Кадастровый номер здания.
	Результат.Вставить("П_2_8", ""); // Кадастровый номер помещения.
	Результат.Вставить("П_2_9", ""); // Кадастровый номер земельного участка.
	Результат.Вставить("П_2_10"); // Площадь торгового зала.
	Результат.Вставить("П_3_1"); // Ставка сбора за объекты без торгового зала и объекты с торговым залом до 50 кв.м.
	Результат.Вставить("П_3_2"); // Ставка сбора за объекты с торговым залом свыше 50 кв.м.
	Результат.Вставить("П_3_4"); // Сумма налоговой льготы.
	Результат.Вставить("П_3_5"); // Код налоговой льготы.
	Результат.Вставить("ИмяФайла"); // Имя файла уведомления поданного в ИФНС через 1С-Отчетность.
	Результат.Вставить("АдресДвДанных"); // Адрес хранилища с двоичными данными уведомления поданного в ИФНС через 1С-Отчетность.
	
	Возврат Результат;
	
КонецФункции

Функция ОпределитьПризнакУведомления(ВидОперации)
	
	Если ВидОперации = Перечисления.ВидыОперацийТорговыеТочки.Регистрация Тогда
		Признак = "1";
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийТорговыеТочки.ИзменениеПараметров Тогда
		Признак = "2";
		
	Иначе
		Признак = "3";
		
	КонецЕсли;
	
	Возврат Признак;
	
КонецФункции

Функция ОпределитьКодВидаДеятельности(ВидТорговойДеятельности)
	
	Если ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиБезТорговыхЗалов Тогда
		
		КодВидаДеятельности = 1;
		
	ИначеЕсли ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.НестационарныеСети
		ИЛИ ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.РазвознаяРазноснаяТорговля Тогда
		
		КодВидаДеятельности = 2;
		
	ИначеЕсли ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.СтационарныеСетиСТорговымиЗалами Тогда
		
		КодВидаДеятельности = 3;
		
	ИначеЕсли ВидТорговойДеятельности = Перечисления.ВидыТорговойДеятельностиОблагаемыеСбором.ОтпускСоСклада Тогда
		
		КодВидаДеятельности = 4;
		
	Иначе
		
		КодВидаДеятельности = 5;
		
	КонецЕсли;
	
	Возврат КодВидаДеятельности;
	
КонецФункции

Функция ОпределитьКодОбъектаОсуществленияТорговли(ТипТорговойТочки)
	
	Если ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Магазин Тогда
		КодОбъекта = 1;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Павильон Тогда
		КодОбъекта = 2;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок Тогда
		КодОбъекта = 3;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.Киоск Тогда
		КодОбъекта = 4;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговаяПалатка Тогда
		КодОбъекта = 5;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговыйАвтомат Тогда
		КодОбъекта = 6;
		
	ИначеЕсли ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.АвтолавкаАвтоприцеп
		ИЛИ ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговаяТележка
		ИЛИ ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.ТорговыйЛоток Тогда
		
		КодОбъекта = 7;
		
	Иначе
		КодОбъекта = 8;
		
	КонецЕсли;
	
	Возврат КодОбъекта;
	
КонецФункции

Функция ОпределитьКодОснованияПользования(ОснованиеПользования)
	
	Если ОснованиеПользования = Перечисления.ОснованияПользованияТорговойТочкой.Собственность Тогда
		
		КодОснованияПользования = "1";
		
	ИначеЕсли ОснованиеПользования = Перечисления.ОснованияПользованияТорговойТочкой.Аренда Тогда
		
		КодОснованияПользования = "2";
		
	Иначе
		
		КодОснованияПользования = "3";
		
	КонецЕсли; 
	
	Возврат КодОснованияПользования;
	
КонецФункции

Функция ОпределитьНомерРазрешения(НомерРазрешения, ВидимостьСвойствТорговойТочки)
	
	Если ВидимостьСвойствТорговойТочки.НомерРазрешения Тогда
		Возврат НомерРазрешения;
		
	Иначе
		Возврат "000000000000000";
		
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьКадастровыйНомер(ПараметрыТорговыхТочек, ДанныеТорговойТочки)
	
	Если ПараметрыТорговыхТочек.ТипТорговойТочки = Перечисления.ТипыТорговыхТочек.РозничныйРынок Тогда
		ДанныеТорговойТочки.П_2_9 = ПараметрыТорговыхТочек.КадастровыйНомер;
		
	ИначеЕсли ПараметрыТорговыхТочек.ВидОбъектаНедвижимости =
		Перечисления.ВидыОбъектовНедвижимостиОблагаемыхТорговымСбором.Здание Тогда
		
		ДанныеТорговойТочки.П_2_7 = ПараметрыТорговыхТочек.КадастровыйНомер;
		
	ИначеЕсли ПараметрыТорговыхТочек.ВидОбъектаНедвижимости =
		Перечисления.ВидыОбъектовНедвижимостиОблагаемыхТорговымСбором.Помещение Тогда
		
		ДанныеТорговойТочки.П_2_8 = ПараметрыТорговыхТочек.КадастровыйНомер;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОпределитьПлощадьТорговогоЗала(ПлощадьТорговогоЗала, ВидимостьСвойствТорговойТочки)
	
	Если ВидимостьСвойствТорговойТочки.ГруппаПлощадьТорговогоЗала Тогда
		Возврат ПлощадьТорговогоЗала;
		
	Иначе
		Возврат 0;
		
	КонецЕсли;
	
КонецФункции

Функция ОпределитьКодНалоговойЛьготы(КодНалоговойЛьготы)
	
	Если ЗначениеЗаполнено(Число(КодНалоговойЛьготы)) Тогда
		Возврат КодНалоговойЛьготы;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Процедура ДополнитьДаннымиРанееПоданногоУведомления(ПараметрыТорговыхТочек, ДанныеТорговойТочки)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НаДату"       , ПараметрыТорговыхТочек.Период);
	Запрос.УстановитьПараметр("ТорговаяТочка", ПараметрыТорговыхТочек.ТорговаяТочка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыТорговыхТочекСрезПоследних.Уведомление
	|ИЗ
	|	РегистрСведений.ПараметрыТорговыхТочек.СрезПоследних(
	|			&НаДату,
	|			ТорговаяТочка = &ТорговаяТочка
	|				И НЕ (Уведомление = НЕОПРЕДЕЛЕНО
	|					ИЛИ Уведомление = ЗНАЧЕНИЕ(Документ.УведомлениеОСпецрежимахНалогообложения.ПустаяСсылка))) КАК ПараметрыТорговыхТочекСрезПоследних";
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если НЕ РезультатЗапроса.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	СведенияПоВсемОтправкам = СведенияПоОтправкам.СведенияПоВсемОтправкам(РезультатЗапроса.Уведомление);
	
	Для Каждого ОтправленныеСведения Из СведенияПоВсемОтправкам Цикл
		Если ЗначениеЗаполнено(ОтправленныеСведения.ДатаЗавершения) Тогда
			Идентификатор = ОтправленныеСведения.ИдентификаторОтправки;
			СведенияПоОтправке = СведенияПоОтправкам.СведенияПоОтправке(РезультатЗапроса.Уведомление, Идентификатор);
			
			Если СведенияПоОтправке.Статус = Перечисления.СтатусыОтправки.Сдан Тогда
				СтруктураПолногоИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(СведенияПоОтправке.ИмяФайла);
				ДанныеТорговойТочки.ИмяФайла      = СтруктураПолногоИмениФайла.ИмяБезРасширения;
				ДанныеТорговойТочки.АдресДвДанных = СведенияПоОтправке.АдресДвДанных;
				Прервать;
				
			Иначе
				Продолжить;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


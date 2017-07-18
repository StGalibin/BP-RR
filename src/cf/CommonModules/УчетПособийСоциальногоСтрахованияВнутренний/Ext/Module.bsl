﻿#Область СлужебныйПрограммныйИнтерфейс

// Заполняет табличные части документа "ИсходящаяСправкаОЗаработкеДляРасчетаПособий".
//
// Параметры:
//  Объект -  ДокументОбъект.ИсходящаяСправкаОЗаработкеДляРасчетаПособий
//  ПараметрыЗаполнения - см. ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия.
//  
// Возвращаемое значение:
//	Истина, если данные в объекте были обновлены.
//
Функция ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(Объект, ПараметрыЗаполнения) Экспорт
	
	Возврат УчетПособийСоциальногоСтрахованияБазовый.ЗаполнитьСправкуДаннымиОЗаработкеИДняхОтсутствия(Объект, ПараметрыЗаполнения);	

КонецФункции

// Формирует параметры для создания временных таблиц используемых для заполнения справки о заработке для расчета
// пособий.
//
// Параметры:
//  Объект - ДокументОбъект.СправкаОЗаработкеДляРасчетаПособий
//
// Возвращаемое значение:
//    Структура:
//		ГодНачало
//		ГодОкончание
//		Сотрудник
//		Организация
//      ПоВсемОП - данные по Организации или по ГоловнойОрганизации.
//      Обновление - учитывать ли зафиксированные в документе реквизиты.
//      РасчетныеГоды - отбор заполняемых лет, входящих в период между ГодНачало и ГодОкончание.
//      ОграничиватьРазмерЗаработка - применять ли ограничение базой страховых взносов.
//
Функция ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия(Объект) Экспорт
	
	Возврат УчетПособийСоциальногоСтрахованияБазовый.ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия(Объект)	

КонецФункции

// Возвращает таблицу с данными о заработке сотрудника по годам.
//
// Параметры:
//  ПараметрыЗаполнения - Структура, состав см. в
//                        УчетПособийСоциальногоСтрахования.ПараметрыЗаполненияСправкиОЗаработкеИДняхОтсутствия.
//  
// Возвращаемое значение:
//  Таблица значений с колонками:
//		РасчетныйГод	
//		Заработок	
//			
Функция ДанныеОЗаработкеДляЗаполнения(ПараметрыЗаполнения) Экспорт
	
	Возврат УчетПособийСоциальногоСтрахованияБазовый.ДанныеОЗаработкеДляЗаполнения(ПараметрыЗаполнения);
	
КонецФункции

// Дополняет параметры фиксации изменений для реквизитов исходящей справки о заработке.
//
// Параметры:
//  Организация - СправочникСсылка.Организации
//
Процедура ДополнитьПараметрыФиксацииИсходящаяСправкаОЗаработкеДляРасчетаПособий(ПараметрыФиксацииВторичныхДанных) Экспорт
	
	// В этой конфигурации ничего не делаем.

КонецПроцедуры

// Возвращает массив ссылок из ПВР Начисления, соответствующих облагаемым взносами компенсациям, возмещаемым из бюджета ФСС 
// (в частности, оплата 4-х дополнительных выходных дней для ухода за детьми инвалидами).
//
// Параметры:
//	нет
// 
// Возвращаемое значение:
//	Массив
// 
Функция НачисленияОблагаемыхВзносамиПособий() Экспорт

	Возврат УчетПособийСоциальногоСтрахованияБазовый.НачисленияОблагаемыхВзносамиПособий();

КонецФункции

Процедура ЗаполнитьВидПособияВПособияхСоциальногоСтрахования() Экспорт
	
	Документы.БольничныйЛист.ЗаполнитьВидПособияВПособияхСоциальногоСтрахования();
	
КонецПроцедуры

Процедура ЗаполнитьПризнакПособиеВыплачиваетсяФССВСуществующихБольничныхЛистах() Экспорт
	
	Документы.БольничныйЛист.ЗаполнитьПризнакПособиеВыплачиваетсяФССВСуществующихБольничныхЛистах();
	
КонецПроцедуры

Процедура ЗаполнитьВБольничныхЛистахДолюНеполногоРабочегоВремени(Параметры) Экспорт
	
	УчетПособийСоциальногоСтрахованияБазовый.ЗаполнитьВБольничныхЛистахДолюНеполногоРабочегоВремени(Параметры);
	
КонецПроцедуры

#Область ПолучениеДанныхДляРасчетаСреднегоЗаработкаПоДокументу

// Создает временную таблицу с реквизитами документов необходимыми для формирования
// структуры параметров расчета среднего заработка ФСС
//
// Параметры:
//  МенеджерВременныхТаблиц	 - менеджер временных таблиц, куда будет помещена временная таблица ВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС 
//  МассивСсылок			 - массив ссылок, по которым необходимо получить данные, допустимые типы элементов - "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
//
Процедура СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок) Экспорт
	
	УчетПособийСоциальногоСтрахованияБазовый.СоздатьВТДанныеДокументовДляРасчетаСреднегоЗаработкаФСС(МенеджерВременныхТаблиц, МассивСсылок);
	
КонецПроцедуры

// Функция - Таблицы данных среднего заработка ФСС
//
// Параметры:
//  ИмяДокумента - Строка, имя документа для которого надо получить данные для расчета среднего заработка
//  МассивСсылок - массив, "ДокументСсылка.БольничныйЛист", "ДокументСсылка.ОтпускПоУходуЗаРебенком" 
// 
// Возвращаемое значение:
//  ДанныеДляРасчета - структура, содержит поля с таблицами данных для расчета среднего заработка по МассивСсылок 
//					ДанныеОНачислениях, Таблица значений	
//					ДанныеОВремени, Таблица значений	
//					ДанныеСтрахователей, Таблица значений	
//
Функция ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок) Экспорт
	
	Возврат УчетПособийСоциальногоСтрахованияБазовый.ТаблицыДанныхСреднегоЗаработкаФСС(ИмяДокумента, МассивСсылок);
	
КонецФункции 

Функция ОписаниеТипаСтраховательСреднийЗаработокФСС() Экспорт
	Возврат УчетПособийСоциальногоСтрахованияБазовый.ОписаниеТипаСтраховательСреднийЗаработокФСС();
КонецФункции 

#КонецОбласти

#КонецОбласти

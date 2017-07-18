﻿
#Область ПрограммныйИнтерфейс

// Процедура вызывается при изменении статуса отправки (сдачи) документа.
//
// Параметры:
//	Ссылка - ссылка на документ.
//	СтатусОтправки - ПеречислениеСсылка.СтатусыОтправки - актуальный статус
//
Процедура ПриИзмененииСтатусаОтправкиДокумента(Ссылка, СтатусОтправки) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения")
		И ОбщегоНазначения.ПодсистемаСуществует("ПодсистемыРегламентированногоУчета.ТорговыйСбор") Тогда
		
		ТорговыйСбор.ЗарегистрироватьИзменениеСтатусаОтправкиУведомления(Ссылка, СтатусОтправки);
		
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет")
		ИЛИ ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган")
		ИЛИ ТипЗнч(Ссылка) = Тип("ДокументСсылка.СведенияОЗастрахованныхЛицахСЗВ_М") Тогда
		
		ВыполнениеЗадачБухгалтера.ЗарегистрироватьИзменениеСтатусаЗадачи(Ссылка, СтатусОтправки);
		
	КонецЕсли;
	
КонецПроцедуры

// Функция должна возвращать дату начала и дату окончания периода
// документа (отчета) по заданной ссылке.
//
// Параметры:
//  Ссылка - ссылка на отчет (документ).
// 
// Результат:
//	Структура, если документ (отчет) представляется за период.
//	Ключи структуры: ДатаНачала, ДатаОкончания. Ключи содержат дату начала
//	и дату окончания периода, за который оформлен документ. Если документ
//	(отчет) представляется не за период, то в ключах ДатаНачала и ДатаОкончания
//	возвращается дата документа.
//
Функция ПолучитьДатыПериодаДокумента(Ссылка) Экспорт
	
	ПериодОтчета = Новый Структура("ДатаНачала, ДатаОкончания");
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		ГодОтчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "НалоговыйПериод");
		ПериодОтчета.ДатаНачала = Дата(ГодОтчета, 1, 1);
		ПериодОтчета.ДатаОкончания = Дата(ГодОтчета, 12, 31);
		Возврат ПериодОтчета;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ") Тогда
		ГодОтчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "НалоговыйПериод");
		ПериодОтчета.ДатаНачала = Дата(ГодОтчета, 1, 1);
		ПериодОтчета.ДатаОкончания = Дата(ГодОтчета, 12, 31);
		Возврат ПериодОтчета;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров") Тогда
		ПериодОтчета.ДатаНачала = Ссылка.Дата;
		ПериодОтчета.ДатаОкончания = Ссылка.Дата;
		Возврат ПериодОтчета;
	Иначе
		Возврат ПерсонифицированныйУчет.ПолучитьДатыПериодаДокумента(Ссылка);
	КонецЕсли;
	
КонецФункции

// Функция выгружает заданный документ и возвращает свойства файла выгрузки.
//
// Параметры:
//  Ссылка - ссылка на отчет (документ).
//
// Результат:
//	Структура или Неопределено, если не удалось сформировать файл выгрузки.
//	Ключи структуры:
//		- АдресФайлаВыгрузки - адрес двоичных данных файла выгрузки во временном хранилище
//		- ТипФайлаВыгрузки - строка
//		- ИмяФайлаВыгрузки - короткое имя файла выгрузки (с расширением)
//		- КодировкаФайлаВыгрузки - перечисление КодировкаТекста
Функция ВыгрузитьДокумент(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ФайлДляОтправки = Новый Структура("АдресФайлаВыгрузки, ИмяФайлаВыгрузки, ТипФайлаВыгрузки, КодировкаФайлаВыгрузки");
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		ИнформацияОФайле = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор, Истина);
		Если ИнформацияОФайле = НеОпределено Тогда
			Возврат НеОпределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле.ИмяФайла;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле.СсылкаНаДвоичныеДанныеФайла;
		ФайлДляОтправки.ТипФайлаВыгрузки = "СправкиНДФЛДляПередачиВНалоговыйОрган";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ") Тогда
		ИнформацияОФайле = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор, Истина);
		Если ИнформацияОФайле = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле.ИмяФайла;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле.СсылкаНаДвоичныеДанныеФайла;
		ФайлДляОтправки.ТипФайлаВыгрузки = "ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров") Тогда
		ИнформацияОФайле = Документы.ЗаявлениеОВвозеТоваров.ВыгрузитьЗаявлениеОВвозеТоваров(УникальныйИдентификатор, Ссылка);
		Если ИнформацияОФайле = НеОпределено Тогда
			Возврат НеОпределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле[0].ИмяФайлаВыгрузки;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле[0].АдресФайлаВыгрузки;
		ФайлДляОтправки.ТипФайлаВыгрузки = "ЗаявлениеОВвозеТоваров";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий") Тогда
		Отказ = Ложь;
		ФайлДляОтправки = Документы.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.ПолучитьФайлДляОтправки(Ссылка, Отказ);
		Если Отказ Тогда
			Возврат Неопределено;
		КонецЕсли;
		Возврат ФайлДляОтправки;
	Иначе
		Возврат ПерсонифицированныйУчет.ВыгрузитьДокументы(Ссылка, УникальныйИдентификатор);		
	КонецЕсли;
	
КонецФункции

// Получает пакет электронных представлений документов.
//
// Параметры
//  МассивНДС - Массив - перечень документов для которых
//                 необходимо получить электронные представления в виде двоичных данных.
//  УникальныйИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор по которому
//                 осуществляется привязка двоичных данных во временном хранилище.
//
// Возвращаемое значение:
//   Соответствие - сответствие переданных ссылок на документы и массива структур с полями:
//                 ТипФайла - Строка - описание типа файла;
//                 ИмяФайла - Строка - имя файла с расширением;
//                 АдресВременногоХранилища - Строка - адрес временного хранилища, в котором размещены двоичные данные файла.
Функция ПолучитьФайлыВыгрузкиНДС(МассивНДС, УникальныйИдентификаторФормы) Экспорт
	
	Возврат УчетНДС.ПолучитьЭлектронныеДокументы(МассивНДС, УникальныйИдентификаторФормы);
	
КонецФункции

// Получает пакет электронных представлений документов.
//
// Параметры
//  МассивЭД - Массив - перечень документов для которых
//                 необходимо получить электронные представления в виде двоичных данных.
//  УникальныйИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор по которому
//                 осуществляется привязка двоичных данных во временном хранилище.
//
// Возвращаемое значение:
//   Соответствие - сответствие переданных ссылок на документы и массива структур с полями:
//                 ТипФайла - Строка - описание типа файла;
//                 ИмяФайла - Строка - имя файла с расширением;
//                 АдресВременногоХранилища - Строка - адрес временного хранилища, в котором размещены двоичные данные файла.
Функция ПолучитьФайлыВыгрузкиЭД(МассивЭД, УникальныйИдентификаторФормы) Экспорт
	
	Возврат ОбменСКонтрагентами.ПолучитьСоответствиеДокументамИБКомплектыЭлектронныхДокументов(МассивЭД, УникальныйИдентификаторФормы);
	
КонецФункции

//Функция возвращает свойства договоров для массива документов
//
//Параметры 
//	МассивСсылок -  массив ссылок на документы ИБ, на основании которых в данном прикладном решении 
//  формируется электронный документ вида «Акт приемки-сдачи работ (услуг)»
//
//Возвращаемое значение: 
//	Соответствие со следующими свойствами:
//	-	ключ соответствия - ссылка на выгружаемый документ ИБ, взятая из входящего параметра
//	-	значение соответствия - Структура, с полями:
//		-	НомерДоговора, тип: Строка 
//		-	ДатаДоговора, тип: Дата 
//В случае, если требуемые реквизиты у договора не заполнены или при невозможности получения данных реквизитов, следует помещать пустые значения указанных типов.
Функция ПолучитьНомерДатаДоговораДокументов(МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровУслуг.ДоговорКонтрагента.Номер КАК НомерДоговора,
	|	РеализацияТоваровУслуг.ДоговорКонтрагента.Дата КАК ДатаДоговора,
	|	РеализацияТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетФактураВыданный.ДоговорКонтрагента.Номер,
	|	СчетФактураВыданный.ДоговорКонтрагента.Дата,
	|	СчетФактураВыданный.Ссылка
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	СчетФактураВыданный.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.ДоговорКонтрагента.Номер,
	|	КорректировкаРеализации.ДоговорКонтрагента.Дата,
	|	КорректировкаРеализации.Ссылка
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Номер,
	|	ПоступлениеТоваровУслуг.ДоговорКонтрагента.Дата,
	|	ПоступлениеТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|ГДЕ
	|	ПоступлениеТоваровУслуг.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СчетФактураПолученный.ДоговорКонтрагента.Номер,
	|	СчетФактураПолученный.ДоговорКонтрагента.Дата,
	|	СчетФактураПолученный.Ссылка
	|ИЗ
	|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|ГДЕ
	|	СчетФактураПолученный.Ссылка В(&МассивСсылок)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КорректировкаПоступления.ДоговорКонтрагента.Номер,
	|	КорректировкаПоступления.ДоговорКонтрагента.Дата,
	|	КорректировкаПоступления.Ссылка
	|ИЗ
	|	Документ.КорректировкаПоступления КАК КорректировкаПоступления
	|ГДЕ
	|	КорректировкаПоступления.Ссылка В(&МассивСсылок)";
	
	Запрос.УстановитьПараметр("МассивСсылок",МассивСсылок); 
	
	Соответствие = Новый Соответствие;
	Для Каждого Ссылка Из МассивСсылок Цикл
		
		Соответствие.Вставить(Ссылка,Новый Структура("НомерДоговора, ДатаДоговора","",'00010101'));
		
	КонецЦикла;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Соответствие.Вставить(Выборка.Ссылка, Новый Структура("НомерДоговора, ДатаДоговора",Выборка.НомерДоговора,Выборка.ДатаДоговора));
		
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции 

// Функция возвращает свойства сотрудника по СправочникСсылка.ФизическиеЛица и СправочникСсылка.Организации
//
// Параметры функции:
// 	СсылкаФизЛицо 		- СправочникСсылка.ФизическиеЛица
// 	ОрганизацияСсылка 	- СправочникСсылка.Организации
//
// Возвращаемое значение:
// Структура со следующими полями:
//  ФИО - структура:
// 		* Фамилия	- Строка 	- фамилия сотрудника.
// 		* Имя		- Строка 	- имя сотрудника.
// 		* Отчество	- Строка 	- отчество сотрудника.
//  Серия			- Строка 	- серия документа, удостоверяющего личность сотрудника.
//  Номер			- Строка 	- номер документа, удостоверяющего личность сотрудника.
//  ДатаВыдачи		- Дата 		- дата выдачи документа, удостоверяющего личность сотрудника.
//  КемВыдан		- Строка 	- кем выдан документ, удостоверяющий личность сотрудника.
//  ВидДокумента	- СправочникСсылка.ВидыДокументовФизическихЛиц - вид документа, удостоверяющего личность сотрудника.
//  Должность		- Строка 	- должность сотрудника.
//  Подразделение	- Строка 	- подразделение, в котором работает сотрудник.
//  СНИЛС			- Строка 	- СНИЛС сотрудника.
//  ДатаРождения	- Дата - Дата рождения.
//  МестоРождения	- Строка - Длина не более 50 символов. Место рождения.
//  КодПодразделения - Строка - Код подразделения организации, выдавшего документ, удостоверяющий личность.
//  Пол             - Строка - пол физ. лица "Мужской" или "Женский".
//  Гражданство     - СправочникСсылка.СтраныМира - гражданство сотрудника.
// 
Функция ПолучитьДанныеИсполнителя(СсылкаФизЛицо, ОрганизацияСсылка) Экспорт
	
	ДанныеФизическогоЛица = УчетЗарплаты.ДанныеФизическихЛиц(ОрганизацияСсылка, СсылкаФизЛицо, КонецДня(ТекущаяДата()), Ложь, Ложь);
	
	Структура		= Новый Структура("ФИО,ДатаРождения,МестоРождения,Пол,КодПодразделения,Гражданство,Серия,Номер,ДатаВыдачи,КемВыдан,КодПодразделения,ВидДокумента,Подразделение,Должность");
	СтруктураФИО	= Новый Структура("Фамилия,Имя,Отчество");
	
	СтруктураФИО.Вставить("Фамилия",  ДанныеФизическогоЛица.Фамилия);
	СтруктураФИО.Вставить("Имя",      ДанныеФизическогоЛица.Имя);
	СтруктураФИО.Вставить("Отчество", ДанныеФизическогоЛица.Отчество);
	
	ЗаполнитьЗначенияСвойств(Структура, ДанныеФизическогоЛица);
	Структура.Вставить("ФИО",           СтруктураФИО);
	Структура.Вставить("СНИЛС",         ДанныеФизическогоЛица.СтраховойНомерПФР);
	Структура.Вставить("Подразделение", ДанныеФизическогоЛица.ПодразделениеОрганизации);
	Структура.Вставить("Гражданство",   ДанныеФизическогоЛица.Страна);
	
	Возврат Структура;
	
КонецФункции

// Функция возвращает соответствие или массив данных об ответственных лицах организации
//	Параметры функции:
//		ОрганизацияСсылка - СправочникСсылка.Организации;
//		ПолучитьСоответствие - Булево.
//
//	Возвращаемое значение:
//			Соответствие или массив, сведений об ответственных лицах организации.
//		Если значение параметра "ПолучитьСоответствие" указано и значение параметра 
//		равно "Истина", то функция вернет коллекцию соответствие с ключем признака ответственного лица (тип "Строка")
//		и стуктуру данных физ. лица.
//			Структура данных физ. лца состоит из значения "должность" должности ответветственного лица (тип "Строка") 
//			и "СНИЛС" значение реквизита "СтраховойНомерПФР" справочника физ. лица (тип "Строка").
//		В противном случаи вернется массив ссылок с типом СправочникСсылка.ФизическиеЛица.
//
Функция ПолучитьДанныеОтветственныхЛиц(ОрганизацияСсылка, ПолучитьСоответствие = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.СтраховойНомерПФР КАК СНИЛС,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.Должность,
	|	ВЫБОР
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)
	|			ТОГДА ""Руководитель""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)
	|			ТОГДА ""ГлавныйБухгалтер""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир)
	|			ТОГДА ""Кассир""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ОтветственноеЛицо
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних(&КонецПериода, СтруктурнаяЕдиница = &Организация) КАК ОтветственныеЛицаОрганизацийСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК СотрудникиОрганизаций
	|		ПО ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо = СотрудникиОрганизаций.Ссылка
	|			И (ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница = &Организация)";
	
	Запрос.УстановитьПараметр("Организация", ОрганизацияСсылка);
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДата());
	
	Если ПолучитьСоответствие Тогда
		Результат = Новый Соответствие;
	Иначе
		Результат = Новый Массив();
	КонецЕсли;
	
	Попытка
		РезультатЗапроса	= Запрос.Выполнить();
		ЗапросВыборка		= РезультатЗапроса.Выбрать();
		
		Пока ЗапросВыборка.Следующий() Цикл
			Если ПолучитьСоответствие Тогда
				СтруктураДанных = Новый Структура;
				СтруктураДанных.Вставить("Должность", ЗапросВыборка.Должность);
				СтруктураДанных.Вставить("СНИЛС",     ЗапросВыборка.СНИЛС);
				Результат.Вставить(ЗапросВыборка.ОтветственноеЛицо, СтруктураДанных);
			Иначе
				Результат.Добавить(ЗапросВыборка.Сотрудник);
			КонецЕсли;
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция должна возвращать код подчиненности реестра сведений на выплату пособий в ФСС по заданной ссылке
// Параметры:      
//  Ссылка - ссылка реестр сведений на выплату пособий в ФСС.
// 
// Результат:
//  Строка, 5 символов.  В случае неудачи - пустая строка.
Функция ПолучитьКодПодчиненностиРеестраСведенийНаВыплатуПособийФСС(Ссылка) Экспорт
	
	
	
КонецФункции

// Функция должна возвращать код ИФНС получателя отправляемого объекта
// Параметры:      
//  ОбъектСсылка - ссылка на отправляемый объект.
// Результат:
// Строка, длина 4. В случае неудачи - пустая строка
Функция ПолучитьКодИФНСПолучателяПоСсылке(ОбъектСсылка) Экспорт
	
	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.ЗаявлениеОВвозеТоваров") Тогда
		СтруктураРеквизитовВыгрузки = ОбъектСсылка.СтруктураРеквизитовВыгрузки.Получить();
		Возврат СтруктураРеквизитовВыгрузки.КодИФНС;
	КонецЕсли;
	
КонецФункции

// Возвращает ключ записи регистра сведений ОтветственныеЛицаОрганизаций
//
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, по которой необходимо получить записи в регистре сведений 
//  ОтветственноеЛицо - СправочникСсылка.ФизическиеЛица - физическое лицо, по которому необходимо получить записи в регистре сведений 
//
// Возвращаемое значение:
//   РегистрСведенийКлючЗаписи - ключ записи регистра сведений, полученный по указанным входящим параметрам
//   РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч() - в случае, если ключ не найден
//
Функция ПолучитьКлючЗаписиРегистраОтветственныеЛицаОрганизаций(Организация,ОтветственноеЛицо)  Экспорт
	
	Ключ = РегистрыСведений.ОтветственныеЛицаОрганизаций.ПустойКлюч();
	
	Запрос	= Новый Запрос;
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница",	Организация);
	Запрос.УстановитьПараметр("ОтветственноеЛицо",	ОтветственноеЛицо);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.Период КАК Период,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ПРЕДСТАВЛЕНИЕ(ОтветственныеЛицаОрганизацийСрезПоследних.ФизическоеЛицо) КАК ФизическоеЛицо,
	|	ПРЕДСТАВЛЕНИЕ(ОтветственныеЛицаОрганизацийСрезПоследних.Должность) КАК Должность,
	|	ВЫБОР
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель)
	|			ТОГДА ""Руководитель""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер)
	|			ТОГДА ""ГлавныйБухгалтер""
	|		КОГДА ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Кассир)
	|			ТОГДА ""Кассир""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ПредставлениеОтветственногоЛица
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций.СрезПоследних КАК ОтветственныеЛицаОрганизацийСрезПоследних
	|ГДЕ
	|	ОтветственныеЛицаОрганизацийСрезПоследних.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И ОтветственныеЛицаОрганизацийСрезПоследних.ОтветственноеЛицо = &ОтветственноеЛицо";
	
	
	Отбор	= Новый Структура("Период, СтруктурнаяЕдиница, ОтветственноеЛицо");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ПустаяСтрока(Выборка.ПредставлениеОтветственногоЛица) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Отбор, Выборка);
		Ключ = РегистрыСведений.ОтветственныеЛицаОрганизаций.СоздатьКлючЗаписи(Отбор);
		
	КонецЦикла;
	
	Возврат Ключ;
	
КонецФункции

// Возвращает ссылку на Главного бухгалтера 
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, главного бухгалтера которой необходимо получить
//
// Возвращаемое значение:
//   СправочникСсылка.ФизическиеЛица - главный бухгалтер организации
//   Неопределено, если главный бухгалтер отсутствует
//
Функция ГлБухгалтер(Организация)  Экспорт
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, ТекущаяДатаСеанса());
	Возврат ОтветственныеЛица.ГлавныйБухгалтер;
	
КонецФункции

// Возвращает ссылку на Руководителя организации
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, руководителя которой необходимо получить
//
// Возвращаемое значение:
//   СправочникСсылка.ФизическиеЛица - руководитель организации
//   Неопределено, если руководитель отсутствует
//
Функция Руководитель(Организация) Экспорт
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, ТекущаяДатаСеанса());
	Возврат ОтветственныеЛица.Руководитель;
	
КонецФункции

// Функция для объекта-источника возвращает ссылку на организацию. 
// В данной функции необходимо определить получение организации для всех типов объектов, которые должны отоборажаться
// в журнале Управление обменом и не имеют реквизита с именем "Организация"
// 
// Параметры:
//  Источник - ДокументСсылка, СправочникСсылка  - объект, который отборажается в форме Управление обменом.
//
// Результат:
//  СправочникСсылка.Организации,
//	Неопределено, если получить ссылку на организацию не получилось
//
Функция ПолучитьСсылкуНаОрганизациюИсточника(Источник) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает ИНН контрагента для случая, когда ИНН в справочнике Контрагенты не хранится в реквизите с именем ИНН 
//
// Параметры
//  Контрагент  - <Справочник.Контрагент> - Контрагент, для котрого необходимо получить ИНН
// Возвращаемое значение:
//   ИНН   - строка - ИНН контрагента
//
Функция ИННКонтрагента(Контрагент) Экспорт
	
КонецФункции

// Функция предназначена для поиска физического лица, найденного по переданным фамилии, имени и отчеству
//
// Параметры
//  Фамилия		- Строка - Фамилия физического лица
//  Имя			- Строка - Имя физического лица
//  Отчество	- Строка - Отчество физического лица
//  СНИЛС		- Строка - СНИЛС физического лица
//  Организация - СправочникиСсылка.Организации - организация, в которой работает физическое лицо
//
// Возвращаемое значение:
//   СправочникиСсылка.ФизическиеЛица - Физическое лицо, найденное по переданным фамилии, имени и отчеству
//		Если найдено несколько физических лиц, брать первого
//
Функция ФизЛицоПоФИО(Фамилия, Имя, Отчество, СНИЛС, Организация) Экспорт
	
	Возврат КадровыйУчет.ФизическоеЛицоПоФИОСНИЛСИОрганизации(Фамилия, Имя, Отчество, СНИЛС, Организация);
	
КонецФункции

// Функция возвращает вид отправляемого документа 
// Параметры:      
//  ОбъектСсылка - ссылка на отправляемый объект.
// Результат:
//	СправочникСсылка.ВидыОтправляемыхДокументов, в случае неудачи - пустая ссылка данного типа
//
Функция ПолучитьВидОтправляемогоДокументаПоСсылке(ОбъектСсылка) Экспорт
	
	ВидОтправляемогоДокумента = Неопределено;
	УчетОбособленныхПодразделений.ПолучитьВидОтправляемогоДокументаПоСсылке(ВидОтправляемогоДокумента, ОбъектСсылка);
	Если ВидОтправляемогоДокумента <> Неопределено Тогда
		Возврат ВидОтправляемогоДокумента;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") Тогда
		ВидУведомления = ОбъектСсылка.ВидУведомления;
		
		Если ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет Тогда 
			Возврат Справочники.ВидыОтправляемыхДокументов.ВыборНалоговогоОрганаДляПостановкиНаУчет;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ОткрытиеЗакрытиеСчета;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.УчастиеВРоссийскихИностранныхОрганизациях;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1 Тогда 
			Возврат Справочники.ВидыОтправляемыхДокументов.СозданиеОбособленныхПодразделений;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ЗакрытиеОбособленныхПодразделений;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.РеорганизацияЛиквидацияОрганизации;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ПостановкаНаУчетОрганизацииПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ПостановкаНаУчетПредпринимателяПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.СнятиеСУчетаОрганизацииПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.СнятиеСУчетаПредпринимателяПлательщикаЕНВД;
		Иначе
			Возврат Справочники.ВидыОтправляемыхДокументов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#Область ДокументыПоТребованиюФНС

// Помещает присоединенные файлы объектов ИБ, 
// являющихся источниками для заполнения реквизитов сканированных документов, 
// представляемых по требованию ФНС, во временное хранилище и возвращает их свойства.
//
// Не требуется заполнять, если указанные присоединенные файлы хранятся при участии механизма БСП "Присоединенные файлы"
//
// Следует возвращать свойства всех файлов следующих типов: JPEG, TIFF, PNG, PDF.
//
// Параметры 
//	ИдентификаторФормыВладельца	- УникальныйИдентификатор, уникальный идентификатор формы, 
//		во временное хранилище которой требуется поместить данные присоединенных файлов.
//	ФайлыИсточников				- Соответствие, соответствие переданных ссылок на источники и массива структур 
//		Ключ 		- ссылка на источник
//		Значение 	- Массив, массив структур (начальное значение: пустой массив)
//		(каждый элемент массива -  структура свойств одного файла)
//
//		Поля структуры:
//			Имя			- Строка, короткое имя файла с расширением
//			Размер		- Число, размер файла в байтах
//			АдресДанных	- Строка, адрес временного хранилища
//
Процедура ПолучитьИзображенияПрисоединенныхФайловИсточников(ФайлыИсточников, ИдентификаторФормыВладельца) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

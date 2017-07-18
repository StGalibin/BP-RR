﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обновляет внешние компоненты через интернет в фоновом процессе.
//
// Параметры:
//  Параметры - Структура - в ключе первого поля указано имя модуля, который нужно обновить.
//                          Если структура пустая, то обновляются все модули.
//
Процедура ОбновитьВнешниеКомпоненты(Параметры, Адрес) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВнешниеКомпоненты.Версия,
	               |	ВнешниеКомпоненты.Адрес,
	               |	ВнешниеКомпоненты.Наименование
	               |ИЗ
	               |	Справочник.ВнешниеКомпоненты КАК ВнешниеКомпоненты
	               |ГДЕ
	               |	ИСТИНА";
	
	Если Параметры.Количество() Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИСТИНА", "ВнешниеКомпоненты.Идентификатор = &Идентификатор");
		Для Каждого КлючЗначение Из Параметры Цикл
			Запрос.УстановитьПараметр("Идентификатор", КлючЗначение.Ключ);
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВремФайл = ПолучитьИмяВременногоФайла("xml");
		ПараметрыПолучения = Новый Структура("Таймаут, ПутьДляСохранения", 20, ВремФайл);
		РезультатИнфоФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Выборка.Адрес, ПараметрыПолучения);
		Если РезультатИнфоФайл.Статус Тогда
			ПараметрыВК = ПараметрыВК(ВремФайл);
			Если Выборка.Версия <> ПараметрыВК.Версия Тогда
				ПараметрыПолучения = Новый Структура("Таймаут", 60);
				РезультатВКФайл = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(
					ПараметрыВК.URLВК, ПараметрыПолучения);
				Если РезультатВКФайл.Статус Тогда
					СохранитьВнешнююКомпонентуВИнформационнойБазе(РезультатВКФайл.Путь);
				Иначе
					ТекстСообщения = НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
												|Описание: %2'");
					ТекстОшибки =  НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
											|Описание: %2
											|URL: %3'");
					Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
						ТекстСообщения = ТекстСообщения + НСтр("ru = '
																|Код ошибки: %3'");
						ТекстСообщения = СтрШаблон(
							ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, РезультатВКФайл.КодСостояния);
						ТекстОшибки = ТекстОшибки + НСтр("ru = '
												|Код ошибки: %4'");
						ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК,
							РезультатВКФайл.КодСостояния);
					Иначе
						ТекстСообщения = СтрШаблон(ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке);
						ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК);
					КонецЕсли;
					
					ВидОперации = Нстр("ru = 'Загрузка внешней компоненты из интернет'");
						
					ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
					
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			ТекстСообщения = НСтр("ru = 'Не удалось получить информацию о файле внешней компоненты: %1
										|Описание: %2'");
			ТекстОшибки =  НСтр("ru = 'Не удалось получить информацию о файле внешней компоненты: %1
								|Описание: %2
								|URL: %3'");
			Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
				ТекстСообщения = ТекстСообщения + НСтр("ru = '
														|Код ошибки: %3'");
				ТекстСообщения = СтрШаблон(
					ТекстСообщения, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, РезультатИнфоФайл.КодСостояния);
				ТекстОшибки = ТекстОшибки + НСтр("ru = '
												|Код ошибки: %4'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, Выборка.Адрес,
					РезультатИнфоФайл.КодСостояния);
			Иначе
				ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке);
				ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.Наименование, РезультатИнфоФайл.СообщениеОбОшибке, Выборка.Адрес);
			КонецЕсли;
			
			ВидОперации = Нстр("ru = 'Загрузка внешней компоненты из интернет'");
			
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Сохраняет внешнюю компоненту в информационной базе
//
// Параметры:
//  Адрес - Строка - адрес временного хранилища c двоичными данными внешней компоненты.
//
Процедура СохранитьВнешнююКомпонентуВИнформационнойБазе(Адрес) Экспорт
	
	ИнформацияОВК = ИнформацияОВК(Адрес);
	НайденныйЭлемент = Справочники.ВнешниеКомпоненты.НайтиПоРеквизиту("Идентификатор", ИнформацияОВК.ИмяМодуля);
	Если ЗначениеЗаполнено(НайденныйЭлемент) Тогда
		ОбъектСправочника = НайденныйЭлемент.ПолучитьОбъект();
	Иначе
		ОбъектСправочника = Справочники.ВнешниеКомпоненты.СоздатьЭлемент();
	КонецЕсли;
	
	ОбъектСправочника.Наименование = ИнформацияОВК.Название;
	ОбъектСправочника.Версия = ИнформацияОВК.Версия;
	ДвоичныеДанныеВК = ПолучитьИзВременногоХранилища(Адрес);
	ОбъектСправочника.ДанныеВК = Новый ХранилищеЗначения(ДвоичныеДанныеВК, Новый СжатиеДанных(9));
	ОбъектСправочника.Идентификатор = ИнформацияОВК.ИмяМодуля;
	ОбъектСправочника.Адрес = ИнформацияОВК.URLИнфо;
	ОбъектСправочника.ПометкаУдаления = Ложь;
	ОбъектСправочника.Записать();
	
КонецПроцедуры

// Скачивает внешнюю компоненту через интернет в фоновом процессе.
//
// Параметры:
//  Параметры - Структура - параметры загрузки внешней компоненты.
//                 * URLИнфо - Строка - адрес информационного файла, используемого для закачки ВК
//  Адрес - Строка - не используется.
//
Процедура СкачатьВнешнююКомпоненту(Параметры, Адрес = Неопределено) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла("xml");
	ПараметрыПолучения = Новый Структура("Таймаут, ПутьДляСохранения", 20, ВремФайл);
	РезультатИнфоФайл = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Параметры.URLИнфо, ПараметрыПолучения);
	Если РезультатИнфоФайл.Статус Тогда
		ПараметрыВК = ПараметрыВК(ВремФайл);
		УдалитьФайлы(ВремФайл);
		ПараметрыПолучения = Новый Структура("Таймаут", 60);
		РезультатВКФайл = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(
			ПараметрыВК.URLВК, ПараметрыПолучения);
		Если РезультатВКФайл.Статус Тогда
			СохранитьВнешнююКомпонентуВИнформационнойБазе(РезультатВКФайл.Путь);
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
										|Описание: %2'");
			ТекстОшибки =  НСтр("ru = 'Не удалось скачать файл внешней компоненты: %1
									|Описание: %2
									|URL: %3'");
			Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
				ТекстСообщения = ТекстСообщения + НСтр("ru = '
														|Код ошибки: %3'");
				ТекстСообщения = СтрШаблон(
					ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, РезультатВКФайл.КодСостояния);
				ТекстОшибки = ТекстОшибки + НСтр("ru = '
										|Код ошибки: %4'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК,
					РезультатВКФайл.КодСостояния);
			Иначе
				ТекстСообщения = СтрШаблон(ТекстСообщения, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке);
				ТекстОшибки = СтрШаблон(ТекстОшибки, ПараметрыВК.Название, РезультатВКФайл.СообщениеОбОшибке, ПараметрыВК.URLВК);
			КонецЕсли;
			
			ВидОперации = Нстр("ru = 'Загрузка внешней компоненты из интернет'");
				
			ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
			
			ВызватьИсключение ТекстСообщения;
				
		КонецЕсли;

	Иначе
			
		ТекстСообщения = НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
									|Описание: %1'");
		ТекстОшибки =  НСтр("ru = 'Не удалось получить информационный файл внешней компоненты.
							|Описание: %1
							|URL: %2'");
		Если РезультатИнфоФайл.Свойство("КодСостояния") Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru = '
													|Код ошибки: %2'");
			ТекстСообщения = СтрШаблон(
				ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке, РезультатИнфоФайл.КодСостояния);
			ТекстОшибки = ТекстОшибки + НСтр("ru = '
											|Код ошибки: %3'");
			ТекстОшибки = СтрШаблон(
				ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфо, РезультатИнфоФайл.КодСостояния);
		Иначе
			ТекстСообщения = СтрШаблон(ТекстСообщения, РезультатИнфоФайл.СообщениеОбОшибке);
			ТекстОшибки = СтрШаблон(ТекстОшибки, РезультатИнфоФайл.СообщениеОбОшибке, Параметры.URLИнфо);
		КонецЕсли;
		
		ВидОперации = Нстр("ru = 'Загрузка внешней компоненты через интернет'");
		
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки);
		
		ВызватьИсключение ТекстСообщения;
	
	КонецЕсли;
		
КонецПроцедуры

// Получает информация о внешней компоненте в файле
//
// Параметры:
//  АдресВнешнейКомпоненты - Строка - адрес временного хранилища с двоичными данными файла внешней компоненты
// 
// Возвращаемое значение:
//  Структура - информация о ВК. Содержит следующие поля:
//     * ИмяМодуля - Строка - регистрируемое название модуля в ОС
//     * Название - Строка - название модуля для вывода пользователю
//     * Версия - Строка - версия модуля
//     * URLВК - Строка - адрес в интернете для скачивания компоненты
//     * URLИнфо - Строка - адрес в интернете для скачивания информационного файла.
//
Функция ИнформацияОВК(АдресВнешнейКомпоненты) Экспорт
	
	ДвоичныеДанныеВК = ПолучитьИзВременногоХранилища(АдресВнешнейКомпоненты);
	ВремФайл = ПолучитьИмяВременногоФайла("zip");
	ДвоичныеДанныеВК.Записать(ВремФайл);
	
	ВремКаталог = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(ВремКаталог);
	
	ЧтениеФайла = Новый ЧтениеZipФайла(ВремФайл);
	НайденаИнформация = Ложь;
	
	Для Каждого Элемент Из ЧтениеФайла.Элементы Цикл
		Если ВРег(Элемент.Имя) = "INFO.XML" Тогда
			НайденаИнформация = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не НайденаИнформация Тогда
		Операция = Нстр("ru = 'Чтение информации о файле внешнего модуля.'");
		ТекстОшибки = Нстр("ru = 'В архиве внешней компоненты отсутствует файл INFO.XML'");
		ТекстСообщения = Нстр("ru = 'При чтении данных внешней компоненты произошла ошибка.'");
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки, ТекстСообщения);
		УдалитьФайлы(ВремКаталог);
		УдалитьФайлы(ВремФайл);
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеФайла.Извлечь(Элемент, ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	ВремКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВремКаталог);
	
	ФайлИнформации = ВремКаталог + Элемент.Имя;
	
	СтруктураВозврата = ПараметрыВК(ФайлИнформации);
	
	ЧтениеФайла.Закрыть();
	УдалитьФайлы(ВремКаталог);
	УдалитьФайлы(ВремФайл);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Получает параметры внешней компоненты.
//
// Параметры:
//  ПутьКФайлуИнформации - Строка - путь к информационному файлу
// 
// Возвращаемое значение:
//  Структура - информация о ВК. Содержит следующие поля:
//     * ИмяМодуля - Строка - регистрируемое название модуля в ОС
//     * Название - Строка - название модуля для вывода пользователю
//     * Версия - Строка - версия модуля
//     * URLВК - Строка - адрес в интернете для скачивания компоненты
//     * URLИнфо - Строка - адрес в интернете для скачивания информационного файла.
//
Функция ПараметрыВК(ПутьКФайлуИнформации) Экспорт
	
	Попытка
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ПутьКФайлуИнформации);
		ЭД = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("ИмяМодуля", ЭД.progid);
		СтруктураВозврата.Вставить("Название", ЭД.name);
		СтруктураВозврата.Вставить("Версия", ЭД.version);
		Если ТипЗнч(ЭД.urladdin) = Тип("Строка") Тогда
			СтруктураВозврата.Вставить("URLВК", ЭД.urladdin);
		КонецЕсли;
		Если ТипЗнч(ЭД.urladdininfo) = Тип("Строка") Тогда
			СтруктураВозврата.Вставить("URLИнфо", ЭД.urladdininfo);
		КонецЕсли;

		Возврат СтруктураВозврата;
	Исключение
		Операция = Нстр("ru = 'Чтение файла информации о внешней компоненте.'");
		ТекстСообщения = Нстр("ru = 'При чтении информации о внешней компоненте произошла ошибка.'");
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ДополнительныеВнешниеКомпонентыВызовСервера.ОбработатьОшибку(Операция, ТекстОшибки);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
КонецФункции

#КонецОбласти


#КонецЕсли
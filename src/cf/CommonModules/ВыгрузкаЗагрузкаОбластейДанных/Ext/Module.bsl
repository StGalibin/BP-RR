﻿#Область ПрограммныйИнтерфейс

// Выгружает данные приложения в zip-архив, из которого они в дальнейшем могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьДанныхИзАрхива().
//
// Возвращаемое значение - Строка, путь к файлу выгрузки.
//
Функция ВыгрузитьТекущуюОбластьДанныхВАрхив() Экспорт
	
	ВыгружаемыеТипы = Новый Массив();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВыгружаемыеТипы, ПолучитьТипыМоделиДанныхОбласти());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВыгружаемыеТипы,
		ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке(), Истина);
	
	ПараметрыВыгрузки = Новый Структура();
	ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", ВыгружаемыеТипы);
	ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Истина);
	ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Истина);
	
	Возврат ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеВАрхив(ПараметрыВыгрузки);
	
	
КонецФункции

// Выгружает данные приложения в zip-архив, который помещает во временное хранилище.
//  В дальнейшем данные из архива могут быть загружены
//  в другую информационную базу или область данных с помощью функции
//  ВыгрузкаЗагрузкаОбластейДанных.ЗагрузитьТекущуюОбластьДанныхИзАрхива().
//
// Параметры:
//  АдресХранилища - Строка, адрес во временном хранилище, в который нужно поместить
//  zip-архив с данными.
//
Процедура ВыгрузитьТекущуюОбластьДанныхВоВременноеХранилище(АдресХранилища) Экспорт
	
	ИмяФайла = ВыгрузитьТекущуюОбластьДанныхВАрхив();
	
	Попытка
		
		ДанныеВыгрузки = Новый ДвоичныеДанные(ИмяФайла);
		ПоместитьВоВременноеХранилище(ДанныеВыгрузки, АдресХранилища);
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецПроцедуры

// Выгружает данные приложения в zip-архив, разбивает, при необходимости,
// на части и помещает результат во временное хранилище.
//
// Параметры:
//   АдресХранилища - Строка - адрес во временном хранилище для размещения результата,
//   РазмерЧастиВМегабайтах - Число - размер одной части файла в мегабайтах.
//
Процедура ВыгрузитьТекущуюОбластьДанныхВФайлИРазделитьНаЧасти(АдресХранилища, АдресХранилищаФайла, ЭтоВебКлиент, РазмерЧастиВМегабайтах = 0) Экспорт
	
	ИмяФайла = ВыгрузитьТекущуюОбластьДанныхВАрхив();
	
	Попытка
		
		ЧастиФайла = РазделитьФайлНаЧасти(ИмяФайла, ЭтоВебКлиент, РазмерЧастиВМегабайтах);
		
		Если ТипЗнч(ЧастиФайла) = Тип("ДвоичныеДанные") Тогда
			
			ПоместитьВоВременноеХранилище(ЧастиФайла, АдресХранилищаФайла);
			ПоместитьВоВременноеХранилище(АдресХранилищаФайла, АдресХранилища);
			
		Иначе
			
			ПоместитьВоВременноеХранилище(ЧастиФайла, АдресХранилища);
			
		КонецЕсли;
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);
		
	Исключение
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ИмяФайла);
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
КонецПроцедуры

// Загружает данные приложения из zip архива с XML файлами.
//
// Параметры:
//  ИмяАрхива - Строка - полное имя файла архива с данными,
//  ПараметрыЗагрузки - Структура, содержащая параметры загрузки данных.
//    Ключи:
//      ЗагружаемыеТипы - Массив(ОбъектМетаданных) - массив объектов метаданных, данные
//        которых требуется загрузить из архива. Если значение параметра задано - все прочие
//        данные, содержащиеся в файле выгрузки, загружены не будут. Если значение параметра
//        не задано - будут загружены все данные, содержащиеся в файле выгрузки.
//      ЗагружатьПользователей - Булево - загружать информацию о пользователях информационной базы,
//      ЗагружатьНастройкиПользователей - Булево, игнорируется, если ЗагружатьПользователей = Ложь.
//    Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//      произвольных обработчиков загрузки данных.
//
Процедура ЗагрузитьТекущуюОбластьДанныхИзАрхива(Знач ИмяАрхива, Знач ЗагружатьПользователей = Ложь, Знач СвернутьЭлементыСправочникаПользователи = Ложь) Экспорт
	
	ЗагружаемыеТипы = Новый Массив();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗагружаемыеТипы, ПолучитьТипыМоделиДанныхОбласти());
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗагружаемыеТипы,
			ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке(), Истина);
	КонецЕсли;
	
	ПараметрыЗагрузки = Новый Структура();
	ПараметрыЗагрузки.Вставить("ЗагружаемыеТипы", ЗагружаемыеТипы);
	
	Если ТехнологияСервисаИнтеграцияСБСП.РазделениеВключено() Тогда
		
		ПараметрыЗагрузки.Вставить("ЗагружатьПользователей", Ложь);
		ПараметрыЗагрузки.Вставить("ЗагружатьНастройкиПользователей", Ложь);
		
	Иначе
		
		ПараметрыЗагрузки.Вставить("ЗагружатьПользователей", ЗагружатьПользователей);
		ПараметрыЗагрузки.Вставить("ЗагружатьНастройкиПользователей", ЗагружатьПользователей);
		
	КонецЕсли;
	
	ПараметрыЗагрузки.Вставить("СвернутьРазделенныхПользователей", СвернутьЭлементыСправочникаПользователи);
	
	ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеИзАрхива(ИмяАрхива, ПараметрыЗагрузки);
	
КонецПроцедуры

// Проверяет совместимость выгрузки из файла с текущей конфигурацией информационной базы.
//
// Параметры:
//  ИмяАрхива - Строка, путь к файлу выгрузки.
//
// Возвращаемое значение: Булево, Истина - если данные из архива могут быть загружены
//  в текущую конфигурацию.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИмяАрхива) Экспорт
	
	Возврат ВыгрузкаЗагрузкаДанных.ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИмяАрхива);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТипыМоделиДанныхОбласти()
	
	Результат = Новый Массив();
	
	МодельДанных = ТехнологияСервисаИнтеграцияСБСП.ПолучитьМодельДанныхОбласти();
	
	Для Каждого ЭлементМоделиДанных Из МодельДанных Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементМоделиДанных.Ключ);
		
		Если Не ОбщегоНазначенияБТС.ЭтоРегламентноеЗадание(ОбъектМетаданных)
				И Не ОбщегоНазначенияБТС.ЭтоЖурналДокументов(ОбъектМетаданных)
				И Не ОбщегоНазначенияБТС.ЭтоВнешнийИсточникДанных(ОбъектМетаданных) Тогда
			
			Результат.Добавить(ОбъектМетаданных);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Разделяет файл на части на сервере, помещает части во временный каталог.
//
// Параметры:
//   ИмяФайла               - Строка - имя файла, который требуется разделить на части.
//   РазмерЧастиВМегабайтах - Число - размер одной части файла в мегабайтах.
// 
// Возвращаемое значение:
//   Массив - полученные части файла, структура с ключами:
//     * Хранение - Строка - положение файла на сервере,
//     * ХешСумма - Число - значение хеш-суммы, полученное функцией CRC32.
//
Функция РазделитьФайлНаЧасти(ИмяФайла, ЭтоВебКлиент, РазмерЧастиВМегабайтах = 0)
	
	Результат = Новый Массив;
	
	// Размер части в байтах. По умолчанию по 100 Мб.
	РазмерЧасти = ?(РазмерЧастиВМегабайтах <= 0, 100, РазмерЧастиВМегабайтах) * 1024 * 1024;
	
	// Определение необходимости разделения файла.
	Если ЭтоВебКлиент Тогда
		
		// Веб-клиент не поддерживает объединение файлов.
		Разделять = Ложь;
		
	Иначе
		
		// Проверка размера файла.
		РазделяемыйФайл = Новый Файл(ИмяФайла);
		Разделять = РазделяемыйФайл.Размер() > РазмерЧасти;
		
	КонецЕсли;
	
	Если Разделять Тогда
		
		Попытка
			
			// Создание временного каталога для хранения частей файла, чтобы в случае неудачи при разделении удалить весь каталог.
			// Имена созданных файлов в случае неудачи неизвестны.
			ВременныйКаталог = ПолучитьИмяВременногоФайла();
			СоздатьКаталог(ВременныйКаталог);
			
			// Разделение файла на части.
			ИменаЧастей = РазделитьФайл(ИмяФайла, РазмерЧасти, ВременныйКаталог);
			
			Для каждого ИмяЧасти Из ИменаЧастей Цикл
				
				// Для каждого имени файла сохраняется хеш, чтобы не было возможности получить другой файл.
				// Клиент при запросе части файла должен запросить имя файла и указать хеш.
				ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.CRC32);
				ХешированиеДанных.ДобавитьФайл(ИмяЧасти);
				
				Результат.Добавить(Новый ФиксированнаяСтруктура("Хранение, ХешСумма", ИмяЧасти, ХешированиеДанных.ХешСумма));
				
			КонецЦикла;
			
		Исключение // По каким-то причинам файл разделить не удалось.
			
			// Удаление временного каталога с созданными частями файла.
			ВыгрузкаЗагрузкаДанныхСлужебный.УдалитьВременныйФайл(ВременныйКаталог);
			
			// Разделить не удалось, отдать сам файл.
			Разделять = Ложь;

		КонецПопытки;
		
	КонецЕсли;
	
	// Разделять не требуется или не получилось разделить, отдать сам файл.
	Если НЕ Разделять Тогда
		
		Результат = Новый ДвоичныеДанные(ИмяФайла);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Операции с файлами (служебный)".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция РаспаковатьАрхив(Адрес) Экспорт
	
	ИмяФайлаАрхива = ПолучитьИмяВременногоФайла(".zip");	
	ПолучитьИзВременногоХранилища(Адрес).Записать(ИмяФайлаАрхива);
	
	ИмяКаталогДляРаспаковки = КаталогВременныхФайлов() + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	
	ЧтениеZIP = Новый ЧтениеZipФайла(ИмяФайлаАрхива);
	ЧтениеZIP.ИзвлечьВсе(ИмяКаталогДляРаспаковки);
	
	ИзвлеченныеФайлы = НайтиФайлы(ИмяКаталогДляРаспаковки, ПолучитьМаскуВсеФайлы(), Истина);
	
	РаспакованныеФайлы = Новый Массив;
	
	Для Каждого ИзвлеченныйФайл Из ИзвлеченныеФайлы Цикл
		РаспакованныйФайл = Новый Структура;
		РаспакованныйФайл.Вставить("Имя", ИзвлеченныйФайл.Имя);
		РаспакованныйФайл.Вставить("Хранение", ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИзвлеченныйФайл.ПолноеИмя)));
		
		РаспакованныеФайлы.Добавить(РаспакованныйФайл);
	КонецЦикла;
	
	Возврат РаспакованныеФайлы;
	
КонецФункции

Функция ПолучитьФайлССервераКакСтроку(Адрес) Экспорт
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Адрес);
		
	Если ТипЗнч(ДвоичныеДанныеФайла) = Тип("Строка") Тогда
		Возврат ДвоичныеДанныеФайла;
	ИначеЕсли ТипЗнч(ДвоичныеДанныеФайла) = Тип("ДвоичныеДанные") Тогда
		Возврат Base64Строка(ДвоичныеДанныеФайла);
	ИначеЕсли ТипЗнч(ДвоичныеДанныеФайла) = Тип("ХранилищеЗначения") Тогда
		Возврат Base64Строка(ДвоичныеДанныеФайла.Получить());
	КонецЕсли;
	
КонецФункции

Функция ПолучитьФайлЧастямиССервераКакСтроку(Адрес, РазмерЧасти = 5242880) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("СтрокаBase64", "");
	Результат.Вставить("РазмерФайла", 0);
	Результат.Вставить("Продолжение", Новый Массив);
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Адрес);
	
	ДанныеФайла = Неопределено;
	Если ТипЗнч(ДвоичныеДанныеФайла) = Тип("Строка") Тогда
		ДанныеФайла = Base64Значение(ДвоичныеДанныеФайла);
	ИначеЕсли ТипЗнч(ДвоичныеДанныеФайла) = Тип("ДвоичныеДанные") Тогда
		ДанныеФайла = ДвоичныеДанныеФайла;
	ИначеЕсли ТипЗнч(ДвоичныеДанныеФайла) = Тип("ХранилищеЗначения") Тогда
		ДанныеФайла = ДвоичныеДанныеФайла.Получить();
	Иначе
		ЗаписьЖурналаРегистрации("КриптографияЭДКОСлужебныйВызовСервера.ПолучитьФайлЧастямиССервераКакСтроку", УровеньЖурналаРегистрации.Ошибка,,
			"Тип = " + Строка(ТипЗнч(ДвоичныеДанныеФайла)), "Нет обработчика для типа данных во временном хранилище");
			
		Возврат Результат;
		
	КонецЕсли;	
	
	Результат.РазмерФайла = ДанныеФайла.Размер();
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ДанныеФайла.Записать(ИмяВременногоФайла);
	
	КаталогРезультата = КаталогВременныхФайлов() + СтрЗаменить(Новый УникальныйИдентификатор, "-", "") + ПолучитьРазделительПути();
	СоздатьКаталог(КаталогРезультата);
	
	ЧастиФайла = РазделитьФайл(ИмяВременногоФайла, РазмерЧасти, КаталогРезультата);
	
	АдресаЧастейФайла = Новый Массив;
	Для Каждого ЧастьФайла Из ЧастиФайла Цикл
		АдресаЧастейФайла.Добавить(ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ЧастьФайла), Новый УникальныйИдентификатор));
	КонецЦикла;
	
	УдалитьФайлы(КаталогРезультата);
	УдалитьФайлы(ИмяВременногоФайла);
	
	Результат.СтрокаBase64 = ПолучитьФайлССервераКакСтроку(АдресаЧастейФайла[0]);
	УдалитьИзВременногоХранилища(АдресаЧастейФайла[0]);                          
	АдресаЧастейФайла.Удалить(0);
	Результат.Продолжение = АдресаЧастейФайла;
	
	Возврат Результат;
	
КонецФункции

Процедура УдалитьДанныеИзВременногоХранилища(СписокАдресов) Экспорт
	
	Для Каждого Адрес Из СписокАдресов Цикл
		УдалитьИзВременногоХранилища(Адрес);		
	КонецЦикла;
	
КонецПроцедуры

Функция Base64ВоВременноеХранилище(СтрокаBase64, Адрес) Экспорт
	
	Возврат ПоместитьВоВременноеХранилище(Base64Значение(СтрокаBase64), Адрес);
	
КонецФункции

Функция ТекущаяДатаНаСервере() Экспорт

	Возврат ТекущаяДатаСеанса(); 

КонецФункции

Функция ДополнитьОписанияРазмерамиФайлов(ОписанияФайлов) Экспорт
	
	НовыеОписанияФайлов = Новый Массив;
	Для Каждого ОписаниеФайла Из ОписанияФайлов Цикл
		ОписаниеФайла.Вставить("Размер", ПолучитьИзВременногоХранилища(ОписаниеФайла.Адрес).Размер());
		Файл = Новый Файл(ОписаниеФайла.Имя);
		ОписаниеФайла.Вставить("Расширение", НРег(СтрЗаменить(Файл.Расширение, ".", "")));
		НовыеОписанияФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	Возврат НовыеОписанияФайлов;
	
КонецФункции

#КонецОбласти
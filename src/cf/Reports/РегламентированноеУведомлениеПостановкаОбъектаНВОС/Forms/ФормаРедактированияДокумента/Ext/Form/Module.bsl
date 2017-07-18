﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеЛицензии = Неопределено;
	Если Параметры.Свойство("ДанныеЛицензии", ДанныеЛицензии)
		И ТипЗнч(ДанныеЛицензии) = Тип("Структура") Тогда 
		
		ДанныеЛицензии.Свойство("ДатаВыдачи", ДатаВыдачи);
		ДанныеЛицензии.Свойство("ДатаНачалаДействия", ДатаНачалаДействия);
		ДанныеЛицензии.Свойство("ДатаОкончанияДействия", ДатаОкончанияДействия);
		ДанныеЛицензии.Свойство("НомерДокумента", НомерДокумента);
		ДанныеЛицензии.Свойство("Орган", Орган);
		ДанныеЛицензии.Свойство("ИмяФайла", ИмяФайла);
		ДанныеЛицензии.Свойство("АдресДД", АдресДД);
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда 
		Параметры.Свойство("ЗаголовокФормы", Заголовок);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяФайла) Тогда 
		Элементы.ЗначокУдалить.Видимость = Истина;
		Элементы.Добавить.Заголовок = ИмяФайла;
	Иначе 
		Элементы.ЗначокУдалить.Видимость = Ложь;
		Элементы.Добавить.Заголовок = "Добавить скан-копию";
		Если Не ЗначениеЗаполнено(АдресДД) Тогда 
			АдресДД = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("РедактируемыйУИД") Тогда 
		РедактируемыйУИД = Параметры.РедактируемыйУИД;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	АдресДД = ПоместитьВоВременноеХранилище(Неопределено, АдресДД);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ПараметрыЗакрытия = СформироватьРезультатДляЗакрытия();
	Закрыть(ПараметрыЗакрытия);
КонецПроцедуры

&НаКлиенте
Процедура ЗначокУдалитьНажатие(Элемент)
	АдресДД = ПоместитьВоВременноеХранилище(Неопределено, АдресДД);
	Элементы.ЗначокУдалить.Видимость = Ложь;
	Элементы.Добавить.Заголовок = "Добавить скан-копию";
	ИмяФайла = "";
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция СформироватьРезультатДляЗакрытия()
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("ДатаВыдачи", ДатаВыдачи);
	СтруктураРезультата.Вставить("ДатаНачалаДействия", ДатаНачалаДействия);
	СтруктураРезультата.Вставить("ДатаОкончанияДействия", ДатаОкончанияДействия);
	СтруктураРезультата.Вставить("НомерДокумента", НомерДокумента);
	СтруктураРезультата.Вставить("Орган", Орган);
	СтруктураРезультата.Вставить("ИмяФайла", ИмяФайла);
	СтруктураРезультата.Вставить("АдресДД", АдресДД);
	
	Результат = Новый Структура;
	Если ЗначениеЗаполнено(РедактируемыйУИД) Тогда
		Результат.Вставить("РедактируемыйУИД", РедактируемыйУИД);
		УИД = РедактируемыйУИД;
	Иначе
		УИД = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Результат.Вставить("УИД", УИД);
	Результат.Вставить("Адрес", ПоместитьВоВременноеХранилище(СтруктураРезультата, УИД));
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ДобавитьНажатие(Элемент)
	Если Не ЗначениеЗаполнено(ИмяФайла) Тогда 
		ДобавитьФайл();
	Иначе
		СохранитьНаДискФайл();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл()
	
	АдресФайла  = "";
	ВыбИмяФайла = "";
	
	Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
	
	Попытка
		НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлЗавершение(Результат, АдресФайла, ВыбИмяФайла, Парам) Экспорт
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	Каталог = "";
	СтрокаПоиска = ВыбИмяФайла;
	
	Пока СтрДлина(СтрокаПоиска) > 0 Цикл
		Если Прав(СтрокаПоиска, 1) = "\" ИЛИ Прав(СтрокаПоиска, 1) = "/" Тогда
			Каталог = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска));
			Прервать;
		Иначе
			СтрокаПоиска = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска) - 1);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ВыбИмяФайла, Каталог);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
	
	Элементы.ЗначокУдалить.Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ПолноеИмяФайла, Каталог)
	ИмяФайла     = СтрЗаменить(ПолноеИмяФайла, Каталог, "");
	ФайлЗагрузкиДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайла);
	АдресДД = ПоместитьВоВременноеХранилище(ФайлЗагрузкиДвоичныеДанные, АдресДД);
	Элементы.Добавить.Заголовок = ИмяФайла;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаДискФайл()
	Попытка
		Если Не ЗначениеЗаполнено(ИмяФайла) Тогда 
			Возврат;
		КонецЕсли;
		#Если ВебКлиент Тогда
			ПолучитьФайл(АдресДД, ИмяФайла, Истина);
		#Иначе
			ИмяВременногоФайла = КаталогВременныхФайлов() + ИмяФайла;
			ПолучитьФайл(АдресДД, ИмяВременногоФайла, Ложь);
			ЗапуститьПриложение(ИмяВременногоФайла);
		#КонецЕсли
	Исключение
		ШаблонСообщения = НСтр("ru = 'При выгрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
КонецПроцедуры
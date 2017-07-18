﻿#Область ПрограммныйИнтерфейс

Функция ПроверитьЛегальностьИспользования() Экспорт
	
	Возврат НовыйРезультатПроверки();
	
КонецФункции

Функция РегистрацииИзФайла(АдресВременногоХранилища) Экспорт
	
	Возврат Новый Массив;
	
КонецФункции

Функция ДоступностьРегистрацииВОрганизации() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Процедура РегистрацииИзВебСервиса(ПараметрыЗадания, АдресХранилища) Экспорт
	
	ПоместитьВоВременноеХранилище(НовыеДанныеРегистрации(), АдресХранилища);
	
КонецПроцедуры

Функция ВыполнитьРегистрациюОрганизации(СведенияОРегистрации, Налогообложение, Регистрация, Подпись) Экспорт
	
	
КонецФункции

Процедура ЗаписатьРегистрацию(СведенияОРегистрации, Регистрация, Подпись) Экспорт

КонецПроцедуры

Функция СведенияОРегистрации() Экспорт
	
	Возврат НовыеСведенияОРегистрации();
	
КонецФункции

Функция ДоступенСервисАктивации() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция РегистрационныеДанныеФорматированнойСтрокой(СведенияОРегистрации) Экспорт
	
	ДанныеРегистрации		 = СведенияОРегистрации.ДанныеРегистрации;
	РегистрационныеДанные	 = Новый Массив;
	ЭтоПерваяСтрока			 = Истина;
	ЖирныйШрифт 			 = Новый Шрифт(,, Истина);
	Если ДанныеРегистрации = Неопределено Тогда
		РегистрационныеДанные.Добавить(НСтр("ru = 'Не указаны данные регистрации'"));
		Возврат Новый ФорматированнаяСтрока(РегистрационныеДанные);
	КонецЕсли;
	
	Если ДанныеРегистрации.Свойство("Наименование") И ЗначениеЗаполнено(ДанныеРегистрации.Наименование) Тогда
		
		ТекстСтроки = ?(ЭтоПерваяСтрока, "", Символы.ПС) + ДанныеРегистрации.Наименование;
		РегистрационныеДанные.Добавить(Новый ФорматированнаяСтрока(ТекстСтроки, ЖирныйШрифт));
		ЭтоПерваяСтрока = Ложь;
		
	КонецЕсли;
	Если ДанныеРегистрации.Свойство("ИНН") И ЗначениеЗаполнено(ДанныеРегистрации.ИНН) Тогда
		
		РегистрационныеДанные.Добавить(?(ЭтоПерваяСтрока, "", Символы.ПС) + НСтр("ru = 'ИНН:'")+" ");
		РегистрационныеДанные.Добавить(Новый ФорматированнаяСтрока(ДанныеРегистрации.ИНН, ЖирныйШрифт));
		ЭтоПерваяСтрока = Ложь;
		
	КонецЕсли;
		
	Возврат Новый ФорматированнаяСтрока(РегистрационныеДанные);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйРезультатПроверки()
	
	РезультатПроверки = Новый Структура();
	РезультатПроверки.Вставить("ПроверкаПройдена", Ложь);
	РезультатПроверки.Вставить("Ошибка", "");
	РезультатПроверки.Вставить("ТекстОшибки", "");
	
	Возврат РезультатПроверки;
	
КонецФункции

Функция НовыеДанныеРегистрации()
	
	ДанныеРегистрации = Новый Структура();
	ДанныеРегистрации.Вставить("Регистрации", Новый Массив);
	ДанныеРегистрации.Вставить("Ошибка", "");
	ДанныеРегистрации.Вставить("КодОшибки", 0);
	
	Возврат ДанныеРегистрации;
	
КонецФункции

Функция НовыеСведенияОРегистрации()
	
	Регистрация = Новый Структура();
	Регистрация.Вставить("РегистрацияСуществует", Ложь);       // Признак того, что регистрация существует и содержит нужные данные
	Регистрация.Вставить("ПодписьРегистрацииВерна", Ложь);     // Признак того, что подпись регистрации верна
	Регистрация.Вставить("ДанныеРегистрации",   Неопределено); // Сведения из регистрации
	Возврат Регистрация;
	
КонецФункции

#КонецОбласти

﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Элементы.ИмяФайлаДанных.Видимость = Форма.ВозможностьВыбораФайлов;	
	
	Если Форма.ВозможностьВыбораФайлов Тогда
		ТекстПояснения = "Укажите путь к файлу, в который были выгружены данные о начисленной зарплате, и нажмите кнопку ""Загрузить данные""";
	Иначе
		ТекстПояснения = "По кнопке ""Загрузить данные"" укажите путь к файлу, в который были выгружены данные о начисленной зарплате";
	КонецЕсли;
	
	Элементы.ДекорацияПояснение.Заголовок = ТекстПояснения;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки)

	ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ОписаниеОшибки.Описание);

КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла)
	
	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресФайла);
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ДвоичныеДанныеФайла", ДвоичныеДанныеФайла);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ЗагрузкаДанныхИзЗиК.ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);		
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка данных из ЗиК'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Обработки.ЗагрузкаДанныхИзЗиК.ЗагрузитьДанныеВИБ", 
			ПараметрыВыгрузки, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьРезультат();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
					Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРезультат()
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(Результат) = Тип("Строка")
		И ЗначениеЗаполнено(Результат) Тогда 
		ТекстСообщения = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайлами() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	ВозможностьВыбораФайлов = РасширениеРаботыСФайламиПодключено;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ИмяФайлаДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайла(Элемент)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр                      = "Файл данных (*.xml)|*.xml";
	ДиалогВыбораФайла.Заголовок                   = "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр     = Ложь;
	ДиалогВыбораФайла.Расширение                  ="xml";
	ДиалогВыбораФайла.ИндексФильтра               = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла              = Элемент.ТекстРедактирования;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект);
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		Объект.ИмяФайлаДанных = ВыбранныеФайлы[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанные(Команда)
	
	ТекстСообщения = "";
	
	АдресФайла = Неопределено;
	
	ОчиститьСообщения();
	
	Если ВозможностьВыбораФайлов Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ИмяФайлаДанных) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Не указан файл данных для загрузки'"));
			Возврат;
		КонецЕсли;
		
		ПомещаемыеФайлы = Новый Массив;
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(Объект.ИмяФайлаДанных));
		
		ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ПомещениеФайловЗавершение", ЭтотОбъект);
		
		НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы, , Ложь);
		
	Иначе
		
		Попытка
			ПомещениеФайлаЗавершение = Новый ОписаниеОповещения("ПомещениеФайлаЗавершение", ЭтотОбъект);
			НачатьПомещениеФайла(ПомещениеФайлаЗавершение, АдресФайла, , Истина, УникальныйИдентификатор);
		Исключение
			ШаблонСообщения = НСтр("ru = 'При чтении файла возникла ошибка
			|%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ОписаниеОшибки = ИнформацияОбОшибке();
			ЗаписатьОшибкуВЖурнал(ТекстСообщения, ОписаниеОшибки);
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайловЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено
		И ПомещенныеФайлы.Количество() > 0 Тогда
		
		ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
		АдресФайла = ОписаниеФайлов.Хранение;
		ВыполнитьЗагрузкуДанных(АдресФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлаЗавершение(Результат, АдресФайлаПомещенный, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ВыполнитьЗагрузкуДанных(АдресФайлаПомещенный);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуДанных(АдресФайла)
	
	Если АдресФайла = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Не удалось получить данные для загрузки'"));
		Возврат;
	КонецЕсли;
	
	Результат = ВыполнитьЗагрузкуДанныхНаСервере(АдресФайла);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ПодключениеРасширенияРаботыСФайлами", 0.1, Истина);
	#Иначе
		ЭтаФорма.ВозможностьВыбораФайлов = Истина;
		УправлениеФормой(ЭтотОбъект);
	#КонецЕсли
	
КонецПроцедуры


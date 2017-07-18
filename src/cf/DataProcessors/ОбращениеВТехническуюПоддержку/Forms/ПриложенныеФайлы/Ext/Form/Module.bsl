﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресХранилища                   = Параметры.АдресХранилища;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификаторВладельца;
	ТаблицаВложений                  = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Объект.Вложения.Загрузить(ТаблицаВложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложитьФайлы(Команда)
	
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища", АдресХранилищаВложений(Объект.Вложения, АдресХранилища));
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	НаименованиеВложения = Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя];
	
	Для Каждого Вложение Из Объект.Вложения Цикл
		Если Вложение.Представление = НаименованиеВложения Тогда
			Объект.Вложения.Удалить(Вложение);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		ДополнительныеПараметры = Новый Структура("Имя", ПараметрыПеретаскивания.Значение.Имя);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияПеретаскиваниеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайла(ОписаниеОповещения, , ПараметрыПеретаскивания.Значение.ПолноеИмя, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскиваниеЗавершение(Результат, АдресВременногоХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Файлы = Новый Массив;
	ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.Имя, АдресВременногоХранилища);
	Файлы.Добавить(ПередаваемыйФайл);
	ДобавитьФайлыВСписок(Файлы);
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДобавитьФайлВоВложения()
	
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Открытие);
	ПараметрыДиалога.Вставить("МножественныйВыбор", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);
	СтандартныеПодсистемыКлиент.ПоказатьПомещениеФайла(ОписаниеОповещения, УникальныйИдентификаторВладельца, "", ПараметрыДиалога);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы = Неопределено ИЛИ ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьФайлыВСписок(ПомещенныеФайлы);
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписок(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ОписаниеФайла.Имя);
		Вложение = Объект.Вложения.Добавить();
		Вложение.Представление             = СтруктураИмениФайла.Имя;
		Вложение.АдресВоВременномХранилище = ОписаниеФайла.Хранение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеВложений()
	
	ПредставлениеВложений.Очистить();
	
	Индекс = 0;
	
	Для Каждого Вложение Из Объект.Вложения Цикл
		Если Индекс = 0 Тогда
			СтрокаПредставления = ПредставлениеВложений.Добавить();
		КонецЕсли;
		
		СтрокаПредставления["Вложение" + Строка(Индекс + 1)] = Вложение.Представление;
		
		Индекс = Индекс + 1;
		Если Индекс = 2 Тогда 
			Индекс = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложитьФайлЗавершение(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВыбранныйФайл Из ВыбранныеФайлы Цикл
		НоваяСтрока = Объект.Вложения.Добавить();
		СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ВыбранныйФайл);
		НоваяСтрока.Представление = СтруктураИмениФайла.ИмяБезРасширения;
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложение()
	
	ВыбранноеВложение = ВыбранноеВложение();
	Если ВыбранноеВложение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ПолучитьФайл(ВыбранноеВложение.АдресВоВременномХранилище, ВыбранноеВложение.Представление, Истина);
	#Иначе
		ДополнительныеПараметры = Новый Структура("ВыбранноеВложение", ВыбранноеВложение);
		ОписаниеОповещения = 
			Новый ОписаниеОповещения("ОткрытьВложениеСозданиеКаталогаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьСозданиеКаталога(ОписаниеОповещения, ПолучитьИмяВременногоФайла());
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеСозданиеКаталогаЗавершение(ИмяВременнойПапки, ДополнительныеПараметры) Экспорт
	
	Если ИмяВременнойПапки = "" Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеВложение = ДополнительныеПараметры.ВыбранноеВложение;
	ИмяВременногоФайла = 
		ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ВыбранноеВложение.Представление;
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВыбранноеВложение.АдресВоВременномХранилище);
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ДополнительныеПараметры.Вставить("ИмяВременнойПапки", ИмяВременнойПапки);
	ДополнительныеПараметры.Вставить("ИмяВременногоФайла", ИмяВременногоФайла);
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ОткрытьВложениеУстановкаТолькоЧтениеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл(ИмяВременногоФайла);
	Файл.НачатьУстановкуТолькоЧтения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеУстановкаТолькоЧтениеЗавершение(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьВложениеЗапускПриложенияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьЗапускПриложения(ОписаниеОповещения, ДополнительныеПараметры.ИмяВременногоФайла,,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВложениеЗапускПриложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Файл = Новый Файл(ДополнительныеПараметры.ИмяВременногоФайла);
	Файл.НачатьУстановкуТолькоЧтения(,Ложь);
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранноеВложение()
	
	Результат = Неопределено;
	Если Элементы.Вложения.ТекущиеДанные <> Неопределено Тогда
		НаименованиеВложения = Элементы.Вложения.ТекущиеДанные[Элементы.Вложения.ТекущийЭлемент.Имя];
		Для Каждого Вложение Из Объект.Вложения Цикл
			Если Вложение.Представление = НаименованиеВложения Тогда
				Результат = Вложение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция АдресХранилищаВложений(Знач Вложения, АдресХранилища)

	Возврат ПоместитьВоВременноеХранилище(Вложения.Выгрузить(), АдресХранилища);

КонецФункции

#КонецОбласти
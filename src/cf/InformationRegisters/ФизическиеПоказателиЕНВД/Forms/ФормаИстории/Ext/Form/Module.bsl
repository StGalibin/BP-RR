﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборНабораЗаписей = Параметры.Отбор;
	
	Организация = ОтборНабораЗаписей.Организация;
	ВидДеятельности = ОтборНабораЗаписей.ВидДеятельности;
	
	Если Не ЗначениеЗаполнено(ВидДеятельности) Или Не ЗначениеЗаполнено(Организация) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НаборЗаписей.Количество() > 0 Тогда
		НаборЗаписей.Сортировать("Период");
		ИдентификаторПоследнейЗаписи = НаборЗаписей[НаборЗаписей.Количество() - 1].ПолучитьИдентификатор();
		Элементы.НаборЗаписей.ТекущаяСтрока = ИдентификаторПоследнейЗаписи;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ФизическиеПоказателиЕНВД) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		ПоследняяЗапись = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторПоследнейЗаписи);
		Если ПоследняяЗапись <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПоследняяЗапись);
			ТекущиеДанные.Период = ДобавитьМесяц(ТекущиеДанные.Период, 1); // Следующий месяц
		Иначе
			ТекущиеДанные.Период = НачалоГода(ТекущаяДата());
			ТекущиеДанные.Организация = Организация;
			ТекущиеДанные.ВидДеятельности = ВидДеятельности;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	НаборЗаписей.Сортировать("Период");
	
	Если НаборЗаписей.Количество() > 0 Тогда
		ИдентификаторПоследнейЗаписи = НаборЗаписей[НаборЗаписей.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
	
	Элементы.НаборЗаписей.ТекущаяСтрока = ТекущиеДанные.ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПослеУдаления(Элемент)
	
	Если НаборЗаписей.Количество() > 0 Тогда
		ИдентификаторПоследнейЗаписи = НаборЗаписей[НаборЗаписей.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
﻿#Область ПрограммныйИнтерфейс

Функция ПолучитьТаблицуРегистрацийВНалоговомОрганеСНезаполеннымКодомПоОКТМО(ТолькоПроверитьНаличие = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяСтрока", "");
	Запрос.Текст =
    "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
    |	РегистрацииВНалоговомОргане.Владелец КАК Организация,
    |	РегистрацииВНалоговомОргане.Ссылка КАК РегистрацияВНалоговомОргане,
    |	РегистрацииВНалоговомОргане.КодПоОКАТО КАК КодПоОКАТО,
    |	РегистрацииВНалоговомОргане.КодПоОКТМО КАК КодПоОКТМО
    |ИЗ
    |	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
    |ГДЕ
    |	РегистрацииВНалоговомОргане.ПометкаУдаления = ЛОЖЬ
    |	И РегистрацииВНалоговомОргане.Владелец.ПометкаУдаления = ЛОЖЬ
    |	И РегистрацииВНалоговомОргане.КодПоОКАТО <> &ПустаяСтрока
    |	И РегистрацииВНалоговомОргане.КодПоОКТМО = &ПустаяСтрока
    |
    |УПОРЯДОЧИТЬ ПО
    |	Организация,
    |	РегистрацияВНалоговомОргане";

	Если Не ТолькоПроверитьНаличие Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1", "");
	КонецЕсли;

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

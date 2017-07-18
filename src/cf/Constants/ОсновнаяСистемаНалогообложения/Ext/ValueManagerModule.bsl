﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Значение = Перечисления.СистемыНалогообложения.ОсобыйПорядок Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Если Константы.ОсновнойВидОрганизации.Получить() = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо Тогда
			Константы.ОсновнойВидОрганизации.Установить(Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецЕсли

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецЕсли

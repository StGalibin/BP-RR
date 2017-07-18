﻿#Область ОбработчкиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ТарификацияБПВызовСервераПовтИсп.РазрешенУчетРегулярнойДеятельности() Тогда
		Элементы.ДекорацияНастройкиСинхронизацииДанных.Видимость = Ложь;
		Элементы.ДекорацияОбменЭлектроннымиДокументами.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчкиСобытийЭлементовФормы

&НаКлиенте
Процедура ДекорацияПоддержкаИОбслуживаниеНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.ПоддержкаИОбслуживание");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбщиеНастройкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.ОбщиеНастройки");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнтерфейсНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.Интерфейс");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПараметрыУчетаНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ПараметрыУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПроведениеДокументовНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.ПроведениеДокументов");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиПользователейИПравНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.НастройкиПользователейИПрав");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОрганайзерНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.Органайзер");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиРаботыСФайламиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.НастройкиРаботыСФайлами");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиСинхронизацииДанныхНажатие(Элемент)
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ДоступноИспользованиеРазделенныхДанных Тогда
		ИмяОткрываемойФормы = "Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанных";
	Иначе
		ИмяОткрываемойФормы = "Обработка.ПанельАдминистрированияБСПВМоделиСервиса.Форма.СинхронизацияДанныхДляАдминистратораСервиса";
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПечатныеФормыОтчетыОбработкиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.ПечатныеФормыОтчетыИОбработки");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиРегистровУчетаНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБП.Форма.НастройкиРегистровУчета");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкаКолонтитуловНажатие(Элемент)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаКолонтитулов");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОбменЭлектроннымиДокументамиНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияЭДО.Форма.ОбменЭлектроннымиДокументами");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключаемоеОборудованиеНажатие(Элемент)
	
	ПараметрКоманды = Новый Структура;
	
	ПараметрыВыполненияКоманды = Новый Структура;
	ПараметрыВыполненияКоманды.Вставить("Источник", ЭтотОбъект);
	ПараметрыВыполненияКоманды.Вставить("Уникальность", Истина);
	ПараметрыВыполненияКоманды.Вставить("Окно", Окно);
	
	МенеджерОборудованияКлиент.ОткрытьПодключаемоеОборудование(ПараметрКоманды, ПараметрыВыполненияКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИнтернетПоддержкаПользователейНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияБИП.Форма.ИнтернетПоддержкаПользователей");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПерсональныеНастройкиНажатие(Элемент)
	
	ОткрытьФорму("ОбщаяФорма.ПерсональныеНастройки");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВыгрузитьДанныеВЛокальнуюВерсиюНажатие(Элемент)
	
	ОткрытьФорму("ОбщаяФорма.ВыгрузкаДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияУдалениеПомеченныхОбъектовНажатие(Элемент)
	
	ОткрытьФорму("Обработка.УдалениеПомеченныхОбъектов.Форма");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗагрузкаИз1СПредприятия77Нажатие(Элемент)
	
	ПараметрыСоединения = СтроковыеФункцииКлиентСервер.ПолучитьПараметрыИзСтроки(СтрокаСоединенияИнформационнойБазы());
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если ЗначениеЗаполнено(СистемнаяИнфо.ИнформацияПрограммыПросмотра)
		ИЛИ НЕ ПараметрыСоединения.Свойство("File") Тогда
		// веб-клиент или сервер
		ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма.ФормаЗагрузкаИзФайла");
	Иначе
		// локальный режим
		ОткрытьФорму("Обработка.ПереносДанныхИзИнформационныхБаз1СПредприятия77.Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкаОбменаСИнтернетМагазиномНажатие(Элемент)
	
	ОткрытьФорму("Обработка.ОбменСИнтернетМагазином.Форма.ФормаНастройки");
	
КонецПроцедуры

#КонецОбласти
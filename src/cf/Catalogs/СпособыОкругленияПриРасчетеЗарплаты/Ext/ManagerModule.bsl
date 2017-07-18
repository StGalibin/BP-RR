﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПоУмолчанию() Экспорт
	
	ОписаниеСпособаБезОкругления = ОписаниеСпособаБезОкругления();
	
	Возврат СпособОкругленияПоОписанию(ОписаниеСпособаБезОкругления, Истина);
	
КонецФункции	

Функция СпособОкругленияДоРубляВБольшуюСторону() Экспорт
	
	ОписаниеСпособаДоРубляВБольшуюСторону = ОписаниеСпособаДоРубляВБольшуюСторону();
	
	Возврат СпособОкругленияПоОписанию(ОписаниеСпособаДоРубляВБольшуюСторону);
	
КонецФункции	

Функция ОписаниеСпособаОкругления(СпособОкругления) Экспорт
	СпособыОкругления = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СпособОкругления);
	ОписаниеСпособовОкругления = ОписаниеСпособовОкругления(СпособыОкругления);
	Возврат ОписаниеСпособовОкругления.Получить(СпособОкругления);
КонецФункции

Функция ОписаниеСпособовОкругления(СпособыОкругления) Экспорт
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъектов(СпособыОкругления, ПоляСтруктурыОписанияСпособаОкругления());
КонецФункции	

//////////////////////////////////////////////////////////////////
/// Первоначальное заполнение и обновление информационной базы.

Процедура НачальноеЗаполнение() Экспорт

	СоздаватьНесуществующийЭлемент = Истина;
	
	СпособОкругленияПоОписанию(ОписаниеСпособаБезОкругления(), 			СоздаватьНесуществующийЭлемент);
	СпособОкругленияПоОписанию(ОписаниеСпособаДоРубляВБольшуюСторону(), СоздаватьНесуществующийЭлемент);
	СпособОкругленияПоОписанию(ОписаниеСпособаДоРубля(), 				СоздаватьНесуществующийЭлемент);	
	СпособОкругленияПоОписанию(ОписаниеСпособаДоДесятиРублей(), 		СоздаватьНесуществующийЭлемент);
	СпособОкругленияПоОписанию(ОписаниеСпособаДоСтаРублей(), 			СоздаватьНесуществующийЭлемент);
	
КонецПроцедуры

Процедура ЗаполнитьПравилаОкругленияСпособовОкругления() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыОкругления.Ссылка
	|ИЗ
	|	Справочник.СпособыОкругленияПриРасчетеЗарплаты КАК СпособыОкругления
	|ГДЕ
	|	СпособыОкругления.ПравилоОкругления = &ПустоеПравилоОкругления";
	
	Запрос.УстановитьПараметр("ПустоеПравилоОкругления", Перечисления.ПравилаОкругленияПриРасчетеЗарплаты.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СпособОкругления = Выборка.Ссылка.ПолучитьОбъект();
		СпособОкругления.ПравилоОкругления = Перечисления.ПравилаОкругленияПриРасчетеЗарплаты.Авто;
		СпособОкругления.ОбменДанными.Загрузка = Истина;
		СпособОкругления.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьСпособОкругленияДоРубляВБольшуюСторону() Экспорт
	ОписаниеСпособаДоРубляВБольшуюСторону = ОписаниеСпособаДоРубляВБольшуюСторону();
	СпособОкругленияПоОписанию(ОписаниеСпособаДоРубляВБольшуюСторону, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПустоеОписаниеСпособаОкругления()
	
	ПоляСтруктуры = ПоляСтруктурыОписанияСпособаОкругления();
	
	ПустоеОписание = Новый Структура(ПоляСтруктуры);
	
	ПустоеОписание.Наименование 		= "";
	ПустоеОписание.Точность 			= 0.01;
	ПустоеОписание.ПравилоОкругления 	= Перечисления.ПравилаОкругленияПриРасчетеЗарплаты.Авто;
	
	Возврат ПустоеОписание;
	
КонецФункции

Функция ПоляСтруктурыОписанияСпособаОкругления()
	Возврат "Наименование, Точность, ПравилоОкругления";
КонецФункции

Функция СпособОкругленияПоОписанию(ОписаниеСпособаОкругления, СоздаватьЕслиНеНайден = Ложь)
	
	СпособОкругления = СпособОкругленияПоПараметрам(ОписаниеСпособаОкругления.ПравилоОкругления, ОписаниеСпособаОкругления.Точность);
	
	Если СпособОкругления = Неопределено 
		И СоздаватьЕслиНеНайден Тогда
		СпособОкругления = НовыйСпособОкругленияПоОписанию(ОписаниеСпособаОкругления)
	КонецЕсли;	
	
	Возврат СпособОкругления;
	
КонецФункции

Функция СпособОкругленияПоПараметрам(ПравилоОкругления, Точность)
	
	СпособОкругления = Неопределено;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпособыОкругленияПриРасчетеЗарплаты.Ссылка
	|ИЗ
	|	Справочник.СпособыОкругленияПриРасчетеЗарплаты КАК СпособыОкругленияПриРасчетеЗарплаты
	|ГДЕ
	|	СпособыОкругленияПриРасчетеЗарплаты.ПравилоОкругления = &ПравилоОкругления
	|	И СпособыОкругленияПриРасчетеЗарплаты.Точность = &Точность";
	
	Запрос.УстановитьПараметр("ПравилоОкругления", ПравилоОкругления);
	Запрос.УстановитьПараметр("Точность", Точность);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Выборка.Следующий();
		
		СпособОкругления = Выборка.Ссылка;
	
	КонецЕсли; 
	
	Возврат СпособОкругления
	
КонецФункции

Функция НовыйСпособОкругленияПоОписанию(ОписаниеСпособаОкругления)
	
	НовыйЭлемент = СоздатьЭлемент();
	
	НовыйЭлемент.Наименование 		= НаименованиеНовогоСпособаОкругления(ОписаниеСпособаОкругления);
	НовыйЭлемент.Точность 			= ОписаниеСпособаОкругления.Точность;
	НовыйЭлемент.ПравилоОкругления 	= ОписаниеСпособаОкругления.ПравилоОкругления;
	
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;	
	
КонецФункции 

Функция НаименованиеНовогоСпособаОкругления(ОписаниеСпособаОкругления)
	
	НаименованиеНового = ОписаниеСпособаОкругления.Наименование;
	
	Если НЕ ЗначениеЗаполнено(НаименованиеНового) Тогда
		НаименованиеНового = "%1 (%2)"; 
	    НаименованиеНового = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НаименованиеНового, ОписаниеСпособаОкругления.ПравилоОкругления, ОписаниеСпособаОкругления.Точность); 
	КонецЕсли;
	
	Возврат НаименованиеНового;	
	
КонецФункции 

#КонецОбласти

#Область ОписанияСпособовОкругления

Функция ОписаниеСпособаБезОкругления()
	
	ОписаниеСпособа = ПустоеОписаниеСпособаОкругления();
	
	ОписаниеСпособа.Наименование = НСтр("ru = 'Без округления'");
	
	Возврат ОписаниеСпособа;
	
КонецФункции

Функция ОписаниеСпособаДоРубляВБольшуюСторону()
	
	ОписаниеСпособа = ПустоеОписаниеСпособаОкругления();
	
	ОписаниеСпособа.Наименование 		= НСтр("ru = 'Округление до рубля в большую сторону'");
	ОписаниеСпособа.Точность 			= 1;
	ОписаниеСпособа.ПравилоОкругления 	= Перечисления.ПравилаОкругленияПриРасчетеЗарплаты.ВБольшуюСторону;
	
	Возврат ОписаниеСпособа;
	
КонецФункции

Функция ОписаниеСпособаДоРубля()
	
	ОписаниеСпособа = ПустоеОписаниеСпособаОкругления();
	
	ОписаниеСпособа.Наименование 		= НСтр("ru = 'Округление до рубля'");
	ОписаниеСпособа.Точность 			= 1;
	
	Возврат ОписаниеСпособа;
	
КонецФункции

Функция ОписаниеСпособаДоДесятиРублей()
	
	ОписаниеСпособа = ПустоеОписаниеСпособаОкругления();
	
	ОписаниеСпособа.Наименование 		= НСтр("ru = 'Округление до десяти рублей'");
	ОписаниеСпособа.Точность 			= 10;
	
	Возврат ОписаниеСпособа;
	
КонецФункции

Функция ОписаниеСпособаДоСтаРублей()
	
	ОписаниеСпособа = ПустоеОписаниеСпособаОкругления();
	
	ОписаниеСпособа.Наименование 		= НСтр("ru = 'Округление до ста рублей'");
	ОписаниеСпособа.Точность 			= 100;
	
	Возврат ОписаниеСпособа;
	
КонецФункции
	
#КонецОбласти 

#КонецЕсли
﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц) Экспорт
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц);
	
КонецПроцедуры

Функция КатегорииНачисленийПособийПоПрямымВыплатамФСС() Экспорт
		
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.КатегорииНачисленийПособийПоПрямымВыплатамФСС();	
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Организация, Ссылка, ОплатаДнейУходаЗаДетьмиИнвалидами = Неопределено) Экспорт
	 Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Организация, Ссылка, ОплатаДнейУходаЗаДетьмиИнвалидами);
КонецФункции 

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов();
	
КонецФункции 

Функция ИспользуетсяЗаполнениеДокументаЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ИспользуетсяЗаполнениеДокументаЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов();
	
КонецФункции 

#КонецОбласти

#Область ЗаявлениеВФССОВозмещенииРасходовНаПогребение

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииРасходовНаПогребение(Организация, Ссылка, ЕдиновременноеПособие = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ДанныеЗаполненияЗаявленияВФССОВозмещенииРасходовНаПогребение(Организация, Ссылка, ЕдиновременноеПособие);
	
КонецФункции 

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение();
	
КонецФункции 

Функция ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение();
	
КонецФункции 

#КонецОбласти

#Область ЗаявлениеСотрудникаНаВыплатуПособия
	
Функция ЗаполнитьЗаявлениеСотрудникаНаВыплатуПособияПоОснованию(Объект) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ЗаполнитьЗаявлениеСотрудникаНаВыплатуПособияПоОснованию(Объект);
	
КонецФункции 

Функция РайонныйКоэффициентРФПодразделенияОрганизацииДляЗаявленияСотрудникаНаВыплатуПособия(Организация, Подразделение = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.РайонныйКоэффициентРФПодразделенияОрганизацииДляЗаявленияСотрудникаНаВыплатуПособия(Организация, Подразделение);
	
КонецФункции

Функция ТипДокументаОснованияЗаявленияСотрудникаНаВыплатуПособия(ВидПособия) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ТипДокументаОснованияЗаявленияСотрудникаНаВыплатуПособия(ВидПособия);
	
КонецФункции

Функция СписокДетейПоУходуЗаКоторымиПредоставленОтпуск(ДокументОснование) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.СписокДетейПоУходуЗаКоторымиПредоставленОтпуск(ДокументОснование);
	
КонецФункции

Функция ВидПособияИмеетДокументОснование(ВидПособия) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ВидПособияИмеетДокументОснование(ВидПособия);
	
КонецФункции

Функция ДоляРабочегоВремениСотрудника(Сотрудник, Дата) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ДоляРабочегоВремениСотрудника(Сотрудник, Дата);
	
КонецФункции

Процедура ДобавитьКомандыПечатиЗаявленияСотрудникаНаВыплатуПособия(КомандыПечати) Экспорт 

	ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ДобавитьКомандыПечатиЗаявленияСотрудникаНаВыплатуПособия(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#Область РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий
	
Функция СведенияБольничныхЛистовНеобходимыеДляНазначенияИВыплатыПособий(Объект, Заявление = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.СведенияБольничныхЛистовНеобходимыеДляНазначенияИВыплатыПособий(Объект, Заявление);
	
КонецФункции

Функция СведенияОтпусковПоУходуНеобходимыеДляНазначенияИВыплатыПособий(Объект, Заявление = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.СведенияОтпусковПоУходуНеобходимыеДляНазначенияИВыплатыПособий(Объект, Заявление);
	
КонецФункции

Функция ОписаниеФиксацииРеквизитовРеестраСведенийНеобходимыхДляНазначенияИВыплатыПособий() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияБазовый.ОписаниеФиксацииРеквизитовРеестраСведенийНеобходимыхДляНазначенияИВыплатыПособий();
	
КонецФункции 

#КонецОбласти

#КонецОбласти

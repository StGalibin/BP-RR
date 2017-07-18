﻿

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	УчетНачисленнойЗарплатыВызовСервера.ВидыОперацийПоЗарплатеОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры
	
#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Формируется массив видов операций по зарплате с учетом отбора по группе операций.
// При добавлении вида операций, его нужно упомянуть в одной из групп.
//
Функция ВидыОперацийПоГруппам(ГруппаОпераций) Экспорт
	
	ИмяОпции = "РаботаВБюджетномУчреждении";
	ФункциональнаяОпцияИспользуется = (Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
	
	// Формируем массив групп операций, по которым осуществляется отбор.
	ГруппыОпераций = Новый Массив;
	Если ТипЗнч(ГруппаОпераций) = Тип("ФиксированныйМассив") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГруппыОпераций, ГруппаОпераций);
	Иначе
		ГруппыОпераций.Добавить(ГруппаОпераций);
	КонецЕсли;
	
	ВидыОпераций = Новый Массив;
	
	Если ГруппыОпераций.Найти("Начисления") <> Неопределено Тогда
		// Начисления
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоСдельноДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НатуральныйДоход);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЗаЗадержкуЗарплаты);  
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпуск);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательства);
		Если НЕ ФункциональнаяОпцияИспользуется ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
			ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
			ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускРезервы);
		КонецЕсли;
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпускаОценочныеОбязательства);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпуска);
		
		// Договоры подряда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоговорАвторскогоЗаказа);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоговорРаботыУслуги);
		// Пособия
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюРаботодатель);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФСС);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПособиеНаПогребение);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.РасходыПоСтрахованиюФССНС);
		// Прочее
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВыплатыБывшимСотрудникам);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Дивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДивидендыСотрудников);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеРасчетыСПерсоналом);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.МатериальнаяПомощь);
	КонецЕсли;
	
	Если ГруппыОпераций.Найти("Дивиденды") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Дивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДивидендыСотрудников);
	КонецЕсли;
	
	// Депонирование
	Если ГруппыОпераций.Найти("Депонирование") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Депонирование);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.СписаниеДепонента);
	КонецЕсли;
	
	Если ГруппыОпераций.Найти("ЕжегодныеОтпускаОценочныеОбязательстваИРезервы") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательства);
		Если НЕ ФункциональнаяОпцияИспользуется ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
			ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускОценочныеОбязательстваИРезервы);
			ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ЕжегодныйОтпускРезервы);
		КонецЕсли;
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.КомпенсацияЕжегодногоОтпускаОценочныеОбязательства);
	КонецЕсли;
	
	// Взносы
	Если ГруппыОпераций.Найти("Взносы") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРДополнительныйТарифЛЭ);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРДополнительныйТарифШахтеры);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахБезСпецОценки);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахБезСпецОценки);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахСпецОценка);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахСпецОценка);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРНакопительнаяЧасть);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРПоСуммарномуТарифу);  
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРСПревышения);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРДоПредельнойВеличины);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПФРСтраховаяЧасть);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ТФОМС);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ФСС);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ФССНС);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ФФОМС);
	КонецЕсли;
	
	// НДФЛ
	Если ГруппыОпераций.Найти("НДФЛ") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛ);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛДоначисленныйПоРезультатамПроверки);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛДоходыКонтрагентов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛПередачаЗадолженностиВНалоговыйОрган);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛПрочиеРасчетыСПерсоналом);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НДФЛРасчетыСБывшимиСотрудниками);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НФДЛДивиденды);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НФДЛДивидендыСотрудникам);
	КонецЕсли;
	
	// Удержания
	Если ГруппыОпераций.Найти("Удержания") <> Неопределено Тогда
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛисты);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВозмещениеУщерба);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгента);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДобровольныеВзносыВНПФ);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ДСВ);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.Профвзносы);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПрочиеУдержания);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеЗаОтпуск);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.УдержаниеПоПрочимОперациямСРаботниками);
		// Займы
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.НачисленоПроцентовПоЗайму);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму);
		// удержания с доходов контрагентов
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.АлиментыПрочиеИсполнительныеЛистыКонтрагенты);
		ВидыОпераций.Добавить(Перечисления.ВидыОперацийПоЗарплате.ВознаграждениеПлатежногоАгентаКонтрагенты);
	КонецЕсли;
	
	Возврат ВидыОпераций;
	
КонецФункции

#КонецОбласти

#КонецЕсли
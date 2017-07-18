﻿
Функция SendData(УзелОбменаКод, УзелОбменаИмя, ДанныеМобильногоПриложения, СообщениеОбОшибке)
	
	Возврат МобильнаяБухгалтерия.ЗагрузитьДанныеМобильногоПриложения(УзелОбменаКод, УзелОбменаИмя, ДанныеМобильногоПриложения, СообщениеОбОшибке);
	
КонецФункции

Функция GetData(УзелОбменаКод, УзелОбменаИмя, СообщениеОбОшибке)
	
	Возврат МобильнаяБухгалтерия.ВыгрузитьДанныеВМобильноеПриложение(УзелОбменаКод, УзелОбменаИмя, СообщениеОбОшибке);
	
КонецФункции

Функция ConfirmGettingFile(УзелОбменаКод, НомерСообщения, СообщениеОбОшибке)
	
	УзелОбмена = ПланыОбмена.МобильнаяБухгалтерия.НайтиПоКоду(УзелОбменаКод);
	ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, НомерСообщения);
	
КонецФункции

Функция GetCityDetails(CityID)
	
	Возврат МобильнаяБухгалтерия.СписокРеквизитовНаселенныйПункт(CityID);
КонецФункции

Функция GetAdressID(ХранилищеПараметров)
	ЧастиАдреса = ХранилищеПараметров.Получить();
	
	Возврат МобильнаяБухгалтерия.УстановитьИдентификаторыНаселенногоПункта(ЧастиАдреса);
КонецФункции

Функция CheckAdress(Adress)
	
	Возврат МобильнаяБухгалтерия.РезультатПроверкиАдресовПоКлассификатору(Adress);
КонецФункции

Функция AutocomleteLocation(Text, ParentID, ХранилищеПараметров)
	Параметры = ХранилищеПараметров.Получить();
	
	Возврат МобильнаяБухгалтерия.ВариантыАвтоподбора(Text, ParentID, Параметры);
КонецФункции

Функция GetHouseList(Text, ParentID)
	
	Возврат МобильнаяБухгалтерия.СписокДомов(Text, ParentID);
КонецФункции

Функция GetRequisitesByINN(INN, ErrorMessage)
	
	Возврат МобильнаяБухгалтерия.ДанныеЕдиныхГосРеестровПоИНН(INN, ErrorMessage);
КонецФункции

Функция SendDeclarationToEmail(ID, ErrorMessage)
	Возврат МобильнаяБухгалтерия.ОтправитьДекларациюНаEmail(ID, ErrorMessage);
КонецФункции



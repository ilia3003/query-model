Перем СхемаЗапроса Экспорт;
Перем ЗапросПакета Экспорт;
Перем ВложенныйЗапрос Экспорт;
Перем ОператорВыбрать Экспорт;
Перем Источник Экспорт;
Перем ИсточникСлева Экспорт;
Перем ИсточникСправа Экспорт;
Перем Поле Экспорт;
Перем Соединение Экспорт;
Перем ТипСоединения Экспорт;
Перем КонтрольнаяТочка Экспорт;
Перем СтруктураЗапроса Экспорт;
Перем МенеджерВременныхТаблиц Экспорт;
Перем Параметры Экспорт;
Перем РезультатПакета Экспорт;
Перем Запрос Экспорт;

Перем Стек Экспорт;

#Область ОбщегоНазначения

//  Возвращаемое значение: КолонкиВременнойТаблицыЗапроса(Имя, ТипЗначения) | ДоступноеПолеСхемыЗапроса(Имя, ТипЗначения)
Функция ДоступныеПоля(ИмяТаблицы)
	ВременныеТаблицы = ЗапросПакета.ДоступныеТаблицы.Найти("Временные таблицы");
	Если ВременныеТаблицы <> Неопределено Тогда
		ИсточникТаблицы = ВременныеТаблицы.Состав.Найти(ИмяТаблицы);
		Если ИсточникТаблицы <> Неопределено Тогда
			Возврат ИсточникТаблицы.Поля;
		КонецЕсли;
	КонецЕсли;
	ИсточникТаблицы = МенеджерВременныхТаблиц.Таблицы.Найти(ИмяТаблицы);
	Если ИсточникТаблицы <> Неопределено Тогда
		Возврат ИсточникТаблицы.Колонки;
	КонецЕсли;
	Возврат Новый Массив;
КонецФункции

Функция ПоляТаблицы(ИмяТаблицы)
	Поля = Новый Массив;
	Для Каждого ДоступноеПоле Из ДоступныеПоля(ИмяТаблицы) Цикл
		Поля.Добавить(ДоступноеПоле.Имя);
	КонецЦикла;
	Возврат Поля;
КонецФункции

Функция ВыражениеВхождения(ИмяТаблицы, Поля = "*") Экспорт
	Если Поля = "*" Тогда
		Поля = ПоляТаблицы(ИмяТаблицы);
		ПоляСлева = Поля; 
		ПоляСправа = Поля;
	Иначе
		ПоляСлева = Новый Массив;
		ПоляСправа = Новый Массив;
		Для Каждого Связь Из ОбщийКлиентСервер.Массив(Поля) Цикл
			Состав = СтрРазделить(Связь, "=", Ложь);
			Если Состав.Количество() = 1 Тогда
				ПоляСлева.Добавить(Связь);
				ПоляСправа.Добавить(ИмяТаблицы + "." +Связь);
				Продолжить;
			КонецЕсли;
			ПоляСлева.Добавить(Состав[0]);
			ПолеСправа = Состав[1];
			Если СтрНачинаетсяС(ПолеСправа, "&") Тогда
				ПоляСправа.Добавить(Состав[1]);
				Продолжить;
			КонецЕсли;
			ПоляСправа.Добавить(ИмяТаблицы + "." + ПолеСправа);
		КонецЦикла;
	КонецЕсли;
	Возврат СтрШаблон("(%1) В (ВЫБРАТЬ РАЗЛИЧНЫЕ %2 ИЗ %3 КАК %3)", СтрСоединить(ПоляСлева, ", "), СтрСоединить(ПоляСправа, ", "), ИмяТаблицы);
КонецФункции

#КонецОбласти

#Область Состояние

Функция СостояниеПоУмолчанию()
	Возврат Новый Структура("ЗапросПакета,ОператорВыбрать,Источник,ИсточникСлева,ИсточникСправа,Поле,Соединение,ТипСоединения,КонтрольнаяТочка");
КонецФункции

Процедура СохранитьСостояниеНаСтеке()
	СохраненноеСостояние = СостояниеПоУмолчанию();
	ЗаполнитьЗначенияСвойств(СохраненноеСостояние, ЭтотОбъект);
	Стек.Добавить(СохраненноеСостояние);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПоУмолчанию());	
КонецПроцедуры

Процедура ВосстановитьСостояниеСоСтека()
	СохраненноеСостояние = Стек[Стек.ВГраница()];
	Стек.Удалить(Стек.ВГраница());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраненноеСостояние);
КонецПроцедуры

#КонецОбласти

#Область ПакетЗапроса

Функция УстановитьТекстЗапроса(ТекстЗапроса) Экспорт
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	ЗапросПакета = СхемаЗапроса.ПакетЗапросов[СхемаЗапроса.ПакетЗапросов.Количество() - 1];
	ОператорВыбрать = ЗапросПакета.Операторы[ЗапросПакета.Операторы.Количество() - 1];
	Источник = ОператорВыбрать.Источники[ОператорВыбрать.Источники.Количество() - 1];  
	Возврат ЭтотОбъект;
КонецФункции

Функция ПолучитьТекстЗапроса() Экспорт
	Возврат СхемаЗапроса.ПолучитьТекстЗапроса();
КонецФункции

Функция ЗапросПакета(ИмяЗапроса = "") Экспорт
	ЗапросПакета = РаботаСоСхемойЗапроса.ЗапросПакета(СхемаЗапроса, , , ОператорВыбрать);
	Если НЕ ПустаяСтрока(ИмяЗапроса) Тогда
		РаботаСоСхемойЗапроса.ОписаниеЗапроса(СхемаЗапроса, СтруктураЗапроса, ИмяЗапроса);
	КонецЕсли;
	Возврат ЭтотОбъект;
КонецФункции

Функция Уничтожить(ИмяВременнойТаблицы) Экспорт
	РаботаСоСхемойЗапроса.ЗапросУничтожения(СхемаЗапроса, ИмяВременнойТаблицы);
	Возврат ЭтотОбъект;
КонецФункции

Функция Поместить(ИмяВременнойТаблицы) Экспорт
	ЗапросПакета.ТаблицаДляПомещения = ИмяВременнойТаблицы;
	Возврат ЭтотОбъект;
КонецФункции

Функция Разрешенные(ВыбиратьРазрешенные = Истина) Экспорт
	ЗапросПакета.ВыбиратьРазрешенные = ВыбиратьРазрешенные;
	Возврат ЭтотОбъект;
КонецФункции

Функция Порядок(Выражение, Направление = Неопределено) Экспорт
	Если ТипЗнч(Направление) = Тип("Строка") Тогда
		РаботаСоСхемойЗапроса.Порядок(ЗапросПакета, Выражение, НаправлениеПорядкаСхемыЗапроса[Направление]);
		Возврат ЭтотОбъект;
	КонецЕсли;				
	РаботаСоСхемойЗапроса.Порядок(ЗапросПакета, Выражение, Направление);
	Возврат ЭтотОбъект;
КонецФункции

Функция Автопорядок(Значение = Истина) Экспорт
	ЗапросПакета.Автопорядок = Значение;
	Возврат ЭтотОбъект;
КонецФункции

Функция Индекс(ИмяПоля) Экспорт
	ЗапросПакета.Индекс.Добавить(ИмяПоля);
	Возврат ЭтотОбъект;
КонецФункции

Функция ПсевдонимКолонки(ТекущийПсевдоним, Псевдоним) Экспорт
	РаботаСоСхемойЗапроса.ИзменитьПсевдонимКолонки(ЗапросПакета, ТекущийПсевдоним, Псевдоним);
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область ОператорВыбрать

Функция Выбрать(Количество = Неопределено, Различные = Неопределено, ТипОбъединения = Неопределено, Индекс = Неопределено) Экспорт
	Если Индекс <> Неопределено Тогда
		Если Индекс = -1 Тогда
			ОператорИсточник = ЗапросПакета.Операторы[ЗапросПакета.Операторы.Количество() - 1];
		ИначеЕсли ТипЗнч(Индекс) = Тип("Число") Тогда
			ОператорИсточник = ЗапросПакета.Операторы[Индекс];
		Иначе
			ОператорИсточник = Индекс;
		КонецЕсли;
		ОператорВыбрать = РаботаСоСхемойЗапроса.КопияОператора(ЗапросПакета, ОператорИсточник);
	Иначе
		ОператорВыбрать = РаботаСоСхемойЗапроса.Оператор(ЗапросПакета);
	КонецЕсли;
	Если Количество <> Неопределено Тогда
		ОператорВыбрать.КоличествоПолучаемыхЗаписей = Количество;
	КонецЕсли;
	Если Различные <> Неопределено Тогда
		ОператорВыбрать.ВыбиратьРазличные = Различные;
	КонецЕсли;
	ОператорВыбрать.ТипОбъединения = ?(ТипОбъединения = Неопределено, ТипОбъединенияСхемыЗапроса.ОбъединитьВсе, ТипОбъединения);
	Возврат ЭтотОбъект;
КонецФункции

Функция Объединить(Количество = Неопределено, Различные = Неопределено, ТипОбъединения = Неопределено, Индекс = Неопределено) Экспорт
	Если ТипОбъединения = Неопределено Тогда
		Возврат Выбрать(Количество, Различные, ТипОбъединенияСхемыЗапроса.Объединить, Индекс);
	КонецЕсли;
	Возврат Выбрать(Количество, Различные, ТипОбъединения, Индекс);
КонецФункции

Функция ОбъединитьВсе(Количество = Неопределено, Различные = Неопределено, Индекс = Неопределено) Экспорт
	Возврат Выбрать(Количество, Различные, ТипОбъединенияСхемыЗапроса.ОбъединитьВсе, Индекс);
КонецФункции

Функция Различные(ВыбиратьРазличные = Истина) Экспорт
	ОператорВыбрать.ВыбиратьРазличные = ВыбиратьРазличные;
	Возврат ЭтотОбъект;
КонецФункции

Функция Первые(КоличествоПолучаемыхЗаписей = 1) Экспорт
	ОператорВыбрать.КоличествоПолучаемыхЗаписей = КоличествоПолучаемыхЗаписей;
	Возврат ЭтотОбъект;
КонецФункции

Функция Отбор(Выражение) Экспорт
	ОператорВыбрать.Отбор.Добавить(Выражение);
	Возврат ЭтотОбъект;
КонецФункции

Функция ОчиститьОтбор() Экспорт
	ОператорВыбрать.Отбор.Очистить();
	Возврат ЭтотОбъект;
КонецФункции

Функция ОтборВхождения(ИмяТаблицы, Поля) Экспорт
	ОператорВыбрать.Отбор.Добавить(ВыражениеВхождения(ИмяТаблицы, Поля));
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область Поля

Функция Поле(Выражение, Псевдоним = "", ВыражениеЕстьNull = "") Экспорт
	Если ПустаяСтрока(ВыражениеЕстьNull) Тогда
		Поле = РаботаСоСхемойЗапроса.Поле(ЗапросПакета, ОператорВыбрать,, Выражение, Псевдоним);
		Возврат ЭтотОбъект;
	КонецЕсли;
	Поле = РаботаСоСхемойЗапроса.Поле(ЗапросПакета, ОператорВыбрать,, СтрШаблон("ЕСТЬNULL(%1, %2)", Выражение, ВыражениеЕстьNull), Псевдоним);
	Возврат ЭтотОбъект;
КонецФункции

Функция Автономер(Псевдоним) Экспорт
	Возврат Поле("АВТОНОМЕРЗАПИСИ()", Псевдоним);
КонецФункции

Функция Представление(Выражение, Псевдоним = "", ЭтоСсылка = Ложь) Экспорт
	Если ПустаяСтрока(Псевдоним) Тогда
		Состав = СтрРазделить(Выражение, ". ", Ложь);
		Если Состав.ВГраница() > 0 Тогда
			Если ОператорВыбрать.Источники.НайтиПоПсевдониму(Состав[0]) <> Неопределено Тогда
				Состав.Удалить(0);
			КонецЕсли;
		КонецЕсли;
		Состав.Добавить("Представление");
		ПсевдонимПредставления = СтрСоединить(Состав, "");
	Иначе
		ПсевдонимПредставления = Псевдоним;
	КонецЕсли;
	Возврат Поле(СтрШаблон("ПРЕДСТАВЛЕНИЕ%1(%2)", ?(ЭтоСсылка, "ССЫЛКИ", ""), Выражение), ПсевдонимПредставления);
КонецФункции

Функция ПредставлениеСсылки(Выражение, Псевдоним = "") Экспорт
	Возврат Представление(Выражение, Псевдоним, Истина);
КонецФункции

Функция Подстрока(Выражение, НачальнаяПозиция, Длина, Псевдоним = "") Экспорт
	Если ПустаяСтрока(Псевдоним) Тогда
		Состав = СтрРазделить(Выражение, ". ", Ложь);
		Если Состав.ВГраница() = 0 Тогда
			ПсевдонимПредставления = Выражение;
		Иначе
			Если ОператорВыбрать.Источники.НайтиПоПсевдониму(Состав[0]) <> Неопределено Тогда
				Состав.Удалить(0);
			КонецЕсли;
			ПсевдонимПредставления = СтрСоединить(Состав, "");
		КонецЕсли;
	Иначе
		ПсевдонимПредставления = Псевдоним;
	КонецЕсли;
	Возврат Поле(СтрШаблон("ПОДСТРОКА(%1, %2, %3)", Выражение, Формат(НачальнаяПозиция, "ЧН=0; ЧГ="), Формат(Длина, "ЧГ=")), ПсевдонимПредставления);
КонецФункции

#КонецОбласти

#Область АгрегатныеФункции

Функция Сумма(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("СУММА(%1)", Выражение), Псевдоним);
КонецФункции

Функция Среднее(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("СРЕДНЕЕ(%1)", Выражение), Псевдоним);
КонецФункции

Функция Количество(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("КОЛИЧЕСТВО(%1)", Выражение), Псевдоним);
КонецФункции

Функция КоличествоРазличных(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("КОЛИЧЕСТВО(РАЗЛИЧНЫЕ %1)", Выражение), Псевдоним);
КонецФункции

Функция Максимум(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("МАКСИМУМ(%1)", Выражение), Псевдоним);
КонецФункции

Функция Минимум(Выражение, Псевдоним = "") Экспорт
	Возврат Поле(СтрШаблон("МИНИМУМ(%1)", Выражение), Псевдоним);
КонецФункции

#КонецОбласти

#Область Источник

Функция Источник(Таблица, Псевдоним = "", ПараметрыТаблицы = Неопределено) Экспорт
	Если СтрНачинаетсяС(Таблица, "&") Тогда
		ВременнаяТаблица = РаботаСоСхемойЗапроса.ОписаниеВременнойТаблицы(Таблица, ПараметрыТаблицы);
		Источник = РаботаСоСхемойЗапроса.Источник(ОператорВыбрать, ВременнаяТаблица, Псевдоним);
		ИсточникСлева = Источник;
		Возврат ЭтотОбъект;
	КонецЕсли;

	Если МенеджерВременныхТаблиц.Таблицы.Найти(Таблица) <> Неопределено Тогда
		ВременнаяТаблица = РаботаСоСхемойЗапроса.ОписаниеВременнойТаблицы(Таблица, МенеджерВременныхТаблиц);
		Источник = РаботаСоСхемойЗапроса.Источник(ОператорВыбрать, ВременнаяТаблица, Псевдоним);
		ИсточникСлева = Источник;
		Возврат ЭтотОбъект;
	КонецЕсли;
	
	Источник = РаботаСоСхемойЗапроса.Источник(ОператорВыбрать, Таблица, Псевдоним, ПараметрыТаблицы);
	ИсточникСлева = Источник;
	Возврат ЭтотОбъект;
КонецФункции

Функция ИсточникНачать(Псевдоним) Экспорт
	ВложенныйЗапрос = РаботаСоСхемойЗапроса.Источник(ОператорВыбрать, РаботаСоСхемойЗапроса.ОписаниеВложенногоЗапроса(), Псевдоним).Источник.Запрос;
	СохранитьСостояниеНаСтеке();
	ЗапросПакета = ВложенныйЗапрос; 
	Возврат ЭтотОбъект;
КонецФункции

Функция ИсточникЗавершить() Экспорт
	ВосстановитьСостояниеСоСтека();
	Возврат ЭтотОбъект;
КонецФункции

Функция ПараметрТаблицы(ИмяПараметра, Значение) Экспорт
	РаботаСоСхемойЗапроса.УстановитьПараметрыВиртуальнойТаблицы(Источник, Новый Структура(ИмяПараметра, Значение));
	Возврат ЭтотОбъект;
КонецФункции

Функция УсловиеВхождения(ИмяТаблицы, Поля = "*") Экспорт
	Возврат Условие(ВыражениеВхождения(ИмяТаблицы, Поля));
КонецФункции

Функция Условие(Выражение) Экспорт
	Перем ТекущееВыражение;
	ПараметрыТаблицы = РаботаСоСхемойЗапроса.СтруктураПараметровВиртуальнойТаблицы(Источник.Источник.ИмяТаблицы, Источник.Источник.Параметры);
	Если ПараметрыТаблицы <> Неопределено И ПараметрыТаблицы.Свойство("Условие", ТекущееВыражение) Тогда
		Возврат ПараметрТаблицы("Условие", СтрШаблон("(%1) И (%2)", ТекущееВыражение, Выражение));
	КонецЕсли;
	Возврат ПараметрТаблицы("Условие", Выражение);
КонецФункции

Функция НачалоПериода(Значение) Экспорт
	Возврат ПараметрТаблицы("НачалоПериода", Значение);
КонецФункции

Функция КонецПериода(Значение) Экспорт
	Возврат ПараметрТаблицы("КонецПериода", Значение);
КонецФункции

Функция Период(Значение) Экспорт
	Возврат ПараметрТаблицы("Период", Значение);
КонецФункции

Функция Периодичность(Значение) Экспорт
	Возврат ПараметрТаблицы("Периодичность", Значение);
КонецФункции

Функция ПериодичностьЗапись() Экспорт
	Возврат Периодичность("Запись");
КонецФункции

Функция ПериодичностьРегистратор() Экспорт
	Возврат Периодичность("Регистратор");
КонецФункции

Функция ПериодичностьПериод() Экспорт
	Возврат Периодичность("Период");
КонецФункции

Функция ПериодичностьСекунда() Экспорт
	Возврат Периодичность("Секунда");
КонецФункции

Функция ПериодичностьМинута() Экспорт
	Возврат Периодичность("Минута");
КонецФункции

Функция ПериодичностьЧас() Экспорт
	Возврат Периодичность("Час");
КонецФункции

Функция ПериодичностьДень() Экспорт
	Возврат Периодичность("День");
КонецФункции

Функция ПериодичностьНеделя() Экспорт
	Возврат Периодичность("Неделя");
КонецФункции

Функция ПериодичностьДекада() Экспорт
	Возврат Периодичность("Декада");
КонецФункции

Функция ПериодичностьМесяц() Экспорт
	Возврат Периодичность("Месяц");
КонецФункции

Функция ПериодичностьКвартал() Экспорт
	Возврат Периодичность("Квартал");
КонецФункции

Функция ПериодичностьПолугодие() Экспорт
	Возврат Периодичность("Полугодие");
КонецФункции

Функция ПериодичностьГод() Экспорт
	Возврат Периодичность("Год");
КонецФункции

Функция ПериодичностьАвто() Экспорт
	Возврат Периодичность("Авто");
КонецФункции

#КонецОбласти

#Область Соединение

Функция ЛевоеСоединение(ПсевдонимСлева, ПсевдонимСправа) Экспорт
	Соединение = Неопределено;
	ТипСоединения = ТипСоединенияСхемыЗапроса.ЛевоеВнешнее;
	ИсточникСлева = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСлева);
	ИсточникСправа = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСправа);
	Возврат ЭтотОбъект;
КонецФункции

Функция ПравоеСоединение(ПсевдонимСлева, ПсевдонимСправа) Экспорт
	Соединение = Неопределено;
	ТипСоединения = ТипСоединенияСхемыЗапроса.ПравоеВнешнее;
	ИсточникСлева = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСлева);
	ИсточникСправа = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСправа);
	Возврат ЭтотОбъект;
КонецФункции

Функция ПолноеСоединение(ПсевдонимСлева, ПсевдонимСправа) Экспорт
	Соединение = Неопределено;
	ТипСоединения = ТипСоединенияСхемыЗапроса.ПолноеВнешнее;
	ИсточникСлева = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСлева);
	ИсточникСправа = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСправа);
	Возврат ЭтотОбъект;
КонецФункции

Функция ВнутреннееСоединение(ПсевдонимСлева, ПсевдонимСправа) Экспорт
	Соединение = Неопределено;
	ТипСоединения = ТипСоединенияСхемыЗапроса.Внутреннее;
	ИсточникСлева = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСлева);
	ИсточникСправа = ОператорВыбрать.Источники.НайтиПоПсевдониму(ПсевдонимСправа);
	Возврат ЭтотОбъект;
КонецФункции

Функция Связь(СоответствиеПолей) Экспорт
	Выражение = РаботаСоСхемойЗапроса.УсловиеСоединения(СоответствиеПолей);
	Если Соединение = Неопределено Тогда
		Соединение = РаботаСоСхемойЗапроса.Соединение(ОператорВыбрать, ИсточникСлева, ИсточникСправа, Выражение, ТипСоединения);
		Возврат ЭтотОбъект;	
	КонецЕсли;
	РаботаСоСхемойЗапроса.ДобавитьУсловиеСоединения(Соединение, Выражение);		
	Возврат ЭтотОбъект;
КонецФункции

Функция УсловиеСвязи(Выражение) Экспорт
	Если Соединение = Неопределено Тогда
		Соединение = РаботаСоСхемойЗапроса.Соединение(ОператорВыбрать, ИсточникСлева, ИсточникСправа, Выражение, ТипСоединения);
		Возврат ЭтотОбъект;	
	КонецЕсли;
	Условие = Выражение;
	Если Условие = "*" Тогда
		МассивОбщихПолейИсточников = Новый Массив;
		Для каждого Поле Из ИсточникСлева.Источник.ДоступныеПоля Цикл
			Если ИсточникСправа.Источник.ДоступныеПоля.Найти(Поле.Имя) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			МассивОбщихПолейИсточников.Добавить(ИсточникСлева.Источник.Псевдоним+"."+Поле.Имя+" = "+ИсточникСправа.Источник.Псевдоним+"."+Поле.Имя);
		КонецЦикла;
		Условие = СтрСоединить(МассивОбщихПолейИсточников, " И ");
	Иначе
		Условие = СтрЗаменить(Условие, "%1", ИсточникСлева.Источник.Псевдоним); 
		Условие = СтрЗаменить(Условие, "%2", ИсточникСправа.Источник.Псевдоним); 
	КонецЕсли;
	РаботаСоСхемойЗапроса.ДобавитьУсловиеСоединения(Соединение, Условие);	
	Возврат ЭтотОбъект;
КонецФункции

Функция СвязьВхождения(ИмяТаблицы, Поля) Экспорт
	Возврат УсловиеСвязи(ВыражениеВхождения(ИмяТаблицы, Поля));
КонецФункции

Функция Характеристика(ПолеОбъектаИсточника, ПолеОбъектаХарактеристики, ПолеВидаХарактеристики, ВыражениеПараметраВида) Экспорт
	УсловиеСвязи(СтрШаблон("%%1.%1 = %%2.%2", ПолеОбъектаИсточника, ПолеОбъектаХарактеристики));
	УсловиеСвязи(СтрШаблон("%%2.%1 = %2", ПолеВидаХарактеристики, ВыражениеПараметраВида));
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область Итоги

Функция Итог(Выражение, Псевдоним) Экспорт
	ЗапросПакета.ВыраженияИтогов.Добавить(Выражение, Псевдоним);
	Возврат ЭтотОбъект;
КонецФункции

Функция ИтогСумма(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("СУММА(%1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция ИтогСреднее(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("СРЕДНЕЕ(%1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция ИтогКоличество(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("КОЛИЧЕСТВО(%1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция ИтогКоличествоРазличных(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("КОЛИЧЕСТВО(РАЗЛИЧНЫЕ %1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция ИтогМаксимум(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("МАКСИМУМ(%1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция ИтогМинимум(Выражение, Псевдоним = "") Экспорт
	Возврат Итог(СтрШаблон("МИНИМИУМ(%1)", Выражение), ?(ПустаяСтрока(Псевдоним), Выражение, Псевдоним));
КонецФункции

Функция Группировка(Выражение, ИмяКолонки = "", ТипКонтрольнойТочки = Неопределено) Экспорт
	КонтрольнаяТочка = РаботаСоСхемойЗапроса.Итог(ЗапросПакета, Выражение, ?(ПустаяСтрока(ИмяКолонки), Выражение, ИмяКолонки), ТипКонтрольнойТочки);
	Возврат ЭтотОбъект;
КонецФункции

// Дополнение результата запроса датами в установленном периоде
// https://its.1c.ru/db/metod8dev/content/2660/hdoc
Функция ПоПериодам(ТипДополненияПериодами, НачалоПериода = "", КонецПериода = "") Экспорт
	КонтрольнаяТочка.ТипДополненияПериодами = ?(ТипДополненияПериодами = Неопределено, ТипДополненияПериодамиСхемыЗапроса.БезДополнения, ТипДополненияПериодами);
	КонтрольнаяТочка.НачалоПериодаДополнения = ?(ТипЗнч(НачалоПериода) = Тип("Строка"), НачалоПериода, ОбщийКлиентСервер.ФорматДатаВремя(НачалоПериода));
	КонтрольнаяТочка.КонецПериодаДополнения = ?(ТипЗнч(КонецПериода) = Тип("Строка"), КонецПериода, ОбщийКлиентСервер.ФорматДатаВремя(КонецПериода));
	Возврат ЭтотОбъект;
КонецФункции

Функция ОбщиеИтоги() Экспорт
	ЗапросПакета.ОбщиеИтоги = Истина;
	Возврат ЭтотОбъект;
КонецФункции

#КонецОбласти

#Область Запрос

Функция Параметр(Имя, Значение) Экспорт
	Параметры.Вставить(Имя, Значение);
	Возврат ЭтотОбъект;
КонецФункции

Функция ВыполнитьЗапрос() Экспорт
	Запрос = РаботаСоСхемойЗапроса.Запрос(СхемаЗапроса, Параметры, МенеджерВременныхТаблиц);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеПоУмолчанию());
	РезультатПакета = Запрос.ВыполнитьПакет();
	Возврат ЭтотОбъект;
КонецФункции

Функция ВыбратьРезультат(Индекс = Неопределено, ТипОбхода = Неопределено, Группировки = Неопределено, ГруппировкиДляЗначенийГруппировок = Неопределено) Экспорт
	Результат = Результат(Индекс);
	Выборка = Результат.Выбрать();
	Возврат Выборка;
КонецФункции

Функция ВыбратьПервый(Индекс = Неопределено, ТипОбхода = Неопределено, Группировки = Неопределено, ГруппировкиДляЗначенийГруппировок = Неопределено) Экспорт
	Выборка = ВыбратьРезультат(Индекс, ТипОбхода, Группировки, ГруппировкиДляЗначенийГруппировок);
	Выборка.Следующий();
	Возврат Выборка;
КонецФункции

Функция Результат(Индекс = Неопределено) Экспорт
	Если Индекс = Неопределено Тогда
		Возврат РезультатПакета[РезультатПакета.ВГраница()];
	КонецЕсли;
	Если ТипЗнч(Индекс) = Тип("Число") Тогда
		Возврат РезультатПакета[Индекс];
	КонецЕсли;
	Возврат РезультатПакета[СтруктураЗапроса[Индекс]];
КонецФункции

#КонецОбласти

СхемаЗапроса = Новый СхемаЗапроса();
МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
Параметры = Новый Структура;
Запрос = Новый Запрос;
Стек = Новый Массив;
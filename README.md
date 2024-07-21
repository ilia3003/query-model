# Объектная модель работы со схемой запроса
---
[![OpenYellow](https://img.shields.io/endpoint?url=https://openyellow.neocities.org/badges/2/340940374.json)](https://openyellow.notion.site/openyellow/24727888daa641af95514b46bee4d6f2?p=d6c0fe70d0b541b3ad83127c3d1c402f&amp;pm=s)![Версия](https://img.shields.io/badge/Версия_1С-8.3.24-yellow)

Объектная модель построена на использовании внешнего интерфейса библиотеки ["Работа со схемой запроса"](https://infostart.ru/1c/articles/811832/). Модель позволяет скрыть переменные контекста работы с библиотекой и использовать вызов методов в стиле текучего интерфейса.

## Конструктор модели запроса

```bsl
МодельЗапроса = Общий.МодельЗапроса();
МодельЗапроса = Общий.МодельЗапроса(ТекстЗапроса);
МодельЗапроса = Общий.МодельЗапроса(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных);
МодельЗапроса = Общий.МодельЗапроса(ДинамическийСписок);
```
## Обработка "Конструктор модели запроса"

Интерактивная обработка позволяет генерировать код модели на основе текста запроса. Описание работы аналогично с [Обработка "Конструктор схемы запроса"](https://infostart.ru/1c/articles/811832/#_Toc512118900).

## Примеры работы

### Описание простого запроса
```bsl
МодельЗапроса = Общий.МодельЗапроса()
;//  ЗАПРОС ПАКЕТА. Контрагенты
МодельЗапроса.ЗапросПакета("Контрагенты")
	.Выбрать()
		.Источник("Справочник._ДемоКонтрагенты")
		.Поле("Ссылка")
		.Поле("ИНН")
		.Поле("КПП")
		.Порядок("Ссылка")
		.Автопорядок()
;
//  Обработка результата
МодельЗапроса.ВыполнитьЗапрос();
Выборка = МодельЗапроса.ВыбратьРезультат("Контрагенты");
Пока Выборка.Следующий() Цикл
	Сообщить(СтрШаблон("%1 (%2/%3)", Выборка.Ссылка, Выборка.ИНН, Выборка.КПП));
КонецЦикла;
```
### Дополнение существующего текста запроса

```bsl
ТекстЗапроса = "ВЫБРАТЬ
|    Контрагенты.Ссылка КАК Ссылка,
|    Контрагенты.Код КАК Код,
|    Контрагенты.Наименование КАК Наименование
|ИЗ
|    Справочник._ДемоКонтрагенты КАК Контрагенты";
//  Конструктор модели запроса на основе существующего текста запроса
МодельЗапроса = Общий.МодельЗапроса(ТекстЗапроса)
    .Источник("РегистрСведений.ДополнительныеСведения")
    .ЛевоеСоединение(0, "ДополнительныеСведения")
        .Связь("Ссылка = Объект")
    .Поле("ДополнительныеСведения.*")
;
```
На выходе получится измененный текст запроса:
```bsl
Сообщить(МодельЗапроса.ПолучитьТекстЗапроса());
```
```bsl
ВЫБРАТЬ
    Контрагенты.Ссылка КАК Ссылка,
    Контрагенты.Код КАК Код,
    Контрагенты.Наименование КАК Наименование,
    ДополнительныеСведения.Объект КАК Объект,
    ДополнительныеСведения.Свойство КАК Свойство,
    ДополнительныеСведения.Значение КАК Значение
ИЗ
    Справочник._ДемоКонтрагенты КАК Контрагенты
        ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
        ПО (Контрагенты.Ссылка = ДополнительныеСведения.Объект)
```

Больше примеров можно найти в статьях:
- ["Модель запроса"](https://infostart.ru/1c/articles/1390402/)
- ["Снежинка для запроса"](https://infostart.ru/1c/articles/1456173/)
- ["Работа со схемой запроса"](https://infostart.ru/1c/articles/811832/)

## Состав

- Конфигурация (этот проект):
	- общие модули
	- модуль библиотеки *РаботаСоСхемойЗапроса*
	- обработка *МодельЗапроса*, реализующая объектный интерфейс
- Внешняя обработка "Конструктор модели запроса" (отдельный проект)
- Внешняя обработка "Конструктор схемы запроса" (поставляется как есть)

## Установка

Установка возможна как объединением с конфигурацией текущего проекта из последнего релиза, так и с конфигурацией из Демо-базы к статье [Модель запроса](https://infostart.ru/1c/articles/1390402/). В 1-ом случае будут объединены только модули и обработки проекта без зависимостей, а во 2-ом - с зависимостями.
### Объединение с конфигурацией (этот проект)

Объединить с файлом конфигурации из последнего релиза проекта:
- Снять признак объединения с общих свойств
- Установить режим объединения с приоритетом в файле

### Объединение с конфигурацией из Демо-базы

Объединить с файлом конфигурации из Демо-базы к статье [Модель запроса](https://infostart.ru/1c/articles/1390402/):
- Снять признак объединения с общих свойств
- Установить режим объединения с приоритетом в файле
- Отметить объекты подсистем:
	- KASSL->ОбщегоНазначения
	- KASSL->Модели->МодельЗапроса
	- KASSL->Конструкторы->КонструкторМодельЗапроса
	- KASSL->АТДМассив

## Зависимости

- БСП (работает с версией 3 и выше)
- Общие модули из подсистемы [KASSL->ОбщегоНазначения](https://github.com/KalyakinAG/common)
- Подсистема [АТДМассив](https://github.com/KalyakinAG/adt-array)

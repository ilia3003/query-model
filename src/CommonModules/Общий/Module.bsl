Функция МодельЗапроса(ТекстЗапроса = "") Экспорт
	МодельЗапроса = Обработки.МодельЗапроса.Создать();
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат МодельЗапроса;
	КонецЕсли;
	МодельЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	Возврат МодельЗапроса;
КонецФункции
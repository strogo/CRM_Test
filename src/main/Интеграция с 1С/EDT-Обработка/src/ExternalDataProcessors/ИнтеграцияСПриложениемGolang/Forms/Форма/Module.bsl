

&НаКлиенте
Процедура ОтправитьСписокКлиентовМетодомPOST(Команда)
	
	// Подключаемся к сайту.
	Соединение = Новый HTTPСоединение(
	"localhost", // сервер (хост)
	8181, // порт, по умолчанию для http используется 80, для https 443
	, // пользователь для доступа к серверу (если он есть)
	, // пароль для доступа к серверу (если он есть)
	, // здесь указывается прокси, если он есть
	, // таймаут в секундах, 0 или пусто - не устанавливать
	// защищенное соединение, если используется https
	);
	
	ЗаголовокHTTP = Новый Соответствие();
	ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded");
	ЗаголовокHTTP.Вставить("token", "Test_Param_777");
	
	// Получаем текст корневой страницы через GET-запрос.
	Запрос = Новый HTTPЗапрос("/connection_rest_1C", ЗаголовокHTTP);
	Запрос.Заголовки.Вставить("Content-type", "application/json");
	Запрос.Заголовки.Вставить("token", "Test_Param_777");
	
	СоотвествиеКорень = Новый Соответствие;
	Для Каждого ЭлемТаблицы Из ТаблицаКлиентов Цикл 
		СоотвествиеУзел = Новый Соответствие;
		СоотвествиеУзел.Вставить("Customer_id", ЭлемТаблицы.Идентификатор);
		СоотвествиеУзел.Вставить("Customer_name", ЭлемТаблицы.Имя);
		СоотвествиеУзел.Вставить("Customer_type", ЭлемТаблицы.Тип);
		СоотвествиеУзел.Вставить("Customer_email", ЭлемТаблицы.ЭлектроннаяПочта);
		
		СоотвествиеКорень.Вставить(ЭлемТаблицы.Идентификатор, СоотвествиеУзел);		
	КонецЦикла;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("json");
	
	Запись = Новый ЗаписьJSON;
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON( ,Символы.Таб);
	Запись.ОткрытьФайл(ИмяВременногоФайла,,,ПараметрыЗаписиJSON);
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДата;
	
	ЗаписатьJSON(Запись, СоотвествиеКорень, НастройкиСериализации);
	Запись.Закрыть();
	
	Запрос.УстановитьТелоИзДвоичныхДанных(Новый ДвоичныеДанные(ИмяВременногоФайла));
	// Если бы нужна была другая страница, мы бы указали,
	// например, "/about" или "/news".
	
	Результат = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Результат.КодСостояния > 299 Тогда
		Сообщить("Код состояния " + Результат.КодСостояния + ". Проверка не выполнена");
	КонецЕсли;
	
	Сообщить(Результат.ПолучитьТелоКакСтроку());
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокКлиентовМетодомGET(Команда)
	// В сети есть сайт http://example.com
	// Запросим содержимое его главной страницы.
	
	// Подключаемся к сайту.
	Соединение = Новый HTTPСоединение(
	"localhost", // сервер (хост)
	8181, // порт, по умолчанию для http используется 80, для https 443
	, // пользователь для доступа к серверу (если он есть)
	, // пароль для доступа к серверу (если он есть)
	, // здесь указывается прокси, если он есть
	, // таймаут в секундах, 0 или пусто - не устанавливать
	// защищенное соединение, если используется https
	);
	
	ЗаголовокHTTP = Новый Соответствие();
	ЗаголовокHTTP.Вставить("Content-Type", "application/x-www-form-urlencoded");
	ЗаголовокHTTP.Вставить("token", "Test_Param_777");
	
	// Получаем текст корневой страницы через GET-запрос.
	Запрос = Новый HTTPЗапрос("/connection_rest_1C", ЗаголовокHTTP);
	Запрос.Заголовки.Вставить("Content-type", "application/json");
	Запрос.Заголовки.Вставить("token", "Test_Param_777");
	// Если бы нужна была другая страница, мы бы указали,
	// например, "/about" или "/news".
	
	Результат = Соединение.Получить(Запрос);
	
	Сообщить("Нам вернули код: " + Результат.КодСостояния);
	// Что примерно означают коды результата запроса:
	// [100, 299] - хороший код возврата
	// [300, 399] - нас перенаправляют на другую страницу,
	//              причём 302 - код постоянного перенаправления
	// [400, 499] - ошибка запроса
	// [500, 599] - ошибка сервера
	
	// в теле результата запроса - текст обычной html страницы
	Сообщить("Тело результата: " + Результат.ПолучитьТелоКакСтроку());
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("json");
	
	Текст = Новый ТекстовыйДокумент;
	Текст.ДобавитьСтроку(Результат.ПолучитьТелоКакСтроку());
	Текст.Записать(ИмяВременногоФайла);
	
	
	тЧтение = Новый ЧтениеJSON;
	тЧтение.ОткрытьФайл(ИмяВременногоФайла);
	тДанные = ПрочитатьJSON(тЧтение, Истина);
	
	//тДатаJSON = ПрочитатьДатуJSON(тДанные.ДатаJSON, ФорматДатыJSON.ISO);
	
	тЧтение.Закрыть();
	
	ТаблицаКлиентов.Очистить();
	Для Каждого Элем Из тДанные Цикл
		НоваяСтрока = ТаблицаКлиентов.Добавить();
		НоваяСтрока.Идентификатор = Элем.Ключ;
		
		Для Каждого ЭлемПодч Из Элем.Значение Цикл
			Если ЭлемПодч.Ключ = "Customer_name" Тогда 
				НоваяСтрока.Имя = ЭлемПодч.Значение;
			ИначеЕсли ЭлемПодч.Ключ = "Customer_type" Тогда
				НоваяСтрока.Тип = ЭлемПодч.Значение;
			ИначеЕсли ЭлемПодч.Ключ = "Customer_email" Тогда
				НоваяСтрока.ЭлектроннаяПочта = ЭлемПодч.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры


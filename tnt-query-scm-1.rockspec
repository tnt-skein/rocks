rockspec_format = '3.0'

package = 'tnt-query'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-query.git',
    branch = 'main',
}

description = {
    summary = 'Разбор параметров запроса по белому списку и ответ списка со страницами и ссылками',
    detailed = [[
        filter[state]=dead, filter[uptime][gte]=3600, sort=-uptime,name,
        page[size]=50, include=replicas — разобранные один раз
        и безопасно. Поле, по которому отбирают и сортируют, называется
        явно: фильтр по произвольному полю стал бы способом прочитать то,
        чего не следует, а сортировка по чужому полю — полным перебором.

        Поля белого списка берутся из формы tnt-data: правило значения,
        имя снаружи и описание — те же, что у тела запроса и ответа;
        скрытое поле в белый список не попадает. Запрос к базе пакет
        не собирает: условия уходят данными — поле, оператор, проверенное
        значение, — и значение из адреса в текст запроса не попадает.

        Отказ — пара nil, errors «параметр → причина», все сразу.
        Параметры строки запроса и схема тела ответа описываются для
        OpenAPI 3.0 из того же объявления.

        Ответ списка — один договор: data, meta (страница, размер, всего
        записей и страниц) и links (self, first, prev, next, last)
        полными адресами; листают номером либо курсором, всего считают,
        только если это объявлено. Окно номеров для листалки — тоже
        из ответа.

        Зависит от tnt-data (поля белого списка), tnt-router (разбор
        строки запроса и кодировщик ссылок) и tnt-must (проверки
        аргументов и тексты отказов). Настроек и состояния у пакета нет.
        Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-query',
    issues_url = 'https://github.com/tnt-skein/tnt-query/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'http', 'query-string', 'pagination', 'filtering', 'openapi' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки аргументов на строке вызывающего и тексты отказов.
    'tnt-must',
    -- Поля белого списка и правила их значений — поля формы.
    'tnt-data',
    -- Строка запроса, пришедшая строкой, разбирается тем же разбором,
    -- что у роутера: повтор, «+» и %XX читаются одинаково; ссылки
    -- страниц собираются его же кодировщиком.
    'tnt-router',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.query'] = 'tnt/query.lua',
        ['tnt.query.declare'] = 'tnt/query/declare.lua',
        ['tnt.query.links'] = 'tnt/query/links.lua',
        ['tnt.query.lists'] = 'tnt/query/lists.lua',
        ['tnt.query.openapi'] = 'tnt/query/openapi.lua',
        ['tnt.query.parse'] = 'tnt/query/parse.lua',
        ['tnt.query.respond'] = 'tnt/query/respond.lua',
        ['tnt.query.slots'] = 'tnt/query/slots.lua',
        ['tnt.query.window'] = 'tnt/query/window.lua',
    },
}

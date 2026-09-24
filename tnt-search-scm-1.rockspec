rockspec_format = '3.0'

package = 'tnt-search'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-search.git',
    branch = 'main',
}

description = {
    summary = 'Полнотекстовый поиск в Tarantool: одно объявление и сменные драйверы под ним',
    detailed = [[
        Индекс объявляется один раз — какие поля записи ищутся, с каким
        весом и по каким полям отбирают точным значением, — а работа
        с ним одна на все драйверы: index и import кладут записи, remove
        стирает, flush очищает, search отдаёт страницу попаданий
        с оценкой совпадения. Прикладной код переезжает с драйвера
        на драйвер без правок.

        Драйвера два. space — свой обратный индекс в двух спейсах
        Tarantool: полнотекстового индекса в CE нет, основу слова даёт
        tnt-morphology, оценка — TF-IDF, а запись внутри транзакции box
        становится её частью. opensearch — индекс в службе OpenSearch
        через клиент, пришедший аргументом: язык разбирает служба, вес
        поля уходит в запрос multi_match. Свой драйвер — таблица
        с четырьмя действиями.

        Правка по одной (index, remove) умеет уходить очередью с методом
        send — например, tnt-queue: обработчик отдаёт index:handler(),
        негодное сообщение зарывается сразу, отказ драйвера повторяется.
        Партия и очистка идут драйверу прямо: их зовёт оператор, а не
        обработчик запроса.

        Отказ — пара nil, err с TntStorageFailure; ошибка программиста —
        исключение на строке вызывающего: незнакомое поле отбора, негодные
        настройки страницы, драйвер по сети внутри транзакции box.

        Зависит от tnt-must (проверки аргументов), tnt-morphology (основа
        слова), tnt-storage (отказ) и tnt-external (подмена признака
        транзакции в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-search',
    issues_url = 'https://github.com/tnt-skein/tnt-search/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'search', 'full-text-search', 'inverted-index', 'tf-idf', 'opensearch' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки объявления, записи и настроек поиска на строке вызывающего.
    'tnt-must',
    -- Основа слова и разбиение текста: без них обратный индекс драйвера
    -- `space` по запросу «кластеров» не нашёл бы ни «кластер», ни «кластеры».
    'tnt-morphology',
    -- Признак транзакции box — через внешнюю зависимость: проверкам он нужен двойником.
    'tnt-external',
    -- Отказ TntStorageFailure: род и `retriable` решают, повторять ли правку.
    'tnt-storage',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.search'] = 'tnt/search.lua',
        ['tnt.search.index'] = 'tnt/search/index.lua',
        ['tnt.search.opensearch'] = 'tnt/search/opensearch.lua',
        ['tnt.search.settings'] = 'tnt/search/settings.lua',
        ['tnt.search.space'] = 'tnt/search/space.lua',
    },
}

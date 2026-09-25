rockspec_format = '3.0'

package = 'tnt-opensearch'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-opensearch.git',
    branch = 'main',
}

description = {
    summary = 'Клиент OpenSearch для Tarantool: документы, поиск, партии NDJSON, срок, повторы и отказ парой',
    detailed = [[
        Готового клиента OpenSearch у Tarantool нет ни в ядре, ни среди
        официальных роков, а клиенты с luarocks.org ходят в сеть мимо
        файберов и останавливают узел целиком. Служба говорит по HTTP
        и JSON, поэтому своего в пакете немного: путь запроса, тело
        поиска, строки партии NDJSON и чтение ответов службы.

        Драйвер привязан к одному индексу: put и get документа, delete,
        партия bulk, страница поиска с меткой продолжения search_after,
        count, refresh, заведение, удаление и проверка индекса. Документ,
        попадание поиска и итог записи приходят записью одной формы —
        id, source, version, seq_no, primary_term. Промах — nil без
        отказа, запись с if_seq_no и if_primary_term — только если
        документ не менялся. Транзакций нет (features.transaction =
        false), партия не атомарна: отказы действий — в её отчёте.

        Отказ — пара nil, err с родом по коду ответа и словам libcurl,
        признаком отправки и приговором повтору; имя беды службы —
        в server_code. Срок один на вызов: попытки и паузы между ними —
        остатки одного мига. Повторяет драйвер, а не клиент HTTP, и все
        действия идемпотентны, поэтому обрыв после отправки повторяется
        без просьбы; несогласный ставит idempotent = false.

        Зависит от tnt-must (проверки аргументов), tnt-http (запросы
        через libcurl со своим кэшем соединений), tnt-retry (повторы)
        и tnt-storage (срок, отказ с родом и кодирование документа
        в JSON). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-opensearch',
    issues_url = 'https://github.com/tnt-skein/tnt-opensearch/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'opensearch', 'search', 'http', 'driver', 'ndjson' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки настроек, опознавателя и действий партии на строке вызывающего.
    'tnt-must',
    -- Запросы к службе, кодирование пути и разбор тела ответа.
    'tnt-http',
    -- Повторы вызова по полю retriable отказа.
    'tnt-retry',
    -- Срок вызова, отказ с родом по коду ответа и кодирование документа в JSON.
    'tnt-storage',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.opensearch'] = 'tnt/opensearch.lua',
        ['tnt.opensearch.body'] = 'tnt/opensearch/body.lua',
        ['tnt.opensearch.call'] = 'tnt/opensearch/call.lua',
        ['tnt.opensearch.reply'] = 'tnt/opensearch/reply.lua',
        ['tnt.opensearch.settings'] = 'tnt/opensearch/settings.lua',
    },
}

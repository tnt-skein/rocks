rockspec_format = '3.0'

package = 'tnt-audit'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-audit.git',
    branch = 'main',
}

description = {
    summary = 'Журнал административных действий Tarantool с проверяемой целостностью',
    detailed = [[
        Журнал отвечает на вопрос «кто, что и над чем сделал с кластером».
        Запись ложится в свой спейс и связывается с предыдущей хешем
        SHA-256, поэтому правка строки в обход писателя видна проверке
        цепочки. Проверка идёт кусками с уступкой, с бюджетом и курсором:
        журнал в миллионы записей не занимает узел и не держит вызывающего
        минутами.

        Старые записи убирает такт очистки — по горизонту хранения
        и по потолку числа записей; граница помечается пломбой, чтобы
        проверка отличала намеренную очистку от подделки. Хеш без ключа
        пересчитает любой, кто пишет в спейс, поэтому от умысла журнал
        бережёт вывоз во второе место: партии уезжают приёмникам с отметкой
        доставки на каждый, доставка — «хотя бы раз», а невывезенное
        очистка не удаляет. Выгрузка кусками отдаёт журнал потоку ответа,
        не собирая его в памяти.

        Схема разворачивается двумя шагами миграции: раннер приходит
        аргументом, своего механизма версий у пакета нет.

        Зависит от tnt-must (проверка аргументов), tnt-clock (часы очистки
        и вывоза), tnt-log (журнал узла), tnt-loop (такты очистки и вывоза)
        и tnt-external (подмена часов, уступки, диска и признака «только
        для чтения» в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-audit',
    issues_url = 'https://github.com/tnt-skein/tnt-audit/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'audit', 'audit-log', 'hash-chain', 'retention', 'export' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверка аргументов с местом вызывающего.
    'tnt-must',
    -- Стенные и монотонные часы очистки и вывоза.
    'tnt-clock',
    -- Журнал узла: сорвавшийся такт, невывезенная партия, отказ очистки.
    'tnt-log',
    -- Такты очистки и вывоза.
    'tnt-loop',
    -- Внешние зависимости: часы, уступка, диск, признак «только для чтения».
    'tnt-external',
    -- Не объявлен `tnt-schema`: раннер миграций приходит аргументом
    -- `register_migrations(schema)`, модули его не требуют.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.audit'] = 'tnt/audit.lua',
        ['tnt.audit.chain'] = 'tnt/audit/chain.lua',
        ['tnt.audit.space'] = 'tnt/audit/space.lua',
        ['tnt.audit.log'] = 'tnt/audit/log.lua',
        ['tnt.audit.verify'] = 'tnt/audit/verify.lua',
        ['tnt.audit.stream'] = 'tnt/audit/stream.lua',
        ['tnt.audit.retention'] = 'tnt/audit/retention.lua',
        ['tnt.audit.export'] = 'tnt/audit/export.lua',
        ['tnt.audit.export.cursor'] = 'tnt/audit/export/cursor.lua',
        ['tnt.audit.export.envelope'] = 'tnt/audit/export/envelope.lua',
        ['tnt.audit.export.sink.file'] = 'tnt/audit/export/sink/file.lua',
    },
}

rockspec_format = '3.0'

package = 'tnt-trace'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-trace.git',
    branch = 'main',
}

description = {
    summary = 'Сквозная трасса для Tarantool: W3C Trace Context, отрезки, слой входа, крюк клиента HTTP, очередь на выгрузку',
    detailed = [[
        Трасса связывает записи одного запроса на всех узлах, через
        которые он прошёл. Трасса — W3C Trace Context версии 00 с флагом
        случайной трассы: опознаватели трассы и отрезка живут в ключах
        контекста файбера, попадают в каждую запись журнала верхними
        полями trace_id, span_id, trace_flags и уезжают заголовком
        traceparent с исходящими обращениями через context.export().
        tracestate пересылается как пришёл, срезанный по W3C; Baggage
        не берём; нулевых опознавателей не бывает.

        Вход — слой trace.layer для конвейера слоёв и trace.serve для
        вызовов между узлами: продолжение трассы из заголовков и отрезок
        server. Выход — крюк клиента HTTP, который ставит
        trace.install({ http = … }): отрезок client на каждую попытку
        запроса. Клиент приходит аргументом, зависимости от него нет.
        Отрезки — trace.within и ручная пара start/run; выборка
        родительская, корень — долей sample_rate по младшим байтам
        опознавателя. Закрытые отрезки складываются в очередь с потолком,
        откуда их забирает выгрузчик: take(limit) и будильник on_filled.
        Случайность приходит аргументом настройки random с умолчанием
        digest.urandom.

        Зависит от tnt-must (проверки аргументов), tnt-clock (монотонные
        часы длительности), tnt-context (ключи трассы в контексте файбера),
        tnt-log (записи о полной очереди и забытом крюке) и tnt-external
        (подмена часов в проверках). Покрытие строк и убитых мутантов —
        100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-trace',
    issues_url = 'https://github.com/tnt-skein/tnt-trace/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'tracing', 'w3c-trace-context', 'traceparent', 'observability', 'spans' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки настроек, имени отрезка и аргументов на строке вызывающего.
    'tnt-must',
    -- Монотонные часы: длительность отрезка не зависит от перевода стенных.
    'tnt-clock',
    -- Ключи трассы в контексте файбера, область отрезка, заголовки наружу.
    'tnt-context',
    -- Записи о полной очереди и о забытом крюке клиента HTTP.
    'tnt-log',
    -- Подмена часов и признака загруженного модуля в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.trace'] = 'tnt/trace.lua',
        ['tnt.trace.hook'] = 'tnt/trace/hook.lua',
        ['tnt.trace.layer'] = 'tnt/trace/layer.lua',
        ['tnt.trace.queue'] = 'tnt/trace/queue.lua',
        ['tnt.trace.span'] = 'tnt/trace/span.lua',
        ['tnt.trace.w3c'] = 'tnt/trace/w3c.lua',
    },
}

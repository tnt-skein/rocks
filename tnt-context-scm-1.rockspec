rockspec_format = '3.0'

package = 'tnt-context'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-context.git',
    branch = 'main',
}

description = {
    summary = 'Контекст файбера: неизменяемый снимок запроса для журнала, порождённых файберов и соседних узлов',
    detailed = [[
        Контекст — неизменяемый снимок «ключ → скаляр» в хранилище файбера
        под одним ключом. Меняется он только вложенной областью
        context.run(values, fn), и прежний снимок возвращается в любом
        исходе: файбер соединения http.server переживает запрос и отдаёт
        хранилище следующему. В порождённый файбер снимок переносит
        context.bind(fn).

        Ключи объявляет владелец (context.declare): пишется ли ключ
        в журнал, под каким заголовком едет за границу процесса, принимается
        ли из чужих заголовков, какой длины бывает строка. Значения — строки,
        числа и boolean. Встроенный ключ — request_id с заголовком
        x-request-id. За границу процесса снимок едет таблицей заголовков
        context.export(), обратно — context.import(carrier); по net.box —
        последним аргументом вызова: context.carried(args) у вызывающего,
        context.accept(fn) у вызываемого. Журналу поля отдаёт
        context.log_fields().

        Зависимость одна — tnt-must, проверки аргументов. Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-context',
    issues_url = 'https://github.com/tnt-skein/tnt-context/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'context', 'fiber', 'request-id', 'logging', 'tracing' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.context'] = 'tnt/context.lua',
        ['tnt.context.key'] = 'tnt/context/key.lua',
    },
}

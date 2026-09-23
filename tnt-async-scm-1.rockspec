rockspec_format = '3.0'

package = 'tnt-async'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-async.git',
    branch = 'main',
}

description = {
    summary = 'Веер задач: все и дождаться, отображение с пределом, первый успешный, задача без ожидания',
    detailed = [[
        Запускает задачи файберами и ждёт их с одним сроком на группу:
        обход десяти узлов при одном молчащем занимает один срок, а не
        десять. Четыре вызова: all — все и дождаться, map — отображение
        массива с пределом одновременных, any — до первого успеха
        с отменой остальных, spawn — одна задача без ожидания.

        Результаты приходят в порядке входа вместе с отказами: отказ одной
        задачи группу не роняет. Исключение в задаче становится итогом
        raised со стеком и одной записью в журнале, опоздавшая к сроку
        задача — timeout, не начатая в очереди предела — not_started.
        Срок есть всегда, по умолчанию пять секунд; после него задачи
        отменяются и отпускаются, группа возвращается сразу, а брошенные
        файберы не копятся.

        Задача идёт с контекстом вызывающего и с его правами
        (box.session.su): файбер, порождённый из вызова ограниченной
        учётки, иначе работал бы от admin и читал бы то, что вызывающему
        закрыто. Внутри транзакции box ожидающий веер бросает: ожидание
        оборвало бы транзакцию, а задачи пишут мимо неё; задачу после
        фиксации ставят spawn из box.on_commit.

        Зависит от tnt-must (проверки аргументов), tnt-clock (часы срока),
        tnt-context (контекст вызывающего в задаче), tnt-log (запись
        о брошенном и об истёкшем сроке) и tnt-external (подмена файберов,
        часов и прав в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-async',
    issues_url = 'https://github.com/tnt-skein/tnt-async/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'fiber', 'async', 'concurrency', 'fanout', 'timeout' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-clock',
    'tnt-context',
    'tnt-log',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.async'] = 'tnt/async.lua',
        ['tnt.async.group'] = 'tnt/async/group.lua',
        ['tnt.async.task'] = 'tnt/async/task.lua',
    },
}

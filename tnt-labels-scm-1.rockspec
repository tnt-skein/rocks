rockspec_format = '3.0'

package = 'tnt-labels'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-labels.git',
    branch = 'main',
}

description = {
    summary = 'Метки узлов и выборка по ним',
    detailed = [[
        Метка — то, что знает об узле человек, а не кластер: центр данных,
        синхронизация часов, запасной он или боевой. Нужны метки там, где
        правило применимо не ко всем узлам: без них такое правило
        приходится отключать целиком, и вместе с узлами, к которым оно
        не относится, замолкают все остальные.

        labels.match(selector, labels) — подходит ли узел под выборку:
        совпадение по всем названным меткам сразу, пустая выборка
        подходит всем. labels.select(labels_of, selector) — имена
        подходящих узлов по порядку. Отметка labels.ABSENT в выборке
        требует, чтобы метки у узла не было.

        Своего хранилища и своего валидатора нет намеренно: раздел labels
        конфигурации Tarantool 3 объявлен на четырёх уровнях и наследуется
        сверху вниз, а второй источник правды расходится с первым в тот
        день, когда его забывают обновить.

        Зависимостей нет: только то, что встроено в Lua. Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-labels',
    issues_url = 'https://github.com/tnt-skein/tnt-labels/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'cluster', 'labels', 'selector' },
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.labels'] = 'tnt/labels.lua',
    },
}

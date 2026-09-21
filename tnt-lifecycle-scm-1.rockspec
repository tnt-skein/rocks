rockspec_format = '3.0'

package = 'tnt-lifecycle'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-lifecycle.git',
    branch = 'main',
}

description = {
    summary = 'Чем узел занят прямо сейчас',
    detailed = [[
        Состояние старта Tarantool 3.x ведёт сам. Чего ядро не знает —
        занят ли узел прикладной операцией: перечитывает конфигурацию,
        меняет лидерство, восстанавливается после отказа, снимает снимок.
        А знать это обязательно: смена лидера, наложенная на применение
        конфигурации, ломает обе.

        Переходы объявлены таблицей, и недопустимый переход — ошибка,
        а не молчаливая запись. Свободным узел считается по двум
        источникам сразу: наших операций нет и ядро поднялось
        (box.info.status спрашивается при каждом опросе). Наружу
        отдаётся и предыдущее состояние: узел, только что вышедший
        из ошибки, ещё не здоров, а мигающий в момент опроса выглядит
        исправным.

        Сводку о себе узел кладёт полем в зонд диагностики: состояние,
        предыдущее, занят ли, сколько секунд в нынешнем положении, что
        ответило ядро и какой стадии восстановления оно достигло.

        Зависимости: tnt-clock (часы) и tnt-external (подмена часов
        и ядра в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-lifecycle',
    issues_url = 'https://github.com/tnt-skein/tnt-lifecycle/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'lifecycle', 'state-machine', 'cluster', 'health' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-clock',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.lifecycle'] = 'tnt/lifecycle.lua',
    },
}

rockspec_format = '3.0'

package = 'tnt-metrics'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-metrics.git',
    branch = 'main',
}

description = {
    summary = 'Состояние кластера числами в реестре встроенного metrics',
    detailed = [[
        Обход кластера знает о нём всё, что нужно снаружи, но рассказывает
        об этом только тому, кто спросит. Сборщик метрик и дежурный алерт
        не спрашивают — они читают выкладку узла. Здесь то же знание
        выложено числами: сколько узлов знает обход и сколько молчит,
        сколько репликасетов с писателем, сколько находок и какого веса,
        и — главное — сколько секунд назад делался обход.

        Выкладку печатает не пакет: числа кладутся калибрами в реестр
        metrics, вшитого в Tarantool 3.8, обновляются обработчиком сбора
        перед каждой выкладкой и уходят сборщику его же плагинами
        Prometheus, Graphite и JSON — с глобальными метками и фильтрами
        раздела metrics конфигурации. Чужой договор отказов реестра пакет
        прячет под pcall и отдаёт парой nil, err, а обработчик сбора
        не бросает никогда: бросивший, он уронил бы всю выкладку узла.

        Метрики самого узла пакет не собирает: их даёт тот же metrics.
        Здесь только то, чего не знает ни один узел в отдельности, —
        состояние кластера целиком.

        Зависит от tnt-clock (монотонные часы для возраста снимка),
        tnt-log (журнал отказов обработчика сбора) и tnt-external (подмена
        часов и реестра в проверках); metrics — модуль ядра, а не рок.
        Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-metrics',
    issues_url = 'https://github.com/tnt-skein/tnt-metrics/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'metrics', 'prometheus', 'monitoring', 'cluster' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-clock',
    'tnt-log',
    'tnt-external',
    -- metrics в зависимостях нет: он вшит в бинарник Tarantool 3.8.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.metrics'] = 'tnt/metrics.lua',
    },
}

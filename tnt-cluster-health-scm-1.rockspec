rockspec_format = '3.0'

package = 'tnt-cluster-health'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-cluster-health.git',
    branch = 'main',
}

description = {
    summary = 'Диагностика кластера Tarantool: опрос узлов и правила разбора',
    detailed = [[
        Обходит инстансы кластера, объявленные конфигурацией, снимает
        с каждого сводку о состоянии и разбирает снимок правилами, которые
        сообщают о найденных проблемах: узел молчит, репликация оборвана
        или отстаёт, память кончается, часы разошлись, конфигурация
        применена не та или застряла, в репликасете нет пишущего узла
        или их два, диск отказал.

        Узлы опрашиваются вызовом зарегистрированной функции-зонда,
        а не удалённым исполнением кода: наблюдателю достаточно права
        вызвать зонд, и он не получает ни чтения данных, ни выполнения
        команд. Соседи спрашиваются одновременно с общим сроком, и один
        молчащий узел не растягивает обход на срок каждого. Перемену
        режима записи сосед сообщает толчком через событие box.status,
        и обход идёт вне очереди.

        Состав зонда и набор правил расширяются: пакет, которому есть что
        рассказать о себе, добавляет своё поле в зонд и своё правило
        в реестр, а диагностика переживает его отсутствие.

        Зависит от tnt-async (веер вызовов с общим сроком), tnt-clock
        (часы), tnt-collection (устойчивый порядок находок и узлов),
        tnt-context (перенос контекста к соседям), tnt-fingerprint
        (отпечаток конфигурации), tnt-labels (отбор по меткам), tnt-log
        (журнал без повторов), tnt-loop (цикл обхода) и tnt-external
        (подмена часов, сети и конфигурации в проверках). Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-cluster-health',
    issues_url = 'https://github.com/tnt-skein/tnt-cluster-health/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'cluster', 'health', 'diagnostics', 'monitoring', 'replication' },
}

dependencies = {
    'lua >= 5.1',
    -- Веер вызовов: каждый сосед спрашивается своей задачей с остатком
    -- общего срока.
    'tnt-async',
    -- Стенные и монотонные часы и время планировщика.
    'tnt-clock',
    -- Словари по порядку имён, устойчивая сортировка находок и узлов,
    -- раскладка узлов по репликасетам.
    'tnt-collection',
    -- Перенос контекста вызывающего к соседям последним аргументом вызова.
    'tnt-context',
    -- Отпечаток общих секций конфигурации: по нему видно расхождение.
    'tnt-fingerprint',
    -- Отбор узлов по меткам: приглушение правил и отбор по конфигурации.
    'tnt-labels',
    -- Журнал без повторов: молчащий узел не пишет строку на каждом обходе.
    'tnt-log',
    -- Цикл обхода с периодом и побудкой толчком.
    'tnt-loop',
    -- Внешние зависимости: часы, конфигурация, net.box, box в проверках.
    'tnt-external',
    -- Не объявлен `tnt-remedy`: подсказки берутся по имени через
    -- `pcall(require, 'tnt.remedy')`, и без пакета `suggestions()` пуст.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.cluster'] = 'tnt/cluster.lua',
        ['tnt.cluster.probe'] = 'tnt/cluster/probe.lua',
        ['tnt.cluster.state'] = 'tnt/cluster/state.lua',
        ['tnt.cluster.issues'] = 'tnt/cluster/issues.lua',
        ['tnt.cluster.rules'] = 'tnt/cluster/rules.lua',
        ['tnt.cluster.poller'] = 'tnt/cluster/poller.lua',
        ['tnt.cluster.pool'] = 'tnt/cluster/pool.lua',
        ['tnt.cluster.fanout'] = 'tnt/cluster/fanout.lua',
    },
}

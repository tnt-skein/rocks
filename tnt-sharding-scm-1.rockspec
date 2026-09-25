rockspec_format = '3.0'

package = 'tnt-sharding'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-sharding.git',
    branch = 'main',
}

description = {
    summary = 'Шардирование vshard снаружи: рассказ узла, находки о бакетах и действия оператора',
    detailed = [[
        vshard знает о себе много, но рассказывает об этом только тому,
        кто пришёл на узел: vshard.storage.info() и vshard.router.info() —
        местные вызовы. Диагностике кластера нужен другой взгляд: разложены
        ли бакеты вообще, все ли они на месте, не идёт ли перенос и не
        застрял ли он, что vshard сам заключил о каждом узле и есть ли
        кому переносить бакеты.

        Пакет состоит из двух половин. Узел рассказывает о себе зонду
        коротким снимком — числа бакетов, вес, замок, режим
        ребалансировщика, роли кластера и вывод vshard о каждой половине
        узла. Правило разбора складывает рассказы в находки о кластере,
        о репликасетах и об узлах: не разложено, недостаёт, узлы разошлись
        в числе бакетов, перенос или сборка стоят дольше срока, перекос,
        вывод репликасета весом 0, замок, ребалансировщик выключен или
        потерян. Кластер без шардирования молчит: поля в зонде просто нет.

        Рядом — два действия оператора глобальными функциями: разложить
        бакеты и включить или выключить ребалансировщик. vshard
        подключается при вызове, а не при загрузке, поэтому в кластере
        без него пакет не падает.

        Зависимости: tnt-clock, tnt-log и tnt-external. Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-sharding',
    issues_url = 'https://github.com/tnt-skein/tnt-sharding/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'vshard', 'sharding', 'diagnostics', 'monitoring' },
}

dependencies = {
    'lua >= 5.1',
    -- Монотонные часы: срок застрявшего переноса и вставшей сборки.
    'tnt-clock',
    -- Журнал действий оператора.
    'tnt-log',
    -- Подмена vshard, конфигурации и часов в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.sharding'] = 'tnt/sharding.lua',
        ['tnt.sharding.state'] = 'tnt/sharding/state.lua',
        ['tnt.sharding.ownership'] = 'tnt/sharding/ownership.lua',
        ['tnt.sharding.stall'] = 'tnt/sharding/stall.lua',
        ['tnt.sharding.tally'] = 'tnt/sharding/tally.lua',
        ['tnt.sharding.nodes'] = 'tnt/sharding/nodes.lua',
        ['tnt.sharding.diagnosis'] = 'tnt/sharding/diagnosis.lua',
        ['tnt.sharding.actions'] = 'tnt/sharding/actions.lua',
    },
}

rockspec_format = '3.0'

package = 'tnt-recovery'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-recovery.git',
    branch = 'main',
}

description = {
    summary = 'Восстановление кластера Tarantool: оценка риска и ворота перед аварийным действием',
    detailed = [[
        Аварийные действия отличаются от обычных тем, что ошибка в них
        необратима: перехват лидерства у узла, ушедшего вперёд, стирает
        подтверждённые записи. Поэтому каждое действие сначала оценивается
        по живому снимку кластера, и класс риска — свойство не действия,
        а состояния: один и тот же перехват безопасен, когда кандидат
        содержит в себе журнал прежнего лидера, и опасен, когда отстал.

        Оценка говорит с оператором: что произойдёт, чем это грозит, что
        сделать руками до и вместо, какие требования не выполнены. Ворота
        перед применением решают одно — пускать ли — и различают три
        причины отказа: состояние изменилось с тех пор, как оценку
        показали (отпечаток), не выполнено требование, нет подтверждения
        словом. Оценка и ворота чистые: ни box, ни сети, ни часов.

        Разобраны четыре беды — раздвоение журналов, потеря кворума,
        застрявший узел и лидерство, которое некому взять, — а ещё
        повреждённый журнал (обход цепочки xlog, оценка и уборка файла
        переименованием) и допуск узла к запуску, когда данные в каталоге
        не сходятся с конфигурацией. Про каждую беду пакет отвечает не
        «как чинить», а «что именно будет потеряно»; выполняет действие
        тот, кто умеет ходить к узлам.

        Зависимости: tnt-collection, tnt-disk, tnt-fencing,
        tnt-fingerprint и tnt-external. Покрытие строк и убитых мутантов —
        100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-recovery',
    issues_url = 'https://github.com/tnt-skein/tnt-recovery/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'recovery', 'replication', 'wal', 'operations' },
}

dependencies = {
    'lua >= 5.1',
    -- Имена узлов по порядку, с отбором по записи узла.
    'tnt-collection',
    -- Каталоги узла, заголовок и записи журнала, переименование файла.
    'tnt-disk',
    -- Сравнение счётчиков: содержит ли журнал одного узла журнал другого.
    'tnt-fencing',
    -- Отпечаток состояния, по которому оператор подтверждает оценку.
    'tnt-fingerprint',
    -- Подмена уступки управления в проверках обхода журналов.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.recovery.group'] = 'tnt/recovery/group.lua',
        ['tnt.recovery.risk'] = 'tnt/recovery/risk.lua',
        ['tnt.recovery.gate'] = 'tnt/recovery/gate.lua',
        ['tnt.recovery.wal'] = 'tnt/recovery/wal.lua',
        ['tnt.recovery.startup'] = 'tnt/recovery/startup.lua',
        ['tnt.recovery.takeover'] = 'tnt/recovery/takeover.lua',
        ['tnt.recovery.quorum'] = 'tnt/recovery/quorum.lua',
        ['tnt.recovery.split_brain'] = 'tnt/recovery/split_brain.lua',
        ['tnt.recovery.orphan'] = 'tnt/recovery/orphan.lua',
    },
}

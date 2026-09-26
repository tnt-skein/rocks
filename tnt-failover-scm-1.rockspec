-- Формат 3.0: в нём есть test_dependencies — зависимости проверок,
-- которые не ставятся тому, кто берёт пакет для дела.
rockspec_format = '3.0'

package = 'tnt-failover'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-failover.git',
    branch = 'main',
}

description = {
    summary = 'Координатор смены лидера для Tarantool 3.x Community: выбор кандидата и раскладка решений',
    detailed = [[
        В Tarantool Community ядро в режиме replication.failover: supervised
        отдаёт лидерство внешнему агенту, а самого агента нет. Пакет его
        даёт: координатор живёт внутри каждого инстанса, место занимает
        один — ключом в etcd под арендой, — выбирает лидера каждому
        репликасету и пишет назначение. Наблюдатель на каждом узле читает
        назначение и приводит свой инстанс к роли.

        Место освобождается само, как только координатор перестаёт
        продлевать аренду. Назначения пишутся под ревизией ключа места:
        опоздавший координатор не может перезаписать чужое решение.

        Выбор кандидата — чистые функции с обоснованием по каждому узлу:
        отставание считается по векторному счётчику, а не по полю с готовым
        числом секунд, которого в box.info попросту нет. Смену держат
        выдержка, предел шторма и срок неисполненного назначения.

        Настройки берутся из штатного раздела failover конфигурации
        Tarantool: сроки, приоритеты, неизбираемые узлы, синхронная
        модель. Точка HTTP с рядами координатора описывается разделами
        failover.http и failover.metrics.exporters (prometheus, zabbix,
        telegraf, json); в Community их открывает расширение
        tnt.failover.extension из TNT_CE_EXTENSIONS, а сервер —
        необязательный рок http.

        Хранилище решений и снимок кластера пакет получает аргументами.
        Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-failover',
    issues_url = 'https://github.com/tnt-skein/tnt-failover/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'failover', 'leader', 'etcd', 'cluster' },
}

dependencies = {
    'lua >= 5.1',
    -- Негодный аргумент настройки — ошибка программиста: нулевая задержка
    -- возврата лидерства отвергается броском, а не принимается молча.
    'tnt-must',
    -- Расширение открывает разделы failover.http и failover.metrics
    -- в схеме Community: без каркаса ядро отвергло бы их как Enterprise.
    'tnt-ce-extras',
    -- Сроки аренды, выдержки и шторма — по монотонным часам.
    'tnt-clock',
    -- Репликасеты и метки по порядку, кандидаты по имени.
    'tnt-collection',
    -- Сравнение векторных счётчиков и решение об ограждении.
    'tnt-fencing',
    -- Роль узла: применение назначения и передача лидерства.
    'tnt-leadership',
    'tnt-log',
    -- Такты координатора, наблюдателя и повтора подъёма точки HTTP.
    'tnt-loop',
    -- Цена подъёма вслепую и ворота опасного действия.
    'tnt-recovery',
    -- Внешние зависимости — box, часы, конфигурация, рок http — подменяются
    -- в проверках.
    'tnt-external',
}

-- Настоящий клиент нужен только проверкам: сам пакет получает
-- его аргументом, а не через require.
test_dependencies = {
    'tnt-etcd-client',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.failover'] = 'tnt/failover.lua',
        ['tnt.failover.keys'] = 'tnt/failover/keys.lua',
        ['tnt.failover.coordinator'] = 'tnt/failover/coordinator.lua',
        ['tnt.failover.candidate'] = 'tnt/failover/candidate.lua',
        ['tnt.failover.election'] = 'tnt/failover/election.lua',
        ['tnt.failover.agent'] = 'tnt/failover/agent.lua',
        ['tnt.failover.appointments'] = 'tnt/failover/appointments.lua',
        ['tnt.failover.promotion'] = 'tnt/failover/promotion.lua',
        ['tnt.failover.diagnosis'] = 'tnt/failover/diagnosis.lua',
        ['tnt.failover.metrics'] = 'tnt/failover/metrics.lua',
        ['tnt.failover.listen'] = 'tnt/failover/listen.lua',
        ['tnt.failover.exporters'] = 'tnt/failover/exporters.lua',
        ['tnt.failover.extension'] = 'tnt/failover/extension.lua',
    },
}

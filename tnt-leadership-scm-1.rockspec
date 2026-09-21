rockspec_format = '3.0'

package = 'tnt-leadership'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-leadership.git',
    branch = 'main',
}

description = {
    summary = 'Применение назначений лидера на узле Tarantool',
    detailed = [[
        Приводит узел к назначенной роли — лидер, ведомый, ограждённый —
        и следит за тем, чтобы у репликасета не оказалось двух писателей.
        Кто назначает лидера, пакету всё равно: назначение приходит
        аргументом, а пакет решает, кем узлу стать, и применяет решение.

        Поддерживаются обе модели репликации, и различие между ними
        не в удобстве: в асинхронной защита от двух писателей — запрет
        записи, в синхронной — владение очередью и кворум. Модель берётся
        из штатной настройки failover.replicasets.<имя>.synchro_mode,
        из которой Tarantool сам выводит режим выборов.

        Решения — чистые функции без обращений к box, сети и часам,
        поэтому проверяются без кластера. Само применение вынесено
        отдельно и следит за порядком вызовов: поднятие узла, которому
        ещё запрещена запись, завершается отказом, успев забрать очередь.
        Передача лидерства спрашивает у прежнего лидера, докуда тот
        дописал, и не поднимает новый узел, пока он не догонит.

        Зависимости: tnt-clock (пауза между попытками), tnt-fencing
        (решения об ограждении и сравнение счётчиков), tnt-external
        (подмена box и сети в проверках). Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-leadership',
    issues_url = 'https://github.com/tnt-skein/tnt-leadership/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'replication', 'failover', 'leadership', 'fencing' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-clock',
    'tnt-fencing',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.leadership.mode'] = 'tnt/leadership/mode.lua',
        ['tnt.leadership.state'] = 'tnt/leadership/state.lua',
        ['tnt.leadership.target'] = 'tnt/leadership/target.lua',
        ['tnt.leadership.apply'] = 'tnt/leadership/apply.lua',
        ['tnt.leadership.handover'] = 'tnt/leadership/handover.lua',
    },
}

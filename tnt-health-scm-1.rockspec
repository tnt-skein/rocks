rockspec_format = '3.0'

package = 'tnt-health'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-health.git',
    branch = 'main',
}

description = {
    summary = 'Пробы узла Tarantool для оркестратора: жив, готов, поднялся',
    detailed = [[
        Три пробы различаются не техникой, а тем, что делает оркестратор
        при отказе: перезапустить узел, снять его с балансировки или
        подождать. Смешать их легко, а стоит это дорого ровно в одну
        сторону — проба «жив», проверяющая готовность, перезапускает
        кластер в тот момент, когда ему нужнее всего покой. Поэтому
        у каждой пробы свой список того, что она читает, и отдельно
        названо, чего в ней нет и почему.

        Снимок узла собирается только на самом узле, под pcall и без
        хождения к соседям: неизвестное значит «годится». Сторожевой
        такт отмечает, что цикл событий крутится, и заранее считает
        вердикт для встроенного реестра проверок Tarantool 3 — отказ
        пробы становится предупреждением конфигурации, а не прошедшие
        встроенные проверки отказывают пробе готовности. Роутер vshard
        уходит из балансировки, если молчит о бакетах или не может
        до них достучаться.

        Роль tnt.health.role вешает маршруты на сервер из roles.httpd
        и принимает вывод узла из эксплуатации полем конфигурации. Без
        HTTP те же пробы публикуются глобальными функциями для iproto.
        Необязательный рок watchdog даёт аварийного сторожа: процесс,
        у которого цикл событий встал без единой уступки, роняется
        по сроку abort_after.

        Зависимости: tnt-clock, tnt-loop, tnt-log, tnt-external,
        tnt-lifecycle, tnt-sharding и рок http. Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-health',
    issues_url = 'https://github.com/tnt-skein/tnt-health/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'health', 'liveness', 'readiness', 'kubernetes', 'vshard' },
}

dependencies = {
    'lua >= 5.1',
    -- Монотонные часы: возраст отметки сторожевого такта.
    'tnt-clock',
    -- Сторожевой такт: отметка жизни и вердикт для встроенного реестра.
    'tnt-loop',
    -- Журнал сломанного такта и сломанной пробы.
    'tnt-log',
    -- Подмена часов, снимка узла и рока watchdog в проверках.
    'tnt-external',
    -- Занят ли узел своей операцией и не восстанавливается ли он.
    'tnt-lifecycle',
    -- Что роутер знает о бакетах и объявлен ли узел роутером.
    'tnt-sharding',
    -- Сервер roles.httpd: роль вешает на него маршруты проб.
    'http',
    -- Необязательно и здесь не объявлено: рок `watchdog` (модуль
    -- `watchdog`) даёт аварийного сторожа `abort_after`, а без него
    -- пакет работает как прежде. Ставится целью `make deps-watchdog`.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.health'] = 'tnt/health.lua',
        ['tnt.health.probes'] = 'tnt/health/probes.lua',
        ['tnt.health.observation'] = 'tnt/health/observation.lua',
        ['tnt.health.abort'] = 'tnt/health/abort.lua',
        ['tnt.health.role'] = 'tnt/health/role.lua',
    },
}

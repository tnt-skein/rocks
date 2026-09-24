rockspec_format = '3.0'

package = 'tnt-downtime'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-downtime.git',
    branch = 'main',
}

description = {
    summary = 'Режим обслуживания: приложение отвечает 503, пока идут работы',
    detailed = [[
        Выкатка, миграция, восстановление после аварии — время, когда
        приложение должно честно сказать клиентам «закрыто, приходите
        через две минуты», а не отвечать вперемешку старым и новым.

        Переключатель — файл: он переживает перезапуск узла, виден
        каждому, кто откроет каталог, и ставится рукой, когда до консоли
        не добраться. Пустой, испорченный и нечитаемый файл — тоже
        «закрыто», только с умолчаниями. Слой HTTP вида (request, next)
        отвечает закрытому приложению отказом парой nil, err — статус,
        слово, код DOWNTIME и Retry-After, — пропуская пути исключений
        и запросы с кукой обхода, которую ставит переход по тайне.

        Зависит от tnt-cookie (кука обхода), tnt-clock (стенные часы
        отметки закрытия) и tnt-must (отказ настройки без места
        в коде). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-downtime',
    issues_url = 'https://github.com/tnt-skein/tnt-downtime/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'maintenance', 'http', 'middleware', 'deployment' },
}

dependencies = {
    'lua >= 5.1',
    -- Отказ настройки без места в коде.
    'tnt-must',
    -- Стенные часы отметки закрытия.
    'tnt-clock',
    -- Сборка куки обхода и разбор заголовка Cookie.
    'tnt-cookie',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.downtime'] = 'tnt/downtime.lua',
    },
}

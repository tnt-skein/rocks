rockspec_format = '3.0'

package = 'tnt-webauth'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-webauth.git',
    branch = 'main',
}

description = {
    summary = 'Пароли, подписанные сессии и счёт попыток для входа в панель',
    detailed = [[
        Вход в панель, которая отвечает с любого узла кластера и нужнее
        всего во время аварии: пароль проверяется растянутым хешем,
        сессия — подписанная cookie без хранилища, перебор считается
        в памяти. Спейсов и репликации вход не касается: где лежит запись
        о пароле и кто такой пользователь, решает приложение.

        Пароли хранятся записью PBKDF2 со своей солью на каждый пароль
        и числом проходов внутри записи: когда настройку поднимут, старые
        записи проверяются по-старому, а пересчитываются при следующем
        входе. Хеш и подпись сравниваются за постоянное время.

        Сессия подписана отдельным ключом и нигде не хранится: любой узел
        проверяет cookie, выданную любым другим. Сроков два — жизнь
        и продление, — а поле версии отзывает все сессии пользователя
        при смене пароля.

        Неверные догадки считаются по учётной записи и по адресу сразу,
        запрет удваивается до предела, повтор того же неверного пароля
        попыткой не считается, а таблица счётчиков не растёт выше потолка.

        Зависимости: tnt-clock (монотонные часы для счёта попыток)
        и tnt-external (подмена часов и соли в проверках). Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-webauth',
    issues_url = 'https://github.com/tnt-skein/tnt-webauth/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'auth', 'password', 'session', 'pbkdf2', 'brute-force' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-clock',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.webauth.constant'] = 'tnt/webauth/constant.lua',
        ['tnt.webauth.password'] = 'tnt/webauth/password.lua',
        ['tnt.webauth.session'] = 'tnt/webauth/session.lua',
        ['tnt.webauth.attempts'] = 'tnt/webauth/attempts.lua',
    },
}

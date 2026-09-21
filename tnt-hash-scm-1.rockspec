rockspec_format = '3.0'

package = 'tnt-hash'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-hash.git',
    branch = 'main',
}

description = {
    summary = 'Хеши, HMAC и пароли фасадом поверх встроенных digest и crypto',
    detailed = [[
        Работу делают встроенные digest и crypto Tarantool, пакет даёт то,
        чего у них нет. Одно место на алгоритм: свёртка целиком живёт
        в digest, HMAC и поток — в crypto, а здесь алгоритм — имя, вид
        итога — аргумент (hex, raw, base64 без переносов, base64url без
        набивки), и опечатка в имени — бросок со списком известных.
        Сверка подписи за постоянное время: hmac_verify и equals. Свёртка
        и HMAC потоком для данных, которые приходят кусками.

        Пароли — PBKDF2-HMAC-SHA256 со своей солью и числом проходов
        в записи, с обходом того, что digest.pbkdf2 режет пароль и соль
        по нулевому байту; внутри транзакции box растягивание бросает,
        а не обрывает её молча.

        Зависит от tnt-must (проверки аргументов) и tnt-external (внешние
        зависимости и их подмена в проверках). Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-hash',
    issues_url = 'https://github.com/tnt-skein/tnt-hash/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'hash', 'hmac', 'password', 'pbkdf2' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.hash'] = 'tnt/hash.lua',
        ['tnt.hash.algorithm'] = 'tnt/hash/algorithm.lua',
        ['tnt.hash.compare'] = 'tnt/hash/compare.lua',
        ['tnt.hash.compute'] = 'tnt/hash/compute.lua',
        ['tnt.hash.encoding'] = 'tnt/hash/encoding.lua',
        ['tnt.hash.password'] = 'tnt/hash/password.lua',
        ['tnt.hash.stream'] = 'tnt/hash/stream.lua',
    },
}

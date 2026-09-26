rockspec_format = '3.0'

package = 'tnt-jwt'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-jwt.git',
    branch = 'main',
}

description = {
    summary = 'Подписанные токены JWT: выпуск и строгая сверка HS256, HS384, HS512 с набором ключей',
    detailed = [[
        Выпуск и сверка JWS в компактной записи по RFC 7515 и RFC 7519.
        Подпись — HMAC-SHA2 из tnt-hash, сверка за постоянное время.
        Алгоритм объявляется вместе с ключом, и токен с другим alg — отказ;
        none не принимается никогда. Ключи — набором по kid: нынешний
        подписывает, прежние только сверяют, и ключ меняют без отказа
        выданным токенам.

        Сверка строгая: предел длины до разбора, base64url одной записью,
        заголовок и утверждения — объекты JSON без nan и бесконечностей,
        утверждения разбираются только после подписи. Выдавший iss —
        точным совпадением, свой адресат в aud, срок exp обязателен,
        exp, nbf и iat — с допуском на расхождение часов, вид sub, amr,
        auth_time и прочих зарегистрированных утверждений проверяется.
        Негодный токен — отказ парой с родом: malformed, forged, invalid,
        expired, premature.

        О личности пакет не знает: он отдаёт утверждения проверенного
        токена. Зависит от tnt-hash (HMAC и сверка), tnt-must (проверки
        аргументов), tnt-clock (стенные часы) и tnt-external (подмена
        часов в проверках).
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-jwt',
    issues_url = 'https://github.com/tnt-skein/tnt-jwt/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'jwt', 'jws', 'token', 'hmac', 'authentication' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки настроек и утверждений выпуска на строке вызывающего.
    'tnt-must',
    -- HMAC-SHA2 подписи и её сверка за постоянное время.
    'tnt-hash',
    -- Стенные часы: отметки iat и exp и сверка сроков.
    'tnt-clock',
    -- Подмена часов в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.jwt'] = 'tnt/jwt.lua',
        ['tnt.jwt.algorithm'] = 'tnt/jwt/algorithm.lua',
        ['tnt.jwt.claims'] = 'tnt/jwt/claims.lua',
        ['tnt.jwt.clock'] = 'tnt/jwt/clock.lua',
        ['tnt.jwt.compact'] = 'tnt/jwt/compact.lua',
        ['tnt.jwt.failure'] = 'tnt/jwt/failure.lua',
        ['tnt.jwt.keyring'] = 'tnt/jwt/keyring.lua',
        ['tnt.jwt.tokens'] = 'tnt/jwt/tokens.lua',
        ['tnt.jwt.verify'] = 'tnt/jwt/verify.lua',
    },
}

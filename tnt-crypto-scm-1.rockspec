rockspec_format = '3.0'

package = 'tnt-crypto'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-crypto.git',
    branch = 'main',
}

description = {
    summary = 'Шифрование с проверкой целостности и проверка подписи открытым ключом',
    detailed = [[
        Шифр делает встроенный crypto (AES-CBC), подпись — HMAC из tnt-hash;
        пакет склеивает их в шифрование с проверкой целостности по RFC 7518,
        §5.2 (A128CBC-HS256, A192CBC-HS384, A256CBC-HS512): метка сверяется
        до расшифровки, и чужая или испорченная шифровка — отказ парой,
        а не мусор и не исключение OpenSSL.

        Шифровальщик с прежними ключами для их смены без потери выданного,
        присоединённые данные, которые привязывают шифровку к месту,
        шифровка строкой base64url без набивки со строгим разбором. Ключи:
        свежий случайный по длине алгоритма и выведенный из одного секрета
        приложения по назначению (HKDF-SHA256, RFC 5869).

        Проверка подписи открытым ключом алгоритмами JWS (RFC 7518, §3):
        RS256…RS512, PS256…PS512, ES256…ES512 и EdDSA. Во встроенном crypto
        её нет, поэтому она идёт через FFI к OpenSSL 3, загруженной
        загрузчиком tnt-tls; род ключа сверяется с алгоритмом, подпись ECDSA
        ждётся записью JWS, ответ — true, false либо nil, err.

        Зависимости: tnt-hash (HMAC и сверка метки за постоянное время),
        tnt-must (проверки аргументов), tnt-tls (загрузка OpenSSL и её
        очередь ошибок) и tnt-external (подмена случайных байтов и загрузки
        OpenSSL в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-crypto',
    issues_url = 'https://github.com/tnt-skein/tnt-crypto/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'crypto', 'encryption', 'aes', 'hmac', 'hkdf', 'jwe', 'jws', 'rsa', 'ecdsa', 'eddsa' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-hash',
    'tnt-tls',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.crypto'] = 'tnt/crypto.lua',
        ['tnt.crypto.aead'] = 'tnt/crypto/aead.lua',
        ['tnt.crypto.algorithm'] = 'tnt/crypto/algorithm.lua',
        ['tnt.crypto.ecdsa'] = 'tnt/crypto/ecdsa.lua',
        ['tnt.crypto.encrypter'] = 'tnt/crypto/encrypter.lua',
        ['tnt.crypto.key'] = 'tnt/crypto/key.lua',
        ['tnt.crypto.openssl'] = 'tnt/crypto/openssl.lua',
        ['tnt.crypto.random'] = 'tnt/crypto/random.lua',
        ['tnt.crypto.signature'] = 'tnt/crypto/signature.lua',
    },
}

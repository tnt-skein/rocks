rockspec_format = '3.0'

package = 'tnt-crypto'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-crypto.git',
    branch = 'main',
}

description = {
    summary = 'Шифрование с проверкой целостности фасадом поверх встроенного crypto',
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

        Зависимости: tnt-hash (HMAC и сверка метки за постоянное время),
        tnt-must (проверки аргументов) и tnt-external (подмена случайных
        байтов в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-crypto',
    issues_url = 'https://github.com/tnt-skein/tnt-crypto/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'crypto', 'encryption', 'aes', 'hmac', 'hkdf', 'jwe' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-hash',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.crypto'] = 'tnt/crypto.lua',
        ['tnt.crypto.aead'] = 'tnt/crypto/aead.lua',
        ['tnt.crypto.algorithm'] = 'tnt/crypto/algorithm.lua',
        ['tnt.crypto.encrypter'] = 'tnt/crypto/encrypter.lua',
        ['tnt.crypto.key'] = 'tnt/crypto/key.lua',
        ['tnt.crypto.random'] = 'tnt/crypto/random.lua',
    },
}

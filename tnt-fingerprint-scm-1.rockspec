rockspec_format = '3.0'

package = 'tnt-fingerprint'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-fingerprint.git',
    branch = 'main',
}

description = {
    summary = 'Устойчивый отпечаток таблицы',
    detailed = [[
        Короткая строка, одинаковая у равных таблиц независимо от того,
        в каком порядке они легли в память. Нужна там, где две структуры
        надо сравнить, не пересылая их целиком: одинакова ли конфигурация
        на двух узлах, не побилась ли запись в хранилище, изменилось ли
        что-нибудь с прошлого раза.

        Ключи сортируются, тип каждого значения входит в отпечаток, части
        разделены: без этого одна и та же таблица давала бы разные
        отпечатки от вызова к вызову, а две разные — один. Свёртка идёт
        потоком, и большая конфигурация не поднимается в память второй раз.

        Способов свёртки два: crc32 — заметить изменение, sha256 —
        доказать совпадение чужих друг другу структур. fingerprint.of_parts
        сворачивает именованные части в заданном порядке и не даёт
        отпечатка пустоте.

        Зависимостей нет: только crypto и digest, встроенные в Tarantool.
        Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-fingerprint',
    issues_url = 'https://github.com/tnt-skein/tnt-fingerprint/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'fingerprint', 'checksum', 'hash', 'digest' },
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.fingerprint'] = 'tnt/fingerprint.lua',
    },
}

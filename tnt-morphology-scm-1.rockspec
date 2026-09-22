rockspec_format = '3.0'

package = 'tnt-morphology'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-morphology.git',
    branch = 'main',
}

description = {
    summary = 'Морфология для поиска: нормализация текста и основа слова по Snowball',
    detailed = [[
        Поиск без морфологии не находит: по запросу «узел» не выходят
        «узлы» и «узлами», а по «running» — «run». Пакет приводит слово
        к основе алгоритмами Snowball для русского и английского
        и готовит текст к обратному индексу: нормализация (нижний
        регистр, «е» вместо «ё», прямой апостроф), разбиение на слова,
        отбор стоп-слов и основа каждого слова.

        Язык определяется у каждого слова отдельно, по письменности:
        в «кластер Tarantool» русское слово и английское, и общий язык
        на весь текст был бы неверен для одного из них. Слово, чья
        письменность пакету незнакома — цифры, «café», иероглифы, —
        идёт в индекс как есть.

        Настроек и состояния у пакета нет: ни configure, ни new.
        Внешних средств он не берёт вовсе — ни часов, ни сети, ни box.
        Отказа парой nil, err тоже нет: у «привести слово к основе»
        нет исхода «не вышло», — зато ошибка программиста роняет вызов
        на месте.

        Стеммеры сверены с официальными словарями Snowball: 49 785
        русских слов и 42 649 английских приводятся к основе дословно
        так же. Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-morphology',
    issues_url = 'https://github.com/tnt-skein/tnt-morphology/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'morphology', 'stemmer', 'snowball', 'search', 'russian' },
}

dependencies = {
    'lua >= 5.1',
    -- Бросок без места: ошибка программиста читается текстом целиком.
    'tnt-must',
    -- Обход строки по знакам: он уже написан и знает про битые байты.
    'tnt-str',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.morphology'] = 'tnt/morphology.lua',
        ['tnt.morphology.english'] = 'tnt/morphology/english.lua',
        ['tnt.morphology.russian'] = 'tnt/morphology/russian.lua',
        ['tnt.morphology.stop'] = 'tnt/morphology/stop.lua',
        ['tnt.morphology.text'] = 'tnt/morphology/text.lua',
        ['tnt.morphology.word'] = 'tnt/morphology/word.lua',
    },
}

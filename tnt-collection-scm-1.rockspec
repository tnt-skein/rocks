rockspec_format = '3.0'

package = 'tnt-collection'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-collection.git',
    branch = 'main',
}

description = {
    summary = 'Списки и словари: устойчивая сортировка, группировка, путь, слияние, вид в JSON',
    detailed = [[
        Списки и словари для Tarantool — то, чего нет во встроенном `fun`.
        Ленивые `map`, `filter`, `reduce`, `take`, `zip`, `chain` в Tarantool
        уже есть, и пакет их не переписывает; но и фасадом над `fun` он
        не стал: всё, что в нём есть, написано своими простыми циклами,
        а из `fun` взяты только звенья цепочки `of(…)`.

        Главное — устойчивая сортировка по ключу: `table.sort` переставляет
        элементы с равным ключом как попало, и панель мигает строками без
        единого изменения в кластере; на ключах разного рода она падает
        с «attempt to compare», а на негодном сравнении — с «invalid order
        function». Здесь порядок устойчив, элементы без ключа уходят
        в хвост, а разнородные ключи названы в отказе с номерами элементов.

        Сверх того: группировка и указатели, доступ по пути
        `get(cfg, 'replicasets.main.instances', {})` с `box.NULL` как
        отсутствием, мелкое и глубокое слияние настроек, словари
        по порядку ключей и различение списка и словаря: пустая таблица
        уезжает в JSON списком `[]`, и пустой словарь надо помечать.
        Кортежи из `select` проходимы по полям, а uuid, decimal
        и 64-битные целые сравниваются по значению, а не по адресу.

        Цепочка `of(list):…:value()` есть, но собирает таблицу на каждом
        звене; в горячем пути дешевле простые функции, а дешевле всех —
        ручной цикл.

        Зависимость одна — `tnt-must`, для текстов отказов. Покрытие
        строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-collection',
    issues_url = 'https://github.com/tnt-skein/tnt-collection/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'collections', 'sort', 'stable-sort', 'json', 'config' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.collection'] = 'tnt/collection.lua',
        ['tnt.collection.aggregate'] = 'tnt/collection/aggregate.lua',
        ['tnt.collection.chain'] = 'tnt/collection/chain.lua',
        ['tnt.collection.dict'] = 'tnt/collection/dict.lua',
        ['tnt.collection.group'] = 'tnt/collection/group.lua',
        ['tnt.collection.kind'] = 'tnt/collection/kind.lua',
        ['tnt.collection.list'] = 'tnt/collection/list.lua',
        ['tnt.collection.merge'] = 'tnt/collection/merge.lua',
        ['tnt.collection.order'] = 'tnt/collection/order.lua',
        ['tnt.collection.guard'] = 'tnt/collection/guard.lua',
        ['tnt.collection.path'] = 'tnt/collection/path.lua',
        ['tnt.collection.sort'] = 'tnt/collection/sort.lua',
        ['tnt.collection.value'] = 'tnt/collection/value.lua',
    },
}

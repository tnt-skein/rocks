rockspec_format = '3.0'

package = 'tnt-external'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-external.git',
    branch = 'main',
}

description = {
    summary = 'Внешние зависимости модуля и их подмена в тестах',
    detailed = [[
        Модуль перечисляет, что берёт снаружи — часы, box, сеть, файлы,
        необязательный рок, — таблицей функций и ходит к ним только через
        неё. Проверка подменяет из таблицы ровно то, что проверяет,
        а остальное остаётся настоящим: иначе проверка одной ветки
        заставляет подделывать весь окружающий мир.

        external.install(module, defaults) — одна строка на модуль: вешает
        на него подмену _set_source и возвращает функцию, отдающую
        действующие зависимости при каждом обращении. Подмена
        с незнакомым именем бросает сразу: промахнувшаяся именем подмена
        иначе ничего не подменяет, а проверка остаётся зелёной.

        Зависимостей нет: только то, что встроено в Lua. Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-external',
    issues_url = 'https://github.com/tnt-skein/tnt-external/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'testing', 'dependencies', 'mocking' },
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.external'] = 'tnt/external.lua',
    },
}

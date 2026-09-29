rockspec_format = '3.0'

package = 'tnt-permissions'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-permissions.git',
    branch = 'main',
}

description = {
    summary = 'Права: роли с разрешениями (RBAC) и правила на объект в одном объявлении',
    detailed = [[
        Опознание отвечает на вопрос «кто это», права — на вопрос «что ему
        можно». Роль — имя для набора разрешений, правило — ответ
        о конкретном объекте, и объявлены они рядом, в одних воротах.
        Разрешения допускают звёздочку последней частью: cluster.* — это
        и cluster.restart, и cluster.node.expel.

        Правила объявляются в одном месте, а спрашивают их отовсюду:
        из обработчика (allows, denies, check), парой с отказом
        (authorize) и слоем can на маршруте, группе или всём роутере.
        Решение идёт по одному порядку: крюки before, правило
        способности, прямые разрешения личности и её роли; не решил
        никто — отказ.

        Отказ — объявленный отказ каталога tnt-error с кодом
        permissions.denied и статусом 403, и как его показать, решает
        каталог приложения; исключение остаётся за промахом программиста.
        Личность приходит аргументом: где у неё роли и прямые разрешения,
        говорит вызывающий (roles_of, permissions_of), а по умолчанию это
        поля roles и permissions.

        Зависит от tnt-error (каталог отказов) и tnt-must (проверки
        аргументов). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-permissions',
    issues_url = 'https://github.com/tnt-skein/tnt-permissions/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'permissions', 'rbac', 'authorization', 'middleware' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки аргументов на строке вызывающего и бросок без места.
    'tnt-must',
    -- Отказ «нет права» — объявленный отказ каталога, а не таблица по месту.
    'tnt-error',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.permissions'] = 'tnt/permissions.lua',
        ['tnt.permissions.ability'] = 'tnt/permissions/ability.lua',
        ['tnt.permissions.decide'] = 'tnt/permissions/decide.lua',
        ['tnt.permissions.gate'] = 'tnt/permissions/gate.lua',
        ['tnt.permissions.layer'] = 'tnt/permissions/layer.lua',
        ['tnt.permissions.refusal'] = 'tnt/permissions/refusal.lua',
        ['tnt.permissions.roles'] = 'tnt/permissions/roles.lua',
        ['tnt.permissions.verdict'] = 'tnt/permissions/verdict.lua',
    },
}

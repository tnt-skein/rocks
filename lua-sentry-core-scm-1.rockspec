rockspec_format = '3.0'

package = 'lua-sentry-core'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/lua-sentry-core.git',
    branch = 'main',
}

description = {
    summary = 'Основание переносимого ядра Sentry: средства, исходы, дескрипторы, типы',
    detailed = [[
        Основание клиента Sentry на чистом Lua. Держит четыре родственные
        вещи, которые нужны всякому, кто собирает и отправляет конверты:
        таблицу внешних средств, которой ядро заменяет себе часы,
        случайность и кодировщик; словарь исходов отправки; дескрипторы
        элементов конверта с пределами приёмника, записанными один раз;
        типизацию значений атрибутов, уровни важности события и лога
        и идентификаторы события, трассы и спана.

        Приставка lua-, а не tnt-, взята не для красоты: пакет не делает
        ни одного require Tarantool и работает в OpenResty, в обычном lua
        и во встраиваемом. Это проверяется, а не обещается: проверка
        читает исходники и отвергает require рантайма и обращение к box.

        Зависимостей нет: только то, что встроено в Lua 5.1. Покрытие
        строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/lua-sentry-core',
    issues_url = 'https://github.com/tnt-skein/lua-sentry-core/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'sentry', 'lua', 'tarantool', 'observability', 'portable' },
}

dependencies = {
    'lua >= 5.1',
}

build = {
    type = 'builtin',
    modules = {
        ['sentry.core'] = 'sentry/core.lua',
        ['sentry.core.attribute'] = 'sentry/core/attribute.lua',
        ['sentry.core.env'] = 'sentry/core/env.lua',
        ['sentry.core.ids'] = 'sentry/core/ids.lua',
        ['sentry.core.item'] = 'sentry/core/item.lua',
        ['sentry.core.outcome'] = 'sentry/core/outcome.lua',
        ['sentry.core.severity'] = 'sentry/core/severity.lua',
        ['sentry.core.signal'] = 'sentry/core/signal.lua',
    },
}

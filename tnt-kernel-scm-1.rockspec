rockspec_format = '3.0'

package = 'tnt-kernel'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-kernel.git',
    branch = 'main',
}

description = {
    summary = 'Ядро приложения: роль Tarantool поверх контейнера зависимостей',
    detailed = [[
        Приложение на Tarantool 3 — это роль: ядро Tarantool зовёт у неё
        validate, apply, on_event и stop, а настройки приходят
        из roles_cfg вместе с подставленными {{ context.* }} — тайнами
        из окружения. kernel.new собирает такую роль из объявления —
        функций и таблиц, без путей и каталогов: сборщики контейнера,
        маршруты, функции iproto, шаги схемы, модели, действия
        по box.status и проверку готовности.

        То, что у каждого приложения одинаково, держит пакет: контейнер
        со стандартными именами и чтением настроек по пути и с родом,
        каталог отказов, слои и роутер с журналом запросов и сквозной
        трассой, подписанные ссылки с ключом из окружения, выгрузку трасс
        в коллектор OpenTelemetry, публикацию функций iproto с приёмом
        контекста и трассы соседа, проведение находок диагностики через
        встроенные проверки готовности, настройку журнала, подъём схемы
        и привязку моделей по месту узла в кластере — к спейсу, к vshard,
        к репликасету с данными или к базе SQL.

        Применение повторно безопасно: новый контейнер и привязка моделей
        собираются целиком, и только потом отпускается прежнее;
        сорвавшаяся сборка оставляет узел отвечать прежним применением.
        config:reload() подменяет обработчик сервера, снимает глобалы,
        которых больше нет, и закрывает прежний контейнер.

        Зависит от tnt-di (контейнер), tnt-router, tnt-middleware
        и tnt-error (граница HTTP), tnt-trace и tnt-trace-otlp (трасса
        и её выгрузка), tnt-model, tnt-orm и tnt-schema (данные и схема),
        tnt-config, tnt-env и tnt-validate (настройки), tnt-log,
        tnt-context, tnt-id, tnt-crypto, tnt-http, tnt-notifier,
        tnt-clock, tnt-must и tnt-external. Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-kernel',
    issues_url = 'https://github.com/tnt-skein/tnt-kernel/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'application', 'roles', 'http', 'dependency-injection' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-clock',
    -- Имя settings в контейнере: снимок настроек с чтением по пути
    -- и с родом.
    'tnt-config',
    -- Перенос соседа последним аргументом функций iproto.
    'tnt-context',
    -- Ключ подписи ссылок роутера — выведенный по назначению из секрета
    -- окружения.
    'tnt-crypto',
    'tnt-di',
    'tnt-env',
    'tnt-error',
    -- Правило адреса коллектора: раздел trace проверяется им же, чем
    -- выгрузчик собирает клиент.
    'tnt-http',
    -- Запас случайности для опознавателей трассы: слой стоит на каждом запросе.
    'tnt-id',
    'tnt-log',
    'tnt-middleware',
    'tnt-model',
    -- Шлюз моделей к базе SQL — по разделу models с source: sql.
    'tnt-orm',
    -- Находки диагностики во встроенных проверках готовности — по разделу
    -- notifier; модуль грузится только там, где раздел их включил.
    'tnt-notifier',
    'tnt-router',
    'tnt-schema',
    'tnt-external',
    -- Слой трассы на входе — всегда; выгрузка — по адресу коллектора
    -- в разделе trace.
    'tnt-trace',
    'tnt-trace-otlp',
    'tnt-validate',
    -- Не объявлен рок http: сервер и роль roles.httpd ядро берёт лениво,
    -- как внешнюю зависимость, а сам рок ставится зависимостью tnt-router.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.kernel'] = 'tnt/kernel.lua',
        ['tnt.kernel.http'] = 'tnt/kernel/http.lua',
        ['tnt.kernel.iproto'] = 'tnt/kernel/iproto.lua',
        ['tnt.kernel.journal'] = 'tnt/kernel/journal.lua',
        ['tnt.kernel.list'] = 'tnt/kernel/list.lua',
        ['tnt.kernel.models'] = 'tnt/kernel/models.lua',
        ['tnt.kernel.notifier'] = 'tnt/kernel/notifier.lua',
        ['tnt.kernel.schema'] = 'tnt/kernel/schema.lua',
        ['tnt.kernel.settings'] = 'tnt/kernel/settings.lua',
        ['tnt.kernel.signing'] = 'tnt/kernel/signing.lua',
        ['tnt.kernel.spec'] = 'tnt/kernel/spec.lua',
        ['tnt.kernel.tracing'] = 'tnt/kernel/tracing.lua',
        ['tnt.kernel.world'] = 'tnt/kernel/world.lua',
    },
}

rockspec_format = '3.0'

package = 'tnt-centrifugo'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-centrifugo.git',
    branch = 'main',
}

description = {
    summary = 'Протокол клиента Centrifugo поверх tnt-websocket: подписки, присутствие, история, шина узлов',
    detailed = [[
        Узел Centrifugo внутри Tarantool: браузер ходит официальным клиентом
        centrifuge-js, как к серверу Centrifugo, а отдельной службы рядом
        с кластером держать не нужно. Протокол клиента по JSON: connect,
        subscribe, unsubscribe, publish, presence, presence_stats, history,
        rpc, send и ping сервера.

        Узел — обработчик маршрута роутера tnt-router поверх tnt-websocket.
        Кто подключается и куда можно подписаться, решают обработчики
        приложения, и без обработчика права запрещено. Частоту команд
        ограничивает tnt-throttle, пришедший настройкой. У каждого
        соединения своя очередь записи: медленный клиент рвётся кодом
        slow, а не держит публикацию. API сервера: publish, send,
        unsubscribe, disconnect, presence, presence_stats, stop.

        Узлы за балансировщиком делят подписчиков через шину на спейсах
        хранителя: публикация доходит до подписчиков всех узлов, история
        канала держится с пределом длины и сроком, клиент после обрыва
        восстанавливает пропущенное, присутствие видно по всем узлам.
        Сообщение, отписка и обрыв пользователя сервером идут тем же
        потоком и находят его соединения на любом узле. Шина идёт
        за ведущим репликасета хранителя, которого называет приложение,
        и повторяет запись, отказанную бывшим ведущим; хвост потока,
        пропавший при аварийной смене ведущего, узел узнаёт по правлению
        хранителя и рвёт подписки с историей кодом 3010, а строки,
        убранные уборкой раньше, чем он их прочёл, — по отметке уборки
        и рвёт свои сессии кодом 3011.

        Отказ — пара nil, err; негодный аргумент и негодная настройка —
        бросок на строке вызывающего. Зависит от tnt-must (проверки
        аргументов), tnt-clock (сроки), tnt-context (писатель соединения
        в контексте сессии), tnt-log (журнал), tnt-websocket (рукопожатие
        и кадры) и tnt-external (подмена часов хранителя и наблюдателя box
        в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-centrifugo',
    issues_url = 'https://github.com/tnt-skein/tnt-centrifugo/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'centrifugo', 'websocket', 'pubsub', 'realtime' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки аргументов и настроек на строке вызывающего.
    'tnt-must',
    -- Сроки connect, ping и такта шины, время хранителя.
    'tnt-clock',
    -- Писатель соединения идёт в контексте сессии.
    'tnt-context',
    -- Журнал нарушений протокола, отказов обработчиков и шины.
    'tnt-log',
    -- Рукопожатие и кадры WebSocket.
    'tnt-websocket',
    -- Часы хранителя и наблюдатель box в проверках подменяются.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.centrifugo'] = 'tnt/centrifugo.lua',
        ['tnt.centrifugo.bus'] = 'tnt/centrifugo/bus.lua',
        ['tnt.centrifugo.client'] = 'tnt/centrifugo/client.lua',
        ['tnt.centrifugo.codes'] = 'tnt/centrifugo/codes.lua',
        ['tnt.centrifugo.commands'] = 'tnt/centrifugo/commands.lua',
        ['tnt.centrifugo.hub'] = 'tnt/centrifugo/hub.lua',
        ['tnt.centrifugo.keeper'] = 'tnt/centrifugo/keeper.lua',
        ['tnt.centrifugo.link'] = 'tnt/centrifugo/link.lua',
        ['tnt.centrifugo.listener'] = 'tnt/centrifugo/listener.lua',
        ['tnt.centrifugo.protocol'] = 'tnt/centrifugo/protocol.lua',
        ['tnt.centrifugo.recovery'] = 'tnt/centrifugo/recovery.lua',
        ['tnt.centrifugo.reign'] = 'tnt/centrifugo/reign.lua',
        ['tnt.centrifugo.registry'] = 'tnt/centrifugo/registry.lua',
        ['tnt.centrifugo.schema'] = 'tnt/centrifugo/schema.lua',
        ['tnt.centrifugo.session'] = 'tnt/centrifugo/session.lua',
        ['tnt.centrifugo.settings'] = 'tnt/centrifugo/settings.lua',
    },
}

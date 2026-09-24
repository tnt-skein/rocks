rockspec_format = '3.0'

package = 'tnt-amqp'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-amqp.git',
    branch = 'main',
}

description = {
    summary = 'Очередь RabbitMQ для Tarantool: AMQP 0-9-1 на неблокирующем сокете, подтверждения брокера, зарытые',
    detailed = [[
        Готового клиента AMQP у Tarantool нет ни в ядре, ни среди
        официальных роков, а обёртки над librabbitmq блокируют поток:
        пока библиотека ждёт сети, стоит весь узел. Пакет говорит
        AMQP 0-9-1 сам, поверх встроенного неблокирующего сокета, и ровно
        тем, чем пользуется: соединение, канал, объявление очереди,
        публикация с подтверждением, подписка и итог.

        broker:declare объявляет очередь вместе с очередью мёртвых
        <имя>.dead. send возвращает опознаватель после подтверждения
        брокера (confirm.select) и публикует с mandatory: сообщению,
        которому некуда лечь, отвечает отказ, а не молчание. consume
        заводит работников — у каждого своё соединение мимо пула, подписка
        с ручным подтверждением и предвыборка в одно сообщение.
        Подтверждение — итог обработчика: значение — basic.ack, nil, err —
        копия с номером выдачи на единицу больше, после max_attempts —
        копия в <имя>.dead с причиной заголовком. Гарантия — хотя бы раз.

        Сообщение приходит конвертом: опознаватель ULID, имя очереди,
        тело JSON, заголовки контекста, номер выдачи и время отправки.
        Отказ — пара nil, err с родом, признаком отправки и приговором
        повтору. broker:sender() отдаёт отправителя для ящика исходящих
        tnt-outbox. Отсрочки и порядка по ключу у брокера нет: delay
        и key — исключение, а не молчаливый пропуск.

        Зависит от tnt-must (проверки аргументов), tnt-clock (время
        отправки), tnt-context (контекст заголовками), tnt-id
        (опознаватель), tnt-log (журнал), tnt-pool (соединения отправки),
        tnt-retry (повторы), tnt-external (подмена сети, шифрования и сна
        в проверках), tnt-storage (срок вызова и отказ с родом) и tnt-tls
        (шифрование). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-amqp',
    issues_url = 'https://github.com/tnt-skein/tnt-amqp/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'amqp', 'rabbitmq', 'queue', 'messaging', 'at-least-once' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки настроек, имени очереди, тела и крюков на строке вызывающего.
    'tnt-must',
    -- Стенное время отправки в конверте.
    'tnt-clock',
    -- Контекст, который едет заголовками сообщения.
    'tnt-context',
    -- Опознаватель ULID сообщения и запроса обработчика.
    'tnt-id',
    -- Записи о зарытом, опоздавшем итоге, выброшенном соединении и крюке.
    'tnt-log',
    -- Соединения отправки.
    'tnt-pool',
    -- Повторы вызова по полю retriable отказа.
    'tnt-retry',
    -- Подмена сети, шифрования и сна работника в проверках.
    'tnt-external',
    -- Срок вызова и отказ с родом, признаком отправки и приговором повтору.
    'tnt-storage',
    -- Шифрование соединения с брокером.
    'tnt-tls',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.amqp'] = 'tnt/amqp.lua',
        ['tnt.amqp.channel'] = 'tnt/amqp/channel.lua',
        ['tnt.amqp.connect'] = 'tnt/amqp/connect.lua',
        ['tnt.amqp.frame'] = 'tnt/amqp/frame.lua',
        ['tnt.amqp.hook'] = 'tnt/amqp/hook.lua',
        ['tnt.amqp.link'] = 'tnt/amqp/link.lua',
        ['tnt.amqp.message'] = 'tnt/amqp/message.lua',
        ['tnt.amqp.method'] = 'tnt/amqp/method.lua',
        ['tnt.amqp.outcome'] = 'tnt/amqp/outcome.lua',
        ['tnt.amqp.queue'] = 'tnt/amqp/queue.lua',
        ['tnt.amqp.settings'] = 'tnt/amqp/settings.lua',
        ['tnt.amqp.wire'] = 'tnt/amqp/wire.lua',
        ['tnt.amqp.worker'] = 'tnt/amqp/worker.lua',
    },
}

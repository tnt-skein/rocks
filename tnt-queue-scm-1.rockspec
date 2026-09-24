rockspec_format = '3.0'

package = 'tnt-queue'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-queue.git',
    branch = 'main',
}

description = {
    summary = 'Очередь заданий Tarantool в спейсах: итог обработчика, зарытые, отправка частью транзакции box',
    detailed = [[
        Надёжная очередь заданий поверх рока queue: сообщение лежит
        в спейсе и переживает перезапуск узла. queue.declare объявляет
        очередь, send отправляет сообщение и отдаёт его опознаватель,
        consume заводит работников на файберах. Работа внутри — рок queue
        с драйвером utubettl: сроки, приоритет, ключ порядка, возврат.
        Пакет задаёт договор и закрывает места, где рок молча теряет
        или отказывает не парой.

        Подтверждение — то, что вернул обработчик: значение подтверждает,
        nil, err возвращает сообщение с отсрочкой retry_after или растущим
        отступом, последняя попытка и err.retriable == false зарывают его
        в отдельный спейс <имя>_dead, откуда kick возвращает зарытые
        на выдачу. Сообщение несёт конверт с ULID отправителя, номером
        выдачи и заголовками контекста, и обработчик идёт в контексте того,
        кто отправил. Отправка в транзакции box — её часть: откат уносит
        и сообщение. С atomic запись обработчика и подтверждение
        фиксируются одной транзакцией.

        Отказ — пара nil, err с TntStorageFailure: unreachable на узле
        для чтения и в окне смены ведущего, broken, conflict при откате
        синхронной транзакции, rejected у продления. Рок грузится лениво
        и только на узле для записи; работник на узле для чтения ждёт
        записи, а не крутит пустое взятие. Время на обработку ttr
        обязательно и конечно. Гарантия — хотя бы раз.

        Зависит от queue 1.5.0-1 (очередь в спейсах), tnt-must (проверки
        аргументов), tnt-clock (время зарытого), tnt-context (заголовки
        контекста), tnt-id (опознаватель ULID), tnt-log (журнал),
        tnt-storage (отказ) и tnt-external (подмена рока, сна и признаков
        узла в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-queue',
    issues_url = 'https://github.com/tnt-skein/tnt-queue/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'queue', 'job-queue', 'messaging', 'at-least-once', 'dead-letter' },
}

dependencies = {
    'lua >= 5.1',
    -- Очередь в спейсах. Выпуск закреплён: пакет опирается на устройство
    -- рока — состояния queue.state(), драйвер utubettl, поле данных задачи
    -- и крюк on_task_change. Подъём — отдельная правка со сверкой заново.
    'queue == 1.5.0-1',
    -- Проверки имени очереди, обработчика и настроек на строке вызывающего.
    'tnt-must',
    -- Стенное время отправки и зарытого.
    'tnt-clock',
    -- Заголовки контекста в конверте и область контекста обработчика.
    'tnt-context',
    -- Опознаватель ULID сообщения и запроса обработчика.
    'tnt-id',
    -- Записи о зарытом, опоздавшем итоге, истёкшем сообщении и шаге работника.
    'tnt-log',
    -- Подмена рока, сна и признаков узла в проверках.
    'tnt-external',
    -- Отказ TntStorageFailure и его текст.
    'tnt-storage',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.queue'] = 'tnt/queue.lua',
        ['tnt.queue.hook'] = 'tnt/queue/hook.lua',
        ['tnt.queue.message'] = 'tnt/queue/message.lua',
        ['tnt.queue.outcome'] = 'tnt/queue/outcome.lua',
        ['tnt.queue.tube'] = 'tnt/queue/tube.lua',
        ['tnt.queue.worker'] = 'tnt/queue/worker.lua',
    },
}

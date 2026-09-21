rockspec_format = '3.0'

package = 'tnt-once'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-once.git',
    branch = 'main',
}

description = {
    summary = 'Однократность: повтор запроса не выполняет действие второй раз',
    detailed = [[
        Вызов по сети не бывает «ровно один раз». Обрыв после того, как
        узел принял запрос, выглядит для вызывающего в точности как отказ,
        и он повторяет; оператор, не дождавшись ответа, жмёт кнопку ещё
        раз. Для чтения это ничего не значит, а для действия значит второй
        чекпойнт посреди первого и второй перехват очереди.

        Запрос приносит ключ, узел помнит по ключу свой ответ и отдаёт
        его на повтор, ничего не выполняя. Повтор, пришедший, пока первый
        запрос ещё выполняется, получает отказ «уже выполняется», а не
        второе выполнение. Отказ помнится наравне с удачей: «не
        получилось» — тоже ответ, и повтор потерянного запроса получает
        его, а не идёт выполнять действие заново.

        Память живёт в процессе: по умолчанию 512 ключей на четверть часа,
        срок и потолок настраиваются. Зависимости — tnt-must, tnt-clock
        и tnt-external. Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-once',
    issues_url = 'https://github.com/tnt-skein/tnt-once/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'idempotency', 'idempotency-key', 'retry', 'deduplication' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-clock',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.once'] = 'tnt/once.lua',
    },
}

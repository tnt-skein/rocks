rockspec_format = '3.0'

package = 'tnt-throttle'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-throttle.git',
    branch = 'main',
}

description = {
    summary = 'Ограничение частоты: пределы по ключу, ограничитель, слой throttle и счёт в памяти или Redis',
    detailed = [[
        Сколько попыток по ключу пускать за окно времени: перебор пароля,
        клиент API с тысячей запросов в секунду, чужое API с правилом
        «не больше десяти в секунду». Предел — значение: per_second,
        per_minute, per_hour, per_day и none, ключ счёта даёт by.
        Окно открывает первая попытка, и живёт оно ровно свой срок.

        Ограничитель считает попытки по ключу: attempt, too_many_attempts,
        hit, attempts, remaining, available_in, clear. Именованные
        ограничители объявляются однажды и получают то, что проверяют,
        — у слоя это запрос. consume засчитывает попытку и решает одним
        действием драйвера: между вопросом «не много ли» и счётом
        не вклинятся ни соседний файбер, ни соседний узел.

        Слой throttle ставится на вход роутера, группы или маршрута:
        исчерпанный предел — отказ парой со статусом 429 и Retry-After,
        у пропущенного ответа — заголовки предела и секунд до сброса.
        Отказ драйвера по умолчанию пропускает запрос без счёта и пишет
        об этом в журнал; strict делает его поломкой запроса.

        Драйвер счёта выбирается настройкой: memory — в памяти узла
        с потолком ключей и окном по монотонным часам, по умолчанию;
        redis — один счёт на все узлы через клиент Redis, пришедший
        аргументом: попытка — один сценарий EVAL, окно меряют часы Redis;
        свой — по договору hit, peek, clear.

        Зависит от tnt-clock (монотонные часы окна), tnt-hash (свёртка
        длинного ключа), tnt-log (запись об отказе драйвера), tnt-must
        (проверки аргументов) и tnt-external (подмена часов и признака
        транзакции в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-throttle',
    issues_url = 'https://github.com/tnt-skein/tnt-throttle/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'rate-limit', 'throttle', 'redis', 'middleware' },
}

dependencies = {
    'lua >= 5.1',
    -- Проверки аргументов на строке вызывающего и бросок без места.
    'tnt-must',
    -- Монотонные часы окна в памяти узла.
    'tnt-clock',
    -- SHA-256 ключа длиннее предела.
    'tnt-hash',
    -- Запись об отказе драйвера с подавлением повторов.
    'tnt-log',
    -- Подмена часов и признака транзакции box в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.throttle'] = 'tnt/throttle.lua',
        ['tnt.throttle.layer'] = 'tnt/throttle/layer.lua',
        ['tnt.throttle.limit'] = 'tnt/throttle/limit.lua',
        ['tnt.throttle.limiter'] = 'tnt/throttle/limiter.lua',
        ['tnt.throttle.memory'] = 'tnt/throttle/memory.lua',
        ['tnt.throttle.redis'] = 'tnt/throttle/redis.lua',
    },
}

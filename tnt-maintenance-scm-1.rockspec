rockspec_format = '3.0'

package = 'tnt-maintenance'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-maintenance.git',
    branch = 'main',
}

description = {
    summary = 'Обслуживание узла Tarantool: чекпойнт, резервная копия, уборка места и памяти',
    detailed = [[
        Плановые работы администратора отличаются от аварийных тем, что
        их делают заранее и по расписанию, а не ночью и в спешке. Но цена
        ошибки у них та же: уборка журналов, которые удерживает отставшая
        реплика, ломает эту реплику необратимо, а восстановление из копии
        стирает всё, что узел записал после её снятия.

        Ядро Community Edition даёт администратору ровно три вещи: снять
        чекпойнт, запретить сборщику мусора удалять его файлы на время
        копирования и подкрутить пороги уже существующей уборки. Ни одна
        кнопка не копирует файлы, не восстанавливает данные без перезапуска
        и не возвращает память операционной системе. Пакет говорит об этом
        прямо, а не делает вид, что умеет больше.

        Узел рассказывает, что лежит на диске и почему не убрано: кто
        удерживает журналы, открыто ли окно копирования, идёт ли чекпойнт.
        Долгие операции — чекпойнт, уборка, копия — принимаются работой,
        а не выполняются в вызове, и публикуются глобальными функциями
        под право lua_call. Каждая операция сначала описывается оценкой:
        что произойдёт, чего это стоит и что нужно сделать до; опасные
        требуют слова подтверждения. Прогноз места считает, через сколько
        кончится диск, а правила диагностики говорят о нём и о старой копии
        заранее.

        Копия снимается целиком, с манифестом, повторяя раскладку каталогов
        узла, и уезжает с машины в объектное хранилище: клиент S3 приходит
        аргументом настройки — всякий, у которого есть вызов put_file,
        манифест выгружается последним, а срок хранения в ведре ведёт
        правило его жизненного цикла, и ключу узла хватает права на запись.

        Зависимости: tnt-async, tnt-clock, tnt-collection, tnt-context,
        tnt-disk, tnt-external, tnt-fingerprint, tnt-log, tnt-loop, tnt-once
        и tnt-recovery. Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-maintenance',
    issues_url = 'https://github.com/tnt-skein/tnt-maintenance/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'maintenance', 'backup', 'checkpoint', 'operations' },
}

dependencies = {
    'lua >= 5.1',
    -- Долгая работа идёт задачей веера — с правами и контекстом принявшего.
    'tnt-async',
    -- Монотонные часы для сроков и стенные для отметок копий и работ.
    'tnt-clock',
    -- Копии по времени, файлы по пути, компоненты счётчика по номеру.
    'tnt-collection',
    -- Перенос вызывающего последним аргументом опубликованных операций.
    'tnt-context',
    -- Каталоги узла, файлы, свободное место, заголовок снимка.
    'tnt-disk',
    -- Такт наблюдения за местом и сторож окна копирования.
    'tnt-loop',
    -- Отпечаток состояния, по которому оператор подтверждает оценку.
    'tnt-fingerprint',
    -- Записи о принятых работах, окне копирования и уборке.
    'tnt-log',
    -- Один ответ на повтор запроса с тем же ключом.
    'tnt-once',
    -- Оценка риска, ворота опасного действия и разбор личности копии.
    'tnt-recovery',
    -- Подмена ядра, часов и диска в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.maintenance'] = 'tnt/maintenance.lua',
        ['tnt.maintenance.inventory'] = 'tnt/maintenance/inventory.lua',
        ['tnt.maintenance.snapshot'] = 'tnt/maintenance/snapshot.lua',
        ['tnt.maintenance.memory'] = 'tnt/maintenance/memory.lua',
        ['tnt.maintenance.reclaim'] = 'tnt/maintenance/reclaim.lua',
        ['tnt.maintenance.jobs'] = 'tnt/maintenance/jobs.lua',
        ['tnt.maintenance.assess'] = 'tnt/maintenance/assess.lua',
        ['tnt.maintenance.restore'] = 'tnt/maintenance/restore.lua',
        ['tnt.maintenance.forecast'] = 'tnt/maintenance/forecast.lua',
        ['tnt.maintenance.diagnosis'] = 'tnt/maintenance/diagnosis.lua',
        ['tnt.maintenance.backup'] = 'tnt/maintenance/backup.lua',
        ['tnt.maintenance.offload'] = 'tnt/maintenance/offload.lua',
    },
}

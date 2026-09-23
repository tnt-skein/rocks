rockspec_format = '3.0'

package = 'tnt-process'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-process.git',
    branch = 'main',
}

description = {
    summary = 'Процессы фасадом поверх popen: срок, kill, чтение со сроком, отказ парой',
    detailed = [[
        Запускает, ждёт и убивает встроенный popen, не блокируя узел;
        пакет даёт то, чего у него нет. Программа ищется по PATH до
        запуска, и её отсутствие — отказ missing либо denied, а не код
        выхода 2 или 13, неотличимый от ответа самой программы.

        Срок есть у всякого ожидания. Запуск до конца (run) идёт одним
        сроком на вход, оба потока вывода и код выхода; оба потока
        читаются разом, каждый своим файбером, и процесс не встаёт
        на полной трубе. Просроченный процесс убит вместе с группой:
        запускается он своей сессией, и внук, который держит трубу,
        умирает с ним. Вывод копится в памяти узла и потому ограничен
        пределом на каждый поток. Сценарий оболочки (shell) получает
        значения позиционными аргументами, а не вклейкой в текст.

        Закрытие ручки, которую ждёт другой файбер, откладывается до конца
        ожидания: у popen оно на macOS роняет узел, на Linux отменяет
        ждущего. Всякий отказ среды — пара nil, err, где err — таблица
        с родом (missing, denied, timeout, exit, signal, overflow, failed),
        которая читается и как строка; незнакомый ключ настроек и прочая
        ошибка программиста — бросок со строкой вызывающего.

        Зависит от tnt-must (проверки аргументов), tnt-clock (часы срока),
        tnt-context (контекст вызывающего в файберах чтения) и tnt-external
        (подмена popen и часов в проверках). Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-process',
    issues_url = 'https://github.com/tnt-skein/tnt-process/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'popen', 'process', 'subprocess', 'shell', 'timeout' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-clock',
    'tnt-context',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.process'] = 'tnt/process.lua',
        ['tnt.process.child'] = 'tnt/process/child.lua',
        ['tnt.process.failure'] = 'tnt/process/failure.lua',
        ['tnt.process.locate'] = 'tnt/process/locate.lua',
        ['tnt.process.run'] = 'tnt/process/run.lua',
        ['tnt.process.system'] = 'tnt/process/system.lua',
    },
}

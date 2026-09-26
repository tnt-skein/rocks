rockspec_format = '3.0'

package = 'tnt-cryptopro'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-cryptopro.git',
    branch = 'main',
}

description = {
    summary = 'Подпись и хеш по ГОСТ программами КриптоПро CSP: отказ парой, ПИН на входе, срок',
    detailed = [[
        Подписывает и проверяет подписи CMS, считает хеш ГОСТ Р 34.11-2012
        и перечисляет сертификаты хранилища программами КриптоПро CSP
        (cryptcp, cpverify, certmgr), запущенными tnt-process: узел
        не стоит, у вызова есть срок, просроченный процесс убит с группой.

        Отказ — пара nil, err с родом по коду КриптоПро, а не по коду
        выхода: у программ он — младший байт кода ошибки. Сертификата нет,
        ключ не открылся, ПИН неверный, цепочка не проверена, подпись
        не сходится — каждое своим родом. ПИН уходит на вход программы,
        а не аргументом, и в списке процессов не виден; на вопрос о
        сертификате с непроверенной цепочкой узел не отвечает — это отказ.
        Данные и подпись живут во временном каталоге tnt-fs, который
        сносится после вызова.

        Зависит от tnt-process (запуск и отказ), tnt-fs (временные файлы),
        tnt-must (проверки аргументов) и tnt-external (подмена окружения
        и архитектуры в проверках). Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-cryptopro',
    issues_url = 'https://github.com/tnt-skein/tnt-cryptopro/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'cryptopro', 'gost', 'signature', 'cms' },
}

dependencies = {
    'lua >= 5.1',
    -- Запуск программ КриптоПро и отказ процесса.
    'tnt-process',
    -- Временный каталог для данных и подписи.
    'tnt-fs',
    -- Проверки аргументов на строке вызывающего.
    'tnt-must',
    -- Окружение узла и архитектура подменяются в проверках.
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.cryptopro'] = 'tnt/cryptopro.lua',
        ['tnt.cryptopro.client'] = 'tnt/cryptopro/client.lua',
        ['tnt.cryptopro.report'] = 'tnt/cryptopro/report.lua',
        ['tnt.cryptopro.system'] = 'tnt/cryptopro/system.lua',
        ['tnt.cryptopro.verdict'] = 'tnt/cryptopro/verdict.lua',
    },
}

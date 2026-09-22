rockspec_format = '3.0'

package = 'tnt-template'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-template.git',
    branch = 'main',
}

description = {
    summary = 'Шаблоны страниц: подстановки, условия, циклы и наследование',
    detailed = [[
        Шаблон — HTML с вкраплениями Lua: экранированный вывод {{ }},
        сырой {!! !!}, заметки, @if/@unless/@for, наследование
        @extends/@section/@yield, подключение @include, скрытое поле
        с токеном формы @csrf и он же меткой @csrf_meta. Выражения —
        обычный Lua, второго языка учить не надо.

        Шаблон переводится в функцию Lua один раз и дальше только
        зовётся; строки перевода совпадают со строками шаблона, и ошибка
        называет шаблон и строку в нём. Имена в выражениях — данные
        страницы и белый список помощников; глобалов узла шаблон не видит.
        Свои директивы и условия заводятся обычной функцией-обработчиком.
        Все шаблоны каталога переводятся заранее, с записью на диск
        и отпечатком своих директив.

        Зависимость — tnt-must: отказы бросаются словом, без места
        в коде. Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-template',
    issues_url = 'https://github.com/tnt-skein/tnt-template/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'template', 'html', 'views', 'web' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.template'] = 'tnt/template.lua',
        ['tnt.template.csrf'] = 'tnt/template/csrf.lua',
        ['tnt.template.directives'] = 'tnt/template/directives.lua',
        ['tnt.template.engine'] = 'tnt/template/engine.lua',
        ['tnt.template.escape'] = 'tnt/template/escape.lua',
        ['tnt.template.sandbox'] = 'tnt/template/sandbox.lua',
        ['tnt.template.source'] = 'tnt/template/source.lua',
        ['tnt.template.translator'] = 'tnt/template/translator.lua',
        ['tnt.template.warm'] = 'tnt/template/warm.lua',
    },
}

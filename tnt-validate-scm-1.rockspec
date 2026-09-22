rockspec_format = '3.0'

package = 'tnt-validate'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-validate.git',
    branch = 'main',
}

description = {
    summary = 'Проверка входных данных: тело запроса, параметры маршрута, настройки',
    detailed = [[
        Проверка входных данных для Tarantool: тело запроса, параметры
        маршрута, настройки модуля. Схема описывается значениями, а не
        строкой правил: опечатка в `validate.string({ mim = 3 })` роняет
        загрузку модуля, а опечатка в 'required|min:3' дожила бы
        до выполнения.

        Проверка возвращает приведённые данные и таблицу «поле → причина
        по-русски» с путём до места: `items[2].price`. Проверяются все
        поля, а не до первого отказа. Приведение типов включается
        настройкой, лишние поля по умолчанию отвергаются, а для настроек
        модулей отказ собирается предложением: «порт должен быть целым
        числом от 1 до 65535, а не 'abc'».

        Правила: строка (длина в знаках, образец Lua, регулярное выражение
        PCRE2, перечень), целое и дробное число, логическое значение,
        таблица с полями, список, отображение, UUID, почтовый адрес,
        ссылка, дата и дата со временем, присланный файл. Своё правило —
        одной функцией. Значения полей, похожих на тайну, в сообщение
        не попадают.

        Зависимость — tnt-external: через неё подключается необязательный
        рок регулярных выражений lrexlib-pcre2. Покрытие строк и убитых
        мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-validate',
    issues_url = 'https://github.com/tnt-skein/tnt-validate/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'validation', 'schema', 'settings', 'http' },
}

dependencies = {
    'lua >= 5.1',
    -- Внешние зависимости: через них подключается необязательный рок регулярных выражений.
    'tnt-external',
    -- Необязательно и здесь не объявлено: `lrexlib-pcre2` (модуль
    -- `rex_pcre2`) даёт настройку `pattern_pcre` правилу строки, а без
    -- него пакет работает как прежде. Ставится целью `make deps-regex`.
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.validate'] = 'tnt/validate.lua',
        ['tnt.validate.text'] = 'tnt/validate/text.lua',
        ['tnt.validate.rule'] = 'tnt/validate/rule.lua',
        ['tnt.validate.coerce'] = 'tnt/validate/coerce.lua',
        ['tnt.validate.regex'] = 'tnt/validate/regex.lua',
        ['tnt.validate.rules'] = 'tnt/validate/rules.lua',
        ['tnt.validate.file'] = 'tnt/validate/file.lua',
        ['tnt.validate.formats'] = 'tnt/validate/formats.lua',
        ['tnt.validate.check'] = 'tnt/validate/check.lua',
        ['tnt.validate.settings'] = 'tnt/validate/settings.lua',
    },
}

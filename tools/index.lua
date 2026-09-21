#!/usr/bin/env tarantool
--- Страница сервера роков: список пакетов по rockspec-файлам каталога.
---
--- Страница, которую пишет `make_manifest`, объявляет кодировку
--- iso-8859-1 и ссылается на архивы манифестов, которых нет, — поэтому
--- она собирается заново после манифеста. Источник — сами rockspec:
--- манифест знает имена и версии, а описание и адрес проекта лежат
--- только в них.
---
--- Запуск: tarantool tools/index.lua [каталог]

local fio = require('fio')

local root = arg[1] or '.'

--- Читает rockspec как таблицу: файл — это присваивания глобалов.
---@param path string
---@return table
local function read_rockspec(path)
    local chunk = assert(loadfile(path))
    local spec = {}

    setfenv(chunk, spec)
    chunk()

    return spec
end

--- Экранирует текст для HTML.
---@param text string
---@return string
local function escape(text)
    return (tostring(text):gsub('[&<>"]', { ['&'] = '&amp;', ['<'] = '&lt;', ['>'] = '&gt;', ['"'] = '&quot;' }))
end

--- Пакеты: имя → { summary, homepage, versions = { { version, file } } }.
local packages = {}

for _, path in ipairs(fio.glob(fio.pathjoin(root, '*.rockspec'))) do
    local spec = read_rockspec(path)
    local entry = packages[spec.package]

    if entry == nil then
        entry = { versions = {} }
        packages[spec.package] = entry
    end

    entry.summary = spec.description and spec.description.summary or ''
    entry.homepage = spec.description and spec.description.homepage or nil
    table.insert(entry.versions, { version = spec.version, file = fio.basename(path) })
end

local names = {}

for name in pairs(packages) do
    table.insert(names, name)
end

table.sort(names)

local out = {}

local function line(text)
    table.insert(out, text)
end

line('<!DOCTYPE html>')
line('<html lang="ru">')
line('<head>')
line('<meta charset="utf-8">')
line('<meta name="viewport" content="width=device-width, initial-scale=1">')
line('<title>skein: сервер роков</title>')
line('<style>')
line(':root { color-scheme: light dark; --accent: #f9322c; }')
line('body { max-width: 52rem; margin: 3rem auto; padding: 0 1rem; font: 16px/1.5 system-ui, sans-serif; }')
line('h1 { font-size: 1.6rem; } h1 span { color: var(--accent); }')
line('code, pre { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; font-size: 0.92em; }')
line('pre { padding: 0.8rem 1rem; border-radius: 0.5rem; background: rgba(127, 127, 127, 0.12); overflow-x: auto; }')
line('table { border-collapse: collapse; width: 100%; }')
line('th, td { text-align: left; vertical-align: top; padding: 0.5rem 0.75rem 0.5rem 0; border-bottom: 1px solid rgba(127, 127, 127, 0.3); }')
line('td.versions { white-space: nowrap; }')
line('footer { margin-top: 2rem; font-size: 0.9em; opacity: 0.7; }')
line('</style>')
line('</head>')
line('<body>')
line('<h1><span>skein</span>: сервер роков</h1>')
line('<p>Пакеты для Tarantool. Установка:</p>')
line('<pre>tt rocks install &lt;пакет&gt; --server=https://tnt-skein.github.io/rocks</pre>')
line('<table>')
line('<tr><th>Пакет</th><th>Что делает</th><th>Версии</th></tr>')

for _, name in ipairs(names) do
    local entry = packages[name]

    table.sort(entry.versions, function(a, b)
        return a.version > b.version
    end)

    local versions = {}

    for _, version in ipairs(entry.versions) do
        table.insert(versions, ('<a href="%s">%s</a>'):format(escape(version.file), escape(version.version)))
    end

    local title = escape(name)

    if entry.homepage ~= nil then
        title = ('<a href="%s">%s</a>'):format(escape(entry.homepage), title)
    end

    line(('<tr><td><code>%s</code></td><td>%s</td><td class="versions">%s</td></tr>'):format(
        title,
        escape(entry.summary),
        table.concat(versions, ', ')
    ))
end

line('</table>')
line('<footer>')
line('<a href="manifest">manifest</a> · <a href="https://github.com/tnt-skein/rocks">исходники сервера</a> · <a href="https://github.com/tnt-skein">tnt-skein</a>')
line('</footer>')
line('</body>')
line('</html>')

local file = assert(io.open(fio.pathjoin(root, 'index.html'), 'w'))
file:write(table.concat(out, '\n'), '\n')
file:close()

print(('index.html: пакетов %d'):format(#names))
os.exit(0)

# rocks

Сервер роков для пакетов Tarantool: статический каталог с манифестом,
который отдаёт GitHub Pages по адресу https://tnt-skein.github.io/rocks.

## Установка пакета

```sh
tt rocks install tnt-must --server=https://tnt-skein.github.io/rocks
```

Сервер хранит только rockspec-файлы: исходники `tt rocks` берёт из
репозитория пакета, указанного в `source.url`.

## Как добавить пакет или версию

1. Положить rockspec в корень: `cp …/tnt-foo-scm-1.rockspec .`
2. Пересобрать манифест и страницу: `make manifest`
3. Закоммитить и отправить: GitHub Pages выкладывает `main` сам.

`make check` сверяет манифест с rockspec-файлами — на случай, если
файл добавили, а манифест забыли.

## Как устроено

`tt rocks admin make_manifest` пишет `manifest` и его копии по версиям
Lua — их читает клиент. Страницу `index.html` собирает `tools/index.lua`
по самим rockspec: там лежат описание и адрес проекта. Файл `.nojekyll`
выключает обработку Jekyll: без него GitHub Pages не отдаёт файлы,
чьи имена начинаются с подчёркивания, и переписывает разметку.

# Сервер роков: статический каталог с манифестом, который отдаёт GitHub Pages.

.PHONY: manifest
manifest: ## Пересобрать манифест и страницу по rockspec-файлам
	tt rocks admin make_manifest .
	tarantool tools/index.lua .

.PHONY: check
check: ## Проверить, что манифест совпадает с rockspec-файлами
	@cp manifest /tmp/rocks-manifest.before && $(MAKE) -s manifest >/dev/null && \
	cmp -s manifest /tmp/rocks-manifest.before && echo 'манифест актуален' || { echo 'манифест устарел: выполните make manifest' >&2; exit 1; }

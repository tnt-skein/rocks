rockspec_format = '3.0'

package = 'tnt-etcd-client'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-etcd-client.git',
    branch = 'main',
}

description = {
    summary = 'Клиент etcd v3 для Tarantool поверх HTTP-шлюза: ключи, условные записи, аренды и наблюдение',
    detailed = [[
        Клиент говорит с etcd через его HTTP-шлюз API v3 — обычным JSON
        поверх HTTP/1.1, без gRPC. Нужен там, где etcd хранит не
        конфигурацию, а решения: координатор держит в нём аренду и запись
        о владельце, сторожа наблюдают за изменениями.

        Чтение и запись ключей под общим префиксом, перебор ветки,
        удаление; условные записи — создать, только если ключа нет,
        перезаписать, пока ревизия не менялась, записать, пока не менялся
        ключ-свидетель; аренды — взять, продлить, отозвать, и истёкшая
        аренда при продлении — отказ, а не ответ со сроком ноль; опрос
        состояния узлов с решением о кворуме; наблюдение за ключом опросом
        ревизии и потоком событий шлюза. Чтения идут через кворум.

        Отказ — пара nil, err, где err — таблица с категорией: CONNECTION,
        AUTH, NOT_FOUND, CAS_CONFLICT, LEASE_EXPIRED, INTERNAL,
        BAD_ARGUMENT. По ней вызывающий отличает потерю связи от занятого
        ключа и решает, повторять ли операцию. Молчащий узел лечится
        переходом к соседнему, отвергнутый токен — повторным входом;
        поддерживаются вход по имени и паролю и TLS с клиентским
        сертификатом. В комплекте — двойник клиента в памяти для проверок
        кода, который строится поверх.

        Зависит от tnt-http (разговор со шлюзом), tnt-retry (обход узлов),
        tnt-async (опрос узлов разом) и tnt-log (журнал наблюдения).
        Покрытие строк и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-etcd-client',
    issues_url = 'https://github.com/tnt-skein/tnt-etcd-client/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'etcd', 'kv', 'lease', 'watch', 'coordination' },
}

dependencies = {
    'lua >= 5.1',
    -- Опрос состояния узлов etcd разом, с одним сроком на весь опрос.
    'tnt-async',
    -- Разговор со шлюзом: сроки, TLS, предел ответа и поток наблюдения.
    'tnt-http',
    -- Записи наблюдения: обрыв потока, отвергнутый токен, бросок обработчика.
    'tnt-log',
    -- Обход узлов: попытки, паузы, бюджет повторов и размыкатель.
    'tnt-retry',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.etcd.client'] = 'tnt/etcd/client.lua',
        ['tnt.etcd.codec'] = 'tnt/etcd/codec.lua',
        ['tnt.etcd.double'] = 'tnt/etcd/double.lua',
        ['tnt.etcd.errors'] = 'tnt/etcd/errors.lua',
        ['tnt.etcd.health'] = 'tnt/etcd/health.lua',
        ['tnt.etcd.kv'] = 'tnt/etcd/kv.lua',
        ['tnt.etcd.lease'] = 'tnt/etcd/lease.lua',
        ['tnt.etcd.transport'] = 'tnt/etcd/transport.lua',
        ['tnt.etcd.watch'] = 'tnt/etcd/watch.lua',
    },
}

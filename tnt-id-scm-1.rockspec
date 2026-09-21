rockspec_format = '3.0'

package = 'tnt-id'
version = 'scm-1'

source = {
    url = 'git+https://github.com/tnt-skein/tnt-id.git',
    branch = 'main',
}

description = {
    summary = 'Опознаватели по порядку: UUIDv7, ULID и азбука Крокфорда',
    detailed = [[
        `uuid.new()` из Tarantool даёт четвёртую версию — случайную, и в
        индексе TREE новые записи ложатся вразброс. UUIDv7 (RFC 9562) и ULID
        несут время в старших битах: запись ложится в конец индекса,
        а курсор «всё, что новее» обходится без отдельного поля времени.
        Опыт на ста тысячах опознавателей, в том числе тысячами в одну
        миллисекунду и с часами, шагнувшими назад, дал ноль не на своих
        местах — и в поле uuid, и в строке.

        Монотонность внутри процесса по RFC 9562, 6.2: счётчик в rand_a
        у UUIDv7, приращение на случайный шаг у ULID; переполнение уводит
        время на миллисекунду вперёд, а не роняет вызов. Разбор принимает
        строчные, I, L, O и дефисы по правилам Крокфорда и отдаёт обычный
        вид. Переводы ULID в 16 байт и в uuid и обратно; наименьший
        опознаватель миллисекунды — граница курсора по времени.

        Не для тайн: оба вида выдают время создания, а соседа угадать
        проще, чем у v4. Для токенов и ссылок сброса — digest.urandom.

        Зависимости: tnt-must (проверка аргументов) и tnt-external
        (подмена часов и случайности в проверках). Покрытие строк
        и убитых мутантов — 100 %.
    ]],
    homepage = 'https://github.com/tnt-skein/tnt-id',
    issues_url = 'https://github.com/tnt-skein/tnt-id/issues',
    maintainer = 'tnt-skein',
    license = 'MIT',
    labels = { 'tarantool', 'uuid', 'uuidv7', 'ulid', 'identifiers', 'crockford' },
}

dependencies = {
    'lua >= 5.1',
    'tnt-must',
    'tnt-external',
}

build = {
    type = 'builtin',
    modules = {
        ['tnt.id'] = 'tnt/id.lua',
        ['tnt.id.crockford'] = 'tnt/id/crockford.lua',
        ['tnt.id.entropy'] = 'tnt/id/entropy.lua',
        ['tnt.id.octets'] = 'tnt/id/octets.lua',
        ['tnt.id.quote'] = 'tnt/id/quote.lua',
        ['tnt.id.sequence'] = 'tnt/id/sequence.lua',
        ['tnt.id.ulid'] = 'tnt/id/ulid.lua',
        ['tnt.id.uuid7'] = 'tnt/id/uuid7.lua',
    },
}

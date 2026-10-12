import SwiftUI

enum AppCategory: String, CaseIterable, Identifiable {
    case all, favorites, bank, social, media, mail

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "Все"
        case .favorites: return "★ Мои"
        case .bank: return "Банки"
        case .social: return "Соцсети"
        case .media: return "Видео и музыка"
        case .mail: return "Почта"
        }
    }
}

enum Availability {
    /// Есть веб-версия, которую можно вынести на экран «Домой».
    case web
    /// Нужен компьютер или визит в офис.
    case computer
    /// Только офис банка.
    case office

    var color: Color {
        switch self {
        case .web: return .green
        case .computer: return .orange
        case .office: return .red
        }
    }

    var title: String {
        switch self {
        case .web: return "есть веб-версия"
        case .computer: return "нужен компьютер или офис"
        case .office: return "только офис"
        }
    }
}

struct InstallMethod: Identifiable {
    let id = UUID()
    let title: String
    let tag: String
    /// Поддерживает Markdown: **жирный**, `код`.
    let text: String
    var best = false
    var link: (title: String, url: URL)? = nil

    var attributedText: AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString(text)
    }
}

struct RuApp: Identifiable {
    let id: String
    let name: String
    let short: String
    let developer: String
    let category: AppCategory
    let color: Color
    let monogram: String
    let availability: Availability
    let status: String
    var note: String? = nil
    let web: URL?
    let site: URL
    let methods: [InstallMethod]
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255
        )
    }
}

private func url(_ s: String) -> URL { URL(string: s)! }

private let restoreFromPurchases = InstallMethod(
    title: "Восстановление из «Покупок»",
    tag: "если ставили раньше",
    text: "App Store → фото профиля → **Покупки**. Если строки нет, восстановите с компьютера через iMazing (только с сайта imazing.com)."
)

enum Catalog {
    static let checkedAt = "12.10.2026"

    static let apps: [RuApp] = [
        RuApp(
            id: "sber", name: "СберБанк Онлайн", short: "Сбер", developer: "Сбербанк",
            category: .bank, color: Color(hex: 0x1F8F4E), monogram: "Сб", availability: .web,
            status: "Удалено из App Store в 2022",
            note: "Вместе с ним недоступны СберИнвестор, СберKids и СберБизнес.",
            web: url("https://online.sberbank.ru"), site: url("https://www.sberbank.ru"),
            methods: [
                InstallMethod(
                    title: "Верни Сбер на iPhone", tag: "компьютер",
                    text: "Официальная программа Сбера для Windows. Скачивает СберБанк Онлайн, СберИнвестор, СберKids и СберБизнес из истории покупок вашего Apple ID. Нужны iTunes, кабель, iOS 14+ и 2 ГБ свободного места. Работает, только если приложение уже когда-то ставилось на этот Apple ID.",
                    best: true, link: ("Найти программу на sberbank.ru", url("https://www.sberbank.ru"))
                ),
                InstallMethod(
                    title: "Отделение банка", tag: "первая установка",
                    text: "Сотрудник бесплатно установит приложение на ваш iPhone. Возьмите паспорт и телефон. Это единственный способ, если вы никогда не скачивали Сбер на свой Apple ID."
                ),
                InstallMethod(
                    title: "Веб-версия", tag: "без установки",
                    text: "СберБанк Онлайн в браузере. Добавьте на экран «Домой», и он откроется как отдельное приложение."
                ),
            ]
        ),
        RuApp(
            id: "tbank", name: "Т-Банк", short: "Т-Банк", developer: "Т-Банк (Тинькофф)",
            category: .bank, color: Color(hex: 0x2B2B2B), monogram: "Т", availability: .web,
            status: "Удалено из App Store",
            note: "Банк меняет доступные способы. Актуальный подскажет чат поддержки в веб-версии.",
            web: url("https://www.tbank.ru/mybank/"), site: url("https://www.tbank.ru"),
            methods: [
                InstallMethod(
                    title: "Временный Apple ID от поддержки", tag: "без компьютера",
                    text: "Напишите в чат поддержки Т-Банка. Банк выдаёт временную учётную запись, под которой приложение скачивается из App Store. После установки выйдите из неё и вернитесь в свой Apple ID.",
                    best: true, link: ("Инструкция на tbank.ru", url("https://www.tbank.ru/bank/help/interfaces/bank-app/get/app-store/"))
                ),
                InstallMethod(
                    title: "T-Mazing", tag: "компьютер",
                    text: "Программа банка для Windows и macOS. Восстанавливает приложения Т-Банка по кабелю. Скачивайте только с сайта tbank.ru: ссылка появляется в личном кабинете, если способ вам доступен."
                ),
                InstallMethod(
                    title: "Курьер", tag: "при выдаче карты",
                    text: "Попросите курьера установить приложение, когда он привезёт карту."
                ),
                InstallMethod(
                    title: "Мобильная версия личного кабинета", tag: "без установки",
                    text: "На iOS 17 и новее работает почти как приложение. Добавьте на экран «Домой»."
                ),
            ]
        ),
        RuApp(
            id: "alfa", name: "Альфа-Банк", short: "Альфа", developer: "Альфа-Банк",
            category: .bank, color: Color(hex: 0xD8261C), monogram: "А", availability: .web,
            status: "Удалено из App Store в 2022",
            note: "Альфа иногда публикует приложение в App Store под другим названием. Доверяйте только ссылке с alfabank.ru.",
            web: url("https://web.alfabank.ru"), site: url("https://alfabank.ru"),
            methods: [
                InstallMethod(
                    title: "Отделение или курьер", tag: "бесплатно",
                    text: "Сотрудник установит приложение на iPhone. Возьмите паспорт и карту. Push-уведомления в такой версии могут не работать.",
                    best: true
                ),
                InstallMethod(
                    title: "Новое приложение в App Store", tag: "проверяйте",
                    text: "Если банк выпустил приложение под новым названием, ссылка будет на сайте alfabank.ru. Копии в App Store от других разработчиков ставить нельзя."
                ),
                InstallMethod(
                    title: "Веб-версия Альфа-Онлайн", tag: "без установки",
                    text: "Переводы, платежи и выписки в браузере. Добавьте на экран «Домой»."
                ),
            ]
        ),
        RuApp(
            id: "vtb", name: "ВТБ Онлайн", short: "ВТБ", developer: "ВТБ",
            category: .bank, color: Color(hex: 0x0A2896), monogram: "ВТБ", availability: .web,
            status: "Удалено из App Store в 2022",
            web: url("https://online.vtb.ru"), site: url("https://www.vtb.ru"),
            methods: [
                InstallMethod(
                    title: "Веб-версия", tag: "без установки",
                    text: "По функциям почти как приложение: переводы, платежи, баланс. Добавьте на экран «Домой». Если сайт открывается с ошибкой сертификата, попробуйте Яндекс Браузер.",
                    best: true
                ),
                InstallMethod(
                    title: "Отделение или курьер", tag: "бесплатно",
                    text: "Сотрудник установит приложение на ваш iPhone."
                ),
            ]
        ),
        RuApp(
            id: "gpb", name: "Газпромбанк", short: "Газпромбанк", developer: "Газпромбанк",
            category: .bank, color: Color(hex: 0x0D5AA7), monogram: "Г", availability: .computer,
            status: "Удалено из App Store",
            web: nil, site: url("https://www.gazprombank.ru"),
            methods: [
                InstallMethod(
                    title: "Отделение банка", tag: "бесплатно",
                    text: "Уточните в отделении, ставят ли они приложение на iPhone.",
                    best: true
                ),
                InstallMethod(
                    title: "Личный кабинет на сайте", tag: "без установки",
                    text: "Вход есть на gazprombank.ru. На телефоне он менее удобен, чем приложение, но основные операции доступны."
                ),
            ]
        ),
        RuApp(
            id: "max", name: "MAX", short: "MAX", developer: "VK",
            category: .social, color: Color(hex: 0x6B3CF0), monogram: "M", availability: .web,
            status: "Удалено из App Store 3 июня 2026",
            note: "Уже установленный MAX работает, но уведомления в нём пропали: Apple отзывает токен уведомлений у удалённых приложений. Не удаляйте его.",
            web: url("https://web.max.ru"), site: url("https://max.ru"),
            methods: [
                InstallMethod(
                    title: "Веб-версия на экране «Домой»", tag: "с уведомлениями",
                    text: "Откройте web.max.ru в Safari и добавьте на экран «Домой». Так вернутся уведомления о сообщениях (iOS 16.4+). Войдите по номеру телефона.",
                    best: true
                ),
                restoreFromPurchases,
            ]
        ),
        RuApp(
            id: "vk", name: "ВКонтакте", short: "ВКонтакте", developer: "VK",
            category: .social, color: Color(hex: 0x0077FF), monogram: "VK", availability: .web,
            status: "Удалено из App Store в июне 2026",
            note: "Установленное приложение продолжает работать без уведомлений.",
            web: url("https://vk.com"), site: url("https://vk.com"),
            methods: [
                InstallMethod(
                    title: "Веб-версия", tag: "без установки",
                    text: "Мобильная версия vk.com на экране «Домой». Лента, сообщения, музыка и клипы.",
                    best: true
                ),
                restoreFromPurchases,
            ]
        ),
        RuApp(
            id: "vkm", name: "VK Мессенджер", short: "VK Мессенджер", developer: "VK",
            category: .social, color: Color(hex: 0x2A5BD7), monogram: "VKм", availability: .web,
            status: "Удалено из App Store в июне 2026",
            web: url("https://web.vk.me"), site: url("https://vk.me"),
            methods: [
                InstallMethod(
                    title: "Веб-версия", tag: "без установки",
                    text: "Чаты ВКонтакте в браузере. Добавьте на экран «Домой».",
                    best: true
                ),
                InstallMethod(
                    title: "Сообщения в vk.com", tag: "альтернатива",
                    text: "Те же переписки есть в веб-версии ВКонтакте."
                ),
            ]
        ),
        RuApp(
            id: "ok", name: "Одноклассники", short: "ОК", developer: "VK",
            category: .social, color: Color(hex: 0xEE8208), monogram: "ОК", availability: .web,
            status: "Удалено из App Store в июне 2026",
            web: url("https://ok.ru"), site: url("https://ok.ru"),
            methods: [
                InstallMethod(title: "Веб-версия", tag: "без установки", text: "Мобильная версия ok.ru на экране «Домой».", best: true),
                restoreFromPurchases,
            ]
        ),
        RuApp(
            id: "dzen", name: "Дзен", short: "Дзен", developer: "VK",
            category: .media, color: Color(hex: 0x1A1A1A), monogram: "Дз", availability: .web,
            status: "Удалено из App Store в июне 2026",
            web: url("https://dzen.ru"), site: url("https://dzen.ru"),
            methods: [
                InstallMethod(title: "Веб-версия", tag: "без установки", text: "Статьи и видео Дзена в браузере. Добавьте на экран «Домой».", best: true),
            ]
        ),
        RuApp(
            id: "vkvideo", name: "VK Видео", short: "VK Видео", developer: "VK",
            category: .media, color: Color(hex: 0xE0245E), monogram: "▶", availability: .web,
            status: "Удалено из App Store в июне 2026",
            web: url("https://vkvideo.ru"), site: url("https://vkvideo.ru"),
            methods: [
                InstallMethod(title: "Веб-версия", tag: "без установки", text: "vkvideo.ru открывается в Safari и на экране «Домой». Видео играет и в полноэкранном режиме.", best: true),
            ]
        ),
        RuApp(
            id: "vkmusic", name: "VK Музыка", short: "VK Музыка", developer: "VK",
            category: .media, color: Color(hex: 0xC4127D), monogram: "♪", availability: .web,
            status: "Удалено из App Store в июне 2026",
            note: "В веб-версии музыка может останавливаться при блокировке экрана.",
            web: url("https://vk.com/audio"), site: url("https://vk.com"),
            methods: [
                InstallMethod(title: "Музыка в веб-версии ВКонтакте", tag: "без установки", text: "Раздел «Музыка» на vk.com. Подписка VK Музыка действует и там.", best: true),
                restoreFromPurchases,
            ]
        ),
        RuApp(
            id: "mailru", name: "Почта Mail.ru", short: "Почта Mail", developer: "VK",
            category: .mail, color: Color(hex: 0x005FF9), monogram: "@", availability: .web,
            status: "Удалено из App Store в июне 2026",
            web: url("https://e.mail.ru"), site: url("https://mail.ru"),
            methods: [
                InstallMethod(
                    title: "Встроенная «Почта» iPhone", tag: "с уведомлениями",
                    text: "**Настройки → Приложения → Почта → Учётные записи → Новая → Другое.** Входящая почта: `imap.mail.ru`, исходящая: `smtp.mail.ru`. Вместо обычного пароля нужен пароль для внешнего приложения: создайте его в настройках безопасности почты на сайте.",
                    best: true
                ),
                InstallMethod(title: "Веб-версия", tag: "без установки", text: "e.mail.ru на экране «Домой»."),
            ]
        ),
    ]
}

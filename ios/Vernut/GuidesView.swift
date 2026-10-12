import SwiftUI

struct StepRow: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.subheadline.monospacedDigit().weight(.semibold))
                .foregroundColor(.accentColor)
                .frame(width: 26, height: 26)
                .background(Circle().fill(Color.accentColor.opacity(0.15)))
            Text((try? AttributedString(markdown: text)) ?? AttributedString(text))
                .font(.subheadline)
        }
        .padding(.vertical, 2)
    }
}

struct GuidesView: View {
    private let homeScreen = [
        "Откройте веб-версию **в Safari**. В других браузерах ярлык тоже создаётся, но уведомления надёжнее работают из Safari.",
        "Нажмите **Поделиться** (квадрат со стрелкой). В iOS 26 он спрятан под **•••** внизу справа.",
        "Пролистайте вниз и выберите **На экран «Домой»**.",
        "Оставьте включённым **Открыть как веб-приложение** и нажмите **Добавить**.",
        "Запустите сайт с новой иконки и войдите. Когда сайт спросит про уведомления, разрешите их.",
    ]

    private let purchases = [
        "App Store → фото профиля справа вверху → **Покупки** → **Мои покупки**.",
        "Найдите приложение и нажмите облако со стрелкой. Если строки нет, Apple скрыла её для удалённых приложений.",
        "Тогда используйте утилиту банка с компьютера: «Верни Сбер на iPhone» или T-Mazing. Для остальных приложений подходит iMazing с сайта imazing.com.",
    ]

    private let mail = [
        "**Настройки → Приложения → Почта → Учётные записи → Новая учётная запись → Другое → Новая учётная запись.**",
        "Введите имя, адрес и **пароль для внешнего приложения**. Создайте его на mail.ru: Настройки → Безопасность → Пароли для внешних приложений.",
        "Сервер входящей почты (IMAP): `imap.mail.ru`. Исходящей (SMTP): `smtp.mail.ru`.",
        "Нажмите **Далее** и **Сохранить**. Уведомления придут от встроенной «Почты».",
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(homeScreen.enumerated()), id: \.offset) { StepRow(number: $0.offset + 1, text: $0.element) }
                } header: {
                    Text("Сайт на экран «Домой»")
                } footer: {
                    Text("Уведомления от веб-приложений работают на iOS 16.4 и новее, и только если сайт открыт с иконки на экране «Домой».")
                }

                Section {
                    ForEach(Array(purchases.enumerated()), id: \.offset) { StepRow(number: $0.offset + 1, text: $0.element) }
                } header: {
                    Text("Если приложение уже было на Apple ID")
                } footer: {
                    Text("Не удаляйте уже установленные приложения. После удаления из App Store они продолжают работать, а поставить их заново будет сложнее.")
                }

                Section {
                    ForEach(Array(mail.enumerated()), id: \.offset) { StepRow(number: $0.offset + 1, text: $0.element) }
                } header: {
                    Text("Почта Mail.ru во встроенной «Почте»")
                }
            }
            .navigationTitle("Инструкции")
        }
    }
}

struct SafetyView: View {
    private let donts = [
        "Не скачивайте IPA-файлы банков из Telegram-каналов и с «зеркал». Модифицированное банковское приложение крадёт коды и деньги.",
        "Не устанавливайте профили конфигурации и «сертификаты разработчика» с чужих сайтов.",
        "Не входите в чужой Apple ID, кроме временной учётки, которую выдал чат поддержки самого банка.",
        "Не платите за «установку Сбера» сторонним сервисам. Банки ставят приложения бесплатно в офисе и через курьера.",
        "Скачивайте утилиты банков только с их сайтов. Банки не рассылают ссылки на них в мессенджерах.",
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Чего не делать") {
                    ForEach(donts, id: \.self) { text in
                        Label {
                            Text(text).font(.subheadline)
                        } icon: {
                            Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
                        }
                    }
                }

                Section("Почему здесь нет кнопки «Скачать»") {
                    Text("iOS ставит приложения только из App Store. Ни одно приложение, включая это, не может само установить Сбер или VK. Сторонние «магазины» работают на корпоративных сертификатах: Apple отзывает их, и все приложения перестают запускаться.")
                        .font(.subheadline)
                    Text("Раздача чужих банковских приложений нарушает права банков, а вы не можете проверить, что сборку никто не изменил. Поэтому «Вернуть» ведёт только на сайты самих компаний.")
                        .font(.subheadline)
                }

                Section {
                    Text("«Вернуть» не связано с банками и VK. Названия принадлежат их владельцам. Данные проверены \(Catalog.checkedAt). Способы меняются: если что-то перестало работать, уточните в поддержке банка.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Безопасность")
        }
    }
}

import SafariServices
import SwiftUI

struct WebPage: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}

struct AppDetailView: View {
    let app: RuApp
    @EnvironmentObject private var favorites: Favorites
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var page: WebPage?
    @State private var copied = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        AppIconView(app: app, size: 56)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(app.name).font(.title3.weight(.semibold))
                            Text(app.developer).font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                    Label(app.status, systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                    if app.web != nil {
                        Label("Веб-версия работает", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    if let note = app.note {
                        Text(note).font(.subheadline).foregroundColor(.secondary)
                    }
                }

                if let web = app.web {
                    Section {
                        Button { page = WebPage(url: web) } label: {
                            Label("Открыть веб-версию", systemImage: "globe")
                        }
                        Button { openURL(web) } label: {
                            Label("Открыть в Safari, чтобы добавить на экран «Домой»", systemImage: "plus.app")
                        }
                        Button {
                            UIPasteboard.general.string = web.absoluteString
                            copied = true
                        } label: {
                            Label(copied ? "Адрес скопирован" : "Скопировать адрес",
                                  systemImage: copied ? "checkmark" : "doc.on.doc")
                        }
                    } footer: {
                        Text(web.host ?? web.absoluteString).font(.footnote.monospaced())
                    }
                }

                Section("Способы установки") {
                    ForEach(Array(app.methods.enumerated()), id: \.element.id) { index, method in
                        MethodRow(index: index + 1, method: method)
                    }
                }

                Section {
                    Link(destination: app.site) {
                        Label("Официальный сайт: \(app.site.host ?? "")", systemImage: "arrow.up.right.square")
                    }
                }
            }
            .navigationTitle(app.short)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button { favorites.toggle(app.id) } label: {
                        Image(systemName: favorites.contains(app.id) ? "star.fill" : "star")
                    }
                    .accessibilityLabel(favorites.contains(app.id) ? "Убрать из моих" : "Добавить в мои")
                }
            }
            .sheet(item: $page) { page in
                SafariView(url: page.url).ignoresSafeArea()
            }
        }
    }
}

struct MethodRow: View {
    let index: Int
    let method: InstallMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(index). \(method.title)").font(.headline)
                Spacer(minLength: 8)
                if method.best {
                    Text("лучший сейчас")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                        .foregroundColor(.accentColor)
                }
            }
            Text(method.tag.uppercased())
                .font(.caption2.monospaced())
                .foregroundColor(.secondary)
            Text(method.attributedText)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let link = method.link {
                Link("\(link.title) ↗", destination: link.url).font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ controller: SFSafariViewController, context: Context) {}
}

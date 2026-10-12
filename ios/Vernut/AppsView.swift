import SwiftUI

struct AppsView: View {
    @EnvironmentObject private var favorites: Favorites
    @AppStorage("category") private var categoryRaw = AppCategory.all.rawValue
    @State private var query = ""
    @State private var selected: RuApp?

    private let columns = [GridItem(.adaptive(minimum: 72, maximum: 100), spacing: 12)]

    private var category: AppCategory { AppCategory(rawValue: categoryRaw) ?? .all }

    private var filtered: [RuApp] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        return Catalog.apps.filter { app in
            switch category {
            case .all: break
            case .favorites: if !favorites.contains(app.id) { return false }
            default: if app.category != category { return false }
            }
            if q.isEmpty { return true }
            return "\(app.name) \(app.short) \(app.developer)".lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Официальные способы вернуть Сбер, Т-Банк, Альфу, ВТБ, MAX, VK и Почту Mail.ru, которые удалили из App Store.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    chips

                    if filtered.isEmpty {
                        Text(category == .favorites
                             ? "Отметьте звёздочкой приложения, которыми пользуетесь, и они появятся здесь."
                             : "Ничего не найдено. Попробуйте другое название.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 24)
                    } else {
                        LazyVGrid(columns: columns, spacing: 22) {
                            ForEach(filtered) { app in
                                Button { selected = app } label: {
                                    AppTile(app: app, isFavorite: favorites.contains(app.id))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    legend

                    Text("Данные проверены \(Catalog.checkedAt)")
                        .font(.caption.monospaced())
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Вернуть")
            .searchable(text: $query, prompt: "Сбер, MAX, почта…")
            .sheet(item: $selected) { app in
                AppDetailView(app: app)
                    .environmentObject(favorites)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var chips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AppCategory.allCases) { c in
                    let on = c == category
                    Button { categoryRaw = c.rawValue } label: {
                        Text(c.title)
                            .font(.subheadline)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Capsule().fill(on ? Color.primary : Color(.secondarySystemGroupedBackground)))
                            .foregroundColor(on ? Color(.systemBackground) : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, -16)
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach([Availability.web, .computer, .office], id: \.title) { a in
                HStack(spacing: 8) {
                    Circle().fill(a.color).frame(width: 10, height: 10)
                    Text(a.title)
                }
            }
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}

struct AppIconView: View {
    let app: RuApp
    var size: CGFloat = 64

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.23, style: .continuous)
            .fill(app.color)
            .frame(width: size, height: size)
            .overlay(
                Text(app.monogram)
                    .font(.system(size: size * 0.3, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(4)
            )
            .accessibilityHidden(true)
    }
}

struct AppTile: View {
    let app: RuApp
    let isFavorite: Bool

    var body: some View {
        VStack(spacing: 7) {
            AppIconView(app: app)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(app.availability.color)
                        .frame(width: 16, height: 16)
                        .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 3))
                        .offset(x: 5, y: -5)
                }
                .overlay(alignment: .bottomLeading) {
                    if isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                            .frame(width: 20, height: 20)
                            .background(Circle().fill(Color(.secondarySystemGroupedBackground)))
                            .offset(x: -4, y: 4)
                    }
                }
            Text(app.short)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(app.name)
    }
}

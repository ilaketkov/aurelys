import SwiftUI

@main
struct VernutApp: App {
    @StateObject private var favorites = Favorites()

    var body: some Scene {
        WindowGroup {
            TabView {
                AppsView()
                    .tabItem { Label("Приложения", systemImage: "square.grid.2x2") }
                GuidesView()
                    .tabItem { Label("Инструкции", systemImage: "book") }
                SafetyView()
                    .tabItem { Label("Безопасность", systemImage: "exclamationmark.shield") }
            }
            .environmentObject(favorites)
        }
    }
}

final class Favorites: ObservableObject {
    @Published private(set) var ids: Set<String>
    private let key = "favorites"

    init() {
        ids = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    func contains(_ id: String) -> Bool { ids.contains(id) }

    func toggle(_ id: String) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}

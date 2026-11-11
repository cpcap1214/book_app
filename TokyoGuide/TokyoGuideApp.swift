import SwiftUI

@main
struct TokyoGuideApp: App {
    init() {
        Appearance.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum AppTab: String, Hashable {
    case spots, featured, areas, web
}

struct ContentView: View {
    // 截圖用：啟動參數 -startTab web 可直接打開指定分頁，平常使用不受影響。
    @State private var selection: AppTab =
        AppTab(rawValue: UserDefaults.standard.string(forKey: "startTab") ?? "") ?? .spots

    var body: some View {
        TabView(selection: $selection) {
            Tab("景點", systemImage: "building.columns", value: AppTab.spots) {
                SpotListView()
            }
            Tab("精選", systemImage: "rectangle.portrait.on.rectangle.portrait", value: AppTab.featured) {
                FeaturedView()
            }
            Tab("地區", systemImage: "map", value: AppTab.areas) {
                AreaListView()
            }
            Tab("官方導覽", systemImage: "safari", value: AppTab.web) {
                NavigationStack {
                    SpotWebView(title: "GO TOKYO", url: URL(string: "https://www.gotokyo.org/tc/")!)
                }
            }
        }
        // iPhone：tab bar 在下方；iPad：tab bar 在上方，並可展開成側邊欄。
        .tabViewStyle(.sidebarAdaptable)
        .tint(Theme.accent)
    }
}

#Preview {
    ContentView()
}

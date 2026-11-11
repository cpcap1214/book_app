import SwiftUI

/// 景點：雜誌目錄式的 List，每一列是一張大照片＋明體店名。
struct SpotListView: View {
    // 截圖用：啟動參數 -openSpot sensoji 會直接打開該景點。
    @State private var path: [Spot] = TokyoData.spots.filter {
        $0.id == UserDefaults.standard.string(forKey: "openSpot")
    }
    /// 點卡片時，照片放大成介紹頁的轉場動畫。
    @Namespace private var zoom

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(TokyoData.spots) { spot in
                    // 透明的 NavigationLink 疊在卡片上：保留點擊換頁，但不顯示系統的箭頭。
                    ZStack {
                        SpotCard(spot: spot, zoom: zoom)
                        NavigationLink(value: spot) { EmptyView() }
                            .opacity(0)
                    }
                    .cardScrollEffect()
                    .column(Theme.listColumn)
                    .plainRow(top: 12, bottom: 28)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Theme.ground)
            .navigationTitle("東京散步")
            .navigationDestination(for: Spot.self) { spot in
                SpotDetailView(spot: spot)
                    .navigationTransition(.zoom(sourceID: spot.id, in: zoom))
            }
        }
    }
}

/// 大張照片在上，店名與站牌在下。
struct SpotCard: View {
    let spot: Spot
    let zoom: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Photo(name: spot.imageName, aspect: 3 / 2)
                .matchedTransitionSource(id: spot.id, in: zoom)

            HStack(alignment: .center, spacing: 12) {
                Text(spot.name)
                    .font(.serif(26, weight: .semibold, relativeTo: .title2))
                    .foregroundStyle(Theme.ink)
                    .lineLimit(2)
                Spacer(minLength: 8)
                StationBadge(station: spot.station, size: 34)
            }
        }
        .contentShape(Rectangle())
    }
}

/// 精簡版的列：地區頁使用。
struct SpotRow: View {
    let spot: Spot
    let zoom: Namespace.ID

    var body: some View {
        HStack(spacing: 18) {
            Photo(name: spot.imageName, aspect: 4 / 3)
                .frame(width: 128)
                .matchedTransitionSource(id: spot.id, in: zoom)

            Text(spot.name)
                .font(.serif(22, weight: .semibold, relativeTo: .title3))
                .foregroundStyle(Theme.ink)
                .lineLimit(2)

            Spacer(minLength: 8)

            StationBadge(station: spot.station, size: 32)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    SpotListView()
}

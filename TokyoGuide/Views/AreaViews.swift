import SwiftUI

/// 地區 → 景點列表 → 景點介紹，三層 NavigationStack。
struct AreaListView: View {
    @Namespace private var zoom

    var body: some View {
        NavigationStack {
            List(TokyoData.areas) { area in
                ZStack {
                    AreaCard(area: area)
                        .matchedTransitionSource(id: area.id, in: zoom)
                    NavigationLink(value: area) { EmptyView() }
                        .opacity(0)
                }
                .cardScrollEffect()
                .column(Theme.listColumn)
                .plainRow(top: 10, bottom: 10)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Theme.ground)
            .navigationTitle("地區")
            .navigationDestination(for: Area.self) { area in
                AreaDetailView(area: area, zoom: zoom)
                    .navigationTransition(.zoom(sourceID: area.id, in: zoom))
            }
            .navigationDestination(for: Spot.self) { spot in
                SpotDetailView(spot: spot)
                    .navigationTransition(.zoom(sourceID: spot.id, in: zoom))
            }
        }
    }
}

struct AreaCard: View {
    let area: Area

    var body: some View {
        Photo(name: area.coverImage, height: 230)
            .overlay { BottomScrim(strength: 0.75) }
            .overlay(alignment: .bottomLeading) {
                HStack(alignment: .lastTextBaseline) {
                    Text(area.name)
                        .font(.serif(32, weight: .semibold, relativeTo: .title))
                        .tracking(1)
                    Spacer()
                    Text("\(TokyoData.spots(in: area).count) 處")
                        .font(.serif(18))
                }
                .foregroundStyle(.white)
                .padding(22)
            }
            .contentShape(Rectangle())
    }
}

struct AreaDetailView: View {
    let area: Area
    let zoom: Namespace.ID
    @State private var shown = false

    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 24) {
                Photo(name: area.coverImage, aspect: 16 / 9)
                Text(area.description)
                    .font(.serif(22, relativeTo: .title3))
                    .lineSpacing(9)
                    .foregroundStyle(Theme.ink)
                    .rise(shown, delay: 0.15)
            }
            .column(Theme.listColumn)
            .plainRow(top: 8, bottom: 32)

            ForEach(Array(TokyoData.spots(in: area).enumerated()), id: \.element.id) { index, spot in
                ZStack {
                    SpotRow(spot: spot, zoom: zoom)
                    NavigationLink(value: spot) { EmptyView() }
                        .opacity(0)
                }
                // 景點一列一列依序浮現
                .rise(shown, delay: 0.25 + Double(index) * 0.08)
                .column(Theme.listColumn)
                .plainRow(top: 10, bottom: 10)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Theme.ground)
        .navigationTitle(area.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { shown = true }
    }
}

#Preview {
    AreaListView()
}

import SwiftUI

/// 精選：TabView 搭配 page 樣式左右滑動，每一頁像雜誌的一個跨頁。
struct FeaturedView: View {
    @State private var current = TokyoData.featuredIDs[0]
    @Namespace private var zoom

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $current) {
                    ForEach(TokyoData.featured) { spot in
                        FeaturedPage(spot: spot, isCurrent: current == spot.id, zoom: zoom)
                            .tag(spot.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                PageBars(ids: TokyoData.featuredIDs, current: current)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
            .background(Theme.ground)
            .navigationTitle("精選")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Spot.self) { spot in
                SpotDetailView(spot: spot)
                    .navigationTransition(.zoom(sourceID: spot.id, in: zoom))
            }
        }
    }
}

struct FeaturedPage: View {
    let spot: Spot
    let isCurrent: Bool
    let zoom: Namespace.ID
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        NavigationLink(value: spot) {
            // 照片在上、文字在下，像雜誌的一頁。
            VStack(alignment: .leading, spacing: sizeClass == .regular ? 36 : 24) {
                photo
                caption
            }
            .padding(.horizontal, sizeClass == .regular ? 56 : 24)
            .padding(.top, sizeClass == .regular ? 32 : 12)
            .padding(.bottom, 28)
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressStyle(scale: 0.99))
    }

    /// 照片：滑動時以較慢的速度橫移（視差），停下來後慢慢推近。
    private var photo: some View {
        GeometryReader { proxy in
            let shift = proxy.frame(in: .global).minX
            DriftingImage(name: spot.imageName, active: isCurrent)
                .frame(width: proxy.size.width + 80, height: proxy.size.height)
                .offset(x: -40 - shift * 0.25)
        }
        .clipped()
        .matchedTransitionSource(id: spot.id, in: zoom)
    }

    private var caption: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(spot.name)
                .font(.serif(sizeClass == .regular ? 52 : 40, weight: .semibold, relativeTo: .largeTitle))
                .tracking(1)
                .foregroundStyle(Theme.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .center) {
                StationLine(station: spot.station, drawsIn: true)
                Spacer(minLength: 12)
                Image(systemName: "arrow.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ground)
                    .frame(width: 52, height: 52)
                    .background(Theme.ink, in: Circle())
                    .accessibilityHidden(true)
            }
        }
        .opacity(isCurrent ? 1 : 0)
        .offset(y: isCurrent ? 0 : 16)
        .animation(.spring(duration: 0.7, bounce: 0.1).delay(0.08), value: isCurrent)
    }
}

/// 慢慢推近的鏡頭效果，只在目前那一頁進行。
struct DriftingImage: View {
    let name: String
    let active: Bool
    @State private var zoomed = false

    var body: some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .scaleEffect(zoomed ? 1.08 : 1.0)
            .onAppear(perform: update)
            .onChange(of: active) { update() }
    }

    private func update() {
        if active {
            withAnimation(.easeInOut(duration: 16).repeatForever(autoreverses: true)) {
                zoomed = true
            }
        } else {
            withAnimation(.easeOut(duration: 0.4)) { zoomed = false }
        }
    }
}

/// 自訂頁面指示：目前那頁的橫條較長。
struct PageBars: View {
    let ids: [String]
    let current: String

    var body: some View {
        HStack(spacing: 6) {
            ForEach(ids, id: \.self) { id in
                Capsule()
                    .fill(Theme.ink.opacity(id == current ? 1 : 0.2))
                    .frame(width: id == current ? 28 : 8, height: 4)
            }
        }
        .animation(.spring(duration: 0.4), value: current)
        .accessibilityHidden(true)
    }
}

#Preview {
    FeaturedView()
}

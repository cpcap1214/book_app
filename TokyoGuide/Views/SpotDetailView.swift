import SwiftUI

struct SpotDetailView: View {
    let spot: Spot
    @State private var shown = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var heroHeight: CGFloat { sizeClass == .regular ? 600 : 470 }

    private var neighbours: [Spot] {
        TokyoData.spots.filter { $0.areaID == spot.areaID && $0.id != spot.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ParallaxHero(imageName: spot.imageName, height: heroHeight)

                VStack(alignment: .leading, spacing: 0) {
                    Text(spot.name)
                        .font(.serif(46, weight: .semibold, relativeTo: .largeTitle))
                        .tracking(1)
                        .foregroundStyle(Theme.ink)
                        .rise(shown, delay: 0.05)

                    StationLine(station: spot.station, drawsIn: true)
                        .padding(.top, 18)
                        .rise(shown, delay: 0.12)

                    Text(spot.lead)
                        .font(.serif(24, relativeTo: .title2))
                        .lineSpacing(9)
                        .foregroundStyle(Theme.ink)
                        .padding(.top, 44)
                        .rise(shown, delay: 0.2)

                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(spot.paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.system(size: 17))
                                .lineSpacing(10)
                                .foregroundStyle(Theme.ink)
                        }
                    }
                    .padding(.top, 28)
                    .rise(shown, delay: 0.28)

                    SpecTable(rows: [
                        ("開放時間", spot.hours),
                        ("費用", spot.price),
                        ("最近車站", "\(spot.station.line) \(spot.station.name)站\n步行 \(spot.station.walkMinutes) 分鐘"),
                    ])
                    .padding(.top, 52)
                    .revealOnScroll()

                    PullQuote(text: spot.tip, color: spot.station.lineColor)
                        .padding(.top, 56)
                        .revealOnScroll()

                    NavigationLink {
                        SpotWebView(title: spot.name, url: spot.website)
                    } label: {
                        InkButtonLabel(title: "前往官方網站", systemImage: "arrow.up.right")
                    }
                    .buttonStyle(PressStyle())
                    .padding(.top, 56)
                    .revealOnScroll()
                }
                .padding(.horizontal, 24)
                .padding(.top, 36)
                .column()

                if !neighbours.isEmpty {
                    Nearby(spots: neighbours)
                        .padding(.top, 88)
                        .revealOnScroll()
                }
            }
            .padding(.bottom, 64)
        }
        .background(Theme.ground)
        .navigationTitle(spot.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { shown = true }
    }
}

/// 往上捲時照片以較慢速度移動；往下拉時照片放大。
struct ParallaxHero: View {
    let imageName: String
    let height: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView).minY
            let pull = max(0, minY)
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: height + pull)
                .offset(y: minY > 0 ? -minY : -minY * 0.4)
                .clipped()
        }
        .frame(height: height)
        .clipped()
        .accessibilityHidden(true)
    }
}

/// 資訊表：左邊小標，右邊明體內容，列與列之間用淡淡的細線。
struct SpecTable: View {
    let rows: [(String, String)]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text(row.0)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.muted)
                        .frame(width: 76, alignment: .leading)
                    Text(row.1)
                        .font(.serif(18, relativeTo: .body))
                        .lineSpacing(5)
                        .foregroundStyle(Theme.ink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 18)

                if index < rows.count - 1 {
                    Rectangle()
                        .fill(Theme.ink.opacity(0.12))
                        .frame(height: 0.5)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Theme.surface)
    }
}

/// 在地人的小提醒，做成雜誌的引言。
struct PullQuote: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            Rectangle()
                .fill(color)
                .frame(width: 3)
            VStack(alignment: .leading, spacing: 14) {
                Text("在地人的小提醒")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.muted)
                Text(text)
                    .font(.serif(22, relativeTo: .title3))
                    .lineSpacing(9)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

/// 同一區的其他景點，直式照片橫向捲動。
struct Nearby: View {
    let spots: [Spot]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("順路走走")
                .font(.serif(30, weight: .semibold, relativeTo: .title))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 24)
                .column()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(spots) { other in
                        NavigationLink(value: other) {
                            VStack(alignment: .leading, spacing: 12) {
                                Photo(name: other.imageName, aspect: 3 / 4)
                                    .frame(width: 200)
                                Text(other.name)
                                    .font(.serif(19, weight: .semibold))
                                    .foregroundStyle(Theme.ink)
                            }
                            .frame(width: 200, alignment: .leading)
                        }
                        .buttonStyle(PressStyle())
                    }
                }
                .padding(.horizontal, 24)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: TokyoData.spots[0])
    }
}

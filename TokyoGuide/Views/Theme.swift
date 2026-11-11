import SwiftUI
import UIKit

// MARK: - 顏色：和紙底、墨色字、朱色點綴

enum Theme {
    static let ground = Color("Ground")    // 和紙
    static let surface = Color("Surface")  // 深一階的和紙
    static let ink = Color("Ink")          // 墨
    static let muted = Color("Muted")      // 淡墨，只用在小標籤
    static let accent = Color("AccentColor") // 朱

    /// 內容欄寬：iPad 上維持雜誌般的閱讀行長。
    static let column: CGFloat = 680
    /// 列表欄寬：iPad 上列表不拉滿整個螢幕。
    static let listColumn: CGFloat = 760
}

// MARK: - 字型：標題用明體（Noto Serif TC），內文用系統黑體

extension Font {
    static func serif(_ size: CGFloat, weight: SerifWeight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        .custom(weight.postScriptName, size: size, relativeTo: style)
    }
}

enum SerifWeight {
    case regular, semibold

    var postScriptName: String {
        switch self {
        case .regular: "TokyoSerif-Regular"
        case .semibold: "TokyoSerif-SemiBold"
        }
    }
}

enum Appearance {
    /// 讓所有 navigation bar 的標題都換成明體。
    static func configure() {
        let ink = UIColor(named: "Ink") ?? .label
        let nav = UINavigationBar.appearance()
        if let large = UIFont(name: SerifWeight.semibold.postScriptName, size: 34) {
            nav.largeTitleTextAttributes = [.font: large, .foregroundColor: ink]
        }
        if let inline = UIFont(name: SerifWeight.semibold.postScriptName, size: 17) {
            nav.titleTextAttributes = [.font: inline, .foregroundColor: ink]
        }
    }
}

// MARK: - 地鐵站牌

/// 仿東京地鐵站牌：白底圓形、路線色外框、中間是站號。
struct StationBadge: View {
    let station: Station
    var size: CGFloat = 40
    /// true 時，路線色的外圈會像被畫出來一樣繞一圈出現。
    var drawsIn = false

    @State private var progress: CGFloat = 1

    var body: some View {
        let ring = size * 0.12
        ZStack {
            Circle().fill(.white)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(station.lineColor, style: StrokeStyle(lineWidth: ring, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .padding(ring / 2)
            VStack(spacing: -size * 0.07) {
                Text(station.code.prefix(1))
                    .font(.system(size: size * 0.24, weight: .bold))
                Text(station.code.dropFirst())
                    .font(.system(size: size * 0.33, weight: .bold))
            }
            .foregroundStyle(Color(white: 0.1))
            .monospacedDigit()
            .scaleEffect(progress < 1 ? 0.6 : 1)
            .opacity(progress < 1 ? 0 : 1)
        }
        .frame(width: size, height: size)
        .onAppear {
            guard drawsIn else { return }
            progress = 0
            withAnimation(.easeInOut(duration: 0.9).delay(0.25)) { progress = 1 }
        }
        .accessibilityElement()
        .accessibilityLabel("\(station.line)\(station.name)站，站號 \(station.code)")
    }
}

/// 站名一列：站牌＋站名＋路線與步行時間。
struct StationLine: View {
    let station: Station
    var onPhoto = false
    var drawsIn = false

    var body: some View {
        HStack(spacing: 12) {
            StationBadge(station: station, size: 38, drawsIn: drawsIn)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(station.name)站")
                    .font(.serif(18, weight: .semibold))
                Text("\(station.line)・步行 \(station.walkMinutes) 分鐘")
                    .font(.system(size: 14))
                    .opacity(onPhoto ? 0.85 : 1)
                    .foregroundStyle(onPhoto ? .white : Theme.muted)
            }
        }
        .foregroundStyle(onPhoto ? .white : Theme.ink)
    }
}

// MARK: - 照片

/// 用 overlay 放照片，避免 scaledToFill 把版面撐寬。
struct Photo: View {
    let name: String
    var aspect: CGFloat? = nil
    var height: CGFloat? = nil

    var body: some View {
        frameShape
            .overlay {
                Image(name)
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .accessibilityHidden(true)
    }

    @ViewBuilder private var frameShape: some View {
        if let aspect {
            Color.clear.aspectRatio(aspect, contentMode: .fit)
        } else {
            Color.clear.frame(maxWidth: .infinity).frame(height: height ?? 240)
        }
    }
}

/// 照片底部的深色遮罩，讓白字清楚。
struct BottomScrim: View {
    var strength: Double = 0.75

    var body: some View {
        LinearGradient(stops: [
            .init(color: .clear, location: 0.35),
            .init(color: .black.opacity(strength), location: 1),
        ], startPoint: .top, endPoint: .bottom)
    }
}

// MARK: - 互動

/// 按下時微微縮小。
struct PressStyle: ButtonStyle {
    var scale: CGFloat = 0.98

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(duration: 0.3), value: configuration.isPressed)
    }
}

/// 墨色膠囊按鈕。
struct InkButtonLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Text(title)
                .font(.serif(18, weight: .semibold))
            Spacer()
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
        }
        .foregroundStyle(Theme.ground)
        .padding(.horizontal, 26)
        .frame(height: 60)
        .background(Theme.ink, in: Capsule())
    }
}

/// 元件依序浮現。
struct Rise: ViewModifier {
    let shown: Bool
    let delay: Double

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 22)
            .animation(.spring(duration: 0.7, bounce: 0.1).delay(delay), value: shown)
    }
}

/// 捲到畫面中才浮現，只播放一次。
struct RevealOnScroll: ViewModifier {
    var delay: Double = 0
    @State private var visible = false

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 30)
            .animation(.spring(duration: 0.8, bounce: 0.1).delay(delay), value: visible)
            .onScrollVisibilityChange(threshold: 0.15) { isVisible in
                if isVisible { visible = true }
            }
    }
}

/// 列表的卡片第一次出現在畫面上時，從模糊、略小的狀態淡入。
struct CardScrollEffect: ViewModifier {
    @State private var shown = false

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .scaleEffect(shown ? 1 : 0.94)
            .blur(radius: shown ? 0 : 6)
            .offset(y: shown ? 0 : 24)
            .onAppear {
                withAnimation(.spring(duration: 0.8, bounce: 0.1)) { shown = true }
            }
    }
}

extension View {
    func rise(_ shown: Bool, delay: Double = 0) -> some View {
        modifier(Rise(shown: shown, delay: delay))
    }

    func revealOnScroll(delay: Double = 0) -> some View {
        modifier(RevealOnScroll(delay: delay))
    }

    func cardScrollEffect() -> some View {
        modifier(CardScrollEffect())
    }

    /// iPad 上把內容限制在置中的欄寬內。
    func column(_ width: CGFloat = Theme.column) -> some View {
        frame(maxWidth: width, alignment: .leading)
            .frame(maxWidth: .infinity)
    }

    /// List 的列：去掉分隔線、統一底色與間距。
    func plainRow(top: CGFloat = 0, bottom: CGFloat = 0) -> some View {
        listRowBackground(Theme.ground)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: top, leading: 20, bottom: bottom, trailing: 20))
    }
}

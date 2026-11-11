import SwiftUI

/// 地鐵站：東京的車站都有路線色與站號（例如銀座線淺草站 G19），App 用它當每個景點的識別。
struct Station: Hashable {
    let name: String
    let line: String
    let code: String
    let lineColor: Color
    let walkMinutes: Int
}

struct Spot: Identifiable, Hashable {
    let id: String
    let name: String
    let imageName: String
    let areaID: String
    let station: Station
    let lead: String
    let paragraphs: [String]
    let hours: String
    let price: String
    let tip: String
    let website: URL
}

struct Area: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let coverImage: String
}

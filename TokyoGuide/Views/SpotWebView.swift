import SwiftUI
import WebKit

/// 用 iOS 26 起 SwiftUI 原生的 WebView 顯示網頁。
struct SpotWebView: View {
    let title: String
    let url: URL

    @State private var page = WebPage()

    var body: some View {
        WebView(page)
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .top) {
                if page.isLoading {
                    ProgressView(value: page.estimatedProgress)
                        .tint(Theme.accent)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        page.reload()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("重新整理")

                    ShareLink(item: page.url ?? url)
                }
            }
            .onAppear {
                if page.url == nil {
                    page.load(URLRequest(url: url))
                }
            }
    }
}

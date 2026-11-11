# 東京散步 Tokyo Guide

**用地鐵站牌，走一遍東京。**

東京散步是一款以東京景點為主題的 SwiftUI 電子書 App。從淺草寺到台場，收錄 11 個景點，以照片、文字和地鐵站牌串起城市裡的散步路線。

畫面以日本旅遊雜誌為靈感，搭配和紙米色、墨黑、朱紅與明體標題，讓每個景點都像翻開一本旅行書。

支援 **iPhone 與 iPad** · **iOS / iPadOS 26.0+** · **Swift 6 / SwiftUI**

![東京散步：景點列表與介紹頁](Screenshots/article/iphone-spots.jpg)

## 功能特色

| 分頁 | 內容 |
| --- | --- |
| 景點 | 以照片卡片瀏覽全部景點，點入閱讀介紹、開放時間、費用與交通資訊。 |
| 精選 | 左右滑動瀏覽精選景點，以大幅照片、緩慢推近與視差效果呈現。 |
| 地區 | 依地區探索，從地區介紹進入景點列表，再閱讀個別景點。 |
| 官方導覽 | 在 App 內開啟 GO TOKYO 繁體中文網站，支援重新整理與分享連結。 |

每個景點都有對應的地鐵路線色、車站名稱、站號與步行時間。介紹頁也提供「在地人的小提醒」、官方網站入口，以及同地區的「順路走走」，方便接著探索附近景點。

景點文字與照片隨 App 內建，可離線閱讀。官方導覽與景點網站需要網路連線。

## 畫面與操作展示

### iPhone

![iPhone：精選、地區與官方導覽](Screenshots/article/iphone-tabs.jpg)

<details>
<summary>觀看操作示範</summary>

![iPhone 操作示範](Screenshots/demo/iphone-demo.gif)

[觀看 MP4 版本](Screenshots/demo/iphone-demo.mp4)

</details>

### iPad

同一套 SwiftUI 畫面會依裝置調整排版。iPad 提供頂部分頁與可展開的側邊欄，並限制閱讀欄寬，讓照片和內文在大螢幕上保持適合閱讀的比例。

![iPad：景點列表與介紹頁](Screenshots/article/ipad-spots.jpg)

<details>
<summary>更多 iPad 畫面與開頭畫面</summary>

![iPad：精選、地區與官方導覽](Screenshots/article/ipad-tabs.jpg)

![開頭畫面：iPhone 與 iPad](Screenshots/article/launch.jpg)

</details>

## 收錄景點

| 地區 | 景點 |
| --- | --- |
| 淺草・上野 | 淺草寺、東京晴空塔、上野恩賜公園、秋葉原 |
| 澀谷・原宿・新宿 | 澀谷十字路口、明治神宮、新宿御苑 |
| 丸之內・港區 | 皇居二重橋、東京鐵塔、築地場外市場 |
| 東京灣岸 | 台場與彩虹大橋 |

## 執行專案

### 環境需求

- macOS 與支援 iOS 26 SDK 的 Xcode。
- iOS / iPadOS 26.0 以上的模擬器或實體裝置。

### 開啟與執行

```sh
git clone https://github.com/cpcap1214/book_app.git
cd book_app
open TokyoGuide.xcodeproj
```

在 Xcode 選擇 `TokyoGuide` scheme 與 iPhone 或 iPad 模擬器，按下 **Run（⌘R）** 即可執行。專案使用 Apple 原生框架，不需安裝第三方套件，也不需設定 API 金鑰。

如需在實體裝置執行，請先在 target 的 **Signing & Capabilities** 設定自己的開發團隊，並視需要修改 Bundle Identifier。

### 重新產生 Xcode 專案（選用）

儲存庫已包含可直接開啟的 `.xcodeproj`。若修改 `project.yml`，可在安裝 XcodeGen 後，於專案根目錄執行：

```sh
xcodegen generate
```

## 實作重點

- **資料與畫面分離**：以 `Spot`、`Station`、`Area` 定義資料，集中在 `TokyoData` 管理，讓列表、精選與地區頁共用內容。
- **多層導覽**：使用 `TabView`、`NavigationStack` 與 `NavigationLink`，串起分頁與「地區 → 景點 → 介紹」的閱讀流程。
- **照片轉場與捲動效果**：使用 zoom 導覽轉場、視差大圖、捲動淡入及站牌描邊動畫，連接列表與內頁。
- **原生網頁整合**：使用 WebKit 的 SwiftUI `WebView` 與 `WebPage` 顯示官方網站，並呈現載入進度。
- **共用視覺元件**：在 `Theme.swift` 集中管理配色、字型、站牌與卡片樣式。
- **字型精簡**：將 Noto Serif TC 裁切為 App 使用的字元，內建 Regular 與 SemiBold 兩個字重。

## 專案結構

```text
TokyoGuide/
├── TokyoGuideApp.swift     # App 入口與四個分頁
├── Models/Spot.swift       # 景點、車站與地區資料模型
├── Data/SpotData.swift     # 景點內容與地區分類
├── Views/                 # 景點、精選、地區、網頁與共用元件
├── Assets.xcassets/        # 景點照片、色彩與 App 圖示
└── Fonts/                 # 精簡後的明體字型
TokyoGuide.xcodeproj/       # 可直接開啟的 Xcode 專案
Screenshots/               # iPhone、iPad 截圖與操作示範
tools/                     # 字型處理工具與字型授權
project.yml                # XcodeGen 設定
article.md                 # 完整創作說明與實作紀錄
credits.json               # 照片來源、作者與授權紀錄
```

新增景點時，可在 `SpotData.swift` 補上資料，並將對應照片放入 `Assets.xcassets`。若新增中文內容，也可使用 `tools/make_fonts.py` 更新字型子集，使用方式寫在該檔案開頭。

## 素材來源

景點照片來自 Wikimedia Commons，各自依原作者的 Creative Commons 授權使用。完整作者、來源頁面與授權連結收錄於 [credits.json](credits.json)。

標題字型以 Noto Serif TC 裁切並重新命名為 Tokyo Serif，採用 [SIL Open Font License 1.1](tools/OFL.txt)。照片與字型的授權請分別依各素材紀錄查閱。

更多創作發想、畫面設計與程式實作說明，請見 [完整專案文章](article.md)。

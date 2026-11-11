import SwiftUI

enum LineColor {
    static let ginza = Color(red: 0.95, green: 0.59, blue: 0.00)       // 銀座線 G
    static let marunouchi = Color(red: 0.96, green: 0.18, blue: 0.21)  // 丸之內線 M
    static let hibiya = Color(red: 0.61, green: 0.68, blue: 0.72)      // 日比谷線 H
    static let chiyoda = Color(red: 0.00, green: 0.73, blue: 0.52)     // 千代田線 C
    static let hanzomon = Color(red: 0.56, green: 0.46, blue: 0.84)    // 半藏門線 Z
    static let oedo = Color(red: 0.81, green: 0.02, blue: 0.36)        // 大江戶線 E
    static let yurikamome = Color(red: 0.11, green: 0.55, blue: 0.77)  // 百合海鷗號 U
}

enum TokyoData {
    static let areas: [Area] = [
        Area(id: "shitamachi", name: "淺草・上野",
             description: "老東京的下町。寺院、市集與高塔，從江戶時代一路走到今天。",
             coverImage: "sensoji"),
        Area(id: "west", name: "澀谷・原宿・新宿",
             description: "年輕人的東京。最擁擠的路口旁邊，就是最安靜的森林與庭園。",
             coverImage: "shibuya"),
        Area(id: "center", name: "丸之內・港區",
             description: "城市的中心。皇居的護城河、紅白鐵塔，還有吃得到早餐壽司的市場。",
             coverImage: "tokyotower"),
        Area(id: "bay", name: "東京灣岸",
             description: "填海而成的新城區，搭無人駕駛的電車跨過海灣。",
             coverImage: "odaiba"),
    ]

    static let spots: [Spot] = [
        Spot(id: "sensoji", name: "淺草寺", imageName: "sensoji", areaID: "shitamachi",
             station: Station(name: "淺草", line: "銀座線", code: "G19", lineColor: LineColor.ginza, walkMinutes: 5),
             lead: "東京最古老的寺院，從雷門的大紅燈籠開始。",
             paragraphs: [
                "相傳西元 628 年，一對漁夫兄弟在隅田川撈起一尊觀音像，淺草寺由此而生，至今已近一千四百年。",
                "穿過掛著巨大紅燈籠的雷門，是長約 250 公尺的仲見世通，兩旁擠滿賣人形燒、仙貝和手工藝品的小店。走到底就是寶藏門與本堂，旁邊的五重塔是拍照的好角度。",
                "傍晚寺院關門後，建築會打上燈光，人潮散去，反而是最有味道的時候。",
             ],
             hours: "本堂 6:00–17:00\n10 月至 3 月 6:30 起",
             price: "免費",
             tip: "早上八點前來，仲見世通的店還沒開，可以拍到幾乎沒有人的參道。",
             website: URL(string: "https://www.senso-ji.jp/")!),

        Spot(id: "skytree", name: "東京晴空塔", imageName: "skytree", areaID: "shitamachi",
             station: Station(name: "押上", line: "半藏門線", code: "Z14", lineColor: LineColor.hanzomon, walkMinutes: 1),
             lead: "634 公尺，全世界最高的電波塔。",
             paragraphs: [
                "2012 年啟用，高度 634 公尺取自東京舊稱「武藏」（む・さ・し）的諧音。塔身從底部的三角形，往上漸漸變成圓形，兼顧日本刀的「反り」與寺院柱子的「起り」兩種曲線。",
                "350 公尺的天望甲板與 450 公尺的天望迴廊可以俯瞰整個關東平原，天氣好的時候，富士山就在西邊的地平線上。",
                "塔下的東京晴空街道有三百多家店，水族館與天象儀也在這裡。",
             ],
             hours: "10:00–22:00",
             price: "天望甲板約 ¥2,100 起\n依日期與時段而定",
             tip: "冬天的早晨空氣最乾淨，看到富士山的機率最高。",
             website: URL(string: "https://www.tokyo-skytree.jp/")!),

        Spot(id: "ueno", name: "上野恩賜公園", imageName: "ueno", areaID: "shitamachi",
             station: Station(name: "上野", line: "銀座線", code: "G16", lineColor: LineColor.ginza, walkMinutes: 2),
             lead: "日本第一座公園，也是東京的博物館之丘。",
             paragraphs: [
                "1873 年成為日本最早指定的公園之一。園內有東京國立博物館、國立西洋美術館、上野動物園，一天都逛不完。",
                "三月底到四月初，約八百棵櫻花沿著中央大道盛開，夜晚掛上燈籠，是東京最熱鬧的賞櫻地點。",
                "南邊的不忍池夏天開滿荷花，池中的辯天堂可以沿著步道走過去。",
             ],
             hours: "5:00–23:00",
             price: "公園免費\n博物館與動物園另計",
             tip: "賞櫻季週末一早就有人鋪墊子佔位，想安靜看花就挑平日早上。",
             website: URL(string: "https://www.kensetsu.metro.tokyo.lg.jp/jimusho/toubuk/ueno/")!),

        Spot(id: "akihabara", name: "秋葉原", imageName: "akihabara", areaID: "shitamachi",
             station: Station(name: "秋葉原", line: "日比谷線", code: "H16", lineColor: LineColor.hibiya, walkMinutes: 1),
             lead: "電器街變成動漫與遊戲的聖地。",
             paragraphs: [
                "戰後這裡是賣收音機零件的黑市，後來成為全日本最大的電器街。九〇年代起，動漫、模型、遊戲店一間間進駐，秋葉原成了御宅族文化的中心。",
                "中央通兩側的大樓一層一店，一棟可以逛上好幾個小時：二手遊戲、扭蛋、模型、復古電腦零件都找得到。",
                "週日下午中央通會封街成為行人徒步區。",
             ],
             hours: "多數店家 10:00–21:00",
             price: "免費",
             tip: "大樓的高樓層通常比一樓便宜，逛街從頂樓往下走最省力。",
             website: URL(string: "https://zh.wikipedia.org/zh-tw/秋葉原")!),

        Spot(id: "shibuya", name: "澀谷十字路口", imageName: "shibuya", areaID: "west",
             station: Station(name: "澀谷", line: "銀座線", code: "G01", lineColor: LineColor.ginza, walkMinutes: 1),
             lead: "綠燈一亮，上千人同時從五個方向走過。",
             paragraphs: [
                "澀谷站八公口前的全向十字路口，號稱世界上最繁忙的行人穿越道，尖峰時段一次綠燈可以有超過兩千人通過。",
                "路口旁就是忠犬八公像。從澀谷 SCRAMBLE SQUARE 頂樓的 SHIBUYA SKY 往下看，人潮像潮水一樣交錯，是東京最具代表性的畫面之一。",
                "入夜後四周的巨型螢幕全亮，整個路口像一座舞台。",
             ],
             hours: "全天開放",
             price: "免費\nSHIBUYA SKY 另需門票",
             tip: "車站二樓的連絡通道有一整排窗戶，可以從正上方拍到整個路口。",
             website: URL(string: "https://www.shibuya-scramble-square.com/sky/")!),

        Spot(id: "meiji", name: "明治神宮", imageName: "meiji", areaID: "west",
             station: Station(name: "明治神宮前〈原宿〉", line: "千代田線", code: "C03", lineColor: LineColor.chiyoda, walkMinutes: 1),
             lead: "原宿旁邊，一片人工種出來的森林。",
             paragraphs: [
                "1920 年為供奉明治天皇與昭憲皇太后而建。當時從全國各地捐來約十萬棵樹，一百年後長成了七十公頃的森林。",
                "從原宿口走進第一座大鳥居，城市的聲音很快就消失了。木造的大鳥居高 12 公尺，是日本最大的木製明神鳥居之一。",
                "新年參拜時，三天內會湧進三百萬人，是全日本人數最多的神社。",
             ],
             hours: "日出至日落",
             price: "免費",
             tip: "參道邊有一整排捐贈的清酒桶，對面則是來自法國勃根地的葡萄酒桶。",
             website: URL(string: "https://www.meijijingu.or.jp/")!),

        Spot(id: "shinjukugyoen", name: "新宿御苑", imageName: "shinjukugyoen", areaID: "west",
             station: Station(name: "新宿御苑前", line: "丸之內線", code: "M10", lineColor: LineColor.marunouchi, walkMinutes: 5),
             lead: "摩天大樓之間，三種風格的庭園。",
             paragraphs: [
                "原本是江戶時代大名的宅邸，後來成為皇室庭園，1949 年對一般民眾開放。",
                "園內同時有日本庭園、英式風景庭園和法式整形庭園，從池塘邊的木橋望出去，背景就是新宿的高樓。",
                "全園約有六十五種、上千棵櫻花，花期從二月一路開到四月底。禁止攜帶酒類，所以賞櫻氣氛比上野安靜許多。",
             ],
             hours: "9:00–16:00 至 18:30\n依季節不同，週一休園",
             price: "成人 ¥500",
             tip: "新海誠電影《言葉之庭》的涼亭就在日本庭園裡。",
             website: URL(string: "https://www.env.go.jp/garden/shinjukugyoen/")!),

        Spot(id: "kokyo", name: "皇居二重橋", imageName: "kokyo", areaID: "center",
             station: Station(name: "二重橋前", line: "千代田線", code: "C10", lineColor: LineColor.chiyoda, walkMinutes: 2),
             lead: "江戶城的護城河，至今仍是天皇的住所。",
             paragraphs: [
                "皇居建在過去江戶城的遺址上。外苑的廣場鋪著白色碎石與黑松，開闊得不像在城市正中央。",
                "二重橋是通往宮殿的正門橋，石造的眼鏡橋倒映在護城河上，背後是伏見櫓，是皇居最經典的一景。",
                "繞皇居一圈約 5 公里，沒有紅綠燈，是東京最受歡迎的慢跑路線。",
             ],
             hours: "皇居外苑全天開放\n東御苑 9:00 起",
             price: "免費",
             tip: "東御苑保留了江戶城天守台的石垣，可以爬上去看看。",
             website: URL(string: "https://www.env.go.jp/garden/kokyogaien/")!),

        Spot(id: "tokyotower", name: "東京鐵塔", imageName: "tokyotower", areaID: "center",
             station: Station(name: "赤羽橋", line: "大江戶線", code: "E21", lineColor: LineColor.oedo, walkMinutes: 5),
             lead: "1958 年的紅白鐵塔，東京的夜景標記。",
             paragraphs: [
                "高 333 公尺，完工時是世界最高的自立式鐵塔。紅白相間的國際橘配色，是為了符合航空安全規定。",
                "150 公尺的主甲板有一段透明地板可以往下看；更高的 250 公尺頂層甲板需要參加導覽行程。",
                "夜晚的「Landmark Light」暖橘色燈光從 1989 年點亮至今，季節與節日時會換成不同顏色。",
             ],
             hours: "9:00–23:00",
             price: "主甲板 ¥1,500 起",
             tip: "從芝公園或增上寺看鐵塔，前景有寺院屋頂，比塔上的風景更好拍。",
             website: URL(string: "https://www.tokyotower.co.jp/")!),

        Spot(id: "tsukiji", name: "築地場外市場", imageName: "tsukiji", areaID: "center",
             station: Station(name: "築地", line: "日比谷線", code: "H10", lineColor: LineColor.hibiya, walkMinutes: 1),
             lead: "批發市場搬走了，早餐壽司留了下來。",
             paragraphs: [
                "魚市場的場內批發在 2018 年搬到豐洲，但場外市場的四百多家店仍在原地營業：海鮮、乾貨、刀具、廚房用品應有盡有。",
                "早上來吃一碗海鮮丼或一份握壽司，再沿街吃玉子燒、烤扇貝和草莓大福，是最經典的築地行程。",
                "市場旁的波除稻荷神社，有一顆巨大的獅子頭，是守護市場的神社。",
             ],
             hours: "多數店家 5:00–14:00\n週日與國定假日多休息",
             price: "免費入場",
             tip: "下午一點後很多店開始收攤，想吃得盡興就十點前到。",
             website: URL(string: "https://www.tsukiji.or.jp/")!),

        Spot(id: "odaiba", name: "台場與彩虹大橋", imageName: "odaiba", areaID: "bay",
             station: Station(name: "台場", line: "百合海鷗號", code: "U06", lineColor: LineColor.yurikamome, walkMinutes: 3),
             lead: "海上的人工島，看東京最遠的夜景。",
             paragraphs: [
                "台場的名字來自江戶末年為防禦黑船而建的砲台。現在這片填海地是購物中心、電視台與海濱公園。",
                "彩虹大橋 1993 年完工，全長 798 公尺，下層有免費的步道，可以走路過海。",
                "搭無人駕駛的百合海鷗號過橋時，坐第一節車廂的最前面，整片東京灣就在眼前。",
             ],
             hours: "全天開放\n彩虹大橋步道 9:00–21:00",
             price: "免費",
             tip: "台場海濱公園的沙灘看夕陽與大橋點燈，是約會的經典路線。",
             website: URL(string: "https://zh.wikipedia.org/zh-tw/彩虹大橋")!),
    ]

    static let featuredIDs = ["sensoji", "shibuya", "tokyotower", "meiji", "odaiba"]

    static var featured: [Spot] { featuredIDs.compactMap { id in spots.first { $0.id == id } } }

    static func spots(in area: Area) -> [Spot] { spots.filter { $0.areaID == area.id } }
}

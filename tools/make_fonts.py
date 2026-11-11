"""把 Noto Serif TC 精簡成 App 只用得到的字，產生兩個字重。

用法（在專案根目錄執行）：
    python3 tools/make_fonts.py <NotoSerifTC[wght].ttf 的路徑>

改了 App 裡的中文文字後，要重新執行一次，新的字才會用明體顯示
（沒包含到的字會自動退回系統字型）。
字型下載：https://github.com/google/fonts/tree/main/ofl/notoseriftc
授權：SIL Open Font License 1.1（tools/OFL.txt）
"""
import glob
import string
import sys

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

SRC = sys.argv[1]
OUT_DIR = "TokyoGuide/Fonts"
EXTRA = "「」『』，。、；：？！…—–・〈〉《》（）〜～¥￥・０１２３４５６７８９東京散步"

text = "".join(
    open(path, encoding="utf-8").read()
    for path in glob.glob("TokyoGuide/**/*.swift", recursive=True)
)
chars = "".join(sorted(set(text) | set(string.printable) | set(EXTRA)))

for weight, style in [(400, "Regular"), (600, "SemiBold")]:
    font = instancer.instantiateVariableFont(TTFont(SRC), {"wght": weight})

    options = subset.Options()
    options.layout_features = ["*"]
    options.name_IDs = ["*"]
    options.notdef_outline = True
    subsetter = subset.Subsetter(options)
    subsetter.populate(text=chars)
    subsetter.subset(font)

    family = "Tokyo Serif" if style == "Regular" else "Tokyo Serif SemiBold"
    postscript = f"TokyoSerif-{style}"
    names = font["name"]
    for name_id in (16, 17, 21, 22, 25):
        names.removeNames(nameID=name_id)
    for name_id, value in {
        1: family,
        2: "Regular",
        3: f"{postscript};subset",
        4: f"Tokyo Serif {style}",
        6: postscript,
    }.items():
        names.setName(value, name_id, 3, 1, 0x409)
        names.setName(value, name_id, 1, 0, 0)
    font["OS/2"].usWeightClass = weight

    path = f"{OUT_DIR}/{postscript}.ttf"
    font.save(path)
    print(path, len(chars), "chars")

import fontTools
from fontTools.ttLib import TTFont, newTable
import vttLib
from vttmisc import tsi1
import shutil
import gftools

vttSource = ["sources/vtt/Montserrat[wght]-VTT.ttf", "sources/vtt/Montserrat-Italic[wght]-VTT.ttf"]
newSource = ["fonts/variable/Montserrat[wght].ttf","fonts/variable/Montserrat-Italic[wght].ttf"]

print ("INFO:Integrating hinting sources and compiling")

for i,source in enumerate(newSource):

    newFont = TTFont(source)
    vttFont = TTFont(vttSource[i])

    for table in ["TSI0", "TSI1", "TSI2", "TSI3", "TSI5", "TSIC"]:
        newFont[table] = fontTools.ttLib.newTable(table)
        newFont[table] = vttFont[table]

    vttLib.compile_instructions(newFont, ship=True)

    newFont["head"].flags |= 1 << 3

    newFont.save(source.replace(".ttf","-VTT.ttf"))

    shutil.move(source.replace(".ttf","-VTT.ttf"), source)

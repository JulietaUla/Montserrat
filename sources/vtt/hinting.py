import fontTools
from fontTools.ttLib import TTFont, newTable
import vttLib
from vttmisc import tsi1


vttSource = ["VTT/Montserrat[wght].ttf", "VTT/Montserrat-Italic[wght].ttf"]
newSource = ["../fonts/variable/Montserrat[wght].ttf","../fonts/variable/Montserrat-Italic[wght].ttf"]

for i,source in enumerate(newSource):

    newFont = TTFont(source)
    vttFont = TTFont(vttSource[i])

    for table in ["TSI0", "TSI1", "TSI2", "TSI3", "TSI5", "TSIC"]:
        newFont[table] = fontTools.ttLib.newTable(table)
        newFont[table] = vttFont[table]

    #vttLib.compile_instructions(newFont, ship=True)
    newFont.save(source.replace(".ttf","-VTT.ttf"))


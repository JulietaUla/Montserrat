import fontmake.instantiator
import fontTools.designspaceLib
from glyphsLib.cli import main
import os, shutil
from pathlib import Path
import ufoLib2

sources = [
    Path("sources/Montserrat.glyphs"),
    Path("sources/Montserrat-Italic.glyphs"),
]

try:
    os.mkdir("sources/masters")
except:
    pass

sourceURL = Path("sources/masters")

for s in sources:
    main(("glyphs2ufo", str(s), "--write-public-skip-export-glyphs", "--output-dir", str(sourceURL)))

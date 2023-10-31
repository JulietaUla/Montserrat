from glyphsLib.cli import main
import os
from pathlib import Path

path = "sources/masters"
sources = [
    Path("sources/Montserrat.glyphs"),
    Path("sources/Montserrat-Italic.glyphs"),
    Path("sources/MontserratSubrayada.glyphs"),
    Path("sources/MontserratSubrayada-Italic.glyphs"),
]

try:
    os.mkdir(path)
except Exception:
    print(f"folder {path} already existed")

sourceURL = Path(path)

for s in sources:
    main(
        (
            "glyphs2ufo",
            str(s),
            "--write-public-skip-export-glyphs",
            "--output-dir",
            str(sourceURL),
        )
    )

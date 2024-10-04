echo
echo Freezing and subsetting Alternates
rm -rf fonts-alternates
cp -r fonts fonts-alternates
cd fonts-alternates

shopt -s nullglob # Enable nullglob to avoid errors

for f in variable/*.ttf; do echo && echo Freezing Alternates version for "$f" && pyftfeatfreeze -f 'ss01' -S -U Alternates "$f" "${f//Montserrat/MontserratAlternates}" && rm "$f"; done
for f in variable/*.ttf; do pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$f.temp $f && mv $f.temp $f; done

for f in otf/*.otf; do echo && echo Freezing Alternates version for "$f" && pyftfeatfreeze -f 'ss01' -S -U Alternates "$f" "${f//Montserrat/MontserratAlternates}" && rm "$f"; done
for f in otf/*.otf; do pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$f.temp $f && mv $f.temp $f; done

for f in ttf/*.ttf; do echo && echo Freezing Alternates version for "$f" && pyftfeatfreeze -f 'ss01' -S -U Alternates "$f" "${f//Montserrat/MontserratAlternates}" && rm "$f"; done
for f in ttf/*.ttf; do pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$f.temp $f && mv $f.temp $f; done

for f in webfonts/*.woff2; do echo && echo Freezing Alternates version for "$f" && pyftfeatfreeze -f 'ss01' -S -U Alternates "$f" "${f//Montserrat/MontserratAlternates}" && rm "$f"; done
for f in webfonts/*.woff2; do pyftsubset --recalc-bounds --recalc-average-width --glyph-names --layout-features="*" --name-IDs="*" --unicodes="*" --output-file=$f.temp $f && mv $f.temp $f; done
cd ../..

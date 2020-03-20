#!/bin/sh
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd $DIR
echo $(pwd)

echo "Generating Static fonts"
mkdir -p ../fonts/ttf ../fonts/otf
fontmake -m Montserrat.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m Montserrat-Italic.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m MontserratAlternates.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m MontserratAlternates-Italic.designspace -i -o ttf --output-dir ../fonts/ttf/
fontmake -m Montserrat.designspace -i -o otf --output-dir ../fonts/otf/
fontmake -m Montserrat-Italic.designspace -i -o otf --output-dir ../fonts/otf/

echo "Generating VFs"
mkdir -p ../fonts/variable
fontmake -m Montserrat.designspace -o variable --output-path ../fonts/variable/Montserrat[wght].ttf
fontmake -m Montserrat-Italic.designspace -o variable --output-path ../fonts/variable/Montserrat-Italic[wght].ttf
fontmake -m MontserratAlternates.designspace -o variable --output-path ../fonts/variable/MontserratAlternates[ALTS,wght].ttf
fontmake -m MontserratAlternates-Italic.designspace -o variable --output-path ../fonts/variable/MontserratAlternates-Italic[ALTS,wght].ttf

rm -rf master_ufo/ instance_ufo/ instance_ufos/


echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
done

echo "Instanciate single axis VFs"
fonttools varLib.instancer -o ../fonts/variable/MontserratAlternates[wght].ttf ../fonts/variable/MontserratAlternates[ALTS,wght].ttf "ALTS=1"
fonttools varLib.instancer -o ../fonts/variable/MontserratAlternates-Italic[wght].ttf ../fonts/variable/MontserratAlternates-Italic[ALTS,wght].ttf "ALTS=1"
rm ../fonts/variable/MontserratAlternates[ALTS,wght].ttf ../fonts/variable/MontserratAlternates-Italic[ALTS,wght].ttf
ttx -t name ../fonts/variable/MontserratAlternates[wght].ttf ../fonts/variable/MontserratAlternates-Italic[wght].ttf
sed -i".bak" "s/Montserrat$/Montserrat Alternates/;s/Montserrat Thin/Montserrat Alternates Thin/;s/Montserrat-Thin/MontserratAlternates-Thin/" ../fonts/variable/MontserratAlternates[wght].ttx;
sed -i".bak" "s/Montserrat$/Montserrat Alternates/;s/Montserrat Thin/Montserrat Alternates Thin/;s/Montserrat-Thin/MontserratAlternates-Thin/" ../fonts/variable/MontserratAlternates-Italic[wght].ttx;
ttx -m ../fonts/variable/MontserratAlternates[wght].ttf ../fonts/variable/MontserratAlternates[wght].ttx
ttx -m ../fonts/variable/MontserratAlternates-Italic[wght].ttf ../fonts/variable/MontserratAlternates-Italic[wght].ttx
mv ../fonts/variable/MontserratAlternates[wght]#1.ttf ../fonts/variable/MontserratAlternates[wght].ttf
mv ../fonts/variable/MontserratAlternates-Italic[wght]#1.ttf ../fonts/variable/MontserratAlternates-Italic[wght].ttf
rm ../fonts/variable/*.ttx
rm ../fonts/variable/*.bak

vfs=$(ls ../fonts/variable/*\[wght\].ttf)

echo "Post processing VFs"
for vf in $vfs
do
	gftools fix-dsig -f $vf;
done



echo "Fixing VF Meta"
# gftools fix-vf-meta $vfs;
# for vf in $vfs
# do
# 	mv "$vf.fix" $vf;
# done
statmake --stylespace stat.stylespace --designspace Montserrat.designspace --output-path ../fonts/variable/Montserrat[wght].ttf ../fonts/variable/Montserrat[wght].ttf;
statmake --stylespace stat.stylespace --designspace Montserrat-Italic.designspace --output-path ../fonts/variable/Montserrat-Italic[wght].ttf ../fonts/variable/Montserrat-Italic[wght].ttf;
statmake --stylespace stat.stylespace --designspace MontserratAlternates.designspace --output-path ../fonts/variable/MontserratAlternates[wght].ttf ../fonts/variable/MontserratAlternates[wght].ttf;
statmake --stylespace stat.stylespace --designspace MontserratAlternates-Italic.designspace --output-path ../fonts/variable/MontserratAlternates-Italic[wght].ttf ../fonts/variable/MontserratAlternates-Italic[wght].ttf;

echo "Dropping MVAR"
for vf in $vfs
do
	gftools fix-unwanted-tables -t MVAR $vf;
done

echo "Fixing Hinting"
for vf in $vfs
do
	gftools fix-nonhinting $vf $vf.fix;
	mv "$vf.fix" $vf;
done
for ttf in $ttfs
do
	gftools fix-nonhinting $ttf $ttf.fix;
	mv "$ttf.fix" $ttf;
done

rm ../fonts/ttf/*gasp.ttf ../fonts/variable/*gasp.ttf


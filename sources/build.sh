#!/bin/sh
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd $DIR
echo $(pwd)

echo "Generating Static fonts"
mkdir -p ../fonts/ttf ../fonts/otf
# fontmake -m Montserrat.designspace -i -o ttf --output-dir ../fonts/ttf/
# fontmake -m Montserrat-Italic.designspace -i -o ttf --output-dir ../fonts/ttf/
# fontmake -m Montserrat.designspace -i -o otf --output-dir ../fonts/otf/
# fontmake -m Montserrat-Italic.designspace -i -o otf --output-dir ../fonts/otf/

echo "Generating VFs"
mkdir -p ../fonts/vf
fontmake -m Montserrat.designspace -o variable --output-path ../fonts/vf/Montserrat[ALTS,wght].ttf
fontmake -m Montserrat-Italic.designspace -o variable --output-path ../fonts/vf/Montserrat-Italic[ALTS,wght].ttf

rm -rf master_ufo/ instance_ufo/ instance_ufos/


echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
done

echo "Instanciate single axis VFs"
fonttools varLib.instancer -o ../fonts/vf/Montserrat[wght].ttf ../fonts/vf/Montserrat[ALTS,wght].ttf "ALTS=drop"
fonttools varLib.instancer -o ../fonts/vf/Montserrat-Italic[wght].ttf ../fonts/vf/Montserrat-Italic[ALTS,wght].ttf "ALTS=drop"
fonttools varLib.instancer -o ../fonts/vf/MontserratAlternates[wght].ttf ../fonts/vf/Montserrat[ALTS,wght].ttf "ALTS=1"
fonttools varLib.instancer -o ../fonts/vf/MontserratAlternates-Italic[wght].ttf ../fonts/vf/Montserrat-Italic[ALTS,wght].ttf "ALTS=1"
rm ../fonts/vf/Montserrat[ALTS,wght].ttf ../fonts/vf/Montserrat-Italic[ALTS,wght].ttf
ttx -t name ../fonts/vf/MontserratAlternates[wght].ttf ../fonts/vf/MontserratAlternates-Italic[wght].ttf
sed -i".bak" "s/Montserrat$/Montserrat Alternates/;s/Montserrat Thin/Montserrat Alternates Thin/;s/Montserrat-Thin/MontserratAlternates-Thin/" ../fonts/vf/MontserratAlternates[wght].ttx;
sed -i".bak" "s/Montserrat$/Montserrat Alternates/;s/Montserrat Thin/Montserrat Alternates Thin/;s/Montserrat-Thin/MontserratAlternates-Thin/" ../fonts/vf/MontserratAlternates-Italic[wght].ttx;
ttx -m ../fonts/vf/MontserratAlternates[wght].ttf ../fonts/vf/MontserratAlternates[wght].ttx
ttx -m ../fonts/vf/MontserratAlternates-Italic[wght].ttf ../fonts/vf/MontserratAlternates-Italic[wght].ttx
mv ../fonts/vf/MontserratAlternates[wght]#1.ttf ../fonts/vf/MontserratAlternates[wght].ttf
mv ../fonts/vf/MontserratAlternates-Italic[wght]#1.ttf ../fonts/vf/MontserratAlternates-Italic[wght].ttf
rm ../fonts/vf/*.ttx
rm ../fonts/vf/*.bak

vfs=$(ls ../fonts/vf/*\[wght\].ttf)

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
statmake --stylespace Montserrat.stylespace --designspace Montserrat.designspace --output-path ../fonts/vf/Montserrat[wght].ttf ../fonts/vf/Montserrat[wght].ttf;
statmake --stylespace Montserrat.stylespace --designspace Montserrat-Italic.designspace --output-path ../fonts/vf/Montserrat-Italic[wght].ttf ../fonts/vf/Montserrat-Italic[wght].ttf;
statmake --stylespace Montserrat.stylespace --designspace MontserratAlternates.designspace --output-path ../fonts/vf/MontserratAlternates[wght].ttf ../fonts/vf/MontserratAlternates[wght].ttf;
statmake --stylespace Montserrat.stylespace --designspace MontserratAlternates-Italic.designspace --output-path ../fonts/vf/MontserratAlternates-Italic[wght].ttf ../fonts/vf/MontserratAlternates-Italic[wght].ttf;

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

rm ../fonts/ttf/*gasp.ttf ../fonts/vf/*gasp.ttf


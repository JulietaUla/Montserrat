#!/bin/sh
set -e

# Go the sources directory to run commands
SOURCE="${BASH_SOURCE[0]}"
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd $DIR
echo $(pwd)

#echo "Generating Static fonts"
#mkdir -p ../fonts
#fontmake -m Montserrat.designspace -i -o ttf --output-dir ../fonts/ttf/
#fontmake -m Montserrat.designspace -i -o otf --output-dir ../fonts/otf/

echo "Generating VFs"
mkdir -p ../fonts/vf
fontmake -m Montserrat.designspace -o variable --output-path ../fonts/vf/Montserrat[wght][ALTS].ttf
fontmake -m Montserrat-Italic.designspace -o variable --output-path ../fonts/vf/Montserrat-Italic[wght][ALTS].ttf

rm -rf master_ufo/ instance_ufo/ instance_ufos/


echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
done

echo "Instanciate single axis VFs"
fonttools varLib.instancer -o ../fonts/vf/Montserrat[wght].ttf ../fonts/vf/Montserrat[wght][ALTS].ttf "ALTS=drop"
fonttools varLib.instancer -o ../fonts/vf/MontserratAlternates[wght].ttf ../fonts/vf/Montserrat[wght][ALTS].ttf "ALTS=1"
fonttools varLib.instancer -o ../fonts/vf/Montserrat-Italic[wght].ttf ../fonts/vf/Montserrat-Italic[wght][ALTS].ttf "ALTS=drop"
fonttools varLib.instancer -o ../fonts/vf/Montserrat-ItalicAlternates[wght].ttf ../fonts/vf/Montserrat-Italic[wght][ALTS].ttf "ALTS=1"
rm ../fonts/vf/Montserrat[wght][ALTS].ttf ../fonts/vf/Montserrat-Italic[wght][ALTS].ttf

vfs=$(ls ../fonts/vf/*\[wght\].ttf)

echo "Post processing VFs"
for vf in $vfs
do
	gftools fix-dsig -f $vf;
done



echo "Fixing VF Meta"
gftools fix-vf-meta $vfs;

echo "Dropping MVAR"
for vf in $vfs
do
	mv "$vf.fix" $vf;
	ttx -f -x "MVAR" $vf; # Drop MVAR. Table has issue in DW
	rtrip=$(basename -s .ttf $vf)
	new_file=../fonts/vf/$rtrip.ttx;
	rm $vf;
	ttx $new_file
	rm $new_file
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


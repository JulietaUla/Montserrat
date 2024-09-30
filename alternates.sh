set -e
echo Freezing and subsetting Alternates 2
rm -rf fonts-alternates
mkdir -p fonts-alternates fonts-alternates/otf fonts-alternates/ttf fonts-alternates/variable fonts-alternates/webfonts

fonts=$(ls fonts/*/*)
for font in $fonts;
do 
    echo Freezing Alternates version for "$font"
    # fonts/variable/Montserrat[wght].ttf --> fonts-alternates/variable/MontserratAlternates[wght].ttf
    new_path="${font//Montserrat/MontserratAlternates}"
    new_path="${new_path//fonts/fonts-alternates}"
    new_path="${new_path//webfonts-alternates/webfonts}"
    gftools remap-font $font --map-file sources/alternative_mapping.txt -o $new_path
    gftools rename-font $new_path "Montserrat Alternates" -o $new_path
done

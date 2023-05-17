# The Montserrat Font Project

Julieta Ulanovsky began this project in 2010 while a post-graduate student of typeface design at the FADU, University of Buenos Aires.
She launched it as a Kickstarter project in 2011, in order to complete the first public release and share it with the world through Google Fonts.
In her Kickstarter, she described it like this:

> The old posters and signs in the traditional neighborhood of Buenos Aires called Montserrat inspired me to design a typeface that rescues the beauty of urban typography from the first half of the twentieth century. The goal is to rescue what is in Montserrat and set it free, under a free, libre and open source license, the SIL Open Font License.
>
> As urban development changes this place, it will never return to its original form and loses forever the designs that are so special and unique. To draw the letters, I rely on examples of lettering in the urban space. Each selected example produces its own variants in length, width and height proportions, each adding to the Montserrat family. The old typographies and canopies are irretrievable when they are replaced.
>
> There are other revivals, but those do not stay close to the originals. The letters that inspired this project have work, dedication, care, color, contrast, light and life, day and night! These are the types that make the city look so beautiful.

Since then it has been developed by Julieta in collaboration with several designers. 
In 2015, a full set of weights and italics were developed by Julieta in collaboration with Ale Paul, Carolina Giovagnoli, Andrés Torresi, Juan Pablo del Peral and Sol Matas. 
In 2017, Jacques Le Bailly reworked the entire Latin design, and in parallel Juan Pablo del Peral and Sol Matas developed the initial Cyrillic extension with review and advise from Maria Doreuli and Alexei Vanyashin. 
Technical reviews were made by Lasse Fister, Kalapi GajjarBordawekar and Marc Foley. Special thanks also to Thomas Linard, Valeria Dulitzky, Belén Quirós, and Germán Rozo.

## Building

Fonts are built automatically by GitHub Actions - take a look in the "Actions" tab for the latest build.

If you particularly want to build fonts manually on your own computer, you will need to install the [`yq` utility](https://github.com/mikefarah/yq). On OS X with Homebrew, type `brew install yq`; on Linux, try `snap install yq`; if all else fails, try the instructions on the linked page.

Then:

* `make build` will produce font files.
* `make test` will run [FontBakery](https://github.com/googlefonts/fontbakery)'s quality assurance tests.
* `make proof` will generate HTML proof files.

## License

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at
http://scripts.sil.org/OFL

## Repository Layout

This font repository structure is inspired by [Unified Font Repository v0.3](https://github.com/unified-font-repository/Unified-Font-Repository), modified for the Google Fonts workflow.

## Changelog

### Version 3.100

- Now with four set of figures: tabular lining (default), tabular oldstyle, proportional lining, proportional oldstyle.
- fixed kcommaaccent (ķ) accent positioning (thanks @kalapi).
- Deleted some open paths in .glyphs files.

### Version 4.000

- Updated character-set/language support to Google's Pro glyph-set (https://github.com/google/fonts/tree/master/tools/encodings/GF%202016%20Glyph%20Sets)
- Updated OS/2 winMetrics to Google's latest vertical metrics recommendations (https://groups.google.com/d/msg/googlefonts-discuss/W4PHxnLk3JY/KoMyM2CfAwAJ)
- Added 'useTypoMetrics' flag
- Added OpenType features consistent with character-set expansion

### Version 7.200
- Google commissioned Jacques Le Bailly @fonthausen to do an extensive revision of the latin character set.
- We applied a new weight distribution across the variables. 
- Now Montserrat has extended Cyrillic support (GF Cyrillic Pro).
- More detais about migration in https://github.com/JulietaUla/Montserrat/releases/tag/v7.200

### Version 8.000
- Variable font wow includes hand hinting by Mike Duggan
- Added necessary glyphs for Navajo
- Other small glyph / OT fixes
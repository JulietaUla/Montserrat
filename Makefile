google:
	@echo " "
	@echo "================================================================="
	@echo "Updating fonts for Google starts on "`date`
	@echo "================================================================="
	@echo " "
	find googlefontdirectory \( -name '*.ttf' -or -name '*.otf' -or -name '*.glyphs' \) -delete
	cp ttf/Montserrat-*.ttf googlefontdirectory/montserrat
	cp otf/Montserrat-*.otf googlefontdirectory/montserrat/src
	cp "Montserrat.glyphs" googlefontdirectory/montserrat/src
	cp ttf/MontserratAlternates-*.ttf googlefontdirectory/montserratalternates
	cp otf/MontserratAlternates-*.otf googlefontdirectory/montserratalternates/src
	cp "Montserrat Alternates.glyphs" googlefontdirectory/montserratalternates/src
	@echo " "
	@echo "================================================================="
	@echo "Fonts updated on "`date`
	@echo "================================================================="
	@echo " "


.PHONY: google
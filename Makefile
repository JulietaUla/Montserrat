SOURCES=$(shell python3 scripts/read-config.py --sources )
FAMILY=$(shell python3 scripts/read-config.py --family )

help:
	@echo "###"
	@echo "# Build targets for $(FAMILY)"
	@echo "###"
	@echo
	@echo "  make build:  Builds the fonts and places them in the fonts/ directory"
	@echo "  make test:   Tests the fonts with fontbakery"
	@echo "  make proof:  Creates HTML proof documents in the proof/ directory"
	@echo

build: build.stamp

venv: venv/touchfile

customize: venv
	. venv/bin/activate; python3 scripts/customize.py

build.stamp: venv sources/config.yaml $(SOURCES)
	rm -rf fonts fonts-underline fonts-alternates
	(for config in sources/config*.yaml; do . venv/bin/activate; gftools builder $$config; done) && touch build.stamp
	. venv/bin/activate; python3 sources/vtt/hinting.py; bash alternates.sh

venv/touchfile: requirements.txt
	test -d venv || python3 -m venv venv
	. venv/bin/activate; pip install -Ur requirements.txt
	touch venv/touchfile

test: venv build.stamp
	. venv/bin/activate; mkdir -p out/ out/fontbakery; fontbakery check-googlefonts -l WARN --full-lists --succinct --badges out/badges --html out/fontbakery/fontbakery-report.html --ghmarkdown out/fontbakery/fontbakery-report.md $(shell find fonts/variable -type f)  || echo '::warning file=sources/config.yaml,title=Fontbakery failures::The fontbakery QA check reported errors in your font. Please check the generated report.'

test-underline: venv build.stamp
	. venv/bin/activate; mkdir -p out/ out/fontbakery-underline; fontbakery check-googlefonts -l WARN --full-lists --succinct --badges out/badges-underline --html out/fontbakery-underline/fontbakery-report.html --ghmarkdown out/fontbakery-underline/fontbakery-report.md $(shell find fonts-underline/variable -type f)  || echo '::warning file=sources/config.yaml,title=Fontbakery failures::The fontbakery QA check reported errors in your font. Please check the generated report.'

test-alternates: venv build.stamp
	. venv/bin/activate; mkdir -p out/ out/fontbakery-alternates; fontbakery check-googlefonts -l WARN --full-lists --succinct --badges out/badges-alternates --html out/fontbakery-alternates/fontbakery-report.html --ghmarkdown out/fontbakery-alternates/fontbakery-report.md $(shell find fonts-alternates/variable -type f)  || echo '::warning file=sources/config.yaml,title=Fontbakery failures::The fontbakery QA check reported errors in your font. Please check the generated report.'

proof: venv build.stamp
	. venv/bin/activate; mkdir -p out/ out/proof; diffenator2 proof $(shell find fonts/ttf -type f) -o out/proof

%.png: %.py build.stamp
	. venv/bin/activate; python3 $< --output $@

clean:
	rm -rf venv
	find . -name "*.pyc" -delete

update-project-template:
	npx update-template https://github.com/googlefonts/googlefonts-project-template/

update:
	pip install --upgrade $(dependency); pip freeze > requirements.txt
COMMONMARK=node_modules/.bin/commonform-commonmark
CRITIQUE=node_modules/.bin/commonform-critique
DOCX=node_modules/.bin/commonform-docx
HTML=node_modules/.bin/commonform-html
JSON=node_modules/.bin/json
LINT=node_modules/.bin/commonform-lint
TOOLS=$(COMMONMARK) $(CRITIQUE) $(DOCX) $(HTML) $(JSON) $(LINT)

SOURCES=$(filter-out README.md,$(wildcard *.md))
FORMS=$(addprefix build/,$(SOURCES:.md=.form.json))

.PHONY: all markdown html docx pdf

all: json markdown html docx pdf

json: $(FORMS)
markdown: $(addprefix build/,$(SOURCES))
html: $(addprefix build/,$(SOURCES:.md=.html))
docx: $(addprefix build/,$(SOURCES:.md=.docx))
pdf: $(addprefix build/,$(SOURCES:.md=.pdf))

build/%.docx: build/%.form.json build/%.directions.json %.title blanks.json %.json styles.json | build $(DOCX)
	$(DOCX) --title "$(shell cat $*.title)" --number outline --indent-margins --left-align-title --values blanks.json --directions build/$*.directions.json --styles styles.json --signatures $*.json $< > $@

build/%.md: build/%.form.json build/%.directions.json %.title blanks.json | build $(COMMONMARK)
	$(COMMONMARK) stringify --title "$(shell cat $*.title)" --values blanks.json --directions build/$*.directions.json --ordered --ids < $< > $@

build/%.html: build/%.form.json build/%.directions.json %.title blanks.json | build $(COMMONMARK)
	$(HTML) stringify --title "$(shell cat $*.title)" --values blanks.json --directions build/$*.directions.json --html5 --lists < $< > $@

%.pdf: %.docx
	unoconv $<

build/%.form.json: %.md | build $(CFCM)
	$(COMMONMARK) parse --only form < $< > $@

build/%.directions.json: %.md | build $(CFCM)
	$(COMMONMARK) parse --only directions < $< > $@

$(TOOLS):
	npm ci

build:
	mkdir -p build

.PHONY: clean lint critique docker

clean:
	rm -rf build

lint: $(FORMS) | $(LINT) $(JSON)
	@for form in $(FORMS); do \
		echo ; \
		echo $$form; \
		cat $$form | $(LINT) | $(JSON) -a message | sort -u; \
	done; \

critique: $(FORMS) | $(CRITIQUE) $(JSON)
	@for form in $(FORMS); do \
		echo ; \
		echo $$form ; \
		cat $$form | $(CRITIQUE) | $(JSON) -a message | sort -u; \
	done

docker:
	docker build -t commonform-build-example .
	docker run --name commonform-build-example commonform-build-example
	docker cp commonform-build-example:/workdir/build .
	docker rm commonform-build-example

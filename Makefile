DOCKER=docker-compose run --rm latex
PDFLATEX=$(DOCKER) pdflatex -interaction=nonstopmode -output-directory=out
LATEXMK=$(DOCKER) latexmk -quiet -bibtex -f -pdf -pdflatex='pdflatex -synctex=1 -interaction=nonstopmode' -use-make -output-directory=out
CONVERT=$(DOCKER) convert -density 150 -trim -quality 100 -flatten -sharpen 0x1.0

all: build
	@echo "Done!"
build: src/*.tex
	@echo "Building.... $^"
	for i in $$(find src -name '*.tex'); do     \
		$(PDFLATEX) "$$i" 1> /dev/null || true; \
	done
	make clean
clean:
	cd out && rm -f *.aux *.dvi *.out *.bak *.nav *.snm *.toc *.fdb_latexmk *.synctex.gz *.fls *.log

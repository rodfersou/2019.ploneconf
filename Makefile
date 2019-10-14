files_tex = $(wildcard *.tex)

# We like colors
# From: https://coderwall.com/p/izxssa/colored-makefile-for-golang-projects
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`
YELLOW=`tput setaf 3`

all: pdf

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
.PHONY: help
help: ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate a PDF instead of DVI.
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
# -synctex=1 is required to jump between the source PDF and the text editor.
# -pvc (preview continuously) watches the directory for changes.
# -quiet suppresses most status messages (https://tex.stackexchange.com/questions/40783/can-i-make-latexmk-quieter).
pdf: *.tex ## Build PDF
	@echo "$(GREEN)==> Building PDF$(RESET)"
	@$(foreach var,$(files_tex),latexmk -quiet -bibtex $(PREVIEW_CONTINUOUSLY) -f -pdf -pdflatex='pdflatex -synctex=1 -interaction=nonstopmode' -use-make '$(var)')

.PHONY: watch
watch: PREVIEW_CONTINUOUSLY=-pvc
watch: pdf ## Watch file for changes

.PHONY: clean
clean: ## Clean everything
	@echo "$(GREEN)==> All clean$(RESET)"
	git clean -Xdf

.PHONY: all clean

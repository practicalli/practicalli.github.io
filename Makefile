# ------------------------------------------
# Practicalli Makefile
#
# Consistent set of targets to support local book development
# ------------------------------------------

# .PHONY: ensures target used rather than matching file name
# https://makefiletutorial.com/#phony
.PHONY: all clean deps dist docs lint pre-commit-check repl test test-ci test-watch
# -------------------------------------- #

# -- Makefile Variables ---------------- #
# run help if no target specified
.DEFAULT_GOAL := help
SHELL := /usr/bin/zsh

# Column the target description is printed from
HELP-DESCRIPTION-SPACING := 24

# Tool Commands
MEGALINTER_RUNNER := npx mega-linter-runner --flavor documentation --env "'MEGALINTER_CONFIG=.github/config/megalinter.yaml'" --env "'VALIDATE_ALL_CODEBASE=true'"  --remove-container
MKDOCS_SERVER := mkdocs serve --dev-addr localhost:7777
OUTDATED_FILE := outdated-$(shell date +%y-%m-%d-%T).md

# Makefile file and directory name wildcard
# EDN-FILES := $(wildcard *.edn)
# -------------------------------------- #

# -- Help ------------------------------ #
# Source: https://nedbatchelder.com/blog/201804/makefile_help_target.html

help:  ## Describe available tasks in Makefile
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
	sort | \
	awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-$(HELP-DESCRIPTION-SPACING)s\033[0m %s\n", $$1, $$2}'
# -------------------------------------- #

# -- Clojure Projects ------------------ #
service:  ## New project with practicalli/service template
	$(info -- Create Service Project ----------------)
	clojure -T:project/create :template practicalli/service :name practicalli/gameboard

service-donut:  ## New project with practicalli/service template & Donut
	$(info -- Create Service Project with Donut -----)
	clojure -T:project/create :template practicalli/service :name practicalli/gameboard :target-dir gameboard-donut

service-integrant:  ## New project with practicalli/service template & Integrant
	$(info -- Create Service Project with Integrant -)
	clojure -T:project/create :template practicalli/service :name practicalli/gameboard :target-dir gameboard-integrant

landing-page:  ## New project with practicalli/landing-page template local
	$(info -- Run Rebel REPL ------------------------)
	clojure -T:project/create :template practicalli/landing-page :name practicalli/landing-page

outdated: ## Check deps.edn & GitHub actions for new versions
	$(info -- Search for outdated libraries ---------)
	- clojure -T:search/outdated > $(OUTDATED_FILE)
# -------------------------------------- #

# -- Code Quality ---------------------- #
pre-commit-check: lint

lint:  ## Run MegaLinter with custom configuration (node.js required)
	$(info -- MegaLinter Runner ---------------------)
	$(MEGALINTER_RUNNER)

lint-fix:  ## Run MegaLinter with applied fixes and custom configuration (node.js required)
	$(info -- MegaLinter Runner fix errors ----------)
	$(MEGALINTER_RUNNER) --fix

lint-clean:  ## Clean MegaLinter report information
	$(info -- MegaLinter Clean Reports --------------)
	- rm -rf ./megalinter-reports

megalinter-upgrade:  ## Upgrade MegaLinter config to latest version
	$(info -- MegaLinter Upgrade Config -------------)
	npx mega-linter-runner@latest --upgrade
# -------------------------------------- #

# ------- Version Control -------------- #
git-sr:  ## status list of git repos under current directory
	$(info -- Multiple Git Repo Status --------------)
	mgitstatus -e --flatten

git-status:  ## status details of git repos under current directory
	$(info -- Multiple Git Status -------------------)
	mgitstatus
# -------------------------------------- #

# --- Documentation Generation  -------- #

python-venv:
	$(info -- Create Python Virtual Environment -----)
	python3 -m venv ~/.local/venv

mkdocs-install:
	$(info -- Install Material for MkDocs -----------)
	source ~/.local/venv/bin/activate; pip install mkdocs-material mkdocs-callouts mkdocs-glightbox mkdocs-git-revision-date-localized-plugin mkdocs-redirects mkdocs-rss-plugin pillow cairosvg --upgrade

docs: ## Build and run mkdocs in local server (python venv)
	$(info -- MkDocs Local Server -------------------)
	source ~/.local/venv/bin/activate && $(MKDOCS_SERVER)

docs-changed:  ## Build only changed files and run mkdocs in local server (python venv)
	$(info -- Mkdocs Local Server -------------------)
	source ~/.local/venv/bin/activate && $(MKDOCS_SERVER) --dirtyreload

docs-build:  ## Build mkdocs (python venv)
	$(info -- Mkdocs Local Server -------------------)
	source ~/.local/venv/bin/activate && mkdocs build
# -------------------------------------- #


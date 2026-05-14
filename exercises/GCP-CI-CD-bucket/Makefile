.PHONY: build serve lint lint-md lint-html clean deploy

# Variables
HUGO_SITE_DIR = hugo-site
PUBLIC_DIR    = $(HUGO_SITE_DIR)/public
BUCKET_NAME   ?= YOUR_BUCKET_NAME

# Build the Hugo site
build:
	cd $(HUGO_SITE_DIR) && hugo --gc --minify

# Serve locally with live reload
serve:
	cd $(HUGO_SITE_DIR) && hugo server -D --disableFastRender

# Run all linters
lint: lint-md lint-html

# Lint markdown files
lint-md:
	npx markdownlint-cli2 $(HUGO_SITE_DIR)/content/**/*.md

# Lint HTML output (after build)
lint-html: build
	npx htmlhint $(PUBLIC_DIR)/**/*.html

# Clean built output
clean:
	rm -rf $(PUBLIC_DIR)

# Deploy to GCS bucket (sync)
deploy: build
	gsutil rsync -r $(PUBLIC_DIR)/ gs://$(BUCKET_NAME)/

# Quick deploy without lint check
deploy-quick: build
	gsutil rsync -r $(PUBLIC_DIR)/ gs://$(BUCKET_NAME)/

help:
	@echo "Usage:"
	@echo "  make build        - Build the Hugo site"
	@echo "  make serve        - Serve locally with live reload"
	@echo "  make lint         - Run all linters"
	@echo "  make lint-md      - Lint markdown files"
	@echo "  make lint-html    - Build and lint HTML output"
	@echo "  make clean        - Remove built output"
	@echo "  make deploy       - Build and sync to GCS (set BUCKET_NAME=...)"
	@echo "  make help         - Show this help"

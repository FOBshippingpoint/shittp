.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@echo ""
	@echo "Specify a command. The choices are:"
	@echo ""
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-20s\033[m %s\n", $$1, $$2}'
	@echo ""

.PHONY: lint
lint: ## Run shellcheck
	shellcheck shittp

.PHONY: unit
unit: ## Run unit test with shellspec
	if type sh; then shellspec -s sh; fi
	if type dash; then shellspec -s dash; fi
	if type bash; then shellspec -s bash; fi
	if type busybox; then shellspec -s 'busybox ash'; fi
	if type ksh; then shellspec -s ksh; fi
	if type zsh; then shellspec -s zsh; fi

.PHONY: integration
integration: ## Run integration test script
	spec/integration/run.sh

.PHONY: webdev
webdev: ## Start web server for home page
	cd web && bun run dev

build: lint unit integration ## Run all check (lint, unit, integration) and build tarball
	tar czvf shittp.tar.gz shittp config

.PHONY: clean
clean: ## Remove shittp tarball from the build step
	rm -f shittp.tar.gz

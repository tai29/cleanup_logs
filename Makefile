.PHONY: lint fmt agent test help

help:
	@echo "Available targets:"
	@echo "  lint    - Run shellcheck on all shell scripts"
	@echo "  fmt     - Format shell scripts with shfmt"
	@echo "  agent   - Launch Cursor Agent (requires CURSOR_API_KEY)"
	@echo "  test    - Run syntax check on all scripts"
	@echo "  clean   - Remove temporary files"

lint:
	@echo "Running shellcheck..."
	@shellcheck $$(git ls-files '*.sh') || true

fmt:
	@echo "Formatting shell scripts..."
	@shfmt -w .

test:
	@echo "Checking script syntax..."
	@for script in $$(git ls-files '*.sh'); do \
		echo "Checking $$script..."; \
		bash -n "$$script" || exit 1; \
	done
	@echo "✅ All scripts passed syntax check"

agent:
	@if [ -z "$$CURSOR_API_KEY" ]; then \
		echo "❌ Error: CURSOR_API_KEY environment variable is not set"; \
		exit 1; \
	fi
	@echo "Launching Cursor Agent..."
	@curl -sS --fail \
		-H "Authorization: Bearer $$CURSOR_API_KEY" \
		-H "Content-Type: application/json" \
		-d "$$(jq -n --arg txt 'READMEを改善して' \
			--arg repo 'https://github.com/tai29/cleanup_logs' \
			--arg ref 'main' \
			--arg branch "cursor/local-$$RANDOM" \
			'{prompt:{text:$$txt}, source:{repository:$$repo, ref:$$ref}, target:{autoCreatePr:true, branchName:$$branch}}')" \
		https://api.cursor.com/v0/agents | jq '.'

clean:
	@echo "Cleaning temporary files..."
	@find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*~" \) -delete
	@echo "✅ Clean completed"


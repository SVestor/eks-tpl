REPO=https://github.com/prometheus-operator/prometheus-operator.git
BRANCH=main
TARGET_DIR=crds
SPARSE_FILE=sparse-dirs.txt
SPARSE_DIRS=$(shell grep -v '^#' $(SPARSE_FILE))
DEST_DIR=/home/sv/code/eks/Monitoring/example-1/prometheus-operator

.PHONY: all clone rename copy clean

all: clone rename copy

clone:
	@echo "[*] Initializing sparse checkout in $(TARGET_DIR)"
	@mkdir -p $(TARGET_DIR)
	@cd $(TARGET_DIR) && \
		git init -q && \
		git remote add origin $(REPO) 2>/dev/null || true && \
		git config core.sparseCheckout true && \
		echo "$(SPARSE_DIRS)" | tr ' ' '\n' > .git/info/sparse-checkout && \
		git pull origin $(BRANCH) --depth=1

rename:
	@echo "[*] Renaming files (removing 'monitoring.coreos.com_' prefix)..."
	@for dir in $(SPARSE_DIRS); do \
		echo "Processing directory: $$dir"; \
		dest_dir="$(TARGET_DIR)/$$dir"; \
		echo "Looking for files in: $$dest_dir"; \
		for f in "$$dest_dir"/monitoring.coreos.com_*.yaml; do \
			[ -e "$$f" ] || { echo "No files found in $$dest_dir"; continue; }; \
			echo "Renaming: $$f"; \
			new_name=$$(basename "$$f" | sed 's/^monitoring.coreos.com_//'); \
			mv -v "$$f" "$$dest_dir/$$new_name"; \
		done; \
	done

copy:
	@echo "[*] Copying results to $(DEST_DIR)..."
	@mkdir -p $(DEST_DIR)
	@cp -r $(TARGET_DIR)/example/* $(DEST_DIR)/

clean:
	rm -rf $(TARGET_DIR)


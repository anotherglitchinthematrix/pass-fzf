EXT    ?= fzf.bash

PASSWORD_STORE_DIR ?= $(HOME)/.password-store
USER_EXT_DIR        = $(PASSWORD_STORE_DIR)/.extensions

.PHONY: install install-ext uninstall clean

install:
	install -d  "$(USER_EXT_DIR)"
	install -m 0755 $(EXT) "$(USER_EXT_DIR)/$(EXT)"
	@echo "$(EXT) installed to $(USER_EXT_DIR)"
	@echo "Remember to 'export PASSWORD_STORE_ENABLE_EXTENSIONS=true'"

install-system-wide:
	@[ -n "$$PASSWORD_STORE_EXTENSIONS_DIR" ] || { echo 'ERROR: PASSWORD_STORE_EXTENSIONS_DIR not set'; exit 1; }
	install -d  "$$PASSWORD_STORE_EXTENSIONS_DIR"
	install -m 0755 $(EXT) "$$PASSWORD_STORE_EXTENSIONS_DIR/$(EXT)"
	@echo "$(EXT) installed to $$PASSWORD_STORE_EXTENSIONS_DIR"

uninstall:
	rm -f "$(USER_EXT_DIR)/$(EXT)"
	@echo "removed $(USER_EXT_DIR)/$(EXT)"

uninstall-system-wide:
	@[ -n "$$PASSWORD_STORE_EXTENSIONS_DIR" ] || { echo 'ERROR: PASSWORD_STORE_EXTENSIONS_DIR not set'; exit 1; }
	rm -f "$$PASSWORD_STORE_EXTENSIONS_DIR/$(EXT)"
	@echo "removed $$PASSWORD_STORE_EXTENSIONS_DIR/$(EXT)"

clean:
	@echo "Nothing to clean."

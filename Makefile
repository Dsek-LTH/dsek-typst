# Paths are absolute so the Makefile also works when invoked with `-C`.
ROOT        := $(CURDIR)
FONT_PATH   := $(ROOT)/fonts

TYPST       := typst
TYPST_FLAGS := --root $(ROOT) --font-path $(FONT_PATH)

SRC_DIR  := src
SOURCES  := $(shell find $(SRC_DIR) -name '*.typ')

DOCS_DIR   := docs
DOCS_ENTRY := $(DOCS_DIR)/templates-docs.typ

EXAMPLES_DIR  := examples
EXAMPLES_SRC  := $(EXAMPLES_DIR)/src
EXAMPLES      := $(wildcard $(EXAMPLES_SRC)/*.typ)
EXAMPLES_PDFS := $(EXAMPLES:$(EXAMPLES_SRC)/%.typ=$(EXAMPLES_DIR)/%.pdf)

.PHONY: all docs examples test clean

all: docs examples

docs: $(DOCS_ENTRY) $(SOURCES)
	@echo 'Building the documentation...'
	$(TYPST) compile $(TYPST_FLAGS) $(DOCS_ENTRY)

examples: $(EXAMPLES_PDFS)

$(EXAMPLES_DIR)/%.pdf: $(EXAMPLES_SRC)/%.typ $(SOURCES)
	@echo "Compiling $<..."
	$(TYPST) compile $(TYPST_FLAGS) $<

test: docs examples
	@echo 'Compiling the files in $(SRC_DIR)...'
	@find $(SRC_DIR) -name '*.typ' \
	    -exec echo '  Compiling {}...' ';' \
	    -exec $(TYPST) compile $(TYPST_FLAGS) {} - > /dev/null ';'
	@echo '...done!'

clean:
	@echo 'Cleaning'
	find $(SRC_DIR) -name '*.pdf' -exec rm -f {} ';'
	find $(EXAMPLES_SRC) -name '*.pdf' -exec rm -f {} ';'

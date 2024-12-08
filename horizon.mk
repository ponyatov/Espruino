include mk/var.mk

# board files
BOARD ?= F4DISCO
JSON   = boards/$(BOARD).json
PYDEF  = boards/$(BOARD).py

include mk/dirs.mk
include mk/src.mk

.PHONY: all
all:
	BOARD=$(BOARD) DEBUG=1 make clean
	BOARD=$(BOARD) DEBUG=1 make

.PHONY: $(JSON)
$(JSON): $(PYDEF)
	BOARD=$(BOARD) DEBUG=1 make boardjson
# clean
# boardjson

.PHONY: cmake
cmake: CMakePresets.json CMakeLists.txt cmake/* cpu/*.cmake arch/*.cmake
	cmake --preset $(BOARD) -S $(CWD) -B $(TMP)/$(BOARD)
	cmake --build $(TMP)/$(BOARD)
	cmake --install $(TMP)/$(BOARD)

include mk/debug.mk
include mk/doc.mk
include mk/install.mk
include mk/merge.mk

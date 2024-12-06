# tiny scripts

# board files
BOARD ?= HORIZON
JSON   = boards/$(BOARD).json
PYDEF  = boards/$(BOARD).py

# dirs
CWD = $(CURDIR)
TMP = $(CWD)/tmp

# patched source code:
C += src/jsinteractive.c
H += 
S += targetlibs/stm32f4/lib/startup_stm32f40_41xxx.s
P += $(PYDEF)

.PHONY: $(JSON)
$(JSON): $(PYDEF)
	BOARD=$(BOARD) DEBUG=1 make boardjson

.PHONY: cmake
cmake: CMakePresets.txt CMakeLists cmake/* cpu/*.cmake arch/*.cmake
	cmake --preset $(BOARD) -S $(CWD) -B $(TMP)/$(BOARD)

# doc
.PHONY: doc
doc:

# install
.PHONY: install update ref gz
install: doc ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.$(shell lsb_release -si)`
ref: $(REF)
gz:  $(GZ)

# merge
MERGE += horizon.mk Makefile README.md apt.Debian
MERGE += Doxyfile .clang-format .gitignore
MERGE += CMakePresets.json CMakeLists.txt cmake
MERGE += $(C) $(H) $(S) $(P)
MERGE += hw cpu arch

# tiny scripts

HZ = HORIZON
JSON  = boards/$(HZ).json
BOARD = boards/$(HZ).py

# patched source code:
C += src/jsinteractive.c
H += 
S += targetlibs/stm32f4/lib/startup_stm32f40_41xxx.s
P += boards/$(HZ).py

.PHONY: $(JSON)
$(JSON): $(BOARD)
	BOARD=$(HZ) DEBUG=1 make boardjson

# merge
MERGE += horizon.mk Makefile README.md apt.Debian
MERGE += Doxyfile .clang-format .gitignore
MERGE += CMakePresets.json CMakeLists.txt cmake
MERGE += $(C) $(H) $(S) $(P)

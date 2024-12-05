# tiny scripts

HZ = HORIZON
JSON  = boards/$(HZ).json
BOARD = boards/$(HZ).py

# patched source code:
C += src/jsinteractive.c
H += 
S += targetlibs/stm32f4/lib/startup_stm32f40_41xxx.s

.PHONY: $(JSON)
$(JSON): $(BOARD)
	BOARD=$(HZ) DEBUG=1 make boardjson

# merge
MERGE += CMakePresets.json CMakeLists.txt apt.Debian
MERGE += $(C) $(H) $(S)

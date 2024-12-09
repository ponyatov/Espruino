# debug

ELF = $(BIN)/$(BOARD)_$(ESPVER).elf
SYM = $(BIN)/$(BOARD)_$(ESPVER).sym
HW  = $(CWD)/hw/$(BOARD)/$(BOARD)

.PHONY: openocd
openocd: $(HW).openocd $(ELF)
	$@ -f $<

.PHONY: gdb
gdb: $(ELF) $(SYM) $(HW).gdbinit
	$@-multiarch -q -s $(ELF) -x $(HW).gdbinit
# -e $(ELF)

.PHONY: sym
sym: $(SYM)
$(SYM): $(ELF)
	arm-none-eabi-objcopy --only-keep-debug $< $@
# arm-none-eabi-objcopy --strip-debug     $<

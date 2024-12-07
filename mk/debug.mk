# debug
.PHONY: openocd
openocd: $(CWD)/hw/$(BOARD)/$(BOARD).openocd $(TMP)/$(BOARD)/$(MODULE).elf
	$@ -f $<

.PHONY: gdb
gdb: $(TMP)/$(BOARD)/$(MODULE).elf
	$@-multiarch -q -x $(CWD)/hw/$(BOARD)/$(BOARD).gdbinit $<

# debug
.PHONY: openocd
openocd: $(TMP)/$(HW)/$(MODULE).elf
	$@ -f $(CWD)/hw/$(HW).openocd

.PHONY: gdb
gdb: $(TMP)/$(HW)/$(MODULE).elf
	$@-multiarch -q -x $(CWD)/hw/$(HW).gdbinit $<

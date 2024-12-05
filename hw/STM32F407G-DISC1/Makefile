#!/usr/bin/make -f

HW  = STM32F407VGT

.PHONY: autopatch
autopatch:
	$(MAKE) fix

LDS = $(HW)x_FLASH.ld
FIX += $(LDS).fix
$(LDS).fix: $(LDS)
	dos2unix $< *-$(LDS).patch
	patch $< 0000-$(LDS).patch
	touch $@

.PHONY: fix
fix: $(FIX)

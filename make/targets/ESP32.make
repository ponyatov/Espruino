ESP_ZIP     = $(PROJ_NAME).tgz

COMPORT?=/dev/ttyUSB0
FLASH_BAUD          ?= 921600 # The flash baud rate

$(PROJ_NAME).elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $(PROJ_NAME).elf -Wl,--start-group $(LIBS) $(OBJS) -Wl,--end-group

$(PROJ_NAME).bin: $(PROJ_NAME).elf
	python $(ESP_IDF_PATH)/components/esptool_py/esptool/esptool.py \
	--chip esp32 \
	elf2image \
	--flash_mode "dio" \
	--flash_freq "40m" \
	-o $(PROJ_NAME).bin \
	$(PROJ_NAME).elf

$(PROJ_NAME).lst : $(PROJ_NAME).elf
	$(OBJDUMP) -d -l -x $(PROJ_NAME).elf > $(PROJ_NAME).lst

$(ESP_ZIP): $(PROJ_NAME).bin
	$(Q)rm -rf $(PROJ_NAME)
	$(Q)mkdir -p $(PROJ_NAME)
	$(Q)cp $(PROJ_NAME).bin $(BINDIR)/espruino_esp32.bin
	@echo "** $(PROJ_NAME).bin uses $$( stat $(STAT_FLAGS) $(PROJ_NAME).bin) bytes of" $(ESP32_FLASH_MAX) "available"
	@if [ $$( stat $(STAT_FLAGS) $(PROJ_NAME).bin) -gt $$(( $(ESP32_FLASH_MAX) )) ]; then echo "$(PROJ_NAME).bin is too big!"; false; fi
	$(Q)cp $(ESP_APP_TEMPLATE_PATH)/build/bootloader/bootloader.bin \
	  $(BINDIR)/espruino_esp32.bin \
	  $(ESP_APP_TEMPLATE_PATH)/build/partitions_espruino.bin \
	  targets/esp32/README_flash.txt \
	  $(PROJ_NAME)
	$(Q)$(TAR) -zcf $(ESP_ZIP) $(PROJ_NAME) --transform='s/$(BINDIR)\///g'

proj: $(PROJ_NAME).bin $(ESP_ZIP)

flash: $(PROJ_NAME).bin
	python $(ESP_IDF_PATH)/components/esptool_py/esptool/esptool.py \
	--chip esp32 \
	--port ${COMPORT} \
	--baud $(FLASH_BAUD) \
	write_flash \
	-z \
	--flash_mode "dio" \
	--flash_freq "40m" \
	0x1000 $(ESP_APP_TEMPLATE_PATH)/build/bootloader/bootloader.bin \
	0x10000 $(PROJ_NAME).bin \
	0x8000 $(ESP_APP_TEMPLATE_PATH)/build/partitions_espruino.bin

erase_flash:
	python $(ESP_IDF_PATH)/components/esptool_py/esptool/esptool.py \
	--chip esp32 \
	--port ${COMPORT} \
	--baud $(FLASH_BAUD) \
	erase_flash

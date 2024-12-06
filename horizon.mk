# tiny scripts

include mk/var.mk

# board files
BOARD ?= HORIZON
JSON   = boards/$(BOARD).json
PYDEF  = boards/$(BOARD).py

# patched source code:
C += src/jsinteractive.c
H += 
S += targetlibs/stm32f4/lib/startup_stm32f40_41xxx.s
P += $(PYDEF)

.PHONY: $(JSON)
$(JSON): $(PYDEF)
	BOARD=$(BOARD) DEBUG=1 make boardjson

include mk/doc.mk

# install
.PHONY: install update ref gz
install: doc ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.$(shell lsb_release -si)`
ref: $(REF)
gz:  $(GZ)

include mk/merge.mk

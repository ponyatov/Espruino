# tiny scripts

H = HORIZON
JSON  = boards/$(H).json
BOARD = boards/$(H).py

.PHONY: $(JSON)
$(JSON): $(BOARD)
	BOARD=$(H) DEBUG=1 make boardjson

# merge
MERGE += README.md LICENSE horizon.mk README.md apt.Debian
MERGE += Doxyfile .clang-format .gitignore
MERGE += CMakePresets.json CMakeLists.txt cmake
MERGE += $(C) $(H) $(S) $(P)
MERGE += hw cpu arch os mk

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout $(USER) -- $(MERGE)

.PHONY: $(USER)
$(USER):
	git push -v
	git checkout $(USER)
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags

ZIP = tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).zip
zip: $(ZIP)
$(ZIP): doxy
	git archive --format zip --output $(ZIP) HEAD
	zip -r $(ZIP) \
		doc/html

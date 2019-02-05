
MODULES=$(dir $(wildcard */Makefile))

.PHONY: build
build:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: test
test:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: lint
lint:
	echo "Linting is not present"

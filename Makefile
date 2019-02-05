
MODULES=$(dir $(wildcard */Makefile))

.PHONY: build
build:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: tag
tag:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: publish
publish:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: test
test:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

.PHONY: lint
lint:
	echo "Linting is not present"


.PHONY: test-docker
test-docker:
	$(foreach mod,$(MODULES),($(MAKE) -C $(mod) $@) || exit $$?;)

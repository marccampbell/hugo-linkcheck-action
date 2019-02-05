

IMAGE_NAME=hugo-linkcheck

.PHONY: build
build:
	docker build -t $(IMAGE_NAME)

.PHONY: test
test:
	docker build -t link-check:test .
	docker run -e HUGO_STARTUP_WAIT=5 -v `pwd`/test:/github/workspace --workdir /github/workspace link-check:test
	@echo "There should be 1 broken link in the test above"



IMAGE_NAME=hugo-linkcheck

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	cd test && hugo serve --baseUrl http://localhost:1313 &
	blc -r --host-requests 20 --exclude https://github.com/marccampbell/ignore-me --exclude https://github.com/marccampbell/this-repo-should-never-exist --requests 20  --input http://localhost:1313
	## TODO test without exclusions

.PHONY: test-docker
test-docker:
	docker build -t link-check:test .
	docker run -e HUGO_STARTUP_WAIT=5 -v `pwd`/test:/github/workspace --workdir /github/workspace link-check:test
	@echo "There should be 1 broken link in the test above"

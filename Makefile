.PHONY: linkcheck-test

linkcheck-test:
	cd link-check && docker build -t link-check:test .
	docker run -e HUGO_STARTUP_WAIT=5 -v `pwd`/link-check/test:/github/workspace --workdir /github/workspace link-check:test
	@echo "There should be 1 broken link in the test above"


IMAGE_NAME=hugo-linkcheck
DOCKER_REPO=marc

.PHONY: lint
	`npm bin`/tslint --project ./tsconfig.json --fix

.PHONY: deps
deps:
	npm i

.PHONY: prebuild
prebuild:
	rm -rf build
	mkdir -p build

.PHONY: build
build: prebuild
	`npm bin`/tsc
	chmod +x ./build/hugo-linkcheck-action.js

.PHONY: run
run:
	node --no-deprecation ./build/hugo-linkcheck-action.js

.PHONY: test
test: build
	npm test

.PHONE: docker-build
docker-build:
	docker build -t $(IMAGE_NAME) .

.PHONY: docker-tag
docker-tag:
	tag $(IMAGE_NAME) $(DOCKER_REPO)/$(IMAGE_NAME) --no-latest --no-sha

.PHONY: docker-publish
docker-publish:
	docker push $(DOCKER_REPO)/$(IMAGE_NAME)

.PHONY: test-docker
test-docker:
	docker build -t hugo-linkcheck-action:test .
	docker run -e HUGO_STARTUP_WAIT=5 -v `pwd`/test-site:/github/workspace --workdir /github/workspace hugo-linkcheck-action:test
	@echo "There should be 1 broken link in the test above"

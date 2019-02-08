workflow "Build and publish" {
  on = "push"
  resolves = ["Publish LinkCheck"]
}

action "Test" {
  uses = "docker://marc/hugo-linkcheck:latest"
  runs = "make"
  args = "test"
}

action "Build" {
  needs = ["Test"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-build"
}

action "Docker Login" {
  needs = ["Build"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Tag LinkCheck" {
  needs = ["Docker Login"]
  uses = "actions/docker/tag@master"
  args = "hugo-linkcheck marc/hugo-linkcheck --no-latest --no-sha"
}

action "Publish LinkCheck" {
  needs = ["Tag LinkCheck"]
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "docker-publish"
}

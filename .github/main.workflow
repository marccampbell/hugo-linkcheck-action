workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for Docker"]
}

action "Build Docker Container" {
  uses = "actions/action-builder/docker@master"
  runs = "make"
  args = "build"  
}

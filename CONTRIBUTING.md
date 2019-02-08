# Contributing

Clone this repo, and run

```
make test
```

To locally run end-to-end tests in a Docker container, and more closely match the GitHub Action environment, you can riun

```
make test-docker
```

To run locally, without Docker:

```
$ make build && \
  node --no-deprecation ./build/hugo-linkcheck-action.js scan https://www.mysite.com
```

# Why is this javascript instead of just bash?

Many GitHub actions are simply an `entrypoint.sh`, intead of code that can be compiled. This is recommended because it's more transparant and often easy to wrap everything in a bash script. For this project, I wanted to use the great work work in the `broken-link-checker` module, but that project is designed to run independently today. The output is not controllable frmo the UI. The original version of this Action used it, and had some rather difficult to grok sed and grep statements to collect the output. In the end, it's much more maintainable as a few lines of javascript, instead of hard-to-read bash.



# Hugo Link Check GitHub Action

Builds a Hugo site and validates that there are no broken links in the site. Any broken links will be reported as a comment on the pull request.

This Action uses the [stevenvachon/broken-link-checker](https://github.com/stevenvachon/broken-link-checker) module to crawl and report broken links.

### Quick Start

Add a new [GitHub Action](https://github.com/features/actions) to your repo. You can create a file named `.github/main.workflow` and use this as a quick start:

```hcl
workflow "Hugo Link Check" {
  resolves = "linkcheck"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "linkcheck" {
  uses = "marccampbell/hugo-linkcheck-action@v0.1.4"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HUGO_FINAL_URL = "https://mysite.com"
  }
}
```

### Environment Variables

The following environment variables can be set to override defaults:

| Name | Default Value | Description |
|------|---------------|-------------|
| HUGO_ACTION_COMMENT | "true" | Set to "true" or "1" to post a comment back on the pull request |
| HUGO_STARTUP_WAIT | 15 | The number of seconds to wait `hugo serve` to be ready |
| HUGO_EXCLUSIONS_LIST | `.github/hugo-linkcheck-actions/exclusions.json` | The path to an optional file that lists exclusions |
| HUGO_CONFIG | `./config.toml` | Path to the config.toml to use when running the site. Relative to the root of the repo |
| HUGO_ROOT | `.` | Path to the Hugo site root, relative to the repo root |
| HUGO_CONTENT_ROOT | `./content` | Path to the Hugo content directory, relative to the repo root |
| HUGO_FINAL_URL | `http://localhost:1313` | URL to show in the diff (and link to) |
| HUGO_VERSION | 0.53 | The version of Hugo to run |

To set any of these parameters in your action, edit the "linkcheck" action step to pass these variables. For example, a main.workflow that sets a few of these would look like:

```hcl
workflow "Hugo Link Check" {
  resolves = "linkcheck"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "linkcheck" {
  uses = "marccampbell/hugo-linkcheck-action@v0.1.4"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    HUGO_CONFIG = "./configs/local.toml"
    HUGO_ROOT = "./hugo"
    HUGO_FINAL_URL = "https://mysite.com"
  }
}
```

### Excluding URLs

Sometimes, it makes sense to exclude a some URLs from the broken link checker. This GitHub Action supports reading a file from the repository that contains a list of domain names or paths to exclude from the action. By default, this file is `.github/hugo-linkcheck-action/exclusions.json`. You can change this path by setting the environment variable `HUGO_EXCLUSIONS_LIST`, as documented in the table above.

This file should be a list of paths to exclude, and an example is:

```
[
  "server:8800",
  "microsoft.com",
  "help.mycompany.com/community/profile"
]
```

### Directories

This GitHub Action doesn't make any assumptions about how your Hugo site is set up. There are sane defaults, which should work if you have a single Hugo site, running a relatively normal setup. But if you have a more custom Hugo setup, with various config.toml/yaml files, or content in a differerent directory than standard, use the environment variables when setting up your action.

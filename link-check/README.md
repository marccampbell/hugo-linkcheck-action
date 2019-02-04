# Hugo Link Check GitHub Action

Builds a Hugo site and validates that there are no broken links in the site. Any broken links will be reported as a comment on the pull request.

### Environment Variables

The following environment variables can be set to override defaults:

| Name | Default Value | Description |
|------|---------------|-------------|
| HUGO_ACTION_COMMENT | "false" | Set to "true" or "1" to post a comment back on the pull request |
| HUGO_STARTUP_WAIT | 15 | The number of seconds to wait `hugo serve` to be ready |
| HUGO_EXCLUSION_LIST | `.github/hugo-github-actions/link-check/exclusions` | The path to an option file that lists exclusions |

### Excluding URLs

Sometimes, it makes sense to exclude a some URLs from the broken link checker. This GitHub Action supports reading a file from the repository that contains a list of domain names or paths to exclude from the action. By default, this file is `.github/hugo-github-actions/link-check/exclusions`. You can change this path by setting the environment variable `HUGO_EXCLUSTION_LIST`, as documented in the table above.

This file should be plain text, and an example is:

```
server:8800
microsoft.com
help.mycompany.com/community/profile
```

# Hugo Link Check GitHub Action

Builds a Hugo site and validates that there are no broken links in the site. Any broken links will be reported as a comment on the pull request.

### Environment Variables

The following environment variables can be set to override defaults:

| Name | Default Value | Description |
|------|---------------|-------------|
| HUGO_ACTION_COMMENT | "false" | Set to "true" or "1" to post a comment back on the pull request |
| HUGO_STARTUP_WAIT | 15 | The number of seconds to wait `hugo serve` to be ready |


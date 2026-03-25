---
description: Run browser automation via Playwright CLI (token-friendly, no MCP server).
---
# /browser
Use `npx -y @playwright/cli` via Bash for all browser tasks. No MCP server needed.

## Common commands
```bash
npx -y @playwright/cli open [url]          # open browser
npx -y @playwright/cli goto <url>          # navigate
npx -y @playwright/cli snapshot            # capture page snapshot (get element refs)
npx -y @playwright/cli click <ref>         # click element
npx -y @playwright/cli fill <ref> <text>   # fill input
npx -y @playwright/cli type <text>         # type text
npx -y @playwright/cli screenshot          # take screenshot
npx -y @playwright/cli pdf                 # save as PDF
npx -y @playwright/cli close               # close browser
```

Use `-s=<session>` to maintain state across commands: `npx -y @playwright/cli -s=main goto https://example.com`
Run `npx -y @playwright/cli close` when done to clean up the browser process.

Always `snapshot` first to get element refs before clicking/filling.

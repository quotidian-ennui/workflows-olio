# action-dependabot-merge

Dismiss dependabot security alerts

## Why

> Because sometimes dependabot has alerts that you can safely dismiss w/o upgrading the dependencies.

## Usage


```action
name: dismiss-dependabot-alerts
on:
  workflow_dispatch:
  schedule:
    - cron: "15 06 * * 1"
  push:
    branches:
      - main
    paths:
      - ".github/dismiss-alerts.yml"
      - ".github/workflows/dismiss-dependabot-alerts.yml"
      - ".github/workflows/_dismiss-alerts.yml"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions: {}
jobs:
  dismiss-alerts:
    uses: ./.github/workflows/dismiss-dependabot-alerts.yml
    with:
      client_id: ${{ vars.WORKFLOW_UPDATE_CLIENT_ID }}
    secrets:
      app_private_key: ${{ secrets.WORKFLOW_UPDATE_KEY }}
```

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

|     INPUT      |  TYPE  | REQUIRED |            DEFAULT             |                                      DESCRIPTION                                      |
|----------------|--------|----------|--------------------------------|---------------------------------------------------------------------------------------|
|   client_id    | string |   true   |                                |           GitHub App Client ID with permission to manage dependabot alerts            |
| dismissal_file | string |  false   | `".github/dismiss-alerts.yml"` | The file that contains the ignore directives (defaults to .github/dismiss-alerts.yml) |

<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->
No outputs.
<!-- AUTO-DOC-OUTPUT:END -->

## Secrets

<!-- AUTO-DOC-SECRETS:START - Do not remove or modify this section -->

|     SECRET      | REQUIRED |                DESCRIPTION                 |
|-----------------|----------|--------------------------------------------|
| app_private_key |   true   | The private key associated with the App ID |

<!-- AUTO-DOC-SECRETS:END -->


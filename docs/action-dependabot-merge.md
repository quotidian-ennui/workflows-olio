# action-dependabot-merge

Merge dependabot changes to workflows

## Why

> This is an action that's very personal and works in tandem with check-pr-with-trigger.

## Usage

- Requires you to have `contents:write` & `pull_requests:write` permissions attached to the token (depending on what you're doing).
- If you are updating `./.github/workflows` then you probably need to have a github application.

```action
name: dependabot-merge
run-name: Merge dependabot-pr (${{ github.event.client_payload.detail.pull_request }})
on:
  repository_dispatch:
    types:
      - dependabot-merge

permissions: {}

jobs:
  actions_merge:
    uses: ./.github/workflows/action-dependabot-merge.yml
    with:
      app_id: ${{ vars.app-id }}
    secrets:
      app_private_key: ${{ secrets.app-id-secret }}
```

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

| INPUT  |  TYPE  | REQUIRED | DEFAULT |                    DESCRIPTION                    |
|--------|--------|----------|---------|---------------------------------------------------|
| app_id | string |   true   |         | The App ID that will modify your github workflows |

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


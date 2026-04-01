# check-pr-with-trigger

Run some standardised tests on the PR (via reviewdog etc) and issue a repository dispatch if the PR was created by dependabot.

## Why

> Dependabot is a busy little bee and sometimes there a lot of toil when it comes to dependabot.

## Usage

- Requires you to have `contents:write` & `pull_requests:write` permissions attached to the token (depending on what you're doing).

```action
name: Check PR
on:
  pull_request:
    branches:
      - main
    types: [opened, synchronize, reopened, edited]

permissions: {}

jobs:
  check-pr:
    uses: ./.github/workflows/check-pr-with-trigger.yml
    secrets: inherit
    permissions:
      contents: write
      pull-requests: write
      checks: write
```

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->

|      INPUT       |  TYPE   | REQUIRED | DEFAULT |                 DESCRIPTION                  |
|------------------|---------|----------|---------|----------------------------------------------|
| dispatch_enabled | boolean |  false   | `true`  | Whether to fire the 'dependabot_merge' event |

<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->
No outputs.
<!-- AUTO-DOC-OUTPUT:END -->

## Secrets

<!-- AUTO-DOC-SECRETS:START - Do not remove or modify this section -->
No secrets.
<!-- AUTO-DOC-SECRETS:END -->

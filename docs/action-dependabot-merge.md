# action-dependabot-merge

Merge dependabot changes to workflows

## Why

> This is an action that's very personal since the defaults refer to an explicit github app that I've created so that I can make modifications to github actions.
>
> Works in tandem with check-pr-with-trigger.

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

# A push via dependabot basically means that the github actions
# have been upgraded;
jobs:
  actions_merge:
    uses: ./.github/workflows/action-dependabot-merge.yml
    secrets: inherit
```

## Inputs

<!-- AUTO-DOC-INPUT:START - Do not remove or modify this section -->
No inputs.
<!-- AUTO-DOC-INPUT:END -->

## Outputs

<!-- AUTO-DOC-OUTPUT:START - Do not remove or modify this section -->
No outputs.
<!-- AUTO-DOC-OUTPUT:END -->

## Secrets


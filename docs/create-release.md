# default-updatecli

Create a release using orhun/git-cliff-action and ncipollo/release-action

## Why

> On tag create a change log & release. I have other workflows that might build docker images off the back of the tag and stuff.

## Usage

- Requires you to have `contents:write` permissions attached to the token.

```action
name: create-release
on:
  push:
    tags:
      - "*"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions: {}
jobs:
  check-pr:
    uses: ./.github/workflows/create-release.yml
    secrets: inherit
    permissions:
      contents: write

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

<!-- AUTO-DOC-SECRETS:START - Do not remove or modify this section -->
No secrets.
<!-- AUTO-DOC-SECRETS:END -->

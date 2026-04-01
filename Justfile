set positional-arguments := true
set unstable := true
set script-interpreter := ['/usr/bin/env', 'bash']

# show recipes
[private]
@help:
    just --list --list-prefix "  "

[doc("Show next version as proposed by git-semver")]
[group('release')]
[script]
next:
    #shellcheck disable=SC2148
    set -eo pipefail

    VERSION_REGEXP_MAJOR='s#^([0-9]+)\.([0-9]+)\.([0-9]+).*$#\1#'
    VERSION_REGEXP_MINOR='s#^([0-9]+)\.([0-9]+)\.([0-9]+).*$#\2#'
    VERSION_REGEXP_PATCH='s#^([0-9]+)\.([0-9]+)\.([0-9]+).*$#\3#'
    bumpMinor() {
      local version="$1"
      local majorVersion
      local minorVersion
      majorVersion=$(echo "$version " | sed -E "$VERSION_REGEXP_MAJOR")
      minorVersion=$(echo "$version " | sed -E "$VERSION_REGEXP_MINOR")
      minorVersion=$((minorVersion + 1))
      echo "$majorVersion.$minorVersion.0"
    }

    bumpPatch() {
      local version="$1"
      local majorVersion
      local minorVersion
      local patchVersion

      majorVersion=$(echo "$version" | sed -E "$VERSION_REGEXP_MAJOR")
      minorVersion=$(echo "$version" | sed -E "$VERSION_REGEXP_MINOR")
      patchVersion=$(echo "$version" | sed -E "$VERSION_REGEXP_PATCH")
      patchVersion=$((patchVersion + 1))
      echo "$majorVersion.$minorVersion.$patchVersion"
    }

    lastTag=$(git tag -l | sort -rV | head -n1)
    lastTaggedVersion=${lastTag#"v"}
    majorVersion=$(echo "$lastTaggedVersion" | sed -E "$VERSION_REGEXP_MAJOR")
    semver_arg=""
    if [[ -z "$majorVersion" || "$majorVersion" = "0" ]]; then
      semver_arg="--stable=false"
    fi

    # git semver only works if this branch has the latest tag in its history.
    # FATA[0000] Latest tag is not on HEAD...
    computedVersion=$(git semver next "$semver_arg" 2>/dev/null || true)
    if [[ -n "$computedVersion" ]]; then
      if [[ "$computedVersion" == "$lastTaggedVersion" ]]; then
        bumpPatch "$lastTaggedVersion"
      else
        echo "$computedVersion"
      fi
    else
      closestAncestorTag=$(git describe --abbrev=0)
      closestTagVersion=${closestAncestorTag#"v"}
      bumpPatch "$closestTagVersion"
    fi

[doc('run autodoc')]
[group('helpers')]
[script]
autodoc:
    #shellcheck disable=SC2148
    set -eo pipefail

    mapfile -t workflow_files < <(find ".github/workflows" -type f -name "*.yml")
    for workflow_file in "${workflow_files[@]}"; do
      workflow="$(basename "$workflow_file")"
      workflow_name="${workflow%%.yml}"
      workflow_doc="./docs/$workflow_name.md"
      if [[ -f "$workflow_doc" ]]; then
        auto-doc --colMaxWords 100 --reusable --filename "$workflow_file" --output "$workflow_doc"
      else
        echo "Skip $workflow because no documentation"
      fi
    done

[doc('auto-generate tag and release')]
[group('release')]
[script]
autotag push="localonly":
    #shellcheck disable=SC2148
    set -eo pipefail

    next="$(just next)"
    just release "$next" "{{ push }}"

# Since we have that refer to their peers(e.g. dependabot-action-merge refers
# to pr-or-issue-comment) we rewrite the @main to be @tag, commit, tag and
# switch back to @main
[doc('Tag & release')]
[group('release')]
[script]
release tag push="localonly":
    #shellcheck disable=SC2148
    set -eo pipefail

    check_uptodate() {
      default_branch=$(git remote show "origin" | grep 'HEAD branch' | cut -d' ' -f5)
      remote_hash=$(git ls-remote origin "refs/heads/$default_branch" | cut -f1)
      local_hash=$(git rev-parse "$(git branch --show-current)")
      if [[ "$remote_hash" != "$local_hash" ]]; then
        echo "⚠️ Remote hash differs, are we up to date?"
        exit 1
      fi
    }

    git diff --quiet || (echo "⚠️ git is dirty" && exit 1)
    check_uptodate
    push="{{ push }}"
    next=$(echo "{{ tag }}" | sed -E 's/^v?/v/')
    git tag "$next" -m"release $next"
    case "$push" in
      push|github|gh)
        git push --tags
        ;;
      *)
        ;;
    esac

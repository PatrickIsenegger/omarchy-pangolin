# Releases

The source of truth is `manifest.json.version`. Tags prefix that value with `v`; the panel's displayed version must match. The public release line begins with `0.1.0-beta.1`.

Use SemVer: `0.x` remains experimental. After `1.0.0`, PATCH fixes compatible behavior, MINOR adds compatible functionality, MAJOR changes the documented configuration/behavior contract incompatibly. Tag contents are immutable.

`main` holds reviewed release commits because Omarchy's update command fetches the remote default branch and fast-forwards. Develop on feature branches. Before merging: run tests, validate QML/manifest, update the changelog and version, inspect the entire publishable tree for private data, and review demo assets. Then tag the release commit and publish matching GitHub release notes. A GitHub prerelease flag does not prevent updates from `main`.

To test or temporarily roll back to a known tag, first preserve any local changes, fetch tags in the installed plugin checkout, and check out that tag detached. Restart the shell. Do not use `omarchy plugin update` while intentionally pinned: it may advance to the default branch again. Return to the release branch deliberately when resuming updates. No destructive reset is needed.

Community registry submission follows initial beta feedback. Publishing the repository, a release or a registry entry is a separate action from preparing files.

## Preparing the next version

```bash
python3 tools/bump_version.py 0.1.0-beta.7
```

This updates the manifest, shared UI version and local README version badge together. Choose the actual next version, update `CHANGELOG.md`, regenerate previews, then run `python3 tools/check_release.py` and the documented checks. Beta numbers increase monotonically; published tags are never rewritten. The version badge links to GitHub Releases so readers can see release notes and prerelease status.

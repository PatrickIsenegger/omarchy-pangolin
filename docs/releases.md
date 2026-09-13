# Releases

Releases use simple SemVer numbers: **0.1.0**, **0.1.1**, **0.2.0**. New releases have no beta suffix and are published as regular GitHub Releases. Existing beta tags remain unchanged as historical snapshots.

`manifest.json.version` is the source of truth. Tags prefix the version with `v`. The version helper keeps the manifest, panel and README badge synchronized.

- PATCH (`0.1.1`): compatible fixes and refinements.
- MINOR (`0.2.0`): new features. During `0.x`, documented breaking changes may appear in a minor release.
- MAJOR (`1.0.0` and later): major milestones; after 1.0, incompatible changes increment the major version.

A regular release does not expand the [tested compatibility scope](compatibility.md). Published tags are immutable.

## Prepare a release

```bash
python3 tools/bump_version.py 0.1.1
```

Choose the actual next version, update the changelog, regenerate synthetic previews and run backend, QML, plugin and release checks. Inspect publishable files for private data before pushing. Publish the matching GitHub Release as the latest regular release.

`main` holds reviewed release commits because Omarchy updates fetch the default branch and fast-forward; the updater does not select the newest GitHub Release. Develop changes on feature branches.

## Roll back

Preserve any local changes in the installed plugin checkout, fetch tags, then check out the desired tag detached and reload the shell. Do not run `omarchy plugin update` while intentionally pinned: it may advance to the default branch. Return deliberately to the release branch when resuming updates. No destructive reset is needed.

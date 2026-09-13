# Community marketplace submission

Checked 13 September 2026. This describes the current public submission route, not a claim that this plugin is already listed or verified.

## Where to submit

The [Omarchy manual](https://omarchy.org/manual/shell-plugins/) links to the community marketplace at [plugins.omarchy.org](https://plugins.omarchy.org/). Its [publishing guide](https://plugins.omarchy.org/publish.html) directs new submissions to an issue in [omacom/omarchy-plugin-marketplace](https://github.com/omacom/omarchy-plugin-marketplace).

Keep the plugin code and releases in this repository. Submit a directory listing; no pull request adding this plugin to Omarchy's built-in source tree is needed. The separate `omarchy-plugin-registry` project describes a newer publishing system whose README still lists launch prerequisites. Follow the live marketplace's submission guide rather than assuming that future CLI publishing is available.

## Proposed listing

| Field | Value |
| --- | --- |
| Title | `[Plugin]: Pangolin for Omarchy` |
| Repository | `https://github.com/PatrickIsenegger/omarchy-pangolin` |
| Plugin ID | `community.pangolin` |
| Category | `System` |
| Tags | `bar`, `launcher`, `system` |
| Preview | Root `preview.png`, illustrated overview; actual UI screenshots in README |

Suggested missing tag: **connectivity**. It describes remote network access and connection state; this plugin is not a general metrics or availability-monitoring dashboard. The current marketplace tag vocabulary does not include connectivity or monitoring. Its Explore graph includes a Network & VPN group derived from names, descriptions and tags. [Explorer implementation](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/scripts/build-explorer-data.mjs).

The ID and repository were not found in the public catalog during this check. Recheck before submitting; availability is not reserved by this document.

Maintainer notes should explain the Pangolin CLI dependency, user-initiated connection and app-install actions, active-account session access, the optional local migration helper, no telemetry, and the documented lack of authenticated Cloud end-to-end testing. Resource access is restricted to the selected account's authorized launcher list.

## Review and approval

Use the [submission form](https://github.com/omacom/omarchy-plugin-marketplace/issues/new?template=submit-plugin.yml) or the exact issue structure in the [CLI submission guide](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/SUBMISSION.md). Read its ownership, dependency, configuration and listing checkboxes before agreeing to them. An AI-prepared submission needs the owner's explicit review and approval of the completed issue before it is posted.

The marketplace checks an exact commit and requires maintainer approval before publication. Its [security baseline](https://github.com/omacom/omarchy-plugin-marketplace/blob/main/SECURITY.md) can flag documented capabilities for manual review. Listing approval is not a security audit or official endorsement of the plugin.

After listing, code changes need the marketplace's newer-commit verification/update flow to update the reviewed snapshot. Omarchy's current git install/update commands follow upstream HEAD, which can differ from that snapshot. See [releases](releases.md).

## Before sending

Run automated tests, `omarchy plugin validate .`, and `python3 tools/check_release.py`; verify the UI on supported Omarchy and review the exact public commit, history and preview assets for private data. Keep private accounts, raw logs and authenticated screenshots out of submission material. [Compatibility and test scope](compatibility.md) records the remaining limitations.

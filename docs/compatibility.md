# Compatibility and beta scope

Development checks target Omarchy 4.0.3-1 / Quattro, Python 3.10+, Pangolin CLI 0.16.x and the Pangolin 1.21.x API shape. This is not a claim that every combination has been integration-tested.

Expected local interface: Unix socket `/run/olm.sock`, `GET /status`, `POST /exit`. Status must provide boolean `connected`, `registered` and `terminated` fields.

Expected account layout: Pangolin CLI `accounts.json` with `activeuserid` and an `accounts` map. Session tokens are used only in request headers. HTTPS servers are supported; HTTP control planes are deliberately unsupported in this beta.

Resource interface: `/api/v1/org/:orgId/launcher/resources` with `groupKey=all`, pagination and `launcherResourceKey`. Optional `/site-resources` supplies private TCP port metadata. These are version-sensitive application APIs, not a promise of long-term compatibility.

Automated checks use synthetic responses and mocked installation. Fresh-user installation, real account switching, multiple monitors and the entire supported server matrix require community testing. Preview renders verify the actual Dashboard component with synthetic palette and data adapters; they are not screenshots of an authenticated desktop.

Known beta limitations: English UI; configuration uses a JSON editor; only HTTP(S) web-app launchers; host ports/protocols sometimes require explicit overrides; Chromium is the web browser; resource lists refresh on panel open or manually; HTTPS diagnosis does not test UDP or prove app reachability.

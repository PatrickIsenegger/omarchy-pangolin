<p align="center">
  <a href="https://patrickisenegger.com"><img src="assets/readme-hero.png" alt="Pangolin for Omarchy — an original watercolor pangolin beside a laptop" width="100%"></a>
</p>

# Pangolin for Omarchy

**Your connections, close at hand.** A community bar plugin for Pangolin connections, resources and web apps — painted in your active Omarchy theme.

[![Version](assets/badges/version.svg)](https://github.com/PatrickIsenegger/omarchy-pangolin/releases)
[![License: MIT](assets/badges/license.svg)](LICENSE)
[![Hosting: Cloud and self-hosted](assets/badges/hosting.svg)](docs/compatibility.md)
[![Style: Omarchy theme](assets/badges/theme.svg)](docs/graphics.md)

[Install](#install) · [Configure](docs/configuration.md) · [Releases](https://github.com/PatrickIsenegger/omarchy-pangolin/releases) · [Deutsch](README.de.md) · [Patrick Isenegger ↗](https://patrickisenegger.com)

![The real plugin UI in two demonstration themes; all resources are fictional](assets/preview.png)

## A small panel for everyday access

| Connection | Resources | Your desktop |
| --- | --- | --- |
| Connect, disconnect and inspect local tunnel status. | Open public services and compact private-resource tiles. | Install resources as web apps, or open existing matching apps. |
| A theme-green dot indicates a confirmed connection. | Copy a web URL or host address with one click. | Text, washes, accents and status colors follow Omarchy. |

The SVG symbol breathes and soft color washes drift while a fresh connection is confirmed. Disconnecting or losing status stops the motion; panel animations also pause when it closes. Quiet, readable controls remain available throughout.

**Community beta · English interface.** Independent of Pangolin and Omarchy. All screenshots and examples use synthetic resources. The watercolor title artwork takes its visual direction from [my website](https://patrickisenegger.com); the desktop interface uses your theme's colors. [Artwork and rendering](docs/graphics.md).

## Requirements

Omarchy Quattro with the Quickshell plugin API (`Color.popups`, `Ui.Panel`, `KeyboardPanel`), Python 3.10+, and the Pangolin CLI with a readable local OLM socket. Resource discovery requires the launcher API and an existing CLI account.

Runtime commands: `python3`, `timeout`, `pangolin`, `omarchy`, `chromium`, `gtk-launch`, `wl-copy`, `xdg-open`, and optionally `notify-send`. The plugin uses Python's standard library; no pip packages are required. See [compatibility](docs/compatibility.md) for the test scope.

## Install

```bash
omarchy plugin add https://github.com/PatrickIsenegger/omarchy-pangolin.git --enable
```

For a local source checkout:

```bash
omarchy plugin add /path/to/omarchy-pangolin --enable
```

### Pangolin Cloud and self-hosted servers

Both are supported through the active CLI account. For Pangolin Cloud:

```bash
pangolin login app.pangolin.net
```

For a self-hosted server:

```bash
pangolin login https://gateway.example.com
```

Select your organization using the CLI. When using several accounts, use `pangolin select account` and reopen the panel to refresh resources. The plugin uses the session API on the selected dashboard host, not the separate integration API at `api.pangolin.net`. You do not need a new integration API key.

Cloud and self-hosted account/request handling are covered by synthetic tests. Authenticated Cloud end-to-end testing still needs a Cloud account.

[Official client endpoint documentation](https://docs.pangolin.net/manage/clients/credentials).

The plugin uses that active account. Connect from the panel; any privilege prompt is handled by Pangolin in a terminal. Nothing connects automatically on installation.

The plugin ID is `patrick.pangolin`. Omarchy will not overwrite an existing installation with that ID. Back up an existing custom copy and its configuration before migrating; do not delete it blindly.

## Use

Left-click the bar icon to open the panel. Right-click opens the account's dashboard. Resource tiles open their web URL, preferring a matching installed app. `+` installs a web-app launcher. The adjacent copy button copies the URL or host address.

Private resources need an active Pangolin connection and working alias DNS. A host resource is not necessarily a web service: configure a full URL or a known scheme under [settings](docs/configuration.md). A TCP allowlist alone does not identify HTTP versus HTTPS.

**Restart shell** restarts the entire Omarchy shell, including its bar and other plugins. It does not disconnect the VPN.

## Settings

The gear button opens `$XDG_CONFIG_HOME/omarchy-pangolin/config.json` (default `~/.config/omarchy-pangolin/config.json`). Settings live outside the plugin checkout and survive updates. Overrides are scoped by server and organization. [Configuration reference](docs/configuration.md).

Demo mode uses only generated data and disables actions. Enable the widget's `demo` setting for previews. It never loads account credentials or requests a server.

## Update and remove

```bash
omarchy plugin update patrick.pangolin
omarchy plugin remove patrick.pangolin
```

The Omarchy updater follows the repository's default branch, not the newest GitHub Release. `main` is reserved for reviewed release commits. See [releases and rollback](docs/releases.md).

Removal leaves your separately stored settings and installed web apps intact. Remove unwanted apps with `omarchy webapp remove`.

## Privacy and permissions

The plugin runs with your desktop user's permissions. It reads the active CLI account file and uses its session token for HTTPS API calls to that account's server. Tokens are not copied into plugin configuration or printed. Authenticated redirects are rejected. There is no telemetry or external icon download.

Public resources and private resources come from the authorized launcher list. Optional administrative metadata enriches private ports; denied metadata access does not replace or broaden the launcher list. Application probes are not run automatically. Desktop app installation is explicit, with a shared installation lock and filename collision handling.

Do not attach credentials, raw account files, private URLs, or unredacted logs to issues. Use synthetic examples. [Troubleshooting](docs/troubleshooting.md).

## Development

```bash
python3 -m unittest discover -s tests -v
omarchy plugin validate .
```

See [contributing](CONTRIBUTING.md), [changelog](CHANGELOG.md), [license](LICENSE) and [third-party notices](THIRD_PARTY_NOTICES.md).

---

Built by [Patrick Isenegger](https://patrickisenegger.com). Ideas and reproducible issues are welcome — please use fictional resources when sharing examples.

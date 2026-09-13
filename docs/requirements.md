# Requirements · Voraussetzungen

The Omarchy plugin installation does **not** install Pangolin or any other
system dependency. `omarchy plugin add ... --enable` clones the plugin,
validates its manifest and enables it in Omarchy. Omarchy does not run plugin
install hooks or `sudo` during that command. Install and configure the Pangolin
client separately.

## Required

- Omarchy Quattro with the Quickshell plugin API used by this widget
  (`Color.popups`, `Ui.Panel` and `KeyboardPanel`).
- Python 3.10 or newer (the plugin uses only Python's standard library; no
  `pip` packages are needed).
- `timeout`, `omarchy`, `xdg-open` and `wl-copy` on `PATH`.
- The official [Pangolin CLI](https://docs.pangolin.net/manage/clients/install-client),
  logged in to Cloud or your self-hosted server, with an active organization.
- A running local Pangolin/Olm client exposing a readable Unix socket at
  `/run/olm.sock` (often the same path as `/var/run/olm.sock`). The plugin uses
  this socket for status and connection control.

The plugin also expects the CLI account file at
`$XDG_CONFIG_HOME/pangolin/accounts.json` (normally `~/.config/pangolin/accounts.json`), as written by `pangolin login`. Resource discovery needs a user account session; a standalone machine client with only client ID/secret is not sufficient. The socket may be absent while disconnected; start the CLI to check connected status. Do not change socket permissions to make it world-readable.

## What Omarchy normally provides

A standard compatible Omarchy desktop already supplies its shell, app launcher and many of the utilities below. Check rather than assume: a customized or minimal installation may differ. Pangolin CLI must be installed separately. Its client implements Olm; you do not need a second standalone Olm installation for this setup.

| Missing command | Arch package |
| --- | --- |
| `python3` | `python` |
| `timeout` | `coreutils` |
| `wl-copy` | `wl-clipboard` |
| `gtk-launch` | `gtk3` |
| `xdg-open` | `xdg-utils` |
| `chromium` | `chromium` |
| `git` (repository installation/updates) | `git` |
| `curl` (CLI quick installer) | `curl` |
| `notify-send` (optional) | `libnotify` |

Install a missing package explicitly with Omarchy, for example:

```bash
omarchy pkg add wl-clipboard
```

Use the package name from the table. Package installation may ask for administrator authentication. See [Arch package information](https://archlinux.org/packages/) for package details. The plugin never installs these packages itself.

## Used by specific actions

- `chromium` opens resources without an installed desktop web app.
- `gtk-launch` opens an already installed matching desktop web app.
- `omarchy webapp install` is used when you choose **Install as app**.
- `notify-send` is optional; it only adds desktop notifications.

Check availability without changing anything:

```bash
for command in python3 timeout omarchy pangolin xdg-open wl-copy chromium gtk-launch; do
  printf '%-12s ' "$command"
  command -v "$command" || echo 'missing'
done
test -r /run/olm.sock && echo 'OLM socket: readable' || echo 'OLM socket: missing or unreadable'
```

## Install the Pangolin CLI separately

Pangolin's official Linux/macOS quick install is:

```bash
curl -fsSL https://static.pangolin.net/get-cli.sh | bash
pangolin login
pangolin up
```

The official [CLI repository](https://github.com/fosrl/cli) and [client
documentation](https://docs.pangolin.net/manage/clients/install-client) also
describe manual downloads, machine clients and updates. For a self-hosted
server, use its URL when prompted by `pangolin login`; the same CLI supports
Pangolin Cloud and self-hosted deployments. Keep client secrets private.

After login, select the organization required by your account (the official
CLI documentation shows `pangolin select org --org <org-id>`). Then reopen the
panel. The plugin uses the selected CLI account; installation itself never
connects automatically.

### Deutsch: kurze Schritte

Die Plugin-Installation installiert **nicht** die Pangolin-CLI und keine
weiteren Pakete. Installiere die [offizielle Pangolin-CLI](https://docs.pangolin.net/manage/clients/install-client)
separat, melde dich an und starte den Client:

```bash
curl -fsSL https://static.pangolin.net/get-cli.sh | bash
pangolin login
pangolin up
```

Danach die Organisation auswählen und das Panel neu öffnen. Mit dem obigen
Prüfbefehl lassen sich fehlende Programme und der OLM-Socket ohne Änderungen
am System erkennen.

## Official references

- [Pangolin CLI installation and login](https://docs.pangolin.net/manage/clients/install-client)
- [Pangolin CLI source and releases](https://github.com/fosrl/cli)
- [Pangolin client credentials](https://docs.pangolin.net/manage/clients/credentials)
- [Omarchy third-party plugin installation](https://github.com/basecamp/omarchy/blob/master/shell/README.md#installing-a-third-party-plugin)

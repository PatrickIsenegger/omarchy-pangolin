# User guide

[Help home](README.md) · [Deutsch](guide.de.md)

## Resource legend

| Icon | Meaning | Click action |
| --- | --- | --- |
| Checked window | Installed web app, with a subtle flat tile tint | Open the app window |
| Globe | Web resource without a detected app launcher | Open in the browser |
| Overlapping sheets | Host address without a configured web URL | Copy the address |
| ⋮ | Resource actions | Open its menu |

Each resource uses one line. Private resources are slightly smaller and remain in their own section. Hover or keyboard focus reveals the full name, destination and connection requirements.

The **⋮ menu**, also available by right-clicking an enabled resource, offers opening, URL copying and app installation. Installed apps omit the installation action. Installing adds an Omarchy launcher; the service remains on its server. Refresh to check resource and installed-app state again.

## Connection

**Green** confirms a local Pangolin connection. Individual sites may still connect on demand. **Yellow** means pending registration, a warning or unknown/stale status. **Red** means disconnected or a client error; the text distinguishes them. Colors follow the active theme. SVG motion runs only with a confirmed connection, and panel motion pauses when closed. Resource icons are static and never downloaded externally.

**Connect** starts Pangolin in a terminal for any required authentication or privileges. **Disconnect** stops the connection. Private resources require Pangolin and alias DNS. A host address does not imply HTTP(S); use [configuration](configuration.md) for explicit URLs.

## Controls

- Left-click the bar icon to toggle the panel; right-click it to open the selected account's dashboard.
- **↻** reloads resources and installed-app detection. **All / Less** expands public resources beyond the first eight or restores that limit.
- **Details** shows tunnel, DNS, sites and status information, plus HTTPS diagnosis and the server dashboard.
- **⚙** opens local settings stored outside the plugin checkout.
- **Restart shell** restarts the whole Omarchy shell, including other plugins, without disconnecting the VPN.
- **? Help** opens the public documentation with no private account or resource data in the link.

Tab navigates buttons; Enter/Space activates them. Escape dismisses an open menu or the panel. Hover explanations also work for unavailable actions. Demo mode disables real actions.

See [troubleshooting](troubleshooting.md) for failures and [releases](releases.md) for updates and rollback. Share only synthetic resources and redacted errors in issues, never credentials or private URLs.

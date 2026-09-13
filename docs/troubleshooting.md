# Troubleshooting

- **No account:** run `pangolin login`, then select an organization in the CLI.
- **Registration pending:** inspect the Pangolin client; a running process is not proof of a registered tunnel.
- **Registered / on demand:** resources may connect a site when accessed. The plugin does not manufacture a healthy peer state.
- **Alias does not resolve:** check Pangolin alias DNS and your client connection. `.local` can conflict with mDNS.
- **Host has no web link:** configure the full URL or a scheme. A port allowlist is not a web protocol declaration.
- **Access denied:** renew the CLI login or check resource access. Missing administrative metadata does not prevent basic resource display.
- **Cannot install/open app:** check `chromium`, `gtk-launch` and `omarchy webapp install`; the plugin never installs system dependencies silently.
- **Update conflict:** preserve local edits before updating. Store preferences outside the repository.
- **Status unavailable:** check local socket permissions; the plugin never interprets permission denial as disconnection.

When reporting a problem, provide versions, the action taken and an anonymized error description. Reproduce with synthetic names and addresses. Do not upload account files or raw server responses.

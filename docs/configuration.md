# Configuration

Default path: `~/.config/omarchy-pangolin/config.json`; respects `XDG_CONFIG_HOME`. The settings button creates an empty version-1 file if needed and opens it with your desktop text editor. Never put credentials in this file.

See [the synthetic example](../examples/config.json). `accounts` is keyed by the active CLI server URL (without trailing slash), then organization ID. Overrides from another account are not applied.

- `webUrls`: map launcher resource IDs, such as `site:1`, to full HTTP(S) URLs, including port/path when necessary. This also supports services with several allowed TCP ports.
- `hostSchemes`: map a single host alias to `http` or `https`. A URL is constructed only if optional server metadata supplies one valid TCP port. No protocol is inferred from ports.

Use a full `webUrls` entry for nonstandard layouts. Arbitrary executable commands and embedded URL credentials are not supported. Never use a CIDR or wildcard itself as a browser URL.

Changes apply on resource refresh. An empty config is sufficient for resources with server-provided URLs.

Demo mode is an Omarchy widget setting (`demo: true`) rather than an account setting. It disables connect, disconnect, open, install, clipboard and restart actions. Data is generated entirely locally.

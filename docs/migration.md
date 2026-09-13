# Migrating from `patrick.pangolin`

Release `0.1.0` uses the community ID `community.pangolin`. The migration
keeps the existing bar position and inline widget settings. Pangolin account
settings are stored separately under `$XDG_CONFIG_HOME/omarchy-pangolin` and
are not moved or rewritten.

For an existing installation, first update the old checkout so it receives
the migration helper, then run it once:

```bash
omarchy plugin update patrick.pangolin
python3 ~/.config/omarchy/plugins/patrick.pangolin/tools/migrate_plugin_id.py
omarchy-shell shell rescanPlugins
```

The helper refuses to overwrite an existing `community.pangolin` checkout. It
backs up the old checkout and `shell.json` under
`~/.local/state/omarchy-pangolin/migrations/`, renames the checkout and changes the matching bar entry in place. The preceding
plugin update supplies the new manifest and QML module ID. The widget may briefly
disappear between update and migration; complete both steps.
Run `omarchy plugin list` afterward and confirm that `community.pangolin` is
listed once and that the panel opens. Restart the shell only if a running shell
does not pick up the rescan:

```bash
omarchy restart shell
```

Do not run `omarchy plugin add` for the new ID when the old checkout is already
installed; that creates a second checkout. Do not enable the new ID before the
bar entry is renamed: Omarchy would temporarily add another right-section
entry. `allowMultiple: false` documents that this widget is intended to have a
single configured bar entry, but two different IDs can still produce two live
instances.

For a fresh installation, use the new ID from the start:

```bash
omarchy plugin add https://github.com/PatrickIsenegger/omarchy-pangolin.git --enable
```

After migration, use:

```bash
omarchy plugin update community.pangolin
omarchy plugin remove community.pangolin
```

## Deutsch

Einmalig den alten Checkout aktualisieren, den oben gezeigten Python-Helfer ausführen und die Plugins neu einlesen. Der Helfer sichert den bisherigen Stand und erhält Position sowie Einstellungen. Danach heißt die Kennung in allen Befehlen `community.pangolin`. Die separate Konfiguration und installierte Web-Apps bleiben unverändert. Bei bereits vorhandenem Zielordner stoppt der Helfer, statt etwas zu überschreiben.

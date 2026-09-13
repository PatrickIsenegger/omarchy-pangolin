#!/usr/bin/env python3
"""One-time, backed-up migration from the legacy plugin ID to community.pangolin."""
import json
import os
from pathlib import Path
import shutil
import stat
import tempfile

OLD = 'patrick.pangolin'
NEW = 'community.pangolin'


def replace_id(value):
    if isinstance(value, dict):
        if OLD in value and NEW in value:
            raise ValueError('Both plugin IDs occur as settings keys; resolve this conflict first.')
        return {(NEW if key == OLD else key): replace_id(item) for key, item in value.items()}
    if isinstance(value, list):
        return [replace_id(item) for item in value]
    return NEW if value == OLD else value


def migrate(home):
    # Omarchy plugin commands use ~/.config directly; account settings use XDG separately.
    config = home / '.config/omarchy'
    old, new = (config / 'plugins' / name for name in (OLD, NEW))
    shell = config / 'shell.json'
    if not old.exists():
        if new.is_dir() and json.loads((new/'manifest.json').read_text())['id'] == NEW:
            print('Already migrated to ' + NEW)
            return
        raise ValueError('Legacy installation not found.')
    if new.exists():
        raise ValueError('Target installation already exists; refusing to overwrite it.')
    if old.is_symlink() or shell.is_symlink():
        raise ValueError('Symlinked installations or shell settings need a manual migration.')
    if json.loads((old/'manifest.json').read_text())['id'] != NEW:
        raise ValueError('Update the legacy checkout first: omarchy plugin update ' + OLD)
    raw = shell.read_text() if shell.exists() else None
    updated = replace_id(json.loads(raw)) if raw is not None else None
    if raw is not None and NEW in raw:
        raise ValueError('New ID already appears in shell settings; review for duplicate instances first.')
    backup_root = home / '.local/state/omarchy-pangolin/migrations'
    backup_root.mkdir(parents=True, exist_ok=True)
    backup = Path(tempfile.mkdtemp(prefix='plugin-id-', dir=backup_root))
    shutil.copytree(old, backup/OLD, symlinks=True)
    if raw is not None:
        shutil.copy2(shell, backup/'shell.json')
    staged = None
    try:
        if updated is not None:
            fd, name = tempfile.mkstemp(prefix='.pangolin-migration-', dir=config)
            staged = Path(name)
            with os.fdopen(fd, 'w') as stream:
                stream.write(json.dumps(updated, indent=2) + '\n')
                stream.flush()
                os.fsync(stream.fileno())
            staged.chmod(stat.S_IMODE(shell.stat().st_mode))
            if shell.read_text() != raw:
                raise ValueError('Shell settings changed during preparation; retry the migration.')
        old.rename(new)
        try:
            if staged is not None:
                staged.replace(shell)
        except BaseException:
            new.rename(old)
            raise
    finally:
        if staged is not None and staged.exists():
            staged.unlink()
    print('Migrated to ' + NEW + '. Backup: ' + str(backup))
    print('Run: omarchy restart shell')


if __name__ == '__main__':
    try:
        migrate(Path.home())
    except (ValueError, OSError, KeyError) as error:
        raise SystemExit(str(error))

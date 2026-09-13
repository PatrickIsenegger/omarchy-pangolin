import json
from pathlib import Path
import tempfile
import unittest
from tools.migrate_plugin_id import migrate, OLD, NEW


class MigrationTests(unittest.TestCase):
    def prepare(self, home):
        config = home / '.config/omarchy'
        old = config / 'plugins' / OLD
        old.mkdir(parents=True)
        (old/'manifest.json').write_text(json.dumps({'id': NEW}))
        shell = {'bar': {'layout': {'right': [{'id': 'other.widget'}, {'id': OLD, 'settings': {'demo': False}}]}}}
        (config/'shell.json').write_text(json.dumps(shell))
        return config, old, shell

    def test_preserves_order_settings_and_backup(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            config, old, original = self.prepare(home)
            migrate(home)
            updated = json.loads((config/'shell.json').read_text())
            self.assertEqual(updated['bar']['layout']['right'][1], {'id': NEW, 'settings': {'demo': False}})
            self.assertEqual(updated['bar']['layout']['right'][0], original['bar']['layout']['right'][0])
            self.assertFalse(old.exists())
            self.assertTrue((config/'plugins'/NEW/'manifest.json').exists())
            backup = next((home/'.local/state/omarchy-pangolin/migrations').iterdir())
            self.assertEqual(json.loads((backup/'shell.json').read_text()), original)
            self.assertTrue((backup/OLD/'manifest.json').exists())
            migrate(home)
            self.assertEqual(json.loads((config/'shell.json').read_text()), updated)

    def test_existing_target_is_never_overwritten(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            config, old, original = self.prepare(home)
            (config/'plugins'/NEW).mkdir()
            with self.assertRaises(ValueError):
                migrate(home)
            self.assertTrue(old.exists())
            self.assertEqual(json.loads((config/'shell.json').read_text()), original)

    def test_old_manifest_requires_update(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            config, old, original = self.prepare(home)
            (old/'manifest.json').write_text(json.dumps({'id': OLD}))
            with self.assertRaises(ValueError):
                migrate(home)
            self.assertTrue(old.exists())
            self.assertEqual(json.loads((config/'shell.json').read_text()), original)

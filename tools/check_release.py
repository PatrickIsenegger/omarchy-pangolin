#!/usr/bin/env python3
"""Checks publishable structure; private-infrastructure review is also manual."""
import json
from pathlib import Path
import re
import sys

root=Path(__file__).resolve().parents[1]
manifest=json.loads((root/'manifest.json').read_text())
assert manifest['schemaVersion']==1
version=manifest['version']
assert re.fullmatch(r'\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?',version)
assert 'Version.current' in (root/'Dashboard.qml').read_text()
assert ('var current = '+json.dumps(version)) in (root/'Version.js').read_text()
assert version in (root/'CHANGELOG.md').read_text()
assert version in (root/'assets/badges/release.svg').read_text()
for name in ['BarWidget.qml','Dashboard.qml','Mark.qml','Wash.qml','ResourceIcon.qml']:
    assert not re.search(r'#[0-9a-fA-F]{6}',(root/name).read_text()), 'Fixed production palette: '+name
for p in root.rglob('*.md'):
    for link in re.findall(r'\]\(([^)]+)\)',p.read_text()) + re.findall(r'(?:href|src)=[\"\']([^\"\']+)[\"\']',p.read_text()):
        if '://' in link or link.startswith('#'):
            continue
        assert (p.parent/link.split('#')[0]).exists(), 'Missing documentation link: '+str(p)+': '+link
for p in root.rglob('*'):
    if not p.is_file() or '.git' in p.parts or '__pycache__' in p.parts:
        continue
    if p.suffix not in ('.png',):
        text=p.read_text()
        assert not re.search('/' + r'home/[^/\s]+/',text), 'Absolute home path in '+str(p)
        assert not re.search(r'gh[pousr]_[A-Za-z0-9]{20,}',text), 'Potential token in '+str(p)
        assert '-----BEGIN ' + 'PRIVATE KEY-----' not in text, 'Potential key in '+str(p)
print('Release structure, links, version and theme checks passed.')

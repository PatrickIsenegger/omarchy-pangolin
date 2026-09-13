#!/usr/bin/env python3
"""Set the next version before a release; never modify already published tags."""
import json
from pathlib import Path
import re
import sys
root=Path(__file__).resolve().parents[1]
version=sys.argv[1] if len(sys.argv)==2 else ''
if not re.fullmatch(r'\d+\.\d+\.\d+',version):
    sys.exit('Usage: python tools/bump_version.py X.Y.Z')
p=root/'manifest.json';data=json.loads(p.read_text());data['version']=version;p.write_text(json.dumps(data,indent=2)+'\n')
(root/'Version.js').write_text('.pragma library\n// Generated from manifest.json by tools/bump_version.py.\nvar current = '+json.dumps(version)+'\n')
badge=root/'assets/badges/release.svg'
badge.parent.mkdir(parents=True,exist_ok=True)
width=62+len(version)*7+22
badge.write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="26" role="img" aria-label="release: {version}"><rect x=".5" y=".5" width="{width-1}" height="25" rx="7" fill="#f8f5ee" stroke="#d8cfc1"/><path d="M62 1v24" stroke="#d8cfc1"/><g font-family="Verdana, sans-serif" font-size="11" text-anchor="middle"><text x="31" y="17" fill="#655e55">release</text><text x="{62+(width-62)/2}" y="17" fill="#8b3a3a">{version}</text></g></svg>\n')
print('Manifest, UI version and badge updated. Update changelog and preview assets before tagging.')

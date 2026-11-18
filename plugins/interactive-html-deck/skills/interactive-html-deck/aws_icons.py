"""Print `const ICONS = {...};` with the official AWS Architecture Icons inlined as data URIs.

Get the current package first: open https://aws.amazon.com/architecture/icons/ , download the
"Icon package" zip (released end of January, April and July), unzip it into a new empty folder.
usage: python3 -I aws_icons.py <unzipped package dir> key=relative/path.svg [key=path.svg ...]
       paths are relative to the package root, e.g.
       bedrock=Architecture-Service-Icons_07312026/Arch_Artificial-Intelligence/48/Arch_Amazon-Bedrock_48.svg
Service icons: Architecture-Service-Icons_*/Arch_<Category>/48/Arch_<Service>_48.svg
Resource icons: Resource-Icons_*/Res_<Category>/Res_<Resource>_48.svg (general ones in Res_General-Icons/Res_48_Light)
Group icons (AWS Cloud, Region, Account): Architecture-Group-Icons_*/<Name>_32.svg
"""
import base64, json, sys
from pathlib import Path

root = Path(sys.argv[1])
icons = {}
for arg in sys.argv[2:]:
    key, rel = arg.split("=", 1)
    icons[key] = "data:image/svg+xml;base64," + base64.b64encode((root / rel).read_bytes()).decode()
print("const ICONS = " + json.dumps(icons) + ";")

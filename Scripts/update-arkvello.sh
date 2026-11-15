#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPOSITORY="IzusX/arkvello"
# With no published release, gh exits nonzero and the workflow reports that fact.
TAG="$(gh release view --repo "$REPOSITORY" --json tagName --jq .tagName)"
VERSION="${TAG#v}"
[[ "$TAG" == v* && "$VERSION" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]] || {
  echo "Expected a stable vMAJOR.MINOR.PATCH release, got: $TAG" >&2
  exit 1
}
ASSETS="$(mktemp -d "${TMPDIR:-/tmp}/arkvello-tap.XXXXXX")"
trap 'rm -rf "$ASSETS"' EXIT
gh release download "$TAG" --repo "$REPOSITORY" --dir "$ASSETS" \
  --pattern "Arkvello-$VERSION-universal.dmg" \
  --pattern "Arkvello-$VERSION-source.tar.gz" \
  --pattern arkvello.rb --pattern SHA256SUMS

# Check every asset and reject unexpected manifest entries before publishing Ruby.
python3 - "$ASSETS" "$VERSION" "$ROOT_DIR/Casks/arkvello.rb" <<'PY'
import hashlib
import pathlib
import re
import sys

assets, version, destination = pathlib.Path(sys.argv[1]), sys.argv[2], pathlib.Path(sys.argv[3])
expected = {f'Arkvello-{version}-universal.dmg', f'Arkvello-{version}-source.tar.gz', 'arkvello.rb'}
checksums = {}
for line in (assets / 'SHA256SUMS').read_text().splitlines():
    digest, name = line.split(maxsplit=1)
    name = name.removeprefix('*')
    if name not in expected or name in checksums or not re.fullmatch(r'[0-9a-f]{64}', digest):
        raise SystemExit('Invalid checksum manifest')
    checksums[name] = digest
if set(checksums) != expected:
    raise SystemExit('Incomplete checksum manifest')
for name, digest in checksums.items():
    if hashlib.sha256((assets / name).read_bytes()).hexdigest() != digest:
        raise SystemExit(f'Checksum mismatch: {name}')
cask = (assets / 'arkvello.rb').read_text()
if f'  version "{version}"' not in cask or 'cask "arkvello" do' not in cask:
    raise SystemExit('Unexpected cask identity or version')
if f'  sha256 "{checksums[f"Arkvello-{version}-universal.dmg"]}"' not in cask:
    raise SystemExit('Cask checksum does not match the DMG')
if 'https://github.com/IzusX/arkvello/releases/download/v#{version}/Arkvello-#{version}-universal.dmg' not in cask:
    raise SystemExit('Unexpected cask download URL')
if destination.exists():
    old = re.search(r'^  version "([0-9.]+)"$', destination.read_text(), re.MULTILINE)
    if old and tuple(map(int, old[1].split('.'))) > tuple(map(int, version.split('.'))):
        raise SystemExit('Refusing to downgrade the cask')
destination.parent.mkdir(parents=True, exist_ok=True)
destination.write_text(cask)
print(f'Prepared Arkvello {version}; all release checksums verified.')
PY

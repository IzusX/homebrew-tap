# IzusX Homebrew tap

**English** | [Русский](README.ru.md)

Homebrew packages maintained by [IzusX](https://github.com/IzusX).
This repository can contain multiple applications (`Casks/`) and command-line
tools (`Formula/`). Application sources and binaries live in their own projects.

## Arkvello

[Arkvello](https://github.com/IzusX/arkvello) is an independent native macOS
archive manager powered by 7-Zip. Requires macOS 14 or later, Apple Silicon or Intel.

```bash
brew install --cask IzusX/tap/arkvello
```

Update or uninstall:

```bash
brew update
brew upgrade --cask IzusX/tap/arkvello
brew uninstall --cask IzusX/tap/arkvello
```

The app is ad-hoc signed, without Developer ID or Apple notarization. macOS may
block launch. If you trust the release, try opening it once and follow Apple's
[Open Anyway instructions](https://support.apple.com/en-us/102445).
Neither this tap nor the application disables Gatekeeper or removes quarantine.
Quick Look extension activation is subject to macOS policy.

## Maintenance

`Update Arkvello` checks the latest published stable
[Arkvello release](https://github.com/IzusX/arkvello/releases) daily and can also
be run from the Actions tab. It downloads the release assets, verifies their
SHA-256 checksums, audits the generated cask and commits `Casks/arkvello.rb` if
it changed. The workflow uses this repository's built-in `GITHUB_TOKEN`; no
personal access token or cross-repository write access is required.

Casks are generated from published releases. The update workflow must complete
before a new release is available through Homebrew.

Pushes and pull requests run cask style and audit checks. The update workflow
runs the same checks before committing, because commits made with `GITHUB_TOKEN`
do not trigger another push workflow.

To update locally, install `gh`, Homebrew and Python 3, then run:

```bash
bash Scripts/update-arkvello.sh
brew style Casks/arkvello.rb
# Inside a locally tapped copy:
brew audit --cask IzusX/tap/arkvello
```

Tap packaging is MIT-licensed; the packaged applications keep their own licenses.
Arkvello includes LGPL/BSD/unRAR components; see its third-party notices.

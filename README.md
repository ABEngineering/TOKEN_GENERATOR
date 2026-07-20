# TOKEN_API Generator

Desktop app (Electron) that generates a `TOKEN_API` and matching passwords by
combining a **project name** with an **email address**.
Creator: **Amaro Balsamo**.

## How TOKEN_API and API_Password are generated

1. Project name and email are normalized (uppercase, letters/digits only).
2. Every letter is converted to a number (`A=01 ... Z=26`); digits are kept as-is.
3. The two numeric sequences are joined with a separator (`99`) to form a "seed".
4. The seed is expanded into a deterministic byte stream by chaining **SHA-256**
   digests.

- **TOKEN_API** (field 02): 89 characters, letters (upper/lower) and digits only
  (Base62), no fixed prefix.
- **API_Password** (field 03): three fields of 12, 20 and 32 characters, each
  guaranteed to contain uppercase, lowercase, digits and a heavy proportion of
  special characters, derived from the same seed.

The same project name + email always produces the same token and the same
passwords (deterministic, reproducible).

## Development

```bash
npm install
npm start
```

## Building the Windows installer

```bash
npm run dist
```

Produces `dist/TOKEN_API Generator Setup <version>.exe` (NSIS installer, with a
choice of install directory and a page with a checkbox to create — or skip —
the Desktop shortcut, see `build/installer.nsh`), plus `dist/latest.yml` (the
update feed).

## Application menu

- **File → Exit**: closes the application.
- **Info → Check for Updates**: opens the About window and checks whether a new
  version is available (only works in the installed app, not with `npm start`).
- **Info → Project Info**: opens the About window with version and creator.

The About window (`renderer/about.html`) is styled to match the main app
(night-sky theme, glass panel, pill button) instead of using plain OS dialogs.

## How updates work

The app uses [`electron-updater`](https://www.electron.build/auto-update), wired
up in `main.js`. `package.json` → `build.publish` points it at the project's
GitHub repository:

```json
"publish": [{ "provider": "github", "owner": "ABEngineering", "repo": "TOKEN_GENERATOR" }]
```

Users with the app installed, clicking **Info → Check for Updates**, will
automatically find and download any new GitHub Release, then can restart from
the About window to install it. See "Releasing a new version" below for how a
release actually gets published.

## GitHub repository

This project is connected to
[github.com/ABEngineering/TOKEN_GENERATOR](https://github.com/ABEngineering/TOKEN_GENERATOR.git)
as the `origin` remote. The repository intentionally tracks only the release
artifacts, not the application source:

- `dist/` — the NSIS installer (`.exe`), its `.blockmap`, and `latest.yml`
  (everything else in `dist/`, like the uncompressed `win-unpacked/` folder, is
  ignored)
- `build/` — the custom NSIS install script
- `README.md`

This is enforced by `.gitignore` (ignores everything else) and `.gitattributes`
routes the `.exe`/`.blockmap` through **Git LFS** (`git lfs install --local` has
already been run in this repo) so the binary installer doesn't bloat the normal
git history on every release.

## Releasing a new version

```bash
set GH_TOKEN=your_github_token_with_repo_scope
npm run release            # defaults to a patch bump
npm run release -- minor   # or: minor / major
```

`scripts/release.js` does the full flow:

1. Bumps the version in `package.json` (`version.js` re-exports it, so the app,
   installer and About window all stay in sync automatically).
2. Runs `npm run dist -- --publish always`, which builds the installer **and**
   uploads it (plus `latest.yml`) as a GitHub Release asset for
   `ABEngineering/TOKEN_GENERATOR`, using `GH_TOKEN` for authentication.
3. Commits the refreshed `dist/` + `build/` + `README.md` and tags the commit
   (`vX.Y.Z`) locally.

The script does **not** push automatically — review the commit, then run:

```bash
git push origin main --tags
```

## Project structure

```
main.js                 main Electron process (menus, windows, auto-update, IPC)
version.js               single source of truth for the app version (reads package.json)
preload.js               secure bridge for the main window (clipboard, app info)
about-preload.js          secure bridge for the About window (version, update IPC)
renderer/index.html       main window UI
renderer/about.html       About window UI
renderer/theme.css        shared night-sky theme variables and components (incl. animated logo)
renderer/style.css        main window layout styles
renderer/about.css        About window layout styles
renderer/app.js           token/password generation logic and clipboard copy
renderer/about.js         About window logic (version display, update status)
assets/icon.ico           application/installer icon (multi-resolution)
scripts/build-icon.js     regenerates assets/icon.ico from the PNG frames in assets/
scripts/release.js        version bump + build + publish to GitHub Releases
build/installer.nsh       custom NSIS script (Desktop shortcut checkbox)
```

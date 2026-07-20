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

The app uses [`electron-updater`](https://www.electron.build/auto-update). The
mechanism is already wired up (`main.js`), but to be actually usable you need to
publish releases somewhere reachable by users. `package.json` → `build.publish`
is configured with a `generic` provider pointing at a placeholder URL:

```json
"publish": [{ "provider": "generic", "url": "https://updates.example.com/token-api-generator/" }]
```

To publish an update:

1. Bump the version in `package.json` (e.g. `1.0.0` → `1.1.0`).
2. Run `npm run dist`: creates the installer + `latest.yml` in `dist/`.
3. Upload **both** files (the `.exe` and `latest.yml`) to the URL configured in
   `build.publish.url` (any static hosting/S3/web server works), or replace the
   `generic` provider with `github` to distribute via GitHub Releases (see the
   electron-builder docs).
4. Users with the app installed, clicking **Info → Check for Updates**, will
   automatically find and download the new version, then can restart from the
   About window to install it.

## Project structure

```
main.js                main Electron process (menus, windows, auto-update, IPC)
preload.js              secure bridge for the main window (clipboard, app info)
about-preload.js         secure bridge for the About window (version, update IPC)
renderer/index.html      main window UI
renderer/about.html      About window UI
renderer/theme.css       shared night-sky theme variables and components
renderer/style.css       main window layout styles
renderer/about.css       About window layout styles
renderer/app.js          token/password generation logic and clipboard copy
renderer/about.js        About window logic (version display, update status)
assets/icon.ico          application/installer icon (multi-resolution)
scripts/build-icon.js    regenerates assets/icon.ico from the PNG frames in assets/
build/installer.nsh      custom NSIS script (Desktop shortcut checkbox)
```

# TOKEN_API Generator

Desktop app (Electron) that generates a `TOKEN_API` and matching passwords by
combining a **project name** with an **email address**, and doubles as a
manager for your saved tokens and AI prompts.

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

The app opens maximized (filling the screen) on every launch.

## Quick-access toolbar

Four 3D buttons sit next to the File/Info menu, always one click away:

- **Open Token** / **Open Prompt** (folder icons, amber / emerald) — same as
  File → Open Tokens / Open Prompt.
- **Save Token** / **Save Prompt** (disk icons, cyan / violet) — same as
  File → Save Tokens / Save Prompt.

## Tokens manager

The **Tokens** page (left sidebar) keeps a list of freeform token entries
(name + code, both multi-line) grouped into projects, shown as tabs at the
top so several projects can stay open at once. Projects are kept
automatically between app restarts. Use **File → Open Tokens / Save Tokens /
Save Tokens As...** to import or export a project as a `.json` file. Closing
a project with unsaved changes asks you to save it first.

## Prompt library

The **Prompt** page keeps a library of AI prompts, grouped into tabs the same
way the Tokens page does, auto-saved between restarts and exportable to a
`.json` file via **File → Open Prompt / Save Prompt / Save Prompt As...**.
Each prompt has five numbered sections:

1. **Prompt Title** — up to 200 characters, with a status picker next to it
   (**Not Used** / **Under review** / **Approved**, each with its own icon
   and color).
2. **Author Prompt** — up to 200 characters.
3. **Prompt - Application Scenario** — the situation or use case the prompt
   is meant for.
4. **Prompt Description** — the full prompt text sent to the AI model, with
   a **Copy** button to grab the whole thing in one click.
5. **Files** — attach reference PDFs, images, Word or Excel files (bigger 3D
   "+" button, easy to spot).
An "i" info button next to each section title opens a short popup explaining
what that field is for.

## Language and visual theme

**Info → Language** opens a picker for 8 languages (English, Italiano,
Deutsch, Français, Español, Polski, Română, Čeština). Every piece of UI text
across the app - main window, About and Software Update popups, and native
file dialogs - switches instantly and the choice is remembered between
restarts. Text you typed yourself (project names, token codes, prompt
content) is never translated.

**Info → Style** opens a picker for 7 visual themes - **Cyan** (default),
**Dark**, **Dev**, **Spring**, **Autumn**, **Summer**, **Winter**. Dark is the
only theme with a black background; the others are light themes with their
own accent color. The chosen theme applies to every window and is remembered
between restarts.

## Download ##############################################################################
To download proceed to the link: 
https://github.com/ABEngineering/TOKEN_GENERATOR/releases

Download the file:
TOKEN_API Generator Setup x.x.x.exe

Creator: **Amaro Balsamo**.

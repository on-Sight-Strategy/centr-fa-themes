# CLAUDE.md

Guidance for agents working in this repo.

## What this repo is

This repo manages Centr's FusionAuth "advanced theme" — FreeMarker (`.ftl`)
templates, a localized message bundle, and a stylesheet for FusionAuth's
hosted login/account UI. Files are synced to/from a live FusionAuth tenant
using the `@fusionauth/cli`.

- See `README.md` for the human workflow (download / watch / upload / diff).
- See FusionAuth's [Advanced Themes docs](https://fusionauth.io/docs/customize/look-and-feel/advanced-themes/)
  for the platform-level template model, helper functions, and localization.
- See `CONTEXT.md` for Centr-specific business logic baked into these
  templates and open questions about them. Read it before touching
  `tmp/helpers.ftl` or anything related to localization, redirects, or
  analytics.

## Sync model & hard guardrails

The scripts in this repo talk to a **live FusionAuth tenant**
(`centr-dev.fusionauth.io`, theme id from `.env`). Treat this like a
production-adjacent system, not a local build.

- `download.sh` — pulls the current theme from FusionAuth into `tmp/`.
  Read-only, safe.
- `upload.sh` — pushes the contents of `tmp/` to the live tenant, overwriting
  whatever is currently deployed.
- `watch.sh` — watches `tmp/` and pushes every saved change to the live
  tenant immediately, in real time.
- `diff-themes.sh` — compares two already-downloaded theme snapshots (e.g.
  current vs. new base theme during a FusionAuth upgrade). Operates on local
  files only, safe.

**Agents must never run `upload.sh` or `watch.sh`.** These immediately change
the live login/account/registration UI for real users on that tenant. Editing
files in `tmp/` is fine; pushing those edits live is a decision only a human
should make, after reviewing a diff.

`.env` contains a live FusionAuth API key. Never print, log, commit, or
otherwise expose its contents.

## Repo layout

- `tmp/` — the theme content itself:
  - One `.ftl` per themed page: login/OAuth flows (`oauth2Authorize.ftl`,
    `oauth2Register.ftl`, `oauth2TwoFactor*.ftl`, etc.), account management
    (`accountEdit.ftl`, `accountTwoFactor*.ftl`, `accountWebAuthn*.ftl`),
    password/email/phone flows (`passwordChange.ftl`, `emailVerify.ftl`,
    `phoneVerify.ftl`, etc.).
  - `helpers.ftl` — shared macros/functions used by every page (~1,840
    lines): page chrome (`head`, `body`, `header`, `footer`), form input
    macros, identity-provider login buttons, analytics, and Centr-specific
    business logic. Page templates are thin and mostly call into this file.
  - `defaultMessages.txt` — default localization keys/strings.
  - `stylesheet.css` — theme CSS.
- Root scripts: `download.sh`, `upload.sh`, `watch.sh`, `diff-themes.sh`.
- `.env` / `.env.sample` — FusionAuth API key, theme id, host, tmp dir.

## FreeMarker basics for this repo

Templates are [Apache FreeMarker](https://freemarker.apache.org/). Common
constructs you'll see throughout `tmp/`:

- Directives: `[#if]...[#elseif]...[#else]...[/#if]`, `[#list ... as x]`,
  `[#assign x = ...]` (global-ish), `[#local x = ...]` (scoped to current
  macro/function), `[#macro name ...][/#macro]`, `[#function name ...]` with
  `[#return ...]`.
- Output: `${expr}` for interpolation; `[#-- comment --]` for comments.
- Theme/localization API (provided by FusionAuth):
  - `${theme.message('key')}` — localized string, errors if key missing.
  - `${theme.optionalMessage('key')}` — falls back to the key name if
    missing.
  - `${theme.stylesheet()}` — emits the theme's CSS.
- Context objects available in templates: `theme`, `tenant` (and
  `tenant.data` for tenant-configured custom fields), `application`,
  `client_id`, `locale`, `request`, and the `fusionAuth.*` namespace (e.g.
  `fusionAuth.currentLocation()`, `fusionAuth.locales()`).
- Most shared UI is implemented as macros in `helpers.ftl` (e.g. `input`,
  `button`, `alternativeLogins`, `header`, `footer`) and invoked from the
  per-page templates — when changing shared UI, check all callers in `tmp/`.

# CONTEXT.md

A living log of Centr-specific decisions and customizations baked into the
FusionAuth theme in `tmp/`. Update this when you discover a new
Centr-specific convention, or when an open question below gets resolved.

## Documented customizations

### Rebrand history: "VDB" baseline vs. current rebrand

The theme on `dev/os-theme` started as a near-duplicate of a *previous*
Centr rebrand ("VDB"): `vdb-*` CSS classes, `Degular`/`SuisseIntl` fonts,
full-bleed cover-image + light card auth layout, Electric Yellow
`#f1ef17`, Charcoal Darkest `#050404`.

The *current* rebrand (Figma file `0XUySxg4fyNvrRqUp4wZs3`) replaces the
auth card's visual language: Electric Yellow `#FFFF33`, Charcoal Darkest
`#1A1818`, new Sand/Charcoal-Light tokens, and a shared `authCard` macro
(`tmp/helpers.ftl`) with `mode="split"` (Sign-in/Create Account, two-column
with marketing copy + tab switcher) and `mode="single"` (Reset Password,
Account Confirmation, and other simple form pages going forward). The
`vdb-*` classes are kept in `styles/input.css` for pages not yet migrated
to `authCard` — don't remove them until all pages are migrated.

CSS is now built from `styles/input.css` (Tailwind v4 + daisyUI v5) via
`npm run build:css`, which compiles to `tmp/stylesheet.css`. Don't
hand-edit `tmp/stylesheet.css` directly — edit `styles/input.css` and
rebuild.

### Suisse Int'l Mono font not yet loaded

`styles/input.css` — `.authcard-eyebrow` (the small uppercase label above
the auth card heading, e.g. "YOUR ACCOUNT") is specified in Figma as
"Suisse Int'l Mono", but only the regular "Suisse Int'l" (`SuisseIntl`)
family is currently loaded via `@font-face`. `.authcard-eyebrow` currently
falls back to `SuisseIntl`. The user mentioned Suisse Int'l Mono font files
are hosted on Shopify and would be provided — once available, add
`@font-face` declarations for it in `styles/input.css` and update
`.authcard-eyebrow`'s `font-family`.

### "Contact support" link on Reset Password

`tmp/passwordForgot.ftl` — Figma shows a "CONTACT SUPPORT" link below the
reset-password form. No dedicated support URL/message-key infrastructure
existed in this repo. Added a new message key
`forgot-password-contact-support` and pointed the link at
`${helpers.frontendUrl('/help')}` (i.e. `https://staging.centr.com/help`,
see the `baseFrontendUrl` open question below) as a placeholder. Confirm
with the team whether `/help` is the correct destination for Centr support.

### Country-based marketing opt-in

`tmp/helpers.ftl` L33-71 — `getCountryCode()` and `requiresOptInCheckbox()`.

Based on `fusionAuth.currentLocation()`, users in the UK, EU member states,
Canada, and Australia are shown an explicit opt-in checkbox for marketing
communications. Users everywhere else (including the US) get auto opt-in
with informational copy instead, no checkbox. This is intentional
region-specific compliance logic — don't simplify or remove it without
checking with the team.

### `tenant.data.baseCentrURL`

`tmp/helpers.ftl` L29.

On `password/forgot` requests, `redirect_uri` is overridden to
`${tenant.data.baseCentrURL}/auth/login`. `tenant.data` is FusionAuth's
free-form custom tenant configuration — `baseCentrURL` is a custom field set
per-tenant in FusionAuth (not part of the standard theme template variables).

### Identity providers in `alternativeLogins`

`tmp/helpers.ftl` L893-1107.

The login UI supports a broad set of identity providers, including several
gaming platforms: Apple, Facebook, Google, LinkedIn, OpenID Connect, SAMLv2,
Sony PSN, Steam, Twitch, Twitter, Xbox, and Nintendo. This breadth is
intentional for Centr's audience.

## Open questions

### `baseFrontendUrl` hardcoded to staging

`tmp/helpers.ftl` L1796 — `[#assign baseFrontendUrl = "https://staging.centr.com" /]`,
used by `frontendUrl()` / `frontendUrlEncoded()` to build links back to the
Centr web app.

This is a single hardcoded URL with no per-environment variant. Confirm with
the team: is this acceptable while this theme/repo only targets the
`centr-dev` (staging) tenant, or does it need to vary per FusionAuth
tenant/environment (e.g. before this theme is used against a production
tenant)?

### Hardcoded analytics/environment IDs with a "replaced by build script" comment

`tmp/helpers.ftl` L203-210, inside the `analytics` macro:

```
[#-- Environment and analytics ID assignment (replaced by build script) --]
[#assign environmentName = "staging" /]
[#assign gtmID = "GTM-NVLCPZ4M" /]
[#assign amplitudeApiKey = "be5804bb69c741f7b2f16c2c182b83a8" /]
[#assign datadogClientToken = "pub6ef5addfab3afb8d8b2c88dd7f163f5c" /]
[#assign datadogSite = "us5.datadoghq.com" /]
[#assign datadogService = "fusionauth" /]
```

The comment implies a build/templating step previously substituted these
per-environment, but **no such build script exists in this repo** — these
values are static. Confirm with the team: was there a prior pipeline that
templated these, and should an equivalent be added here, or are these meant
to stay static for the dev/staging tenant this repo currently targets?

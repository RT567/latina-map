# latina-map — "Latino Sydney — El Mapa" (made for Jackson)

Live (GitHub Pages): https://rt567.github.io/latina-map/ (root redirects to `site/`) ·  Live (Cloudflare Pages, original target): https://latino-sydney.pages.dev
Repo: github.com/RT567/latina-map (branch `master`). Local: `~/silly/latina-map`.

## The idea

A silly-but-real bilingual (EN/ES) Leaflet map of Latin Sydney: venues, salsa nights, census-powered crowds of little dancing characters, beaches, an "empanada radar", and "Radio Latina" (a Spotify playlist). Built for a friend (Jackson). Tone: jokes allowed, data real.

## Timeline

| date | event |
|---|---|
| 2026-09-01 | Built in one day, deployed to **Cloudflare Pages** via `deploy.sh` (wrangler; project `latino-sydney`). Not in git yet. |
| 2026-09-02 | Owner: "put latina map onto my github fuck it". `git init`, `.gitignore` (`.wrangler/`, `node_modules/`), root `index.html` that meta-refreshes to `site/` (GitHub Pages can only serve `/` or `/docs`, and the site lives in `site/`), pushed as public repo, Pages enabled on `master`. Linked from the landing page as "latina-map (made for jackson)". |
| 2026-09-02 | Owner: "music should be automatically playing". Radio panel changed to open on load and start the Spotify embed immediately, with a play attempt via the Spotify iFrame API and a retry on first user gesture (browsers block autoplay audio before any interaction; without a Spotify login the embed plays 30 s previews). What landed (commit "radio autoplays on load"): `#radio` gets `.open` on load; `#radio-frame` is now a placeholder `<div>` that the Spotify iFrame API (`https://open.spotify.com/embed/iframe-api/v1`, loaded dynamically) replaces with the player via `createController`; `play()` is called on ready and again on the first `pointerdown`/`keydown`; if the API script fails to load, a plain embed `<iframe>` is inserted instead. The bar click still toggles the panel. Verified locally: panel open, 152px player iframe present, controller created, no console errors. Whether audio actually starts before a click is up to the browser. |

## Layout

```
index.html        <- redirect to site/ (GitHub Pages only)
deploy.sh         <- Cloudflare Pages deploy (npx wrangler pages deploy site --project-name latino-sydney)
README.md         <- data sources + run instructions
site/index.html   <- the whole app (~600 lines: CSS, markup, I18N table, Leaflet setup, layers, radio)
site/data.js      <- OSM venues via Overpass (ODbL)
site/curated.js   <- hand-curated venues/events (dance calendars, empanada shops, Spanish masses, consulates); suburb-level pins
site/census.json  <- ABS Census 2021 G13 (Spanish/Portuguese at home) + G09 (born Brazil/Chile) at SAL level, clipped to Sydney, simplified (CC BY 4.0)
site/densitydata.js <- crowd density per suburb for the dancer sprites
```

Data fact the map shows: two waves — 1970s–80s Spanish-speaking heartland Fairfield–Liverpool, and the 2010s+ Brazilian/student wave Bondi–Maroubra–Dee Why.

## Working on it

- Local: `python3 -m http.server 8742 --directory site` → http://localhost:8742
- Deploy to GitHub Pages: `git push` (≈1 min). Deploy to Cloudflare: `./deploy.sh` (first run needs `wrangler login`). Both serve the same `site/`.
- External deps: Leaflet 1.9.4 from cdnjs, Spotify embed / iFrame API from open.spotify.com. No build.
- `#radio` is a fixed panel bottom-left; `.bar` toggles `.open`; the Spotify player sits in `.body`.
- i18n: every translatable element has `data-i18n="key"`; strings live in the `I18N` object (`en`/`es`); `#lang-toggle` switches.

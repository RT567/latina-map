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
| 2026-09-02 | Owner: "music should be automatically playing". First pass: Spotify embed opened on load with the Spotify iFrame API calling `play()` (commit "radio autoplays on load"). |
| 2026-09-02 | Owner, minutes later: music should be "classic old school latina music… not salsa, like kinda meme music with brasil beat or latino beat", and "free source if possible so it doesn't skip or get Spotify ads". Spotify dropped entirely. Radio panel now plays **free internet-radio streams** via a plain `<audio>`: stations found through the radio-browser.info API (`https://de1.api.radio-browser.info/json/stations/search?tag=…&order=votes&hidebroken=true`), HTTPS-only, each probed with curl and then played in Chrome. Default is **Radio Cumbia 90s (Bolivia)**; ⏭ cycles through Rádio MGT Brasil Hits, MGT Brega e Retrô, Top Merengue Radio, Colombia Crossover, Jovem Pan FM Floripa. A dead stream auto-advances. Commit "radio: free latin/brasil internet radio, no spotify". |

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
- `#radio` is a fixed panel bottom-left; `.bar` toggles `.open`; `.body` holds `<audio id="radio-audio">`, the station name (`#radio-now`) and ⏯ / ⏭ buttons. JS block starts at the comment `// radio: free internet-radio streams`. Identifiers are all `radio`-prefixed (`RADIO_STATIONS`, `radioTune`, …) because the page already has a `STATIONS` (train stations) — a bare `STATIONS` redeclaration broke the whole script once.
- Adding/replacing a station: query radio-browser (see timeline), keep only `https://` `url_resolved`, curl it (`-r 0-4000`, expect 200 + `audio/*` content-type), then add `{name,url}` to `RADIO_STATIONS`. Streams die over time; re-probe if the panel keeps skipping.
- Autoplay: browsers block audio before a user gesture; the code tries on load and retries on the first pointerdown/keydown. The eq bars animate only while `#radio.playing`.
- i18n: every translatable element has `data-i18n="key"`; strings live in the `I18N` object (`en`/`es`); `#lang-toggle` switches.

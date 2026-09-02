# Latino Sydney — El Mapa 🌎💃

A silly-but-real bilingual (EN/ES) map of Latin Sydney: venues, salsa nights,
census-powered crowds of little dancing characters, beaches, an empanada radar,
and Radio Latina.

## Run locally

```
python3 -m http.server 8742 --directory site
# → http://localhost:8742
```

## Deploy (Cloudflare Pages)

```
./deploy.sh
```

First time: it runs `wrangler login` — click **Allow** in the browser, then it
creates the `latino-sydney` Pages project and uploads `site/`.
Live URL: `https://latino-sydney.pages.dev`

## Data sources (all real)

- **Venues** — OpenStreetMap via Overpass API (`site/data.js`), © OSM contributors, ODbL.
- **Curated venues/events** — latindancecalendar.com, sydneysalsaclasses.com.au,
  Concrete Playground, Argentum Empanadas' grocery map, Archdiocese of Sydney
  Spanish-mass directory, consulate listings (`site/curated.js`). Pin locations
  are suburb-level approximations.
- **Census heat + crowd density** — ABS Census 2021, table G13 (language used at
  home: Spanish & Portuguese) + G09 (born in Brazil/Chile) at SAL (suburb) level,
  joined to ASGS Ed.3 SAL boundaries, clipped to Sydney, simplified
  (`site/census.json`, `site/densitydata.js`). © ABS, CC BY 4.0.

Fun fact the data actually shows: two waves — the 1970s–80s Spanish-speaking
heartland in Fairfield–Liverpool, and the 2010s+ Brazilian/student wave along
Bondi–Maroubra–Dee Why.

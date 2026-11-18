---
name: interactive-html-deck
description: Use when asked for an interactive presentation, a deck, slides, a talk, a briefing for management or a vendor, a video backdrop, or an "explain it in simple words" piece built as one HTML file, especially one that has to show a process moving (pods between nodes, requests through services, data through a pipeline, search results merging) or has to be read alone without a presenter.
---

# Interactive HTML deck

## Overview
A deck here is a fixed 16:9 stage (1280x720, scaled to the window) with step builds and diagrams that move. It is not a scrolling page with cards, buttons and forms: audiences read that as a web page, not a presentation. The result is one self-contained HTML file with no build step.

Files next to this one:
- `template.html`: the stage, the controls and the Sim engine for "objects in boxes" (pods on nodes, jobs on workers).
- `example.html`: a 5-slide deck with the other engines (Graph, MeaningMap, Lists, bars) and notes open by default. Copy its `<style>` and the engine part of its `<script>`; replace the slides and the `R` renderers.
- `aws_icons.py`: builds `const ICONS = {...}` from the official AWS Architecture Icons package, for Graph nodes.
- `check_deck.sh`: screenshots the last step of every slide with headless Chrome and prints each step counter.

## Before building
Ask, or restate and confirm, these things:
- who the audience is (developers, team lead, management, a vendor, video viewers);
- the one goal of the deck, and what the audience should do after it;
- whether it is presented live, recorded, or **read alone**;
- the language;
- how much internal detail it may show (hostnames, account ids, ticket keys), and whether it will be shared by link.

Developer audience: 7-9 slides told from the developer's daily actions, no operations jargon, no inventories (those go in a separate document).

A deck grows with follow-up requests, so check that each addition still belongs in it.

**Read alone:** open the notes panel by default (`<body class="shownotes">`). The narration strip carries each step's message in full sentences, and the notes hold sources, dates and caveats. The first slide's notes say how to read the deck.

## Slide recipe
Each slide has these parts, in this order:
1. **eyebrow**: the section and its position, e.g. "Problem · 2 of 3 · onboarding".
2. **h2**: one message, at most 2 lines at 30px. A longer one runs into the scenario line.
3. **Scenario box (`.uc`)**: one line under the title, always visible. It says what is happening.
4. **Stage**: an animated diagram or one picture. Never a bullet list.
5. **Narration strip (`.narr`)**: the step label on the left, 1-2 sentences on the right. It changes with every step.
6. **`<aside>`**: notes, shown with N. Detail and sources live here, not on the slide.

`data-steps="N"` on the section. Each slide id has a renderer `R[id](k)` that draws state k from scratch, so both ← and → work. Never draw state incrementally.

Layout that fits:

| part | position |
|---|---|
| h2 | 30px, slide padding 44px |
| `.uc` | top 154px |
| stage | top 210px, 1152 x 340 |
| `.narr` | top 562px |

## Story order
- **Problem decks:**
  1. The problem, on a live example from real data.
  2. Why it happens, including "why the system doesn't handle it itself".
  3. A terms slide on that same example.
  4. The solution, a one-slide checklist, and how it gets verified.
- **"Explain in simple words" decks:**
  1. How it was, with one real example.
  2. How often that hurt, as a number.
  3. The idea, as a picture.
  4. What was built.
  5. The problem found on the way.
  6. The result before and after.
  7. "Thanks to what" as 3-4 cards.

## Engines
| Engine | Use for | State per step |
|---|---|---|
| Sim (`template.html`) | objects moving between boxes | `[[box, label, cls, ['item:st<from']]]` |
| Graph (`example.html`) | architecture, flows, timelines | `{on, hi, ok, bad, warn, dim, e, f, fb}`; nodes `[x,y,w,h,title,sub,cls,iconKey]` |
| MeaningMap (`example.html`) | "points close by meaning" (embeddings, clusters) | `{on, cls, at: {id:[x,y]}, lines: [[a,b,cls]]}` |
| Lists (`example.html`) | rankings merging, items moving between columns | `{id: [col, row, cls]}` |
| bars | before/after numbers | grow `width` on entry, reset on leave |

Sim rules:
- Positions are states. A step says where every object is, and CSS transitions on `transform` move them (0.6-0.7 s, `cubic-bezier(.3,.7,.2,1)`).
- A new object flies in from its source with `name<from`.
- Use states, not decoration: starting, terminating, pending, blocked, each with its own colour and a short label.

Graph rules:
- `e` draws an edge, `f` puts moving packets on it, `fb` makes them red.
- An edge `'a>b~v'` or `'a>b~h'` forces the route. Without it the route is horizontal only when the boxes do not overlap in x. Force it when a curve would cross a box.
- A point label that collides with a neighbour in MeaningMap: give it label side `'r'`, or move the point.

## Cloud icons
For AWS diagrams, use the official AWS Architecture Icons, not hand-drawn shapes.
1. Download the current "Icon package" zip from aws.amazon.com/architecture/icons into its own empty folder and unzip it.
2. Build the icon map: `python3 -I aws_icons.py <pkg> lambda=Architecture-Service-Icons_*/Arch_Compute/48/Arch_AWS-Lambda_48.svg ...`
3. Replace `const ICONS = {}` with the output. A Graph node takes the key as its 8th field.
4. Group boxes (AWS Cloud, Region, Account) are `.grp` divs with the group icon, coloured as in the package: Cloud `#232F3E` solid, Region `#00A4A6` dashed, Account `#E7157B` solid.

Keep the icon package out of any repository you publish; generate the map per deck.

## Numbers
- **Source:** every figure comes from a live read, an export, or a run made for this deck, and the notes name the source and date. An estimate is labelled "estimate" on the slide.
- **Prices:** come from the provider's price list or pricing API for the exact region and usage type, never from memory. Remembered prices are often off by an order of magnitude.
- **State changes** (a pilot goes live, a change ships, a number is re-measured):
  1. Search the deck for stale words and old figures: `not built`, `planned`, `pilot`, `proposal`, `will`, the old numbers.
  2. Update them in one pass.

## Text
- **Plain-language pass:** before shipping, reread the narration for AI-sounding patterns. If a humanizer-style skill is installed, run it on the deck text. The usual hits:
  - "not X but Y" contrasts;
  - one-line closers that repeat the slide title;
  - bold scattered through sentences;
  - "That is the real win" style endings.
- **Bold:** only in titles, tiles and card headings, never inside narration sentences.
- **Terms:** in a non-English deck, keep technical terms in English and explain each once.

## Look
- **Theme:** one light, high-contrast theme that survives a projector.
  - stage `#fbfcfe` on `#d9dee6`;
  - ink `#0f1726`, accent blue `#1d5bd6`;
  - amber `#c05a00` for warnings, red `#c62828` for errors, green `#11804a` for OK.
- **No dark theme:** dark slides wash out on projectors and in screen shares.
- **Type:** h1 54-56px, h2 30px, body 20-23px, mono for names.

## Controls
- → / Space / PageDown / Enter / click: next step. ← / PageUp: back. Home and End.
- N: notes, F: fullscreen. If the audience types in another keyboard layout, bind those keys too (the files bind Cyrillic `т` and `а`).
- Hash `#s5` or `#s5-3` opens slide 5 at step 3.
- Bottom bar: counter "5/21 · step 3/6" and a progress bar.

For a recorded deck: keyboard only, `cursor:none`, no click targets, and the bottom-right corner left empty for a face cam.

## Ship
1. **Back up first.** Before big edits, copy the file as `deck.vNN-before-<what>.html`.
2. **Check every slide.** Run `bash check_deck.sh deck.html <out dir>` and read every PNG. Look for:
   - the h2 over the `.uc` line;
   - text past the narration strip;
   - labels on top of each other;
   - edges through boxes;
   - truncated `.uc` lines.

   Headless capture can show the step before the one asked for. The printed counter from the DOM dump is the truth.
3. **Publish** the single HTML file wherever the audience reads it. For a page that is already shared, every update is visible at once: say so before editing, and list what changed.
4. **Links.** After inserting a slide, say that the `#sN` links have shifted.

## Common mistakes
| Mistake | Fix |
|---|---|
| Scrolling page with cards | Fixed 1280x720 stage + builds |
| Bullet lists as the content | An animated diagram + a narration strip |
| Scenario revealed step by step | Scenario line always visible under the title |
| Renderer mutates the previous state | Rebuild the whole state for step k |
| Two-line h2 at 34px or two-line `.uc` overlaps the stage | h2 30px, `.uc` one line, layout table above |
| Notes hidden in a deck read alone | `body.shownotes` by default |
| Price or count from memory | Price list or live read, date in the notes |
| "not built yet" left after the thing shipped | Search for stale words on every state change |
| Hand-drawn cloud boxes | `aws_icons.py` with the official package |
| AI-sounding narration, bold everywhere | Plain-language pass, bold only in headings |
| Counter "wrong" in a screenshot | Read the DOM dump line from `check_deck.sh` |
| Demo in a separate page | Interactive demo slides inside the same deck |

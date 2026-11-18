# Interactive HTML deck

A Claude Code plugin with one skill, `interactive-html-deck`. It teaches Claude to build a presentation as a single self-contained HTML file instead of a scrolling web page or a static slide file.

Each deck is a fixed 16:9 stage (1280x720, scaled to the window). Slides build in steps, and diagrams move between steps: packets travel along the edges of an architecture graph, pods move between nodes, points settle on a "map of meaning", ranked lists merge, and bars grow from before to after. Every slide has one message, a one-line scenario under the title, a narration strip that changes with each step, and speaker notes. A deck meant to be read alone opens with the notes visible.

## Install

```
/plugin install interactive-html-deck --marketplace devops01ua/caps
```

On older Claude Code: `/plugin marketplace add devops01ua/caps`, then `/plugin install interactive-html-deck@caps`.

## What is in it

| File | Purpose |
|---|---|
| `skills/interactive-html-deck/SKILL.md` | The method: intake questions, slide recipe, story order, engines, numbers, text, look, controls, shipping checks |
| `template.html` | Stage, controls and the Sim engine (objects in boxes) |
| `example.html` | A 5-slide English example with the Graph, MeaningMap, Lists and bar engines; all numbers are illustrative |
| `aws_icons.py` | Builds a `const ICONS = {...}` map from the official AWS Architecture Icons package you download yourself |
| `check_deck.sh` | Takes a headless Chrome screenshot of the last step of every slide and prints each step counter |

Open `example.html` in a browser to see it: arrow keys or click to step, N for notes, F for full screen, `#s3-2` in the URL to jump to slide 3, step 2.

## What runs and where data goes

Nothing runs on its own. The skill has no hooks, MCP servers or network calls.

- `aws_icons.py` reads SVG files from a local folder you pass on the command line and prints JavaScript to stdout.
- `check_deck.sh` starts a local headless Chrome (path in `CHROME`, macOS default otherwise) on a local file and writes PNG screenshots to the folder you pass.
- The HTML files load two fonts from Google Fonts (Onest, JetBrains Mono). Remove the `<link>` tags to work fully offline; the system font fallback is defined.

AWS Architecture Icons are not included. Download them from https://aws.amazon.com/architecture/icons/ under AWS's own terms.

## License

MIT, see `LICENSE`.

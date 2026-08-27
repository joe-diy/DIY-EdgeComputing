# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is a Jekyll-based GitHub Pages site (`jekyll-theme-tactile`) that hosts a tutorial book, **"DIY Edge Computing"**, about building edge-computing projects on a Raspberry Pi. It is not an application — there is no build pipeline, package manager, or test suite for source code. The "content" is the product: Markdown chapters, images, and small reference snippets (e.g. a `Dockerfile`) that readers copy into their own Raspberry Pi.

## Structure

- Each chapter is a top-level directory named `"<prefix> - <Title>"` (e.g. `Introduction - Getting Ready`, `CH01 - Docker`), containing a `README.md` chapter body and an `images/` subfolder for screenshots referenced from that README with relative paths.
- `_config.yml` — Jekyll/GitHub Pages site configuration (title, theme, GitHub repo metadata).
- `index.html` — the site's landing page (currently a placeholder).
- `Gemfile` / `Gemfile.lock` — pulls in the `github-pages` gem bundle so the site can be previewed with Jekyll locally and builds identically to GitHub Pages' hosted build.
- `_site/` — Jekyll's generated build output. Treat as disposable/generated; don't hand-edit files here, edit the source chapter/`_config.yml` instead.

## Working with content

- Chapter READMEs follow a consistent voice: a numbered walkthrough of commands/steps, with an italicized `*Why?*` subsection after major steps explaining the reasoning, and a `## Next` section at the end linking to the following chapter.
- Commands intended for the reader to run are fenced with ` ```bash `; keep this convention when adding new steps.
- Image references use relative paths into that chapter's own `images/` folder (e.g. `images/grove-pi-plus.png`), not absolute paths.
- When adding a new chapter, follow the existing naming pattern (`"CH<NN> - <Title>"`) and add a `## Next` link from the previous chapter's README to keep the book's linear flow intact.

## Local preview

Standard Jekyll/Bundler workflow (requires Ruby + Bundler):

```bash
bundle install
bundle exec jekyll serve
```

This serves the site locally (default `http://localhost:4000`) and regenerates `_site/` on changes, matching how GitHub Pages builds and serves the live site.

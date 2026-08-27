# Future Chapters Outline: Open Horizon + Local AI

**Date:** 2026-08-27
**Status:** Approved

## Goal

Extend the DIY Edge Computing book from its current two chapters (Introduction, CH01 - Docker) through a sequence that gives the reader the skills to run [Open Horizon](https://github.com/open-horizon) and deploy a local AI service (LLM inference), following the pattern of [service-edge-ai](https://github.com/joewxboy/service-edge-ai). A companion YouTube series (short, humorous, Gen Z-oriented) pairs one video per chapter — full video scripting/outline is a separate spec, out of scope here.

## Structure & Principles

- The book stays linear: each chapter ends with a `## Next` link to the following chapter, per existing convention (see `CLAUDE.md`).
- **Container-engine neutrality**: CH01 needs revising to teach Docker and Podman side-by-side without favoring either, since every later chapter builds on "a container engine" rather than a specific one. This is a prerequisite edit to existing content, not a new chapter.
- **Existing hub for the main path**: the fundamentals/policies/secrets chapters assume the reader connects to an already-running Open Horizon management hub — either the LF Edge Community Lab's free hub or a company-provided one. The book gives generic "get hub credentials and exchange URL" instructions rather than hosting-specific steps.
- **Self-hosting is a branch, not a detour**: CH03 (hosting your own hub) is optional. Readers who skip it rejoin the main path immediately at CH04 (deployment policies), still using the existing hub. Readers who take the branch use their own hub from CH04 onward instead.
- **One chapter, one short video**: each chapter pairs with one YouTube short that dramatizes that chapter's single "aha" moment rather than summarizing the whole chapter.

## Chapter List

Granularity choice: expanded path (each major topic gets its own chapter, including splitting policies into deployment/node policies and the capstone into detection/remediation), favoring short, tightly-scoped chapters that each map to one short video.

| # | Chapter | Goal | Status |
|---|---------|------|--------|
| — | Introduction - Getting Ready | Hardware/OS setup | Existing, no change planned |
| CH01 | Docker & Podman | Container basics, neutral between engines | **Needs revision** — currently Docker-only |
| CH02 | Open Horizon Fundamentals | Install the Horizon agent on the RPi; register it as a node against an existing hub (LF Edge Community Lab or company-provided) | New |
| CH03 | Hosting Your Own Hub *(optional)* | Stand up exchange + agbot + CSS for readers who want full control instead of a third-party hub | New |
| CH04 | Deployment Policies | Write a deployment policy to push a service to matching nodes without manual targeting | New |
| CH05 | Node Policies | Node-side properties/constraints so the right service lands on the right hardware | New |
| CH06 | Secrets Management | Store and bind a secret (e.g. an API key) instead of hardcoding it, in preparation for the AI chapter | New |
| CH07 | Deploying Local AI | Deploy an LLM inference service (service-edge-ai pattern) via Open Horizon, using the secret from CH06 | New |
| CH08 | Detecting Problems | Monitor the deployed AI/workload and recognize failure states | New |
| CH09 | Autonomous Remediation | Use the local AI to detect and fix workload errors without human intervention | New (capstone) |

Chapter numbers are provisional and may shift once per-chapter content volume is known.

## Video Series (framing only — details are a separate spec)

Each chapter's companion video follows this structure, in order:

1. **Relatable problem** — the pain the reader/viewer would hit at this stage
2. **Open Horizon feature** — the efficient fix for that problem
3. **Punchline**
4. **Demo** — quick, real
5. **Hook** for the next video
6. **Call to action**
7. **Pointer to the book chapter** for the full deep-dive

Videos release in the same order as the chapters, so each assumes only what prior chapters/videos already covered. Platform/runtime specifics (Shorts vs. long-form, exact length, channel branding) are left open for the dedicated video-series spec.

## Open Questions

- **service-edge-ai specifics unconfirmed**: no internet access during this design session to inspect the actual repo. CH07's exact content (which model/runtime, exact secret needed) must be verified against the repo before that chapter is drafted.
- **Video platform/runtime specifics**: left for the separate video-outline spec.
- **Chapter numbering**: provisional, may shift.

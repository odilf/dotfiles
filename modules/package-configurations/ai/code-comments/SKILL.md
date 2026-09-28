---
name: code-comments
description: >-
  Guidance on code comments and where design context lives instead of them
  (ADRs, design docs, handoff notes, general docs). Use when writing, reviewing,
  or deciding whether to add a code comment, or when deciding where to document
  a decision, a subsystem, or session/task continuity.
---

# Docs system: where design context lives instead of comments

Check for an existing docs convention in the project first (`docs/`, `docs/adr/`, `docs/decisions/`, a root `HANDOFF.md`, etc.) and match its structure and naming. Only use the structure below where nothing already exists, and only create a file when there's real content to put in it.

## ADRs — decisions and tradeoffs

`docs/decisions/NNNN-short-title.md`, numbered sequentially.

One per decision that was actually weighed against a real alternative — not every choice, just the ones a future reader could reasonably ask "why didn't we just do X?" about.

```md
# NNNN — Title

## Status
Accepted | Superseded by NNNN

## Context
The forces at play; the problem this addresses.

## Decision
What we chose.

## Consequences
What this makes easier or harder; what we gave up.
```

## Design docs — how a subsystem works

`docs/design/<subsystem>.md`. (Some teams call this a PRD, used loosely — a living reference for how something works, not a proposal for an upcoming change.)

Long-lived. Update it in place as the system evolves; don't create a new one per change.

```md
# <Subsystem name>

## Purpose
Why this exists as its own thing.

## How it works
Current shape of the system.

## Boundaries
What this subsystem is explicitly not responsible for.
```

## Handoff notes — session and task continuity

Root `HANDOFF.md`, or `docs/handoff/<date>.md` for history. Split into `HANDOFF.md` (outgoing) / `RESUME.md` (incoming) if work regularly passes between people; one file is enough otherwise.

This is where "recently," "just changed," TODOs, and narrated history belong — none of it belongs in code comments.

```md
# Handoff — <date>

## What changed
## Why
## What's next
## Open questions
```

## General docs

`docs/<topic>.md` or `README.md` — setup steps, operational runbooks, anything a new contributor needs that isn't a decision or a subsystem description.

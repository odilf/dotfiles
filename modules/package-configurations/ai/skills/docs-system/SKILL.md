---
name: docs-system
description: >-
  File layouts and templates for the design context that doesn't belong in a
  code comment: ADRs for decisions and tradeoffs, design docs for how a
  subsystem works, handoff notes for session/task continuity, and general docs.
  Use when recording a decision, documenting a subsystem, capturing where work
  left off, or checking whether the project already has a docs convention to
  match.
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


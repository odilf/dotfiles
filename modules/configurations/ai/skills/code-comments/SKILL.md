---
name: code-comments
description: Use whenever writing or editing any code, not only when comments are the explicit topic — check this before adding a comment, docstring, or doc comment of any kind (JSDoc, block comments, Python docstrings, etc.). Separates doc comments (contracts for consumers) from code comments (the "why" for collaborators), lists the kinds of comments worth writing, and says when context belongs in docs instead.
---

# Code comments

Code shows *how*. Good names, small functions and expressive types make the how clearer, so do that first. They can't show *why*: why the obvious version doesn't work, why this constant, why this order. Information that was never written down can't be recovered by reading harder. Use comments to fill that gap.

There's no correct ratio of comments to code, and no rule that all code must be commented. Write a comment where a reader would otherwise **misread** the code — not merely benefit from the extra context. Assume that reader is a capable engineer, or a coding agent, who has none of your current context.

There are two kinds of comment, written for two audiences:

- **Doc comments** (`///`, JSDoc, docstrings) are for *consumers*. They state the contract.
- **Code comments** (inline `//`, `#`) are for *collaborators*, meaning whoever changes this code next. They state the why.

## Doc comments: the contract

State what's promised: inputs, outputs, invariants, errors and side effects. Don't describe how it's built. A doc comment has to pass two checks:

1. **Survives a rewrite.** It stays true if the implementation is replaced but the behavior stays the same.
2. **Swap the caller.** It stays true for every valid caller. If you can't write it without naming a specific feature or caller, the function's boundary is probably in the wrong place.

Bad: coupled to one caller, and it describes a purpose instead of a contract.

```ts
// Fetches cart items and applies the loyalty discount so checkout can
// show the discounted total before payment is submitted.
function getCartWithDiscount(userId: string): Cart { ... }
```

Good: just as true for checkout, an admin tool or anything else.

```ts
/**
 * Returns the user's cart with loyalty discounts applied per their
 * current tier. Promotional overrides aren't applied here — apply
 * them to the result if the caller needs them.
 */
function getCartWithDiscount(userId: string): Cart { ... }
```

Bad: walks through the algorithm and buries the guarantee.

```python
def normalize_email(email: str) -> str:
    """
    Lowercases the email, strips whitespace, splits on '@', strips any
    '+tag' suffix from the local part with a regex, and rejoins it.
    """
```

Good: states the guarantee, and stays true if the regex is replaced by a library.

```python
def normalize_email(email: str) -> str:
    """
    Returns a canonical form of `email` such that two addresses that
    deliver to the same inbox under common provider aliasing rules
    (e.g. Gmail's plus-addressing) normalize to the same string.
    """
```

Implementation reasoning doesn't go in the doc comment. Put it in a code comment inside the body, next to the code it explains, where the person changing that code will see it.

## Code comments: the why

These kinds are nearly always worth writing:

- **Load-bearing choices.** Correctness depends on a detail that looks innocuous, such as an ordered collection, a call order or a type's visibility. Say what breaks if someone "simplifies" it. Encode the invariant in types or assertions where you can, and comment whatever you can't.
- **Why not.** The code deliberately avoids the obvious approach, a standard helper or a convention. Name the obvious way and say why it doesn't work here.
- **Hard-learned lessons.** A fix that took more than ~30 minutes of debugging and looks unnecessary. Say what happens without it. If you don't fully understand why it works, say how you arrived at it so the next person can pick up from there.
- **Rationale for constants.** Say what the value represents, how it was chosen and what changing it would affect. "Chosen arbitrarily; nothing depends on the exact value" is useful information.
- **Correctness arguments.** For non-trivial code, explain why these steps reliably produce the right result. Tests show *that* it works. The argument lets someone change it safely. Back the invariants it relies on with assertions. If the argument doesn't fully hold, say where it breaks rather than committing a partial proof.
- **References.** For code ported from or implementing an external source (a paper, spec or another repo), link it. Use a permalink for code (on GitHub, press `y` before copying the link). Document and justify any divergence from the source.
- **Algorithm outlines.** When a long function's high-level steps get lost in the syntax, outline them at the top or label each phase inline.
- **TODOs.** Known gaps that are deliberately shipping. Write enough that someone without your context could act on it: what's missing, why that's acceptable for now and how you'd approach it. Multi-line TODOs and ticket links are fine. If the project has a TODO format, match it.
- **Intentional trade-offs.** See [Trade-offs](#trade-offs-y-statements) below.

```rust
// Must stay a BTreeMap: `emit_diff` below relies on sorted iteration and
// produces a corrupt diff if keys come out in arbitrary order.
let entries: BTreeMap<_, _> = changes.into_iter().collect();
```

```go
// Take A before B. Compact() acquires them in the same order, and
// reversing it here deadlocks under concurrent writes (trace in #482).
mu.LockA()
```

```python
# 30s rather than the client's 5s default: cold starts on the shared
# cluster regularly take 10–20s. Anything above ~20s works; below that
# the spurious timeouts come back.
CONNECT_TIMEOUT_S = 30
```

A ticket or link can point to more detail, but the comment has to stand on its own if the link rots.

### Trade-offs: Y-statements

If a choice was weighed against a real alternative and lives in one place in the code, record it there as a Y-statement:

```text
In the context of <use case>, facing <concern>, we decided for <option>
to achieve <quality>, accepting <downside>.
```

Every field is required, and each one is a short sentence fragment rather than a paragraph. You can add paragraphs after the statement if more context helps. If the project uses `yadr`, follow its format so `yadr check` passes.

```rust
// In the context of the per-replica event log, facing unbounded growth on
// long-lived replicas, we decided for compacting on every 1000th append to
// achieve bounded memory without a background task, accepting a latency
// spike on the compacting append.
```

If a decision spans many files or is architectural, write an ADR instead and leave a short pointer comment at the main site, e.g. `// see docs/decisions/0007-retry-backoff.md`.

## Writing them

Comments are technical writing.

- **Bytes are cheap.** Use full sentences, real punctuation and only the most obvious abbreviations. Don't compress a comment so far that a tired reader can't parse it a year from now.
- **Remember the reader.** They don't share your current context. Words like "obviously", "of course", "trivially" and "just" signal that you're assuming they do. Reread the comment as if you didn't know the code.
- **Precision matters.** Wrong identifiers, ambiguous phrasing and stale claims mislead more than a missing comment does. Reread it once more before moving on.

## As an agent

You're well placed to write these comments. Over a session you learn exactly the context the code can't hold: why the first approach failed, what the user corrected and which choices were deliberate. Before finishing, write the durable parts of that next to the code they explain, using the categories above.

- If the user corrected an approach that looks natural, that's probably a "why not" or load-bearing comment waiting to be written. Put it in the code so the next agent doesn't make the same mistake.
- When you touch code that has comments, check they're still true. Update or delete stale ones, because a wrong comment is worse than none.
- If you repeatedly correct the same approach, put the correction in a comment next to the code — not in AGENTS.md. Comments travel with the file and land in the agent's context; AGENTS.md stanzas don't.

## Not worth writing

- Restating the next line (`// loop over paying customers` above a `.map`) or narrating syntax and control flow. Rename things instead if the code wasn't clear.
- Change history like "previously this did X" or "refactored from Y". That belongs in the commit message. A hard-learned lesson is different because it explains the code's current shape: "without this, X happens" is fine, "changed this on Tuesday" isn't.
- Filler and hedging, like "this basically..." or "just a simple helper that...".
- Comments nobody can act on, like a TODO that's only a few keywords or a `// hack` that doesn't say what's hacky.
- A comment that no longer matches the code. A wrong comment is worse than none — fix or delete it when you touch the code.

## Where else context goes

If the context belongs to one spot in the code, put it at that spot. Comments get read, and they land in an agent's context, while separate docs are easy to miss. Use docs for context that has no single spot:

| Context                                                   | Goes in              |
|-----------------------------------------------------------|----------------------|
| An architectural or cross-cutting decision                | An ADR               |
| How a whole subsystem works, and why it's shaped that way | A design doc         |
| Where work left off, open questions, next steps           | A handoff note       |
| Setup, operational or environment instructions            | General project docs |

Use the `docs-system` skill for the structure, but only once you're actually about to write one of these. Match the project's existing docs convention, and don't scaffold empty docs speculatively.

## Don't gold-plate

Landing good code with imperfect comments is fine. If commenting starts to feel mechanical, the comment probably isn't needed.

Before finalizing a diff:

- Doc comments you added or changed: do they state a contract that survives a rewrite and a caller swap?
- Code you wrote that looks odd, fragile or arbitrary: does it say why?
- What you learned this session that the code can't show: is it written next to the code it explains?
- Comments on code you touched: are they still true?

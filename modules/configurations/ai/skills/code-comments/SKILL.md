---
name: code-comments
description: Use whenever writing or editing any code, not only when comments are the explicit topic — check this before adding a comment, docstring, or doc comment of any kind (JSDoc, block comments, Python docstrings, etc.). Enforces a decoupled, contract-first commenting standard, and redirects design rationale, tradeoffs, and session notes to project docs instead of inline comments.
---

# Decoupled Code Comments

*A comment should describe a contract, not tell a story.*

**Default: no comment.** If code needs a comment to be understood, check first whether better naming, a smaller function, or a clearer type removes the need — most comments are a patch over a naming problem.

When one really is warranted, write it the way one senior engineer leaves a note for another: assume competence, skip the preamble, state only the one non-obvious thing. And if what you actually want to say isn't a contract, it probably belongs in a doc, not a comment — see "Where the rest goes" below.

## The three tests

Every comment has to pass all three, or it gets fixed, deleted, or moved:

1. **Necessity** — a competent reader would still misread the *intent* of this code without it. Not "would benefit from." Misread.
2. **Contract, not mechanism** — it states what's promised (inputs, outputs, invariants, failure modes), not how it's built. It should still be true if the whole implementation were rewritten but the behavior stayed the same.
3. **Swap-the-caller** — it's still true, unchanged, no matter which valid caller is reading it. If it only makes sense for one caller, it's coupled.

A comment that fails test 3 is often telling you something about the code, not just the comment — if a doc comment can't be written without naming a specific feature or caller, the function's boundary is probably drawn in the wrong place.

## Doc comments: contract, not story

Bad — coupled to one caller, and a decision narrated instead of a contract stated:

```ts
// Fetches cart items and applies the loyalty discount so checkout can
// show the discounted total before payment is submitted.
function getCartWithDiscount(userId: string): Cart { ... }
```

Good — decoupled; equally true for checkout, an admin tool, or anything else:

```ts
/**
 * Returns the user's cart with loyalty discounts applied per their
 * current tier. Promotional overrides aren't applied here — apply
 * them to the result if the caller needs them.
 */
function getCartWithDiscount(userId: string): Cart { ... }
```

Bad — explains the algorithm, buries the one fact that actually matters:

```python
def normalize_email(email: str) -> str:
    """
    Lowercases the email, strips whitespace, splits on '@', strips any
    '+tag' suffix from the local part with a regex, and rejoins it. We
    do this because Gmail treats 'user+tag@gmail.com' as 'user@gmail.com'.
    """
```

Good — states the guarantee; survives a rewrite from regex to a library:

```python
def normalize_email(email: str) -> str:
    """
    Returns a canonical form of `email` such that two addresses that
    deliver to the same inbox under common provider aliasing rules
    (e.g. Gmail's plus-addressing) normalize to the same string.
    """
```

## Inline comments: rare, local, present tense

The only inline comments worth keeping state a non-obvious invariant right at the point it matters — not history, not a ticket, not a narrated decision:

```go
// Must run before LockB: the reverse order deadlocks with the
// writer in Compact().
mu.LockA()
```

Not this:

```go
// Fixed in #482 after the prod deadlock on 2025-03-02 — lock A first.
mu.LockA()
```

Same underlying fact, but the second is a commit message wearing a comment's clothes. If the incident matters, it goes in a handoff note; the code just states the invariant, present tense, no story attached.

## Never

- Restate the next line in English (`// loop over paying customers` above a `.map`). Delete it, or rename the variable if the code itself wasn't clear.
- Write anything a junior engineer would write to narrate obvious syntax or control flow.
- Name a specific caller, page, feature, ticket, or date inside a function's own doc comment.
- Explain *why we chose X over Y* in a comment — that's a real decision; it belongs in an ADR.
- Hedge or narrate ("this basically...", "just a simple helper that...").

## Where the rest goes

If what you're about to write isn't a decoupled contract, it's probably one of these instead:

| You're about to write...                                              | It goes in...        |
|--------------------------------------------------------------------------|-----------------------|
| A real decision and its tradeoffs ("we chose X over Y because...")       | An ADR                |
| How a whole feature or subsystem works, and why it's shaped this way     | A design doc          |
| What changed, why, what's next, open questions                          | A handoff note        |
| Setup, operational, or environment instructions                          | General project docs  |

Use the `docs-system` skill for the exact structure and templates — only once you're actually about to write one of these, not before. Short version: check whether the project already has a docs convention and match it before inventing a new one, and only create a new doc when there's real content for it. Don't scaffold empty folders speculatively.

A short pointer comment is fine when code really is shaped by a recorded decision — `// ordering constraint, see docs/decisions/0007-retry-backoff.md` — as long as it points at the rationale instead of repeating it.

## Before finalizing a diff

- Every new comment: does it pass all three tests?
- Every comment on code you're touching anyway: if it fails, fix or delete it rather than leaving it next to your change.
- Every paragraph you wrote that isn't a contract: does it belong in an ADR, design doc, or handoff note instead?

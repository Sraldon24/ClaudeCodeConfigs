---
name: improve-codebase-architecture
description: Explore a codebase to find opportunities for architectural improvement, focusing on making the codebase more testable by deepening shallow modules. Use when user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more AI-navigable.
origin: mattpocock/skills
---

# Improve Codebase Architecture

Goal: surface architectural friction and implement module-deepening refactors.
**Deep module** (Ousterhout): small interface hiding large implementation — more testable, more AI-navigable.
Dependency categories in REFERENCE.md.

## Steps

1. **Explore** — Use Agent(subagent_type=Explore). Note friction: shallow modules, tight coupling, untested seams. Friction IS the signal.

2. **Present candidates** — Numbered list. Each: Cluster | Why coupled | Dependency category | Test impact. No interfaces yet. Ask: "Which to explore?"

3. **User picks**

4. **Frame problem space** — Show user: constraints, dependencies, illustrative sketch (not a proposal). Then immediately start step 5 in parallel.

5. **Design interfaces** — Spawn 3+ parallel agents, each with a radically different constraint:
   - Agent 1: minimize (1-3 entry points)
   - Agent 2: maximize flexibility
   - Agent 3: optimize for common caller
   - Agent 4 (if cross-boundary): ports & adapters
   Each outputs: signature, usage example, hidden complexity, dependency strategy, trade-offs.
   Compare, then give your own opinionated recommendation (or hybrid).

6. **User picks** (or accepts recommendation)

7. **Implement** — Apply the chosen interface. Update/delete tests per REFERENCE.md testing strategy. Notify user when done with a summary of what changed.

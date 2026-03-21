---
name: strategic-compact
description: Suggests manual context compaction at logical intervals.
origin: ECC
---
# Strategic Compact
Use `/compact` at structural boundaries (Research->Plan, Plan->Implement, Debug->Next feature). 
Do NOT compact mid-implementation.
`suggest-compact.js` triggers periodically via `COMPACT_THRESHOLD` (50 changes). 
Retains: rules, TodoWrite, File tree.
Lost: Intermediate reasoning, file contents read.

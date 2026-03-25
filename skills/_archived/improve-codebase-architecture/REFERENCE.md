# Reference

## Dependency Categories

1. **In-process** — pure computation/in-memory, no I/O. Always deepenable; merge and test directly.
2. **Local-substitutable** — has local test stand-ins (PGLite, in-memory FS). Test with stand-in running.
3. **Remote but owned (Ports & Adapters)** — own services across network. Define port at boundary; inject transport. In-memory adapter for tests, real adapter for prod.
4. **True external (Mock)** — third-party (Stripe, Twilio). Mock at boundary; tests provide mock impl.

## Testing Strategy

**Replace, don't layer.** Delete old shallow-module unit tests once boundary tests exist. New tests assert on observable outcomes through the public interface only — must survive internal refactors.


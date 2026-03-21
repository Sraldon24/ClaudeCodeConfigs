# Patterns
## Skeleton Projects
For new functionality: Search battle-tested skeletons. Use parallel agents for security/extensibility analysis. Clone best match, iterate.
## Design Patterns
- **Repository:** Encapsulate data access behind interface (findAll, findById, create, update, delete). Business logic depends on interface, enabling swap/mock.
- **API Response:** Consistent envelope. Payload (nullable on error), success bool, error message (nullable on success), pagination metadata.

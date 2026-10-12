# ADR 0001: Cross-platform application foundation

- **Status:** Accepted for the initial prototype
- **Date:** 2026-10-12

## Context

MeshLedger targets Windows, Linux, macOS, Android, and iOS. The first milestone needs a maintainable shared UI and domain layer, local storage, and a path to adding multiple data-source adapters. The project also needs English and Brazilian Portuguese from the beginning.

## Decision

Use Flutter and Dart for the client application and shared domain logic. Use SQLite for local persistence. Keep radio, MQTT, and file ingestion behind source-specific adapters so transport constraints do not leak into the domain model.

Use native SQLite implementations on Android/iOS and an FFI implementation on desktop. Begin with a minimal schema that separates immutable source evidence from interpreted node observations.

## Alternatives considered

- **Python-only client:** rejected for the first cross-platform client because packaging and native radio connectivity across iOS, Android, and desktop would introduce avoidable platform-specific complexity.
- **Separate native app per platform:** rejected for the initial project because it duplicates UI and domain work.
- **Web-first application:** deferred because direct local radio access and durable local storage differ significantly by browser and operating system.

## Consequences

- Flutter/Dart becomes the primary client implementation language.
- Platform support must still be validated with actual builds and device tests; selecting Flutter does not itself prove that every transport works on every platform.
- MQTT and radio adapters may require platform-specific implementations or capability limits.
- SQLite schema changes require versioned migrations and tests.
- Python remains an option for tooling or a separate service, not a mandatory dependency of the client.

## Revisit when

Revisit this decision if tested requirements show that a target platform cannot support a required transport, storage behavior, or packaging model with acceptable maintenance cost.

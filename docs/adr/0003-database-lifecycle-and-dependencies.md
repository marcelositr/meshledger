# ADR 0003: Database lifecycle and application dependencies

- **Status:** Accepted
- **Date:** 2026-10-12
- **Scope:** Local SQLite startup, connection ownership, and repository wiring

## Context

The initial home page opened the local SQLite database to check availability and immediately closed it. That meant startup did not establish a usable data dependency for future features, and database initialization was owned by a screen widget.

## Decision

1. Open the database once during application startup through `AppDependencies`.
2. Construct repositories with that database connection and pass the dependency bundle into the feature UI.
3. Keep database initialization outside the home screen. Widgets must not independently open or close the shared connection.
4. Show a loading state while initialization runs and a localized error with a retry action if it fails.
5. Keep the connection open while the application is active. Tests must close their owned connections during teardown.
6. Preserve the existing desktop SQLite FFI setup and native Android/iOS SQLite implementations.

## Alternatives considered

- **Open and close the database from a screen:** rejected because the connection is unavailable to later operations and UI owns persistence lifecycle.
- **Open a new database connection in each repository or screen:** rejected because it creates unclear ownership and unnecessary connection churn.
- **Use one startup-owned connection injected into repositories:** accepted because it makes ownership explicit and supports testing.

## Consequences

- Startup is asynchronous and the UI must represent loading and failure states.
- Repositories receive a concrete database connection without owning its lifecycle.
- The database connection can be tested independently of the widget tree.
- Future explicit shutdown handling must close the connection exactly once.
- Schema migrations and transactional integrity remain separate responsibilities and still require their own tests.

## Revisit when

Revisit this decision if the app introduces multiple isolated database files, background workers with independent connection needs, or a lifecycle manager that can safely coordinate connection shutdown.

# ADR 0003: Database lifecycle and dependency ownership

- **Status:** Accepted
- **Date:** 2026-10-12

## Context

MeshLedger uses one SQLite connection shared by repositories through
`AppDependencies`. Startup can fail, be retried, or finish after the startup
widget has already been removed. Leaving a successfully opened connection
unowned can leak a database handle.

## Decision

- `AppDependencies` owns the database connection and the repositories wired
  to it.
- The startup page does not create database connections directly; it delegates
  to the dependency loader.
- Synchronous exceptions and asynchronous failures during initialization use
  the same error and retry path.
- When the startup page is disposed, it closes dependencies if initialization
  succeeded. If initialization completes after disposal, that connection is
  closed as soon as it becomes available.
- Failed initialization has no successfully created dependency object to close.
- `AppDependencies.close()` is idempotent so repeated shutdown requests share
  the same close operation.
- Tests must verify successful startup, both failure forms, retry, normal
  disposal, late completion after disposal, and repeated close requests.

## Consequences

- The application has a single clear owner for its SQLite connection.
- Initialization that finishes after its consumer disappears cannot leave an
  open connection behind.
- Platform process termination is still controlled by the operating system;
  widget disposal is a resource-release path, not a guarantee that every abrupt
  process termination will run cleanup.

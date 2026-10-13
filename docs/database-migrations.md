# SQLite schema migrations

MeshLedger's local database schema is versioned through SQLite's `user_version`, managed by `sqflite`.

## Rules

1. Increase `LocalDatabase.schemaVersion` for every schema change that requires an existing database to be upgraded.
2. Add a sequential migration branch in `_migrate` for every new version. A migration from version N to N+1 must not assume that an older database already has changes introduced after N.
3. Apply schema changes with the migration transaction supplied by `sqflite`. Do not catch and ignore migration failures.
4. Preserve source events and observations. Do not drop evidence or silently replace duplicate records as a migration shortcut.
5. Keep fresh database creation aligned with the latest schema. New installs should not need to run every historical migration after creation.
6. Add a migration test that opens a database at an older version, seeds representative records, upgrades it, and verifies both schema and retained data.
7. When a migration transforms stored values, test the transformation and rollback behavior as well as the schema version.

## Current versions

- **Version 1:** initial source event and node observation tables, foreign key, and chronological/source-node indexes.
- **Version 2:** adds `idx_source_events_source_received_at`, an index for filtering event history by source and ordering it chronologically.

Fresh databases are created directly at the current schema version. Existing version 1 databases receive the version 2 index through the upgrade callback.

## Validation

The migration suite uses a version 1 SQLite database with an event and observation, opens it through `LocalDatabase.open`, and checks that the version advances, the new index exists, and the original rows remain. The normal repository integrity suite continues to check foreign keys, duplicate IDs, and transaction atomicity.

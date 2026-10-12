# MeshLedger foundation

**Status:** Initial implementation baseline. The application is not yet feature-complete.

## Technology direction

- **Flutter and Dart** provide the shared application and domain layer for Windows, Linux, macOS, Android, and iOS.
- **SQLite** stores local history.
- Platform-specific radio connectivity and MQTT ingestion are adapters, not assumptions baked into the data model.
- English (`en`) and Brazilian Portuguese (`pt_BR`) are the initial UI locales. Additional locales should be additive.
- Python may be used for development tools or independent services if justified, but it is not required in the client runtime.

## Data flow

```text
Radio adapter ─┐
MQTT adapter ──┼─> source event ─> parser/validator ─> node observation
File importer ─┘        │                                  │
                        └──── original evidence ───────────┘
```

The event is evidence of what a source supplied. An observation is the application's interpretation of some of that evidence. These are related, but not interchangeable.

## Initial records

### Source event

A source event records provenance and ingestion details: source kind, optional source instance, received/observed timestamps, payload format and encoding, original payload when available, parser version, parse status, and errors.

### Node observation

An observation records what the application could interpret about a node at a point in time. The source node ID and display name are separate fields. Display names are not stable identity keys. Signal metrics are optional because not every source supplies them.

## Data integrity rules

1. Do not merge identities based only on display name.
2. Keep source events and observations attributable to their source.
3. Keep original payloads where available and permitted; record when data is unavailable or cannot be decoded.
4. Do not translate node names, IDs, packet contents, or source payloads.
5. Deduplication belongs in query or presentation logic until a documented policy says otherwise.
6. Use explicit, versioned migrations for schema changes. Do not delete historical data as an incidental side effect.
7. MQTT reception does not grant permission to republish data.
8. Exporting or sharing data must require an explicit user action.

## Current scope

This baseline creates the app shell, locale resources, an initial SQLite schema, and a source-aware observation model. It does not yet connect to a radio, subscribe to MQTT, import files, or provide node browsing and search. Those capabilities must be added and tested separately.

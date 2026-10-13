# MeshLedger

Cross-platform Meshtastic node and contact manager with local history and SQLite storage.

> **Project status: early prototype.** The development branch contains a Flutter app shell, initial platform-aware app/page scaffolds, English and Brazilian Portuguese locale resources, a versioned SQLite schema, source-event and node-observation models, an atomic persistence repository, starter tests, architecture decisions, and a CI workflow. Radio/MQTT/file ingestion and the node-management UI are not implemented yet. Tests, CI results, and platform compatibility must be verified before being claimed.

## Vision

MeshLedger aims to help users collect, organize, inspect, and locally retain Meshtastic node and contact observations from multiple sources, with provenance preserved so information from different sources can be compared without losing its origin.

## Planned principles

- **Local-first:** keep the user's collected history on their device by default.
- **Source transparency:** distinguish radio, MQTT, and imported-file observations.
- **Data provenance:** retain source identifiers, timestamps, and original events where practical.
- **Conservative identity matching:** do not merge nodes solely because their display names match.
- **Preserve evidence:** retain original events when possible; deduplicate in queries and visualizations rather than silently deleting records.
- **Explicit sharing:** exporting or publishing locally collected information must be an intentional user action.
- **Cross-platform direction:** Windows, Linux, macOS, Android, and iOS are target platforms. Actual support will be validated and documented as implementation progresses.
- **Adaptive UI:** share the application foundation without forcing one operating system's design language onto every platform. Use Cupertino conventions on iOS, Material conventions on Android, and a desktop-oriented interface on Linux, Windows, and macOS.
- **Linux independence:** core functionality must not require GNOME, KDE Plasma, or a specific distribution. GTK/Libadwaita and Qt/Kirigami are optional integration paths, not mandatory competing UI frameworks.
- **Internationalization:** English (`en`) and Brazilian Portuguese (`pt_BR`) are the initial target languages. The design should allow additional locales later.
- **Security and privacy:** document limitations honestly and do not imply that data is available, readable, or authorized when the source does not provide it.

## Platform UI strategy

Flutter remains the shared client foundation, but the UI must go through a platform-adaptation boundary. Feature and domain code should not directly choose platform-specific app shells or native toolkit widgets.

Because the native Flutter runner directories are not committed yet, a local checkout must have Flutter installed and run `sh tool/bootstrap_platforms.sh` to generate the Android, iOS, Windows, Linux, and macOS runner projects. The CI workflow performs this bootstrap before analysis, tests, and debug builds. The current platform-aware scaffolds are only an architectural starting point. They do **not** prove a fully native appearance, complete accessibility, native menus/window behavior, or hardware connectivity on every platform. Native integrations should be added only when a demonstrated need justifies their implementation, packaging, fallback, and testing costs.

See [ADR 0002: Adaptive UI and platform integration](docs/adr/0002-adaptive-platform-ui.md) and the [platform support and validation policy](docs/platform-support.md).

## Planned data sources

1. **Meshtastic radio** connected through a supported transport.
2. **MQTT**, initially investigating the MeshBrasil network and its actual topics, payloads, access conditions, and usage rules.
3. **Files**, through explicit user-initiated import.

The application can only collect information exposed by a source and accessible to the user. MQTT visibility depends on server configuration, subscriptions, payload format, encryption, and access permissions. MeshLedger will not claim to capture every node or every packet on a network.

## Initial development scope

The first foundation pass is represented in code:

- initial source-event and node-observation models;
- local SQLite schema with source provenance and foreign-key constraints;
- sequential schema migrations with retained-data tests;
- transactional persistence of an event and its parsed observation;
- a startup-owned SQLite connection injected into the repository layer;
- localized loading, failure, retry, and ready states for database startup;
- startup widget tests for loading, failure, retry, and successful recovery;
- English (`en`) and Brazilian Portuguese (`pt_BR`) UI resources;
- repository integrity tests for atomic rollback, foreign-key enforcement, duplicate IDs, and schema indexes;
- dependency-lifecycle and platform-scaffold tests;
- a Flutter CI workflow with analysis, tests, and Linux/Android debug build smoke checks;
- architecture decisions for the shared foundation, adaptive UI, and database lifecycle.

Next, review schema-upgrade failure handling and UI behavior, then add source adapters. Radio capture, node catalog, filters and history, MQTT integration, file import, and platform-specific validation remain future work.

## Governance and contributions

The project's decision-making and contribution rules are described in [GOVERNANCE.md](GOVERNANCE.md).

Until the project explicitly adopts additional maintainers or a community decision model, the founder is the principal maintainer and has final project authority, subject to applicable law, platform rules, and the project's published policies. Contributions are welcome, but submitting a contribution does not guarantee acceptance or grant repository administration rights.

Please open an issue to discuss substantial changes before investing in a large implementation. Changes should be focused, explain their reasoning, and include tests or validation evidence where applicable. Do not submit secrets, personal data, or captured network data without a clear legal basis and a demonstrated need.

## Current limitations

- The current app is an early prototype, not a complete node-management application.
- Supported devices, transports, operating systems, MQTT topics, and import formats must be verified before being declared supported. Linux/Android debug build checks do not validate hardware compatibility or release packaging.
- The initial desktop shell is Flutter-based and is not yet a fully native GTK, Qt, WinUI, or AppKit interface.
- Data interpretation may evolve; original source data should be preserved when practical so it can be reprocessed.
- Governance text does not itself enforce GitHub permissions, branch protection, CI requirements, or release signing. Those controls must be configured and tested separately.

## License

MeshLedger is distributed under the Apache License 2.0. See [LICENSE](LICENSE).

# MeshLedger

Cross-platform Meshtastic node and contact manager with local history and SQLite storage.

> **Project status: early prototype.** The development branch now contains a Flutter app shell, English and Brazilian Portuguese locale resources, an initial SQLite schema, source-event and node-observation models, an atomic persistence repository, starter tests, and a CI workflow. Radio/MQTT/file ingestion and the node-management UI are not implemented yet. Platform compatibility and CI results must be verified before being claimed.

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
- **Internationalization:** English (`en`) and Brazilian Portuguese (`pt_BR`) are the initial target languages. The design should allow additional languages later.
- **Security and privacy:** document limitations honestly and do not imply that data is available, readable, or authorized when the source does not provide it.

## Planned data sources

1. **Meshtastic radio** connected through a supported transport.
2. **MQTT**, initially investigating the MeshBrasil network and its actual topics, payloads, access conditions, and usage rules.
3. **Files**, through explicit user-initiated import.

The application can only collect information exposed by a source and accessible to the user. MQTT visibility depends on server configuration, subscriptions, payload format, encryption, and access permissions. MeshLedger will not claim to capture every node or every packet on a network.

## Initial development scope

The first foundation pass is now represented in code:

- initial source-event and node-observation models;
- local SQLite schema with source provenance and foreign-key constraints;
- transactional persistence of an event and its parsed observation;
- English (`en`) and Brazilian Portuguese (`pt_BR`) UI resources;
- starter unit and repository tests;
- a Flutter CI workflow and an architecture decision record.

The next steps are to validate the build and tests, strengthen schema migration and data-integrity behavior, and then add source adapters. Radio capture, node catalog, filters and history, MQTT integration, file import, manual tests, and platform-specific validation remain future work.

## Governance and contributions

The project's decision-making and contribution rules are described in [GOVERNANCE.md](GOVERNANCE.md).

Until the project explicitly adopts additional maintainers or a community decision model, the founder is the principal maintainer and has final project authority, subject to applicable law, platform rules, and the project's published policies. Contributions are welcome, but submitting a contribution does not guarantee acceptance or grant repository administration rights.

Please open an issue to discuss substantial changes before investing in a large implementation. Changes should be focused, explain their reasoning, and include tests or validation evidence where applicable. Do not submit secrets, personal data, or captured network data without a clear legal basis and a demonstrated need.

## Current limitations

- The current app is an early prototype, not a complete node-management application.
- Supported devices, transports, operating systems, MQTT topics, and import formats must be verified before being declared supported. The CI workflow has been added, but its passing status has not yet been verified.
- Data interpretation may evolve; original source data should be preserved when practical so it can be reprocessed.
- Governance text does not itself enforce GitHub permissions, branch protection, CI requirements, or release signing. Those controls must be configured and tested separately.

## License

MeshLedger is distributed under the Apache License 2.0. See [LICENSE](LICENSE).

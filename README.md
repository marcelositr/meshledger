# MeshLedger

Cross-platform Meshtastic node and contact manager with local history and SQLite storage.

> **Project status: early planning.** MeshLedger is not yet a working application. Features described here are goals, not claims of implemented functionality.

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

The first milestone is the foundation, not a feature-complete user interface:

- data model and event provenance;
- local SQLite storage;
- event logging and error handling;
- automated tests for core behavior;
- documented architecture decisions.

Radio capture, node catalog, filters and history, MQTT integration, file import, manual tests, and platform-specific validation will be introduced in later, reviewed steps.

## Governance and contributions

The project's decision-making and contribution rules are described in [GOVERNANCE.md](GOVERNANCE.md).

Until the project explicitly adopts additional maintainers or a community decision model, the founder is the principal maintainer and has final project authority, subject to applicable law, platform rules, and the project's published policies. Contributions are welcome, but submitting a contribution does not guarantee acceptance or grant repository administration rights.

Please open an issue to discuss substantial changes before investing in a large implementation. Changes should be focused, explain their reasoning, and include tests or validation evidence where applicable. Do not submit secrets, personal data, or captured network data without a clear legal basis and a demonstrated need.

## Current limitations

- No functional application is promised by this initial repository state.
- Supported devices, transports, operating systems, MQTT topics, and import formats must be verified before being declared supported.
- Data interpretation may evolve; original source data should be preserved when practical so it can be reprocessed.
- Governance text does not itself enforce GitHub permissions, branch protection, CI requirements, or release signing. Those controls must be configured and tested separately.

## License

MeshLedger is distributed under the Apache License 2.0. See [LICENSE](LICENSE).

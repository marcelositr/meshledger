# ADR 0002: Adaptive UI and platform integration

- **Status:** Accepted for the initial prototype
- **Date:** 2026-10-12
- **Scope:** Application UI architecture and platform-specific integration

## Context

MeshLedger targets Android, iOS, Windows, macOS, and Linux. The project must not force one platform's design language onto every other platform. Linux additionally has multiple desktop environments, toolkits, packaging systems, and differing conventions.

## Decision

1. Keep Flutter and Dart as the shared client foundation for domain logic, application features, and most UI structure.
2. Introduce a platform UI boundary. Feature/domain/data code must not directly choose Material, Cupertino, GTK, Qt, WinUI, or AppKit widgets.
3. Start with platform-aware app/page scaffolds: Cupertino conventions on iOS, Material conventions on Android, and a restrained desktop shell for Linux, Windows, and macOS. This is a foundation, not a claim of complete native look-and-feel.
4. Keep MeshLedger's brand identity separate from operating-system conventions. Shared identity elements may remain consistent; navigation, menus, dialogs, keyboard behavior, density, and other controls should adapt when useful.
5. Linux support must not depend on a single distribution or desktop environment. GTK/Libadwaita and Qt/Kirigami are optional integration ecosystems, not competing mandatory UI frameworks in the shared application.
6. Add GTK or Qt integration only for a demonstrated need, behind a narrow platform adapter or plugin boundary. Do not embed multiple native widget systems into the same screen merely to claim support. Prefer desktop portals and stable cross-desktop interfaces where suitable.
7. Any native integration must define fallback behavior, packaging implications, accessibility and keyboard behavior, and tests for the environments it claims to support.
8. Platform support is declared only after relevant builds and validation evidence exist. Flutter compilation alone does not prove native integration, device connectivity, or full compatibility.

## Alternatives considered

- **One Material interface everywhere:** rejected because it would impose Android-oriented UI conventions on iOS and desktop users.
- **Separate complete native UI for every platform from day one:** deferred because it multiplies implementation and maintenance cost before platform-specific requirements are known.
- **Make GTK and Qt both mandatory Linux UI frameworks:** rejected because the toolkits are distinct widget ecosystems and would add dependencies and complexity without a demonstrated need.
- **Use Flutter for the shared client with platform-specific boundaries:** accepted as the most maintainable starting point, while allowing native integrations where tests demonstrate value.

## Consequences

- Flutter remains the shared UI foundation, but feature code should use platform-neutral boundaries instead of constructing platform-specific app shells directly.
- The current scaffold is intentionally modest. Native desktop fidelity, native menus, window integration, and GTK/Qt adapters remain future work.
- Linux validation must cover representative desktop environments rather than claiming that one distribution represents all Linux desktops.
- Platform-specific UI and transport capabilities must be recorded separately; UI adaptation does not guarantee radio, Bluetooth, USB/serial, or packaging compatibility.

## Revisit when

Revisit this decision if user testing or technical validation demonstrates that a target platform needs a separate native UI, or if GTK/Qt integration provides a measurable accessibility, usability, packaging, or system-integration benefit.

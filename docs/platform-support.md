# Platform support and validation

**Status:** Planned support matrix. No platform is yet certified by this document.

MeshLedger targets Android, iOS, Windows, macOS, and Linux. Targets are intentions until builds and relevant behavior have been tested and recorded.

## Local development bootstrap

The current repository does not commit generated native runner directories. With the Flutter SDK installed, run `sh tool/bootstrap_platforms.sh` from the repository root to generate the standard Android, iOS, Windows, Linux, and macOS runner projects. The CI workflow runs the same script before analysis and tests. Generation is not equivalent to a successful native build; each target still needs platform-specific validation.

## UI strategy

| Platform | Initial UI direction | Current status |
|---|---|---|
| Android | Material conventions, adaptive to screen size | Foundation only; not validated |
| iOS | Cupertino conventions where appropriate | Foundation only; not validated |
| Windows | Desktop-oriented layout, keyboard and window behavior | Foundation only; not validated |
| macOS | Desktop-oriented layout, with Apple conventions added deliberately | Foundation only; not validated |
| Linux | Desktop-oriented layout, independent of one distribution or desktop environment | Foundation only; not validated |

The initial Flutter scaffold is not a claim that every control is native to its host operating system. Platform fidelity must be reviewed as features are implemented.

## Linux environments

The project must avoid requiring GNOME, KDE Plasma, or a particular distribution for core functionality. Validation should eventually include representative environments, such as:

- GNOME;
- KDE Plasma;
- one lighter desktop environment such as XFCE or Cinnamon.

The actual test matrix may change based on available CI runners and user-reported issues. Record exact distribution, desktop environment, package format, and test result when reporting a validation result.

GTK/Libadwaita and Qt/Kirigami are optional integration paths. Neither is a mandatory foundation for the Flutter client. A native integration must be justified, isolated, and have a fallback where practical.

## Required evidence before claiming support

For each platform/version claimed as supported, record:

1. build and launch result;
2. layout behavior at supported sizes and scaling settings;
3. keyboard, navigation, accessibility, and window behavior relevant to the platform;
4. local database creation, read/write, and upgrade behavior;
5. install/update/uninstall behavior for the distribution format;
6. relevant device and transport tests, reported separately from UI tests;
7. known limitations and the date of validation.

A successful build on one platform does not prove compatibility on another. A successful UI test does not prove Bluetooth, USB/serial, MQTT, or packaging support.

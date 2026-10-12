# MeshLedger Governance

**Status:** Initial governance policy  
**Applies to:** The MeshLedger project and its public development process  
**Review:** This policy may evolve as the project and contributor community grow.

## 1. Purpose

This document defines how project decisions are made, how contributions are evaluated, how sensitive changes are handled, and how this policy itself may be changed. Governance should be transparent, proportionate to the project's size, and resistant to unauthorized or undocumented changes.

This document is a project policy. It does not, by itself, configure or enforce GitHub permissions, branch rules, CI checks, signing requirements, or access controls. Those controls must be configured separately and verified.

## 2. Founding authority and roles

### Founder and Principal Maintainer

Until a change is explicitly announced in this document or in a recorded governance decision, the project founder is the Principal Maintainer and retains final authority over:

- project direction, scope, and priorities;
- acceptance or rejection of contributions;
- releases and release timing;
- appointment and removal of maintainers;
- repository administration and access grants;
- resolution of project-level disputes;
- approval of governance changes.

This authority is not automatically transferred by contributing code, reviewing pull requests, holding an informal role, or being active in the community.

### Contributors

Contributors may propose ideas, report bugs, submit documentation, tests, and code, and participate in public discussion. Contribution does not grant merge rights, administrative access, ownership, or a guaranteed right to have work accepted.

### Additional maintainers

Additional maintainers may be appointed only through an explicit decision by the Principal Maintainer. Their responsibilities and permissions should be documented and limited to what they need. Repository administration should not be granted merely because someone can review code.

The project does not claim to have a committee or shared community governance until such a model is explicitly adopted and documented.

## 3. Decision-making

### Routine decisions

Routine implementation and documentation decisions may be made by the Principal Maintainer, with discussion in issues or pull requests when useful. Decisions should prioritize correctness, maintainability, security, privacy, accessibility, cross-platform feasibility, and evidence from tests.

### Significant decisions

The following should have a written rationale in an issue, pull request, or Architecture Decision Record (ADR):

- changes to architecture or core data models;
- changes affecting stored data, migrations, or event provenance;
- changes to identity matching or deduplication behavior;
- new network communication, MQTT publishing, or data-sharing behavior;
- privacy, security, permissions, or retention changes;
- breaking changes to user-facing behavior, configuration, or import/export formats;
- new dependencies with meaningful security, licensing, or maintenance implications;
- release and compatibility policy changes;
- changes to the platform UI strategy, platform-specific code, or native toolkit integrations.

ADRs should record the context, decision, alternatives considered, and consequences. An ADR explains a decision; it does not independently grant permission to implement it.

### Disagreement

Participants should explain concerns with concrete reasoning and evidence. The Principal Maintainer makes the final project decision under the initial governance model and should document the rationale for consequential disagreements. Harassment, threats, and disclosure of private information are not acceptable ways to resolve disputes.

## 4. Contributions and review

- Prefer focused changes that can be reviewed and tested independently.
- For substantial work, discuss the proposed direction in an issue before implementation.
- Pull requests should explain the problem, proposed solution, relevant risks, and validation performed.
- Tests should accompany behavior changes when practical. Claims of compatibility must identify what was actually tested.
- Do not claim support for a device, transport, operating system, MQTT topic, or file format without evidence.
- Do not silently remove historical observations or alter source data in ways that destroy provenance.
- Do not include credentials, tokens, private keys, personal data, or unneeded captured network traffic.
- A contribution may be declined, revised, deferred, or closed. Discussion and review do not guarantee acceptance.

Until repository controls are configured and verified, contributors must not assume that branch protection or mandatory review is technically enforced.

## 5. Protected areas and sensitive changes

The following areas are considered security- and governance-sensitive:

- this file and other governance or security policies;
- repository permission and branch-protection configuration;
- CI workflows and release automation;
- dependency and build configuration;
- authentication, encryption, secrets handling, and network publishing;
- database migrations and data deletion or export behavior;
- platform selection, native toolkit bridges, and operating-system integration code.

Changes to these areas require a clear explanation and appropriate validation. Attempts to weaken tests, bypass review, conceal behavior, introduce undisclosed network transmission, or remove security checks without a documented justification should be treated as high risk and may be rejected.

Where technically available, the project should configure branch rules, required checks, restrictions on force pushes and branch deletion, least-privilege permissions, and protections against bypass. These are implementation tasks, not guarantees made by this policy.

## 6. Security reports and incidents

Do not publish exploitable vulnerability details, credentials, or personal data in a public issue. Use the repository's GitHub security reporting mechanism if it is enabled. If it is not enabled or is unavailable, contact the Principal Maintainer privately through a verified contact method listed in the repository profile.

Reports should include the affected component, impact, reproduction steps where safe, and any suggested mitigation. The project will assess reports in good faith, coordinate disclosure where feasible, and avoid promising response times that it cannot meet.

For suspected compromise, exposed credentials, malicious dependencies, or a compromised release, the priority is to limit further harm, revoke or rotate affected credentials, preserve relevant evidence, assess affected releases, and publish an accurate incident summary when safe to do so.

Never commit secrets to the repository. Removing a secret from the latest file does not remove it from Git history or invalidate it; exposed credentials must be revoked or rotated.

## 7. Privacy and data stewardship

MeshLedger is intended to be local-first. This is a design goal, not a claim that every future feature is automatically private.

- Collection must be limited to information actually exposed by a configured source and accessible to the user.
- Receiving information from MQTT does not imply permission to republish it.
- Exporting, sharing, or publishing collected information must be explicit and understandable.
- Raw events and normalized interpretations should remain distinguishable where practical.
- Retention, deletion, backups, and exports should be documented before the application handles real user history.
- Logs should avoid secrets and unnecessary sensitive payloads.
- Location, message content, identifiers, and other potentially sensitive data must be handled deliberately, with user control and clear defaults.

Legal, network, and service rules still apply. Users are responsible for ensuring they have the right to collect, retain, and share the information they use.

## 8. Releases and compatibility

A release must not be described as tested on a platform, device, or transport unless relevant validation was performed and recorded. Release notes should identify meaningful changes, known limitations, and breaking changes.

The project should adopt an explicit versioning and deprecation policy before stable public releases. Until then, APIs, schemas, and behavior may change during early development, and this limitation should be communicated clearly.

Release credentials and signing keys, if introduced, must be kept out of source control and handled with least privilege. Release automation should be reviewed like application code.

## 9. Changes to this governance policy

Anyone may propose a governance change through a public issue or pull request, unless disclosure would create a security risk.

A proposed change must explain its purpose, scope, and consequences. The Principal Maintainer reviews and approves governance changes under the initial model. Changes that materially affect authority, repository control, contribution rights, or the amendment process should include a clear rationale and be announced in the decision record.

No pull request, contributor role, automated workflow, or undocumented agreement independently changes who holds final authority. A future community-governance model must be adopted explicitly, including its decision process and transition arrangements.

## 10. Transparency and review

Consequential decisions should be recorded in public project history unless doing so would expose sensitive information or create a security risk. Exceptions should be limited and explained when possible.

This policy should be reviewed when the project adds maintainers, begins accepting substantial external contributions, prepares stable releases, or introduces features that materially change privacy or security risks.

## 11. Governance limitations

No policy can guarantee absolute security. A compromised administrator account, stolen credentials, platform-level compromise, or misconfigured repository controls can defeat protections. The project should reduce these risks through layered controls, least privilege, testing, auditability, and recovery planning, and should distinguish documented rules from controls that have actually been configured and tested.

## 12. Platform UI and native integration policy

- Shared domain and data layers must not depend on UI frameworks or operating-system-specific widgets.
- Platform-specific UI selection must be isolated behind a documented boundary.
- Android, iOS, and desktop interfaces should follow relevant platform conventions where practical, without requiring the entire application to be duplicated.
- Linux core functionality must not require a specific distribution or desktop environment.
- GTK/Libadwaita and Qt/Kirigami integrations are optional and require a documented technical reason, explicit fallback behavior where practical, and validation evidence.
- Do not claim native appearance, accessibility, hardware connectivity, or platform support solely because Flutter can compile for that target.
- Platform support records must identify the tested OS/version, desktop environment where relevant, packaging route, test scope, results, and known limitations.
- Changes to this strategy require an Architecture Decision Record and tests appropriate to the affected platforms.

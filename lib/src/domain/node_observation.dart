import 'dart:convert';

/// The transport or action from which an observation was collected.
enum ObservationSource {
  radio,
  mqtt,
  file,
  manual,
}

/// A point-in-time observation of a Meshtastic node.
///
/// This model deliberately does not treat a display name as a unique identity.
/// Source-specific observations remain separate until an explicit identity
/// resolution policy can safely associate them.
class NodeObservation {
  const NodeObservation({
    required this.observationId,
    required this.eventId,
    required this.source,
    required this.receivedAt,
    required this.createdAt,
    required this.rawFields,
    this.sourceNodeId,
    this.displayName,
    this.observedAt,
    this.rssiDbm,
    this.snrDb,
    this.hopCount,
  });

  final String observationId;
  final String eventId;
  final ObservationSource source;
  final String? sourceNodeId;
  final String? displayName;
  final DateTime? observedAt;
  final DateTime receivedAt;
  final DateTime createdAt;
  final int? rssiDbm;
  final double? snrDb;
  final int? hopCount;

  /// Parsed fields retained for forward compatibility and diagnostics.
  /// Values are not translated or rewritten for localization.
  final Map<String, Object?> rawFields;

  /// Produces values for the node_observations table.
  /// The referenced source event must be inserted first.
  Map<String, Object?> toDatabaseMap() => {
        'observation_id': observationId,
        'event_id': eventId,
        'source_type': source.name,
        'source_node_id': sourceNodeId,
        'display_name': displayName,
        'observed_at_utc': observedAt?.toUtc().toIso8601String(),
        'received_at_utc': receivedAt.toUtc().toIso8601String(),
        'rssi_dbm': rssiDbm,
        'snr_db': snrDb,
        'hop_count': hopCount,
        'raw_fields_json': jsonEncode(rawFields),
        'created_at_utc': createdAt.toUtc().toIso8601String(),
      };

  static ObservationSource sourceFromString(String value) {
    return ObservationSource.values.firstWhere(
      (source) => source.name == value,
      orElse: () => throw ArgumentError.value(
        value,
        'value',
        'Unknown observation source',
      ),
    );
  }
}

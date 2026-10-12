/// Metadata and original evidence for one item received from a source.
///
/// Source payloads are not localized or rewritten. The raw payload may be
/// absent when the source/API does not expose it or the format cannot be kept.
class SourceEvent {
  const SourceEvent({
    required this.eventId,
    required this.sourceType,
    required this.receivedAt,
    required this.createdAt,
    this.sourceInstance,
    this.observedAt,
    this.payloadFormat,
    this.rawPayload,
    this.payloadEncoding,
    this.parseStatus = EventParseStatus.pending,
    this.parserVersion,
    this.errorMessage,
  });

  final String eventId;
  final String sourceType;
  final String? sourceInstance;
  final DateTime receivedAt;
  final DateTime? observedAt;
  final String? payloadFormat;
  final String? rawPayload;
  final String? payloadEncoding;
  final EventParseStatus parseStatus;
  final String? parserVersion;
  final String? errorMessage;
  final DateTime createdAt;

  Map<String, Object?> toDatabaseMap() => {
        'event_id': eventId,
        'source_type': sourceType,
        'source_instance': sourceInstance,
        'received_at_utc': receivedAt.toUtc().toIso8601String(),
        'observed_at_utc': observedAt?.toUtc().toIso8601String(),
        'payload_format': payloadFormat,
        'raw_payload': rawPayload,
        'payload_encoding': payloadEncoding,
        'parse_status': parseStatus.name,
        'parser_version': parserVersion,
        'error_message': errorMessage,
        'created_at_utc': createdAt.toUtc().toIso8601String(),
      };
}

enum EventParseStatus {
  pending,
  parsed,
  partial,
  failed,
}

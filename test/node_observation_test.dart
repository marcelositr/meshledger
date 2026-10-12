import 'package:flutter_test/flutter_test.dart';
import 'package:meshledger/src/domain/node_observation.dart';

void main() {
  group('NodeObservation', () {
    test('serializes source and timestamps without changing the source ID', () {
      final receivedAt = DateTime.parse('2026-10-12T15:00:00-03:00');
      final observedAt = DateTime.parse('2026-10-12T18:00:00Z');

      final observation = NodeObservation(
        observationId: 'obs-1',
        eventId: 'event-1',
        source: ObservationSource.mqtt,
        sourceNodeId: '!a1b2c3d4',
        displayName: 'PU2OMT-1',
        receivedAt: receivedAt,
        observedAt: observedAt,
        rssiDbm: -87,
        snrDb: 7.5,
        hopCount: 1,
        rawFields: const {'originalName': 'PU2OMT-1'},
      );

      final map = observation.toDatabaseMap();

      expect(map['source_type'], 'mqtt');
      expect(map['source_node_id'], '!a1b2c3d4');
      expect(map['received_at_utc'], receivedAt.toUtc().toIso8601String());
      expect(map['observed_at_utc'], observedAt.toUtc().toIso8601String());
    });

    test('rejects unknown source values instead of guessing', () {
      expect(
        () => NodeObservation.sourceFromString('unknown'),
        throwsArgumentError,
      );
    });
  });
}

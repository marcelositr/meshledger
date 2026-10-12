import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show Database, databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:meshledger/src/data/local_database.dart';
import 'package:meshledger/src/data/observation_repository.dart';
import 'package:meshledger/src/domain/node_observation.dart';
import 'package:meshledger/src/domain/source_event.dart';

void main() {
  late Directory temporaryDirectory;
  late Database database;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('meshledger-test-');
    database = await LocalDatabase.open(
      databasePath: p.join(temporaryDirectory.path, 'test.db'),
    );
  });

  tearDown(() async {
    await database.close();
    await temporaryDirectory.delete(recursive: true);
  });

  test('records source evidence and observation in one transaction', () async {
    final now = DateTime.utc(2026, 10, 12, 18);
    final event = SourceEvent(
      eventId: 'event-1',
      source: ObservationSource.mqtt,
      receivedAt: now,
      createdAt: now,
      payloadFormat: 'json',
      rawPayload: '{"nodeId":"!a1b2c3d4"}',
      payloadEncoding: 'utf-8',
      parseStatus: EventParseStatus.parsed,
    );
    final observation = NodeObservation(
      observationId: 'observation-1',
      eventId: 'event-1',
      source: ObservationSource.mqtt,
      sourceNodeId: '!a1b2c3d4',
      displayName: 'PU2OMT-1',
      receivedAt: now,
      createdAt: now,
      rawFields: const {'nodeId': '!a1b2c3d4'},
    );

    await ObservationRepository(database).record(
      event: event,
      observation: observation,
    );

    final events = await database.query('source_events');
    final observations = await database.query('node_observations');

    expect(events, hasLength(1));
    expect(events.single['raw_payload'], '{"nodeId":"!a1b2c3d4"}');
    expect(observations, hasLength(1));
    expect(observations.single['source_node_id'], '!a1b2c3d4');
  });

  test('rejects mismatched event and observation sources', () async {
    final now = DateTime.utc(2026, 10, 12, 18);
    final event = SourceEvent(
      eventId: 'event-2',
      source: ObservationSource.radio,
      receivedAt: now,
      createdAt: now,
    );
    final observation = NodeObservation(
      observationId: 'observation-2',
      eventId: 'event-2',
      source: ObservationSource.mqtt,
      receivedAt: now,
      createdAt: now,
      rawFields: const {},
    );

    await expectLater(
      ObservationRepository(database).record(
        event: event,
        observation: observation,
      ),
      throwsArgumentError,
    );

    expect(await database.query('source_events'), isEmpty);
    expect(await database.query('node_observations'), isEmpty);
  });
}

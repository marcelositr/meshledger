import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show DatabaseException;
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart'
    show Database, databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
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
    await ObservationRepository(database).record(
      event: _event(),
      observation: _observation(),
    );

    final events = await database.query('source_events');
    final observations = await database.query('node_observations');

    expect(events, hasLength(1));
    expect(events.single['raw_payload'], '{"nodeId":"!a1b2c3d4"}');
    expect(observations, hasLength(1));
    expect(observations.single['source_node_id'], '!a1b2c3d4');
  });

  test('rejects mismatched event and observation sources', () async {
    await expectLater(
      ObservationRepository(database).record(
        event: _event(eventId: 'event-2', source: ObservationSource.radio),
        observation: _observation(
          observationId: 'observation-2',
          eventId: 'event-2',
        ),
      ),
      throwsArgumentError,
    );

    expect(await database.query('source_events'), isEmpty);
    expect(await database.query('node_observations'), isEmpty);
  });

  test('rejects mismatched event IDs before writing either record', () async {
    await expectLater(
      ObservationRepository(database).record(
        event: _event(),
        observation: _observation(eventId: 'different-event'),
      ),
      throwsArgumentError,
    );

    expect(await database.query('source_events'), isEmpty);
    expect(await database.query('node_observations'), isEmpty);
  });

  test('rolls back the source event when observation insertion fails',
      () async {
    final repository = ObservationRepository(database);
    await repository.record(
      event: _event(),
      observation: _observation(),
    );

    await expectLater(
      repository.record(
        event: _event(eventId: 'event-2'),
        observation: _observation(
          observationId: 'observation-1',
          eventId: 'event-2',
        ),
      ),
      throwsA(isA<DatabaseException>()),
    );

    expect(await database.query('source_events'), hasLength(1));
    expect(await database.query('node_observations'), hasLength(1));
    expect(
      (await database.query('source_events')).single['event_id'],
      'event-1',
    );
  });

  test('rejects observations without an existing source event', () async {
    await expectLater(
      database.insert(
        'node_observations',
        _observation(eventId: 'missing-event').toDatabaseMap(),
      ),
      throwsA(isA<DatabaseException>()),
    );

    expect(await database.query('node_observations'), isEmpty);
  });

  test('duplicate event IDs fail without replacing existing evidence',
      () async {
    final repository = ObservationRepository(database);
    await repository.record(
      event: _event(rawPayload: 'original evidence'),
      observation: _observation(),
    );

    await expectLater(
      repository.record(
        event: _event(rawPayload: 'replacement evidence'),
        observation: _observation(observationId: 'observation-2'),
      ),
      throwsA(isA<DatabaseException>()),
    );

    final events = await database.query('source_events');
    final observations = await database.query('node_observations');

    expect(events, hasLength(1));
    expect(events.single['raw_payload'], 'original evidence');
    expect(observations, hasLength(1));
    expect(observations.single['observation_id'], 'observation-1');
  });

  test('schema version, foreign key, and indexes are present', () async {
    final versionRows = await database.rawQuery('PRAGMA user_version');
    expect(versionRows.single['user_version'], LocalDatabase.schemaVersion);

    final foreignKeys =
        await database.rawQuery('PRAGMA foreign_key_list(node_observations)');
    expect(foreignKeys, hasLength(1));
    expect(foreignKeys.single['table'], 'source_events');
    expect(foreignKeys.single['from'], 'event_id');
    expect(foreignKeys.single['to'], 'event_id');

    final indexRows = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index'",
    );
    final indexNames = indexRows.map((row) => row['name']).toList();

    expect(
      indexNames,
      containsAll([
        'idx_source_events_received_at',
        'idx_observations_source_node',
        'idx_observations_received_at',
      ]),
    );
  });
}

SourceEvent _event({
  String eventId = 'event-1',
  ObservationSource source = ObservationSource.mqtt,
  String? rawPayload = '{"nodeId":"!a1b2c3d4"}',
}) {
  final now = DateTime.utc(2026, 10, 12, 18);

  return SourceEvent(
    eventId: eventId,
    source: source,
    receivedAt: now,
    createdAt: now,
    payloadFormat: 'json',
    rawPayload: rawPayload,
    payloadEncoding: 'utf-8',
    parseStatus: EventParseStatus.parsed,
  );
}

NodeObservation _observation({
  String observationId = 'observation-1',
  String eventId = 'event-1',
  ObservationSource source = ObservationSource.mqtt,
}) {
  final now = DateTime.utc(2026, 10, 12, 18);

  return NodeObservation(
    observationId: observationId,
    eventId: eventId,
    source: source,
    sourceNodeId: '!a1b2c3d4',
    displayName: 'PU2OMT-1',
    receivedAt: now,
    createdAt: now,
    rawFields: const {'nodeId': '!a1b2c3d4'},
  );
}

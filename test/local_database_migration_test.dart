import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show Database, openDatabase;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:meshledger/src/data/local_database.dart';

void main() {
  late Directory temporaryDirectory;
  late String databasePath;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('meshledger-migration-');
    databasePath = p.join(temporaryDirectory.path, 'legacy.db');
  });

  tearDown(() async {
    await temporaryDirectory.delete(recursive: true);
  });

  test('upgrades version 1 without losing source evidence', () async {
    final legacyDatabase = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE source_events (
            event_id TEXT PRIMARY KEY NOT NULL,
            source_type TEXT NOT NULL,
            received_at_utc TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE node_observations (
            observation_id TEXT PRIMARY KEY NOT NULL,
            event_id TEXT NOT NULL,
            FOREIGN KEY (event_id) REFERENCES source_events(event_id)
          )
        ''');
        await db.insert('source_events', {
          'event_id': 'legacy-event',
          'source_type': 'mqtt',
          'received_at_utc': '2026-10-12T18:00:00Z',
        });
        await db.insert('node_observations', {
          'observation_id': 'legacy-observation',
          'event_id': 'legacy-event',
        });
      },
    );
    await legacyDatabase.close();

    final upgradedDatabase =
        await LocalDatabase.open(databasePath: databasePath);
    addTearDown(upgradedDatabase.close);

    final versionRows =
        await upgradedDatabase.rawQuery('PRAGMA user_version');
    expect(versionRows.single['user_version'], LocalDatabase.schemaVersion);

    expect(
      (await upgradedDatabase.query('source_events')).single['event_id'],
      'legacy-event',
    );
    expect(
      (await upgradedDatabase.query('node_observations'))
          .single['observation_id'],
      'legacy-observation',
    );

    final indexes = await upgradedDatabase.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index'",
    );
    expect(
      indexes.map((row) => row['name']),
      contains('idx_source_events_source_received_at'),
    );
  });
}

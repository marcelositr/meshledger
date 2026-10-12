import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Opens the local MeshLedger database and owns its initial schema.
///
/// Schema changes must be versioned with explicit migrations. Never silently
/// discard source events or observations during an upgrade.
class LocalDatabase {
  LocalDatabase._();

  static const databaseName = 'meshledger.db';
  static const schemaVersion = 1;

  static Future<Database> open() async {
    final databasePath = p.join(await getDatabasesPath(), databaseName);

    return openDatabase(
      databasePath,
      version: schemaVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
      },
    );
  }

  static Future<void> _createSchema(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE source_events (
        event_id TEXT PRIMARY KEY NOT NULL,
        source_type TEXT NOT NULL
          CHECK (source_type IN ('radio', 'mqtt', 'file', 'manual')),
        source_instance TEXT,
        received_at_utc TEXT NOT NULL,
        observed_at_utc TEXT,
        payload_format TEXT,
        raw_payload TEXT,
        payload_encoding TEXT,
        parse_status TEXT NOT NULL DEFAULT 'pending'
          CHECK (parse_status IN ('pending', 'parsed', 'partial', 'failed')),
        parser_version TEXT,
        error_message TEXT,
        created_at_utc TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE node_observations (
        observation_id TEXT PRIMARY KEY NOT NULL,
        event_id TEXT NOT NULL,
        source_type TEXT NOT NULL
          CHECK (source_type IN ('radio', 'mqtt', 'file', 'manual')),
        source_node_id TEXT,
        display_name TEXT,
        observed_at_utc TEXT,
        received_at_utc TEXT NOT NULL,
        rssi_dbm INTEGER,
        snr_db REAL,
        hop_count INTEGER,
        raw_fields_json TEXT NOT NULL DEFAULT '{}',
        created_at_utc TEXT NOT NULL,
        FOREIGN KEY (event_id) REFERENCES source_events(event_id)
          ON DELETE RESTRICT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_source_events_received_at
      ON source_events(received_at_utc)
    ''');

    await db.execute('''
      CREATE INDEX idx_observations_source_node
      ON node_observations(source_type, source_node_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_observations_received_at
      ON node_observations(received_at_utc)
    ''');
  }
}

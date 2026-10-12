import 'package:sqflite/sqflite.dart';

import '../domain/node_observation.dart';
import '../domain/source_event.dart';

/// Persists original source evidence and its parsed observation together.
///
/// A failed observation insert rolls back the source event insert, avoiding
/// orphaned half-records. Repeated IDs fail rather than silently overwrite
/// existing evidence.
class ObservationRepository {
  const ObservationRepository(this._database);

  final Database _database;

  Future<void> record({
    required SourceEvent event,
    required NodeObservation observation,
  }) async {
    if (event.eventId != observation.eventId) {
      throw ArgumentError('The event and observation must share an event ID.');
    }
    if (event.sourceType != observation.source.name) {
      throw ArgumentError('The event and observation source types must match.');
    }

    await _database.transaction((transaction) async {
      await transaction.insert(
        'source_events',
        event.toDatabaseMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      await transaction.insert(
        'node_observations',
        observation.toDatabaseMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    });
  }
}

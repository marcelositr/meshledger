import 'package:sqflite/sqflite.dart';

import 'data/local_database.dart';
import 'data/observation_repository.dart';

/// Owns the long-lived dependencies shared by the application.
class AppDependencies {
  AppDependencies._({
    required this.database,
    required this.observationRepository,
  });

  final Database database;
  final ObservationRepository observationRepository;

  /// Opens persistent storage once and wires repositories to that connection.
  ///
  /// The caller owns this object and may close it when the application is shut
  /// down or when a test finishes. Widgets must not open or close the database.
  static Future<AppDependencies> open({String? databasePath}) async {
    final database = await LocalDatabase.open(databasePath: databasePath);
    return AppDependencies._(
      database: database,
      observationRepository: ObservationRepository(database),
    );
  }

  Future<void> close() => database.close();
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:meshledger/src/app_dependencies.dart';
import 'package:meshledger/src/data/observation_repository.dart';

void main() {
  late Directory temporaryDirectory;
  AppDependencies? dependencies;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('meshledger-startup-');
  });

  tearDown(() async {
    await dependencies?.close();
    dependencies = null;
    await temporaryDirectory.delete(recursive: true);
  });

  test('opens the database once and keeps it available to repositories',
      () async {
    dependencies = await AppDependencies.open(
      databasePath: p.join(temporaryDirectory.path, 'test.db'),
    );

    expect(dependencies!.database.isOpen, isTrue);
    expect(
      dependencies!.observationRepository,
      isA<ObservationRepository>(),
    );
    expect(
      await dependencies!.database.rawQuery('PRAGMA foreign_keys'),
      equals([{'foreign_keys': 1}]),
    );
    expect(
      await dependencies!.database.query('source_events'),
      isEmpty,
    );
  });

  test('closes the database once and safely accepts repeated close requests',
      () async {
    dependencies = await AppDependencies.open(
      databasePath: p.join(temporaryDirectory.path, 'close.db'),
    );
    final database = dependencies!.database;

    expect(database.isOpen, isTrue);

    await dependencies!.close();
    expect(database.isOpen, isFalse);

    await dependencies!.close();
    expect(database.isOpen, isFalse);

    dependencies = null;
  });
}

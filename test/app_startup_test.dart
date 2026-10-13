import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:meshledger/src/app.dart';
import 'package:meshledger/src/app_dependencies.dart';

void main() {
  late Directory temporaryDirectory;
  AppDependencies? dependencies;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    temporaryDirectory =
        await Directory.systemTemp.createTemp('meshledger-app-startup-');
  });

  tearDown(() async {
    await dependencies?.close();
    await temporaryDirectory.delete(recursive: true);
  });

  testWidgets('shows loading and then the ready state', (tester) async {
    final completer = Completer<AppDependencies>();

    await tester.pumpWidget(
      MeshLedgerApp(dependenciesLoader: () => completer.future),
    );
    await tester.pump();

    expect(find.text('Opening local database…'), findsOneWidget);

    dependencies = await AppDependencies.open(
      databasePath: p.join(temporaryDirectory.path, 'ready.db'),
    );
    completer.complete(dependencies);

    await tester.pumpAndSettle();

    expect(
      find.text('Local database opened and kept available.'),
      findsOneWidget,
    );
    expect(find.text('The foundation is in place'), findsOneWidget);
  });

  testWidgets('shows an error and retry recovers after startup failure',
      (tester) async {
    var attempts = 0;

    Future<AppDependencies> loadDependencies() {
      attempts++;
      if (attempts == 1) {
        return Future<AppDependencies>.error(
          StateError('Simulated database startup failure'),
        );
      }
      return AppDependencies.open(
        databasePath: p.join(temporaryDirectory.path, 'retry.db'),
      ).then((value) {
        dependencies = value;
        return value;
      });
    }

    await tester.pumpWidget(
      MeshLedgerApp(dependenciesLoader: loadDependencies),
    );
    await tester.pumpAndSettle();

    expect(find.text('Could not open the local database.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(
      find.text('Local database opened and kept available.'),
      findsOneWidget,
    );
  });
}

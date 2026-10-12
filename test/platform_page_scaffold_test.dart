import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshledger/src/ui/platform/platform_page_scaffold.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('uses Cupertino navigation conventions on iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(
      const CupertinoApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(CupertinoNavigationBar), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });

  testWidgets('uses Material app bar conventions on Android', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    await tester.pumpWidget(
      const MaterialApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });

  testWidgets('uses desktop page framing on Linux', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;

    await tester.pumpWidget(
      const MaterialApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('MeshLedger'), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });
}

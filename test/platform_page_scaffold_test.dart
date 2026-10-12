import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meshledger/src/ui/platform/platform_page_scaffold.dart';

void main() {
  testWidgets('uses Cupertino navigation conventions on iOS', (tester) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          platform: TargetPlatform.iOS,
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(CupertinoNavigationBar), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });

  testWidgets('uses Material app bar conventions on Android', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          platform: TargetPlatform.android,
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });

  testWidgets('uses desktop page framing on Linux', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlatformPageScaffold(
          title: 'MeshLedger',
          platform: TargetPlatform.linux,
          child: Text('Page content'),
        ),
      ),
    );

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('MeshLedger'), findsOneWidget);
    expect(find.text('Page content'), findsOneWidget);
  });
}

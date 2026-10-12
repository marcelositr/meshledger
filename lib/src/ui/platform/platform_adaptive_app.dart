import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Selects the top-level navigation and design system for the current platform.
///
/// The application domain and data layers must not depend on this choice.
class PlatformAdaptiveApp extends StatelessWidget {
  const PlatformAdaptiveApp({super.key, required this.home});

  final Widget home;

  static bool get _usesCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    if (_usesCupertino) {
      return CupertinoApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      );
    }

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315B70),
        ),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}

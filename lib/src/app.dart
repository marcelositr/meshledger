import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import 'app_dependencies.dart';
import 'ui/platform/platform_adaptive_app.dart';
import 'ui/platform/platform_page_scaffold.dart';

typedef AppDependenciesLoader = Future<AppDependencies> Function();

class MeshLedgerApp extends StatelessWidget {
  const MeshLedgerApp({super.key, this.dependenciesLoader});

  final AppDependenciesLoader? dependenciesLoader;

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveApp(
      home: AppStartupPage(dependenciesLoader: dependenciesLoader),
    );
  }
}

class AppStartupPage extends StatefulWidget {
  const AppStartupPage({super.key, this.dependenciesLoader});

  final AppDependenciesLoader? dependenciesLoader;

  @override
  State<AppStartupPage> createState() => _AppStartupPageState();
}

class _AppStartupPageState extends State<AppStartupPage> {
  late Future<AppDependencies> _dependencies;

  @override
  void initState() {
    super.initState();
    _openDependencies();
  }

  void _openDependencies() {
    final loader = widget.dependenciesLoader;
    _dependencies = Future<AppDependencies>.sync(
      () => loader != null ? loader() : AppDependencies.open(),
    );
  }

  void _retry() {
    setState(_openDependencies);
  }

  @override
  void dispose() {
    // If initialization finishes after this page is removed, release the
    // connection too. Failed initialization has no connection to close.
    unawaited(
      _dependencies.then<void>(
        (dependencies) => dependencies.close(),
        onError: (Object _, StackTrace __) {},
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return FutureBuilder<AppDependencies>(
      future: _dependencies,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _StartupStatusPage(
            message: strings.databaseChecking,
            icon: Icons.storage_outlined,
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _StartupStatusPage(
            message: strings.databaseError,
            icon: Icons.error_outline,
            action: defaultTargetPlatform == TargetPlatform.iOS
                ? CupertinoButton(
                    onPressed: _retry,
                    child: Text(strings.databaseRetry),
                  )
                : FilledButton(
                    onPressed: _retry,
                    child: Text(strings.databaseRetry),
                  ),
          );
        }

        return HomePage(dependencies: snapshot.data!);
      },
    );
  }
}

class _StartupStatusPage extends StatelessWidget {
  const _StartupStatusPage({
    required this.message,
    required this.icon,
    this.action,
  });

  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return PlatformPageScaffold(
      title: strings.appTitle,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              if (action != null) ...[
                const SizedBox(height: 16),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    const accent = Color(0xFF315B70);
    final databaseMessage = dependencies.database.isOpen
        ? strings.databaseReady
        : strings.databaseError;

    return PlatformPageScaffold(
      title: strings.appTitle,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.hub_outlined, size: 44, color: accent),
                const SizedBox(height: 20),
                Text(
                  strings.foundationHeading,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(strings.appSubtitle),
                const SizedBox(height: 16),
                Text(strings.foundationDescription),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      dependencies.database.isOpen
                          ? Icons.storage_outlined
                          : Icons.error_outline,
                      color: dependencies.database.isOpen
                          ? accent
                          : const Color(0xFFB3261E),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(databaseMessage)),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  strings.developmentNotice,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import 'data/local_database.dart';
import 'ui/platform/platform_adaptive_app.dart';
import 'ui/platform/platform_page_scaffold.dart';

class MeshLedgerApp extends StatelessWidget {
  const MeshLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<void> _databaseStartup;

  @override
  void initState() {
    super.initState();
    _databaseStartup = _openDatabase();
  }

  Future<void> _openDatabase() async {
    final database = await LocalDatabase.open();
    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    const accent = Color(0xFF315B70);

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
                FutureBuilder<void>(
                  future: _databaseStartup,
                  builder: (context, snapshot) {
                    final isWaiting =
                        snapshot.connectionState == ConnectionState.waiting;
                    final isError = snapshot.hasError;
                    final message = isWaiting
                        ? strings.databaseChecking
                        : isError
                            ? strings.databaseError
                            : strings.databaseReady;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isError
                              ? Icons.error_outline
                              : Icons.storage_outlined,
                          color: isError ? const Color(0xFFB3261E) : accent,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(message)),
                      ],
                    );
                  },
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

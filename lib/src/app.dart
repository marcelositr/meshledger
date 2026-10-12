import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import 'data/local_database.dart';

class MeshLedgerApp extends StatelessWidget {
  const MeshLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315B70)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hub_outlined, size: 44, color: colors.primary),
                const SizedBox(height: 20),
                Text(
                  strings.foundationHeading,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(strings.appSubtitle),
                const SizedBox(height: 16),
                Text(strings.foundationDescription),
                const SizedBox(height: 24),
                FutureBuilder<void>(
                  future: _databaseStartup,
                  builder: (context, snapshot) {
                    final message = switch (snapshot.connectionState) {
                      ConnectionState.waiting => strings.databaseChecking,
                      _ when snapshot.hasError => strings.databaseError,
                      _ => strings.databaseReady,
                    };
                    final isError = snapshot.hasError;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isError ? Icons.error_outline : Icons.storage_outlined,
                          color: isError ? colors.error : colors.primary,
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
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

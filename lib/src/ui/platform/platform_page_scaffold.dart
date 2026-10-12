import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Minimal page frame that follows broad platform conventions.
///
/// Desktop uses a deliberately restrained shell built from Flutter widgets,
/// rather than claiming to be a native GTK, Qt, WinUI, or AppKit interface.
/// Deeper native integrations must remain optional and separately tested.
class PlatformPageScaffold extends StatelessWidget {
  const PlatformPageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.platform,
  });

  final String title;
  final Widget child;

  /// Optional platform override, primarily useful for deterministic widget tests.
  /// In normal application use, the current platform is detected automatically.
  final TargetPlatform? platform;

  @override
  Widget build(BuildContext context) {
    switch (platform ?? defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(title),
          ),
          child: SafeArea(child: child),
        );
      case TargetPlatform.android:
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: child,
        );
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
        return _DesktopPageScaffold(title: title, child: child);
    }
  }
}

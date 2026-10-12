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
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
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

class _DesktopPageScaffold extends StatelessWidget {
  const _DesktopPageScaffold({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F6),
                border: Border(
                  bottom: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF202124),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

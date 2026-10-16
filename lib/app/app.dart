import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:material_ui_packages_migration/app/router.dart';
import 'package:material_ui_packages_migration/core/theme/app_theme.dart';

class ReleaseNotesApp extends StatefulWidget {
  const ReleaseNotesApp({super.key});

  @override
  State<ReleaseNotesApp> createState() => _ReleaseNotesAppState();
}

class _ReleaseNotesAppState extends State<ReleaseNotesApp> {
  final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Release notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
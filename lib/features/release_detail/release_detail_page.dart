import 'package:material_ui/material_ui.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'package:material_ui_packages_migration/core/data/releases.dart';

class ReleaseDetailPage extends StatelessWidget {
  const ReleaseDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final Release? release = releaseById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          release == null ? 'Not found' : 'Version ${release.version}',
        ),
      ),
      body: release == null
          ? const Center(child: Text('This release does not exist.'))
          : Markdown(
              data: release.notes,
              styleSheet: MarkdownStyleSheet(
                code: TextStyle(
                  backgroundColor: Theme.of(context).cardTheme.color,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
    );
  }
}

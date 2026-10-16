import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:material_ui_packages_migration/app/app.dart';
import 'package:material_ui_packages_migration/core/theme/app_theme.dart';

TextStyle? firstStyle(InlineSpan span) {
  if (span.style != null) {
    return span.style;
  }
  if (span is TextSpan && span.children != null) {
    for (final InlineSpan child in span.children!) {
      final TextStyle? style = firstStyle(child);
      if (style != null) {
        return style;
      }
    }
  }
  return null;
}

Future<void> openRelease3(WidgetTester tester) async {
  await tester.pumpWidget(const ReleaseNotesApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('Version 3.0.0'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Markdown text uses the app font', (WidgetTester tester) async {
    await openRelease3(tester);

    final RichText paragraph = tester.widget<RichText>(
      find.byWidgetPredicate(
            (Widget widget) =>
        widget is RichText &&
            widget.text.toPlainText().startsWith('Notely now saves'),
      ),
    );
    expect(firstStyle(paragraph.text)?.fontFamily, startsWith('Merriweather'));
  });

  testWidgets('Markdown code block uses the app card color', (WidgetTester tester) async {
    await openRelease3(tester);

    expect(
      find.byWidgetPredicate(
            (Widget widget) =>
        widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == AppTheme.codeBlock,
      ),
      findsOneWidget,
    );
  });
}
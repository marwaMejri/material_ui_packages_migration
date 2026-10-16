import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:material_ui_packages_migration/app/app.dart';

void main() {
  testWidgets('the app title uses the Google font', (WidgetTester tester) async {
    await tester.pumpWidget(const ReleaseNotesApp());
    await tester.pumpAndSettle();

    final RichText title = tester.widget<RichText>(
      find.descendant(
        of: find.text('Notely releases'),
        matching: find.byType(RichText),
      ),
    );
    expect(title.text.style?.fontFamily, startsWith('Merriweather'));
  });
}
import 'package:flutter_test/flutter_test.dart';

import 'package:material_ui_packages_migration/app/app.dart';

void main() {
  testWidgets('the channel can be changed to Beta', (WidgetTester tester) async {
    await tester.pumpWidget(const ReleaseNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Update channel'), findsOneWidget);
    expect(find.text('Stable'), findsOneWidget);

    await tester.tap(find.text('Stable'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();

    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Stable'), findsNothing);
  });
}
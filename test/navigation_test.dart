import 'package:flutter_test/flutter_test.dart';

import 'package:material_ui_packages_migration/app/app.dart';
import 'package:material_ui_packages_migration/features/release_detail/release_detail_page.dart';
import 'package:material_ui_packages_migration/features/releases/releases_page.dart';

void main() {
  testWidgets('opening a release plays a page transition', (WidgetTester tester) async {
    await tester.pumpWidget(const ReleaseNotesApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Version 3.0.0'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ReleasesPage), findsOneWidget);
    expect(find.byType(ReleaseDetailPage), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(ReleasesPage), findsNothing);
    expect(find.byType(ReleaseDetailPage), findsOneWidget);
  });
}
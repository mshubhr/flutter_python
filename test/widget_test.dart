// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_flutter_python/main.dart';

void main() {
  testWidgets('Splash screen displays', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SplashApp());

    // Verify splash content is shown.
    expect(find.text('TODO Flutter + Python'), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
  });
}

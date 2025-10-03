import 'package:book_store_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Profile shows mock data and Edit updates name; theme colors applied',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    // Navigate to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    // Initial mock data
    expect(find.text('Reader'), findsOneWidget);
    expect(find.text('reader@example.com'), findsOneWidget);

    // Tap Edit to update name via UserState.update(name: 'Ocean Reader')
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    // Name updated
    expect(find.text('Ocean Reader'), findsOneWidget);

    // Theme adherence basic checks: verify primary present in widgets
    final primaryBlue = const Color(0xFF2563EB);
    // App uses primary in multiple icons and containers; ensure at least one widget uses primary color
    final primaryIcon = find.byWidgetPredicate((w) =>
        (w is Icon && (w.color == primaryBlue)) ||
        (w is CircleAvatar && w.backgroundColor == primaryBlue.withAlpha(30)));
    expect(primaryIcon, findsWidgets);

    // Responsiveness: resize to a common device size and ensure layout builds
    final view = tester.view;
    view.physicalSize = const Size(390, 844);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
  });
}

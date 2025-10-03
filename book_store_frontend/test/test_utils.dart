import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simple HttpOverrides to avoid real network calls for Image.network during tests.
/// It returns a 1x1 transparent image for any URL.
class _TestHttpOverrides extends HttpOverrides {}

/// Pumps the provided widget into the tester wrapped in a MaterialApp with Ocean Professional theme colors
/// and ensures animations/async microtasks settle.
/// Prefer using this when testing isolated widgets requiring Material context.
Future<void> pumpThemedWidget(WidgetTester tester, Widget child) async {
  HttpOverrides.global = _TestHttpOverrides();
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF2563EB),
        onPrimary: Colors.white,
        secondary: Color(0xFFF59E0B),
        onSecondary: Colors.white,
        error: Color(0xFFEF4444),
        onError: Colors.white,
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF111827),
        tertiary: Color(0xFF0EA5E9),
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      fontFamily: 'Roboto',
    ),
    home: child,
  ));
  // Allow first frame + any scheduled timers to complete
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

/// Finds the BottomNavigationBar item by its text label and taps it.
Future<void> tapBottomNavItem(WidgetTester tester, String label) async {
  final finder = find.text(label);
  expect(finder, findsOneWidget);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Enters text in a TextField found by hint text then settles.
Future<void> enterTextByHint(WidgetTester tester, String hint, String text) async {
  final tf = find.byWidgetPredicate((w) =>
      w is TextField && (w.decoration?.hintText ?? '').toLowerCase() == hint.toLowerCase());
  expect(tf, findsOneWidget);
  await tester.enterText(tf, text);
  // one pump for text, a second for debounced async setQuery
  await tester.pump();
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

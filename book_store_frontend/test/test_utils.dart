import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Provides a 1x1 transparent image as MemoryImage to avoid real network image
/// fetching in tests. Use this to prime the ImageCache when tests create
/// Image.network/NetworkImage widgets.
ImageProvider transparentImageProvider() {
  // Tiny 1x1 transparent PNG bytes
  const List<int> kTransparentImage = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0xDA, 0x63, 0xF8, 0xCF, 0xC0, 0x00,
    0x00, 0x03, 0x01, 0x01, 0x00, 0x18, 0xDD, 0x8D,
    0x18, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E,
    0x44, 0xAE, 0x42, 0x60, 0x82,
  ];
  return MemoryImage(Uint8List.fromList(kTransparentImage));
}

/// Pumps the provided widget into the tester wrapped in a MaterialApp with Ocean Professional theme colors
/// and ensures animations/async microtasks settle.
/// Note: Tests that need to suppress real network fetches can rely on the test
/// environment not fetching images if they are offscreen; otherwise, image
/// widgets should be provided with a pre-cached transparent image where needed.
Future<void> pumpThemedWidget(WidgetTester tester, Widget child) async {
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

/// Pre-cache a transparent image into the provided BuildContext so that
/// NetworkImage widgets that get substituted can resolve synchronously.
Future<void> precacheTransparentImage(BuildContext context) async {
  await precacheImage(transparentImageProvider(), context);
}

/// Convenience to replace a widget subtree's ImageProvider to transparent by wrapping in Image widget.
Widget replaceWithTransparentImage({double? width, double? height, BoxFit? fit}) {
  return Image(image: transparentImageProvider(), width: width, height: height, fit: fit);
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

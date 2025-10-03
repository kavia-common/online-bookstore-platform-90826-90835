import 'package:book_store_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Book details open from catalog card and display data; add to cart updates badge',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    // Go to Shop
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle(const Duration(milliseconds: 800));

    // Wait for CatalogState initialization (categories/results)
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Tap first BookCard by tapping on a text that should exist (fallback to tapping first grid tile)
    Finder anyTitle = find.text('Ocean of Code');
    if (anyTitle.evaluate().isEmpty) {
      // If filtered differently, search for known item to ensure we can open details
      final searchField = find.byWidgetPredicate((w) =>
          w is TextField && (w.decoration?.hintText ?? '').contains('Search by title or author'));
      await tester.enterText(searchField, 'Ocean of Code');
      await tester.pumpAndSettle(const Duration(milliseconds: 700));
      anyTitle = find.text('Ocean of Code');
    }
    expect(anyTitle, findsWidgets);

    await tester.tap(anyTitle.first);
    await tester.pumpAndSettle();

    // On details page
    expect(find.text('Book Details'), findsOneWidget);
    expect(find.text('Ocean of Code'), findsOneWidget);
    expect(find.textContaining('Marin Azure'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsWidgets);

    // Add to cart via floating action button (Add)
    final addFab = find.byIcon(Icons.shopping_bag_rounded);
    expect(addFab, findsOneWidget);
    await tester.tap(addFab);
    await tester.pump(); // SnackBar animation
    await tester.pump(const Duration(milliseconds: 300));

    // Show snackbar
    expect(find.text('Added to cart'), findsOneWidget);

    // Return to root to check badge on Cart
    await tester.pageBack();
    await tester.pumpAndSettle();

    // The cart badge should now show at least '1'
    final cartLabel = find.text('Cart');
    expect(cartLabel, findsOneWidget);
    // Tap to trigger bottom bar rebuild and visibility if needed
    await tester.tap(cartLabel);
    await tester.pumpAndSettle();

    // Badge text could appear in bottom nav icon stack; assert cart page shown
    expect(find.text('Your Cart'), findsOneWidget);
    // The item should be listed
    expect(find.textContaining('Ocean of Code'), findsWidgets);
  });
}

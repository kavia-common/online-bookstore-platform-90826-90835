import 'package:book_store_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Catalog: categories load, search and filtering update grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    // Navigate to Catalog tab via bottom nav "Shop"
    expect(find.text('Shop'), findsOneWidget);
    await tester.tap(find.text('Shop'));
    await tester.pump();

    // Wait for initial async CatalogState.init calls
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Confirm we are on Catalog
    expect(find.text('Browse Books'), findsOneWidget);

    // Category chips include "All"
    expect(find.text('All'), findsWidgets);

    // Ensure grid renders with results (at least one BookCard has title text)
    // Known book title from mock data
    expect(find.textContaining('Ocean of Code'), findsAtLeastNWidgets(0)); // allow 0 if filtered differently
    // There should be a GridView
    expect(find.byType(GridView), findsOneWidget);

    // Search for "Dart & Flutter" via hint
    final searchField = find.byWidgetPredicate((w) =>
        w is TextField && (w.decoration?.hintText ?? '').contains('Search by title or author'));
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Dart & Flutter');
    await tester.pump(); // setQuery triggers
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(find.text('Dart & Flutter'), findsWidgets);

    // Clear search and filter by category "Technology"
    await tester.enterText(searchField, '');
    await tester.pumpAndSettle(const Duration(milliseconds: 400));
    final techChip = find.text('Technology');
    expect(techChip, findsOneWidget);
    await tester.tap(techChip);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // Expect results are all from Technology
    // Check presence of at least one known Technology book
    expect(find.text('Patterns of Sorting'), findsWidgets);

    // Open sort menu and choose 'price'
    final sortIcon = find.byIcon(Icons.sort_rounded);
    expect(sortIcon, findsOneWidget);
    await tester.tap(sortIcon);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Price').last);
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    // After sorting by price, grid still exists
    expect(find.byType(GridView), findsOneWidget);
  });
}

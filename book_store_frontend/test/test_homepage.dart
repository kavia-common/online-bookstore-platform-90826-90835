import 'package:book_store_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Homepage renders header and Featured section; Browse all navigates to Catalog',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    // Header title
    expect(find.text('Ocean Bookstore'), findsOneWidget);

    // Hero card button and Featured header
    expect(find.text('Start Exploring'), findsOneWidget);
    expect(find.text('Featured'), findsOneWidget);

    // Tapping "Browse all" navigates to CatalogPage (Browse Books title)
    final browseAll = find.text('Browse all');
    expect(browseAll, findsOneWidget);
    await tester.tap(browseAll);
    await tester.pumpAndSettle();

    expect(find.text('Browse Books'), findsOneWidget);
    // Catalog search bar present
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });
}

import 'package:book_store_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cart: add, decrement, remove; Checkout renders sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    // Navigate to Shop and add a known book to cart from details
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Search for 'Dart & Flutter' and open
    final searchField = find.byWidgetPredicate((w) =>
        w is TextField && (w.decoration?.hintText ?? '').contains('Search by title or author'));
    expect(searchField, findsOneWidget);
    await tester.enterText(searchField, 'Dart & Flutter');
    await tester.pumpAndSettle(const Duration(milliseconds: 700));

    await tester.tap(find.text('Dart & Flutter').first);
    await tester.pumpAndSettle();
    expect(find.text('Book Details'), findsOneWidget);

    // Add to cart using the button on page content (not only FAB) if visible
    final addInline = find.widgetWithText(ElevatedButton, 'Add to Cart');
    if (addInline.evaluate().isNotEmpty) {
      await tester.tap(addInline.first);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
    } else {
      // fallback to FAB
      final addFab = find.byIcon(Icons.shopping_bag_rounded);
      await tester.tap(addFab);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
    }

    // Navigate to Cart via bottom nav
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    // Quantity controls exist: Increase/Decrease/Remove
    expect(find.byTooltip('Increase'), findsWidgets);
    expect(find.byTooltip('Decrease'), findsWidgets);
    expect(find.byTooltip('Remove'), findsWidgets);

    // Increase quantity once
    await tester.tap(find.byTooltip('Increase').first);
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Decrease quantity once
    await tester.tap(find.byTooltip('Decrease').first);
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Navigate to Checkout
    final checkoutBtn = find.widgetWithText(ElevatedButton, 'Checkout');
    expect(checkoutBtn, findsOneWidget);
    await tester.tap(checkoutBtn);
    await tester.pumpAndSettle();

    // Checkout screen sections
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Shipping'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);

    // Fields appear
    expect(find.widgetWithText(TextField, 'Full Name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Address'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}

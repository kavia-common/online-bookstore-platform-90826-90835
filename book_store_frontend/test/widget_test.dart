import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_store_frontend/main.dart';

void main() {
  testWidgets('Loads home with Ocean Bookstore title', (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    expect(find.text('Ocean Bookstore'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
  });

  testWidgets('Bottom nav has Home, Shop, Cart, Profile', (WidgetTester tester) async {
    await tester.pumpWidget(const BookStoreApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

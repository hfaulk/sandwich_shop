import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      expect(
        find.text('0 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(
        find.text('1 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(
        find.text('1 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(
        find.text('0 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(
        find.text('0 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(
        find.text('0 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
    });

    testWidgets('does not increment above maxQuantity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      expect(
        find.text('5 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪🥪🥪🥪🥪'), findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wheat').last);
      await tester.pumpAndSettle();
      // The dropdown shows a visible "Wheat" label and the order display
      // shows "on wheat bread:" — assert the order display specifically
      expect(find.textContaining('wheat bread'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Italian').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('italian bread'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(
        find.byKey(const Key('notes_textfield')),
        'Extra mayo',
      );
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(home: Scaffold(body: testButton));
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      // Label is shown as a tooltip, not visible text, so check for Tooltip widget instead
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('0 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('3 footlong sandwich(es) on white bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('2 six-inch sandwich(es) on wheat bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.italian,
        orderNote: 'Lots of lettuce',
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);
      expect(
        find.text('1 footlong sandwich(es) on italian bread:'),
        findsOneWidget,
      );
      expect(find.text('🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });
}

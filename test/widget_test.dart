import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_animation/app.dart';
import 'package:pizza_animation/screens/home_screen.dart';
import 'package:pizza_animation/screens/splash_screen.dart';
import 'package:pizza_animation/widgets/curved_home_background.dart';
import 'package:pizza_animation/widgets/pizza_showcase.dart';
import 'package:pizza_animation/widgets/quantity_price_bar.dart';

void main() {
  testWidgets('opens splash then fades to home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PizzaApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Pizza Animation'), findsNothing);

    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('shows product home screen sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.byType(CurvedHomeBackground), findsOneWidget);
    expect(find.byType(QuantityPriceBar), findsOneWidget);
    expect(find.text('Pepperoni Blast'), findsOneWidget);
    expect(find.text('\$17.99'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('long press zoom stays on home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PizzaShowcase)),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.moveBy(const Offset(24, -20));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(PizzaShowcase), findsOneWidget);
  });

  testWidgets('horizontal swipe changes pizza showcase image', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.drag(find.byType(PizzaShowcase), const Offset(80, 0));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(PizzaShowcase), findsOneWidget);
  });
}

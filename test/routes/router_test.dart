import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realneers_reports/routes/router.dart';

void main() {
  testWidgets('Initial route is LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });

  testWidgets('Navigates to RegisterScreen when tapping Crear cuenta', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
      ),
    );

    // Ensure starting on LoginScreen
    expect(find.text('Login'), findsOneWidget);

    // Tap navigation button
    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();

    // Should be on RegisterScreen now
    expect(find.text('Registro'), findsOneWidget);
    expect(find.text('Registrarme'), findsOneWidget);
  });
}
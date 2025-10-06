import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:realneers_reports/features/home/presentation/screens/home_screen.dart';

class TestAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'home': {
        'reports': 'Reports',
        'profile': 'My Profile'
      },
      'app': {
        'title': 'Realneers Reports'
      }
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> _pumpLocalized(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'localization/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        assetLoader: TestAssetLoader(),
        child: Builder(
          builder: (ctx) => MaterialApp(
            localizationsDelegates: ctx.localizationDelegates,
            supportedLocales: ctx.supportedLocales,
            locale: ctx.locale,
            home: child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HomeScreen responsive UI', () {
    testWidgets('Mobile: shows BottomNavigationBar and Drawer; switches tabs', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(375, 812);
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      await _pumpLocalized(tester, const HomeScreen());

      // Expect bottom bar with two items and a drawer button
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Default tab title should be Reports
      expect(find.text('Reports'), findsWidgets);

      // Switch to Profile via bottom nav
      final bottomNav = find.byType(BottomNavigationBar);
      expect(bottomNav, findsOneWidget);
      // Tap the second item (index 1)
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Title should update to My Profile
      expect(find.text('My Profile'), findsWidgets);

      // Open drawer and ensure items exist
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.text('Reports'), findsWidgets);
      expect(find.text('My Profile'), findsWidgets);
    });

    testWidgets('Desktop: shows SideBar (NavigationRail) and no BottomNavigationBar', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1280, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      await _pumpLocalized(tester, const HomeScreen());

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);

      // Default selected is Reports
      expect(find.text('Reports'), findsWidgets);

      // Tap profile item on NavigationRail
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(find.text('My Profile'), findsWidgets);
    });

    testWidgets('Initial index out of bounds falls back to 0 (Reports)', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(375, 812);
      tester.binding.window.devicePixelRatioTestValue = 2.0;
      addTearDown(() {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
      });

      await _pumpLocalized(tester, const HomeScreen(initialIndex: 99));
      expect(find.text('Reports'), findsWidgets);
    });
  });
}
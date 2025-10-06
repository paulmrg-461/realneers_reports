import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class TestAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      'app': {
        'title': 'Realneers Reports'
      },
      'auth': {
        'login': {
          'title': 'Login',
          'button': 'Login',
          'create_account': 'Crear cuenta',
          'success': 'Inicio correcto',
          'error': 'Error de inicio'
        },
        'register': {
          'title': 'Registro',
          'button': 'Registrarme',
          'success': 'Registro correcto',
          'error': 'Error de registro',
          'save_profile_error': 'Error al guardar perfil'
        }
      },
      'input': {
        'name': {
          'label': 'Nombre',
          'hint': 'Tu nombre'
        },
        'email': {
          'label': 'Email',
          'hint': 'Tu correo electrónico'
        },
        'dni': {
          'label': 'DNI',
          'hint': 'Tu DNI'
        },
        'phone': {
          'label': 'Teléfono'
        },
        'password': {
          'label': 'Contraseña',
          'error': {
            'min_length': 'Mínimo 6 caracteres'
          }
        }
      },
      'custom_dropdown_searcher': {
        'search': 'Buscar',
        'cancel': 'Cancelar',
        'accept': 'Aceptar'
      }
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Initial route is LoginScreen', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(context.tr('auth.login.title'))),
            body: Center(
              child: TextButton(
                onPressed: () => context.go('/register'),
                child: Text(context.tr('auth.login.create_account')),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(context.tr('auth.register.title'))),
            body: Center(child: ElevatedButton(onPressed: () {}, child: Text(context.tr('auth.register.button')))),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'localization/translations',
        fallbackLocale: const Locale('es'),
        startLocale: const Locale('es'),
        assetLoader: TestAssetLoader(),
        child: Builder(
          builder: (ctx) => MaterialApp.router(
            localizationsDelegates: ctx.localizationDelegates,
            supportedLocales: ctx.supportedLocales,
            locale: ctx.locale,
            routerConfig: router,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
 
    expect(find.text('Login'), findsWidgets) ;
    expect(find.widgetWithText(TextButton, 'Crear cuenta'), findsOneWidget);
  });

  testWidgets('Navigates to RegisterScreen when tapping Crear cuenta', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(context.tr('auth.login.title'))),
            body: Center(
              child: TextButton(
                onPressed: () => context.go('/register'),
                child: Text(context.tr('auth.login.create_account')),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: Text(context.tr('auth.register.title'))),
            body: Center(child: ElevatedButton(onPressed: () {}, child: Text(context.tr('auth.register.button')))),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'localization/translations',
        fallbackLocale: const Locale('es'),
        startLocale: const Locale('es'),
        assetLoader: TestAssetLoader(),
        child: Builder(
          builder: (ctx) => MaterialApp.router(
            localizationsDelegates: ctx.localizationDelegates,
            supportedLocales: ctx.supportedLocales,
            locale: ctx.locale,
            routerConfig: router,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Ensure starting on LoginScreen
    expect(find.text('Login'), findsWidgets);

    // Tap navigation button using the specific button widget
    await tester.tap(find.widgetWithText(TextButton, 'Crear cuenta'));
    await tester.pumpAndSettle();

    // Should be on RegisterScreen now
    expect(find.widgetWithText(AppBar, 'Registro'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Registrarme'), findsOneWidget);
  });
}
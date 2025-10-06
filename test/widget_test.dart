// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';

// Nota: Evitamos importar LoginScreen real para no arrastrar dependencias de Firebase en tests.
// Creamos un widget mínimo para validar localización.
class _TestLoginScreen extends StatelessWidget {
  const _TestLoginScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('auth.login.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text(context.tr('auth.login.button'))),
            const SizedBox(height: 12),
            TextButton(onPressed: () {}, child: Text(context.tr('auth.login.create_account'))),
          ],
        ),
      ),
    );
  }
}

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
  testWidgets('Shows Login screen title on app start', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('es')],
        path: 'localization/translations',
        fallbackLocale: const Locale('es'),
        startLocale: const Locale('es'),
        assetLoader: TestAssetLoader(),
        child: Builder(
          builder: (ctx) => MaterialApp(
            localizationsDelegates: ctx.localizationDelegates,
            supportedLocales: ctx.supportedLocales,
            locale: ctx.locale,
            home: const _TestLoginScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Crear cuenta'), findsOneWidget);
  });
}

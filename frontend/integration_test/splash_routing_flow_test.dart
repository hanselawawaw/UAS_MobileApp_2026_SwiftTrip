import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/splash/splash_screen.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';

// ============================================================
// FLOW: Splash Routing
// App boots → splash renders → animation plays → routes to Login
// ============================================================

const _secureStorageChannel = MethodChannel(
  'plugins.it_nomads.com/flutter_secure_storage',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, (call) async {
      if (call.method == 'read') return null;
      if (call.method == 'write') return null;
      if (call.method == 'delete') return null;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, null);
  });

  group('Splash Routing Flow', () {
    Widget buildApp() => const MaterialApp(home: SplashScreen());

    testWidgets('splash boots → shows logo animations → routes to LoginPage', (tester) async {
      await tester.pumpWidget(buildApp());

      // Splash renders with animation widgets
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(ScaleTransition), findsWidgets);

      // No interactive elements during splash
      expect(find.byType(TextField), findsNothing);
      expect(find.byType(ElevatedButton), findsNothing);

      // Background is white
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.white));

      // Animation completes → navigates to LoginPage via pushReplacement
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);

      // Cannot pop back (pushReplacement)
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      expect(navigator.canPop(), isFalse);
    });

    testWidgets('splash does not crash when no active session', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}

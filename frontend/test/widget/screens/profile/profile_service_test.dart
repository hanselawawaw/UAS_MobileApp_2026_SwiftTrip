import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/screens/profile/clear_cache.dart';
import 'package:swifttrip_frontend/screens/profile/language.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/cache_row.dart';

// ============================================================
// PROFILE SERVICE - CONSOLIDATED WIDGET TEST
// Merges: logout_test, language_test, clear_cache_test
//
// Coverage:
//   Screen           | Test Scenario
//   -----------------|----------------------
//   LanguageScreen   | renders title + list, tapping changes language
//   ClearCacheScreen | renders loading then cache rows, clears cache
//   ProfilePage      | logout taps navigates to LoginPage
// ============================================================

class _TestAssetBundle extends CachingAssetBundle {
  static final ByteData _svgBytes = ByteData.view(
    Uint8List.fromList(
      utf8.encode(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 10"><rect width="10" height="10" fill="black"/></svg>',
      ),
    ).buffer,
  );

  @override
  Future<ByteData> load(String key) async => _svgBytes;
}

const _secureStorageChannel = MethodChannel(
  'plugins.it_nomads.com/flutter_secure_storage',
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_secureStorageChannel, null);
  });

  // ── Language Widget ───────────────────────────────────────────

  group('Profile Service Widget - Language', () {
    testWidgets('renders language screen title and language list entries', (tester) async {
      final provider = LanguageProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: provider,
          child: const MaterialApp(home: LanguageScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('tapping language item shows success SnackBar', (tester) async {
      final provider = LanguageProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: provider,
          child: const MaterialApp(home: LanguageScreen()),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Indonesia'));
      await tester.pump();

      expect(find.textContaining('Language updated to Indonesia'), findsOneWidget);
    });
  });

  // ── Clear Cache Widget ────────────────────────────────────────

  group('Profile Service Widget - Cache', () {
    testWidgets('renders loading then cache rows and total cache', (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text('Clear Cache'), findsNWidgets(2));
      expect(find.byType(CacheRow), findsNWidgets(3));
      expect(find.text('Total Cache:'), findsOneWidget);
      expect(find.text('304 kb'), findsOneWidget);
    });

    testWidgets('tap clear cache updates values and shows snackbar', (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear Cache').last);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('0 kb'), findsNWidgets(4));
      expect(find.text('Cache cleared successfully'), findsOneWidget);
    });
  });

  // ── Logout Widget ─────────────────────────────────────────────

  group('Profile Service Widget - Logout', () {
    testWidgets('taps logout menu item and navigates to LoginPage', (tester) async {
      final languageProvider = LanguageProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      final logoutFinder = find.text('Log Out');
      expect(logoutFinder, findsWidgets);

      await tester.ensureVisible(logoutFinder.last);
      await tester.pumpAndSettle();
      await tester.tap(logoutFinder.last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}

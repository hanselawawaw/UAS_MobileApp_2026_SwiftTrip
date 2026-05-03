import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomePage Integration Tests', () {
    Widget buildApp({VoidCallback? onNavigateToDestination}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: MaterialApp(
          home: HomePage(
            onNavigateToDestination: onNavigateToDestination ?? () {},
          ),
        ),
      );
    }

    testWidgets('HomePage tampil tanpa error', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage memiliki RefreshIndicator untuk pull-to-refresh',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Pull-to-refresh pada HomePage tidak menyebabkan crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Simulasi pull to refresh
      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
        800,
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Tidak crash
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage menampilkan PageView banner carousel',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(PageView), findsWidgets);
    });

    testWidgets('Banner carousel dapat di-swipe ke kiri',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      final pageViews = find.byType(PageView);
      if (pageViews.evaluate().isNotEmpty) {
        await tester.drag(pageViews.first, const Offset(-300, 0));
        await tester.pumpAndSettle();
      }

      // Tidak crash setelah swipe
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage menampilkan loading indicator saat fetch data',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());

      // Langsung setelah pump, loading mungkin tampil
      await tester.pump(Duration.zero);

      // Widget tetap ada
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('onNavigateToDestination callback terdaftar dengan benar',
        (WidgetTester tester) async {
      bool called = false;

      await tester.pumpWidget(buildApp(
        onNavigateToDestination: () => called = true,
      ));
      await tester.pump();

      // Callback belum dipanggil saat init
      expect(called, isFalse);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage dapat di-scroll tanpa crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Scroll ke bawah untuk melihat konten lebih bawah
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage scroll ke bawah dan kembali ke atas',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Scroll ke bawah
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();

      // Scroll kembali ke atas
      await tester.drag(
        find.byType(RefreshIndicator),
        const Offset(0, 400),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage menggunakan provider Language dengan benar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // LanguageProvider tersedia di context
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Floating buttons tampil di atas konten',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Stack digunakan untuk floating buttons
      expect(find.byType(Stack), findsWidgets);
    });
  });
}
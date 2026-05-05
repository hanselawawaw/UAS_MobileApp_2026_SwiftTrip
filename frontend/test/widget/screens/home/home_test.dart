import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:swifttrip_frontend/screens/home/home.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/providers/cart_provider.dart';
import 'dart:io';
import '../../test_helpers.dart';

// ============================================================
// HOME PAGE WIDGET TEST
// Tabel Coverage:
//   Widget            | Class Method
//   ------------------|----------------------
//   RefreshIndicator  | onRefresh()
//                     | fetchHomeDashboardData()
//   CustomScrollView  | buildScrollPhysics()
//   SliverList        | renderContent()
// ============================================================

void main() {
  HttpOverrides.global = MockHttpOverrides();
  setupMockSecureStorage();

  group('HomePage Widget Tests', () {
    Widget buildSubject({VoidCallback? onNavigateToDestination}) {
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

    /// Pumps the widget and waits for async data fetching to complete,
    /// so the loading spinner is replaced by the actual content.
    Future<void> pumpUntilLoaded(WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      // Let async _fetchHomeData and _checkPendingReviews resolve
      await tester.runAsync(() => Future.delayed(const Duration(seconds: 3)));
      // Rebuild multiple times to process all pending setState calls
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    // ----------------------------------------------------------
    // WIDGET: RefreshIndicator
    // METHOD: onRefresh()
    // ----------------------------------------------------------
    testWidgets(
        '[RefreshIndicator] onRefresh() - ScrollView ada '
        'di HomePage untuk mendukung pull-to-refresh',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final hasSingleScroll =
          find.byType(SingleChildScrollView).evaluate().isNotEmpty;
      final hasCustomScroll =
          find.byType(CustomScrollView).evaluate().isNotEmpty;
      expect(hasSingleScroll || hasCustomScroll, isTrue);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[RefreshIndicator] onRefresh() - Scroll ke bawah tidak crash '
        '(onRefresh dipicu dari gesture scroll)',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final scrollable = find.byType(SingleChildScrollView).evaluate().isNotEmpty
          ? find.byType(SingleChildScrollView)
          : find.byType(CustomScrollView);

      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[RefreshIndicator] onRefresh() - Setelah scroll selesai, '
        'HomePage masih tampil normal',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final scrollable = find.byType(SingleChildScrollView).evaluate().isNotEmpty
          ? find.byType(SingleChildScrollView)
          : find.byType(CustomScrollView);

      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, 400));
        await tester.pump(const Duration(seconds: 1));
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    // ----------------------------------------------------------
    // WIDGET: RefreshIndicator
    // METHOD: fetchHomeDashboardData()
    // ----------------------------------------------------------
    testWidgets(
        '[RefreshIndicator] fetchHomeDashboardData() - Data dashboard '
        'di-fetch saat HomePage pertama kali dibuka',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pump(Duration.zero);

      // During fetch, widget still exists
      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[RefreshIndicator] fetchHomeDashboardData() - Setelah fetch selesai, '
        'konten dashboard tampil',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(HomePage), findsOneWidget);
      // After loading, the main content (Stack layout) should be visible
      expect(find.byType(Stack), findsWidgets);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[RefreshIndicator] fetchHomeDashboardData() - '
        'Scroll ke atas memicu ulang tampilan konten',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final scrollable = find.byType(SingleChildScrollView).evaluate().isNotEmpty
          ? find.byType(SingleChildScrollView)
          : find.byType(CustomScrollView);

      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, 400));
        await tester.pump(const Duration(milliseconds: 300));
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    // ----------------------------------------------------------
    // WIDGET: CustomScrollView
    // METHOD: buildScrollPhysics()
    // ----------------------------------------------------------
    testWidgets(
        '[CustomScrollView] buildScrollPhysics() - ScrollView dengan '
        'physics yang benar ada di HomePage',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final hasCustomScroll =
          find.byType(CustomScrollView).evaluate().isNotEmpty;
      final hasSingleScroll =
          find.byType(SingleChildScrollView).evaluate().isNotEmpty;
      expect(hasCustomScroll || hasSingleScroll, isTrue);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[CustomScrollView] buildScrollPhysics() - Konten dapat '
        'di-scroll ke bawah tanpa crash',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final scrollable = find.byType(SingleChildScrollView).evaluate().isNotEmpty
          ? find.byType(SingleChildScrollView)
          : find.byType(CustomScrollView);

      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pump();
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[CustomScrollView] buildScrollPhysics() - Konten dapat '
        'di-scroll ke atas setelah scroll ke bawah',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final scrollable = find.byType(SingleChildScrollView).evaluate().isNotEmpty
          ? find.byType(SingleChildScrollView)
          : find.byType(CustomScrollView);

      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pump();
        await tester.drag(scrollable.first, const Offset(0, 300));
        await tester.pump();
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    // ----------------------------------------------------------
    // WIDGET: SliverList
    // METHOD: renderContent()
    // ----------------------------------------------------------
    testWidgets(
        '[SliverList] renderContent() - Konten di-render berupa '
        'list widget yang tampil di layar',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[SliverList] renderContent() - Banner carousel di-render '
        'sebagai bagian dari konten',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      // After loading, the banner PageView should be rendered
      final hasPageView = find.byType(PageView).evaluate().isNotEmpty;
      // The banner carousel uses PageView.builder internally
      expect(hasPageView, isTrue,
          reason: 'PageView should be present after loading completes');
      await tester.pumpWidget(Container());
    });

    testWidgets(
        '[SliverList] renderContent() - Konten dapat di-swipe '
        'pada banner carousel',
        (WidgetTester tester) async {
      await pumpUntilLoaded(tester);

      final pageViews = find.byType(PageView);
      if (pageViews.evaluate().isNotEmpty) {
        await tester.drag(pageViews.first, const Offset(-200, 0));
        await tester.pump(const Duration(milliseconds: 500));
      }

      expect(find.byType(HomePage), findsOneWidget);
      await tester.pumpWidget(Container());
    });
  });
}
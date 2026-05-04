import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swifttrip_frontend/providers/language_provider.dart';
import 'package:swifttrip_frontend/providers/wishlist_provider.dart';
import 'package:swifttrip_frontend/screens/auth/login.dart';
import 'package:swifttrip_frontend/screens/destination/models/destination_model.dart';
import 'package:swifttrip_frontend/screens/profile/clear_cache.dart';
import 'package:swifttrip_frontend/screens/profile/language.dart';
import 'package:swifttrip_frontend/screens/profile/profile.dart';
import 'package:swifttrip_frontend/screens/profile/subscription_plan.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/cache_row.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/menu_item.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/profile_card.dart';
import 'package:swifttrip_frontend/screens/profile/wishlist.dart';
import 'package:swifttrip_frontend/screens/profile/services/subscription_service.dart';
import 'package:swifttrip_frontend/screens/profile/models/subscription_plan_model.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/subscription/plan_card.dart';

// ============================================================
// FLOW: Profile Settings
// User opens profile → taps Language → changes language →
// views subscription → clears cache → logs out
// ============================================================

class MockWishlistProvider extends Mock implements WishlistProvider {}

class MockSubscriptionService extends Mock implements SubscriptionService {}

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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

  group('Profile Settings Flow', () {
    testWidgets('profile renders card + menus → tap Language → change language', (tester) async {
      final languageProvider = LanguageProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      // Profile page elements
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(ProfileCard), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byType(MenuItem), findsNWidgets(6));

      // Tap Language menu
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Language screen
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);

      // Select Indonesia
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Language updated to Indonesia'), findsOneWidget);
    });

    testWidgets('cache flow: load → clear → verify zeroed', (tester) async {
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(),
          child: const MaterialApp(home: ClearCacheScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CacheRow), findsNWidgets(3));
      expect(find.text('304 kb'), findsOneWidget);

      await tester.tap(find.text('Clear Cache').last);
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Cache cleared successfully'), findsOneWidget);
      expect(find.text('0 kb'), findsNWidgets(4));
    });

    testWidgets('subscription flow: load plans → tap card → tap back', (tester) async {
      final mockService = MockSubscriptionService();
      final dummyPlans = [
        SubscriptionPlan(
          id: 'basic-plan',
          name: 'Basic Plan',
          gradientColor: Colors.blue,
          features: [PlanFeature(text: 'Feature 1')],
          buttonLabel: 'Current Plan',
          isCurrent: true,
        ),
        SubscriptionPlan(
          id: 'premium-plan',
          name: 'Premium Plan',
          gradientColor: Colors.purple,
          features: [PlanFeature(text: 'Feature 1')],
          buttonLabel: 'Upgrade Now',
          isCurrent: false,
        ),
      ];
      when(() => mockService.getPlans()).thenAnswer((_) async => dummyPlans);

      await tester.pumpWidget(MaterialApp(
        home: const Scaffold(body: Text('Home')),
        routes: {
          '/plans': (context) => SubscriptionPlanScreen(subscriptionService: mockService),
        },
        initialRoute: '/plans',
      ));
      await tester.pumpAndSettle();

      expect(find.text('Subscription Plan'), findsOneWidget);
      expect(find.byType(PlanCard), findsWidgets);

      // Tap plan card
      await tester.tap(find.byType(PlanCard).last);
      await tester.pumpAndSettle();
      expect(find.byType(PlanCard), findsWidgets);

      // Tap back
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('wishlist flow: renders items → tap back', (tester) async {
      final mockWishlist = MockWishlistProvider();
      final items = <DestinationModel>[
        DestinationModel(
          id: 'dest-10',
          title: 'City Hotel',
          imageUrl: 'https://example.com/hotel.jpg',
          rating: 4.2,
        ),
      ];
      when(() => mockWishlist.isLoading).thenReturn(false);
      when(() => mockWishlist.wishlistItems).thenReturn(items);
      when(() => mockWishlist.loadFullWishlist()).thenAnswer((_) async {});
      when(() => mockWishlist.isFavorite(any())).thenReturn(false);

      await tester.pumpWidget(
        ChangeNotifierProvider<WishlistProvider>.value(
          value: mockWishlist,
          child: MaterialApp(
            home: const Scaffold(body: Text('Home')),
            routes: {'/wishlist': (_) => const WishlistScreen()},
            initialRoute: '/wishlist',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Wishlist'), findsOneWidget);
      expect(find.text('City Hotel'), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('logout flow: tap logout → navigates to LoginPage', (tester) async {
      final languageProvider = LanguageProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<LanguageProvider>.value(
          value: languageProvider,
          child: const MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      final logoutFinder = find.text('Log Out');
      expect(logoutFinder, findsOneWidget);

      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });
}

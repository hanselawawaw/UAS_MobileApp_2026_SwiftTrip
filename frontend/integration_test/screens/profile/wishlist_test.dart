import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/profile/wishlist.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('Wishlist Integration', () {
    testWidgets('WishlistScreen renders with My Wishlist title', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const WishlistScreen()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(WishlistScreen), findsOneWidget);
      expect(find.text('My Wishlist'), findsOneWidget);
    });
  });
}

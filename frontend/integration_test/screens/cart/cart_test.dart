import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/cart/cart.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('CartPage Integration', () {
    testWidgets('CartPage renders with Scaffold', (tester) async {
      await tester.pumpWidget(wrapWithProviders(const CartPage()));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(CartPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

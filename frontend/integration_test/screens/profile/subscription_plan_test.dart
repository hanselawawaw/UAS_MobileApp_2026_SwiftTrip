import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/profile/subscription_plan.dart';
import '../../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => mockSecureStorage());
  tearDown(() => clearSecureStorageMock());

  group('SubscriptionPlan Integration', () {
    testWidgets('SubscriptionPlanScreen renders with Scaffold', (tester) async {
      await tester.pumpWidget(
        wrapWithProviders(const SubscriptionPlanScreen()),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(SubscriptionPlanScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

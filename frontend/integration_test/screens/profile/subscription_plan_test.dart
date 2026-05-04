import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swifttrip_frontend/screens/profile/subscription_plan.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/subscription/plan_card.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/profile/services/subscription_service.dart';
import 'package:swifttrip_frontend/screens/profile/models/subscription_plan_model.dart';

class MockSubscriptionService extends Mock implements SubscriptionService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockSubscriptionService mockSubscriptionService;

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

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
    when(() => mockSubscriptionService.getPlans()).thenAnswer((_) async => dummyPlans);
  });

  group('Profile Subscription Plan - Integration Test', () {
    testWidgets('full flow: load plans, tap to switch card, tap back button', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(
        home: const Scaffold(body: Text('Home')),
        routes: {
          '/plans': (context) => SubscriptionPlanScreen(subscriptionService: mockSubscriptionService),
        },
        initialRoute: '/plans',
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Subscription Plan'), findsOneWidget);
      expect(find.byType(PlanCard), findsWidgets);

      // Act - Tap a plan card to switch
      final cards = find.byType(PlanCard);
      await tester.tap(cards.last);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PlanCard), findsWidgets);

      // Act - Tap back button
      final backButton = find.byIcon(Icons.chevron_left);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

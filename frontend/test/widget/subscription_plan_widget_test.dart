import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';
import 'package:swifttrip_frontend/screens/profile/subscription_plan.dart';
import 'package:swifttrip_frontend/screens/profile/widgets/subscription/plan_card.dart';
import 'package:swifttrip_frontend/screens/profile/services/subscription_service.dart';
import 'package:swifttrip_frontend/screens/profile/models/subscription_plan_model.dart';

class MockSubscriptionService extends Mock implements SubscriptionService {}

void main() {
  late MockSubscriptionService mockSubscriptionService;

  final List<SubscriptionPlan> dummyPlans = [
    SubscriptionPlan(
      id: 'basic-plan',
      name: 'Basic Plan',
      gradientColor: Colors.blue,
      features: [PlanFeature(text: 'Feature 1'), PlanFeature(text: 'Feature 2')],
      buttonLabel: 'Current Plan',
      isCurrent: true,
    ),
    SubscriptionPlan(
      id: 'premium-plan',
      name: 'Premium Plan',
      gradientColor: Colors.purple,
      features: [PlanFeature(text: 'Feature 1'), PlanFeature(text: 'Feature 2'), PlanFeature(text: 'Feature 3')],
      buttonLabel: 'Upgrade Now',
      isCurrent: false,
    ),
  ];

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
    when(() => mockSubscriptionService.getPlans()).thenAnswer((_) async => dummyPlans);
  });

  group('Profile Subscription Plan - Widget Test', () {
    testWidgets('renders loading indicator initially', (tester) async {
      // Arrange
      final completer = Completer<List<SubscriptionPlan>>();
      when(() => mockSubscriptionService.getPlans()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(MaterialApp(home: SubscriptionPlanScreen(subscriptionService: mockSubscriptionService)));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders subscription title and at least one plan card after fetch', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: SubscriptionPlanScreen(subscriptionService: mockSubscriptionService)));

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Subscription Plan'), findsOneWidget);
      expect(find.byType(PlanCard), findsWidgets);
    });

    testWidgets('tapping active plan area keeps screen stable', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: SubscriptionPlanScreen(subscriptionService: mockSubscriptionService)));
      await tester.pumpAndSettle();

      // Act
      final gestureTargets = find.byType(GestureDetector);
      expect(gestureTargets, findsWidgets);
      await tester.tap(gestureTargets.first);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Subscription Plan'), findsOneWidget);
    });
  });
}

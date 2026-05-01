import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swifttrip_frontend/screens/profile/models/subscription_plan_model.dart';
import 'package:swifttrip_frontend/screens/profile/services/subscription_service.dart';

class MockSubscriptionService extends Mock implements SubscriptionService {}

void main() {
  late MockSubscriptionService mockSubscriptionService;

  setUp(() {
    mockSubscriptionService = MockSubscriptionService();
  });

  group('Profile Subscription Plan - Unit Test', () {
    test('SubscriptionPlan.fromJson parses plan details correctly', () {
      // Arrange
      final json = <String, dynamic>{
        'id': 'plan_free',
        'name': 'Free Plan',
        'gradient_color': '4286898432',
        'button_label': 'Currently Used',
        'is_current': true,
        'features': [
          {'text': 'Basic support', 'is_highlighted': true},
        ],
      };

      // Act
      final plan = SubscriptionPlan.fromJson(json);

      // Assert
      expect(plan.id, equals('plan_free'));
      expect(plan.name, equals('Free Plan'));
      expect(plan.buttonLabel, equals('Currently Used'));
      expect(plan.isCurrent, isTrue);
      expect(plan.features.length, equals(1));
      expect(plan.features.first.text, equals('Basic support'));
    });

    test('SubscriptionPlan.toJson serializes plan fields', () {
      // Arrange
      const plan = SubscriptionPlan(
        id: 'plan_premium',
        name: 'Premium',
        gradientColor: Color(0xFFEF4444),
        buttonLabel: 'Buy Premium Plan',
        isCurrent: false,
        features: [PlanFeature(text: 'Priority support', isHighlighted: true)],
      );

      // Act
      final json = plan.toJson();

      // Assert
      expect(json['id'], equals('plan_premium'));
      expect(json['name'], equals('Premium'));
      expect(json['button_label'], equals('Buy Premium Plan'));
      expect(json['is_current'], isFalse);
      expect((json['features'] as List).length, equals(1));
    });

    test('getPlans can be stubbed with mocktail', () async {
      // Arrange
      const plans = [
        SubscriptionPlan(
          id: 'plan_golden',
          name: 'Golden',
          gradientColor: Color(0xFFEAB308),
          buttonLabel: 'Buy Golden Plan',
          isCurrent: false,
          features: [PlanFeature(text: 'Feature A')],
        ),
      ];
      when(() => mockSubscriptionService.getPlans()).thenAnswer((_) async => plans);

      // Act
      final result = await mockSubscriptionService.getPlans();

      // Assert
      expect(result, equals(plans));
      verify(() => mockSubscriptionService.getPlans()).called(1);
    });
  });
}

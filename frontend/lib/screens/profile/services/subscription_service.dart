import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../models/subscription_plan_model.dart';

class SubscriptionService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<List<SubscriptionPlan>> getPlans() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, you would fetch these from the backend
    // and check the current user's tier to set isCurrent.
    final user = AuthRepository().currentUser;
    final currentTier = user?.subscriptionTier?.toUpperCase() ?? 'FREE';

    return [
      SubscriptionPlan(
        id: 'plan_golden',
        name: 'Golden',
        gradientColor: const Color(0xFFEAB308),
        buttonLabel: currentTier == 'GOLD' ? 'Currently Used' : 'Buy Golden Plan',
        isCurrent: currentTier == 'GOLD',
        features: const [
          PlanFeature(
            text: 'Priority AI Travel Assistant (24/7 real-time support)',
            isHighlighted: true,
          ),
          PlanFeature(
            text: 'Exclusive mid-tier discounts on flights & hotels (up to 15%)',
            isHighlighted: true,
          ),
          PlanFeature(
            text: 'Flexible booking options with low-fee reschedule & cancellation',
          ),
          PlanFeature(
            text: 'Early access to flash sales & limited travel deals',
          ),
          PlanFeature(text: 'Earn 2x loyalty points on every transaction'),
        ],
      ),
      SubscriptionPlan(
        id: 'plan_free',
        name: 'Free Plan',
        gradientColor: const Color(0xFF84CC16),
        buttonLabel: currentTier == 'FREE' ? 'Currently Used' : 'Downgrade to Free',
        isCurrent: currentTier == 'FREE',
        features: const [
          PlanFeature(
            text: 'Standard AI Travel Assistant (best-effort support)',
            isHighlighted: true,
          ),
          PlanFeature(text: 'Access to basic discounts (up to 5%)'),
          PlanFeature(text: 'Standard booking with regular fees'),
          PlanFeature(text: 'Standard access to sales and deals'),
          PlanFeature(text: 'Earn 1x loyalty points on every transaction'),
        ],
      ),
      SubscriptionPlan(
        id: 'plan_premium',
        name: 'Premium',
        gradientColor: const Color(0xFFEF4444),
        buttonLabel: currentTier == 'PREMIUM' ? 'Currently Used' : 'Buy Premium Plan',
        isCurrent: currentTier == 'PREMIUM',
        features: const [
          PlanFeature(
            text: 'Premium AI Travel Assistant (24/7 priority support)',
            isHighlighted: true,
          ),
          PlanFeature(
            text: 'Top-tier discounts on flights & hotels (up to 25%)',
            isHighlighted: true,
          ),
          PlanFeature(
            text: 'Most flexible booking with waived reschedule & cancellation fees',
            isHighlighted: true,
          ),
          PlanFeature(text: 'Priority access to all sales & limited deals'),
          PlanFeature(text: 'Earn 3x loyalty points on every transaction'),
          PlanFeature(text: 'Complimentary travel insurance coverage'),
        ],
      ),
    ];
  }

  Future<void> updateUserPlan(String planId) async {
    try {
      final token = await AuthRepository().getToken();
      
      // Map planId to backend tier string
      String tier = 'FREE';
      if (planId.contains('golden')) tier = 'GOLD';
      if (planId.contains('premium')) tier = 'PREMIUM';

      await _dio.patch(
        'update-subscription/',
        data: {'subscription_tier': tier},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Refresh current user profile to reflect the change globally
      await AuthRepository().getUserProfile();
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to update subscription.';
      if (data is Map && data.containsKey('detail')) {
        message = data['detail'];
      }
      throw Exception(message);
    }
  }
}

import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String id;
  final String name;
  final Color gradientColor;
  final String buttonLabel;
  final bool isCurrent;
  final List<PlanFeature> features;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.gradientColor,
    required this.buttonLabel,
    required this.isCurrent,
    required this.features,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      gradientColor: Color(int.parse(json['gradient_color'])),
      buttonLabel: json['button_label'],
      isCurrent: json['is_current'] ?? false,
      features: (json['features'] as List)
          .map((f) => PlanFeature.fromJson(f))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gradient_color':
          // ignore: deprecated_member_use
          '0x${gradientColor.value.toRadixString(16).toUpperCase()}',
      'button_label': buttonLabel,
      'is_current': isCurrent,
      'features': features.map((f) => f.toJson()).toList(),
    };
  }
}

class PlanFeature {
  final String text;
  final bool isHighlighted;

  const PlanFeature({required this.text, this.isHighlighted = false});

  factory PlanFeature.fromJson(Map<String, dynamic> json) {
    return PlanFeature(
      text: json['text'],
      isHighlighted: json['is_highlighted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'is_highlighted': isHighlighted};
  }
}

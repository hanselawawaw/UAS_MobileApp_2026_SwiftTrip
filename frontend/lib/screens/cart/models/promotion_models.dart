import 'package:flutter/foundation.dart';

@immutable
class Promotion {
  final String id;
  final String title;
  final String dateRange;
  final String description;
  final String promotionType;
  final double discountValue;
  final double minPurchase;

  const Promotion({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.description,
    required this.promotionType,
    required this.discountValue,
    required this.minPurchase,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'] as String,
      title: json['title'] as String,
      dateRange: json['date_range'] as String,
      description: json['description'] as String,
      promotionType: json['promotion_type'] as String? ?? 'PERCENTAGE',
      discountValue: _toDouble(json['discount_value']),
      minPurchase: _toDouble(json['min_purchase']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date_range': dateRange,
      'description': description,
      'promotion_type': promotionType,
      'discount_value': discountValue,
      'min_purchase': minPurchase,
    };
  }
}

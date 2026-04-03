import 'package:flutter/foundation.dart';

class DestinationModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String description;
  final double price;
  final List<String> features;
  final bool hasDiscount;
  final ValueNotifier<bool> isFavoriteNotifier;

  DestinationModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.description = '',
    this.price = 0.0,
    this.features = const [],
    this.hasDiscount = false,
    bool isFavorite = false,
  }) : isFavoriteNotifier = ValueNotifier<bool>(isFavorite);

  bool get isFavorite => isFavoriteNotifier.value;
  set isFavorite(bool value) => isFavoriteNotifier.value = value;

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'hasDiscount': hasDiscount,
      'isFavorite': isFavorite,
    };
  }
}


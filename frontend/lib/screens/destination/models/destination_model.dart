
class DestinationModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final double originalPrice;
  final int discountPercentage;
  final double price;
  final String description;
  final List<String> features;
  final List<String> tags;
  final String sectionTag;
  final double? latitude;
  final double? longitude;

  DestinationModel({
    required this.id,
    required this.title,
    this.category = '',
    required this.imageUrl,
    this.location = '',
    required this.rating,
    this.reviewCount = 0,
    this.originalPrice = 0.0,
    this.discountPercentage = 0,
    this.price = 0.0,
    this.description = '',
    this.features = const [],
    this.tags = const [],
    this.sectionTag = '',
    this.latitude,
    this.longitude,
  });

  bool get hasDiscount => discountPercentage > 0;

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      originalPrice:
          double.tryParse(json['original_price']?.toString() ?? '0.0') ?? 0.0,
      discountPercentage: json['discount_percentage'] as int? ?? 0,
      price: double.tryParse(json['final_price']?.toString() ?? '0.0') ?? 0.0,
      description: json['description'] as String? ?? '',
      features:
          (json['advantages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      sectionTag: json['section_tag'] as String? ?? '',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image_url': imageUrl,
      'location': location,
      'rating': rating,
      'review_count': reviewCount,
      'original_price': originalPrice,
      'discount_percentage': discountPercentage,
      'final_price': price,
      'description': description,
      'advantages': features,
      'tags': tags,
      'section_tag': sectionTag,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RecommendationItem {
  final String name;
  final String description;
  final String? imageUrl;
  final String? imageAsset;

  const RecommendationItem({
    required this.name,
    required this.description,
    this.imageUrl,
    this.imageAsset,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      imageAsset: json['image_asset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'image_asset': imageAsset,
    };
  }
}

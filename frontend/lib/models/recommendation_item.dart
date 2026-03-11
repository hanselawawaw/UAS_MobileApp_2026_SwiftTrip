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
}

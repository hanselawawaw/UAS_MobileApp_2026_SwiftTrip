class ScheduleItem {
  final String title;
  final String time;
  final String? imageUrl;
  final String? imageAsset;

  const ScheduleItem({
    required this.title,
    required this.time,
    this.imageUrl,
    this.imageAsset,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      title: json['title'] as String,
      time: json['time'] as String,
      imageUrl: json['image_url'] as String?,
      imageAsset: json['image_asset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'image_url': imageUrl,
      'image_asset': imageAsset,
    };
  }
}

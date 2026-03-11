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
}

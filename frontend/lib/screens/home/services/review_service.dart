class ReviewService {
  Future<List<String>> getFeelingOptions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      'Relaxing',
      'Cozy',
      'Luxury',
      'Entertaining',
      'Fun',
    ];
  }

  Future<void> submitReview({
    required String targetName,
    required int rating,
    required String? feeling,
    required String thoughts,
  }) async {
    // Simulated network submit
    await Future.delayed(const Duration(milliseconds: 800));
  }
}

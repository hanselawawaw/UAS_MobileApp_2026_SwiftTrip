import '../../destination/services/destination_service.dart';

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
    String? destinationId,
    required int rating,
    required String? feeling,
    required String thoughts,
  }) async {
    if (destinationId != null) {
      await DestinationService().submitReview(
        destinationId: destinationId,
        rating: rating,
        feeling: feeling,
        thoughts: thoughts,
      );
    } else {
      // Simulated network submit for generic reviews
      await Future.delayed(const Duration(milliseconds: 800));
      print('Simulated generic review submit for $targetName');
    }
  }
}

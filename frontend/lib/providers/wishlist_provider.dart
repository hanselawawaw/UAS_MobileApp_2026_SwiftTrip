import 'package:flutter/foundation.dart';
import 'package:swifttrip_frontend/screens/destination/services/destination_service.dart';
import '../screens/destination/models/destination_model.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlistedIds = {};
  List<DestinationModel> _wishlistItems = [];
  bool _isLoading = false;

  Set<String> get wishlistedIds => _wishlistedIds;
  List<DestinationModel> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;

  Future<void> loadWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final ids = await DestinationService().fetchWishlistIds();
      _wishlistedIds.clear();
      _wishlistedIds.addAll(ids);
    } catch (e) {
      print('Error loading wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFullWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final items = await DestinationService().fetchWishlist();
      _wishlistItems = items;
      // Sync IDs as well
      _wishlistedIds.clear();
      _wishlistedIds.addAll(items.map((i) => i.id));
    } catch (e) {
      print('Error loading full wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlistedIds.clear();
    _wishlistItems.clear();
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _wishlistedIds.contains(id);
  }

  Future<bool> toggleWishlist(String id) async {
    final bool wasFavorite = _wishlistedIds.contains(id);

    // Optimistic UI toggle for IDs
    if (wasFavorite) {
      _wishlistedIds.remove(id);
      _wishlistItems.removeWhere((item) => item.id == id);
    } else {
      _wishlistedIds.add(id);
      // Note: Full item will be added on next fetch or handled by UI
    }
    notifyListeners();

    // Backend call
    final success = await DestinationService().toggleWishlist(id);

    // Rollback if failure
    if (!success) {
      if (wasFavorite) {
        _wishlistedIds.add(id);
        // Note: Re-populating the full item would require a fetch or local cache
      } else {
        _wishlistedIds.remove(id);
      }
      notifyListeners();
    }

    return success;
  }
}

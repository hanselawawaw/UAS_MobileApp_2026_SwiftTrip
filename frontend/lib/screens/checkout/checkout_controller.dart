import 'package:flutter/material.dart';
import 'models/checkout_details_model.dart';
import 'services/checkout_service.dart';

class CheckoutController extends ChangeNotifier {
  CheckoutDetailsModel? _details;
  bool _isLoading = false;
  String? _lastErrorMessage;
  final _service = CheckoutService();

  // Payment Form Controllers
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvcController = TextEditingController();

  CheckoutDetailsModel? get details => _details;
  bool get isLoading => _isLoading;
  String? get lastErrorMessage => _lastErrorMessage;

  void init(CheckoutDetailsModel details) {
    _details = details;
    notifyListeners();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvcController.dispose();
    super.dispose();
  }

  Future<bool> confirmPurchase() async {
    _lastErrorMessage = null;
    final cleanCardNumber = cardNumberController.text.replaceAll(' ', '');
    final cvc = cvcController.text;

    if (cleanCardNumber.length != 16 ||
        expiryDateController.text.length != 5 ||
        cvc.length != 3) {
      _lastErrorMessage = 'Please fill in all payment details';
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _service.confirmPurchase();

      _isLoading = false;
      notifyListeners();

      if (success) {
        return true;
      }
      
      _lastErrorMessage = 'Server error. Please try again.';
      return false;
    } catch (e) {
      debugPrint('Error confirming purchase: $e');
      _lastErrorMessage = 'An error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

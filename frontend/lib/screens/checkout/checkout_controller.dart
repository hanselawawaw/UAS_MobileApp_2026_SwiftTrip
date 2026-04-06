import 'package:flutter/material.dart';
import 'models/checkout_details_model.dart';

class CheckoutController extends ChangeNotifier {
  CheckoutDetailsModel? _details;
  bool _isLoading = false;

  // Payment Form Controllers
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvcController = TextEditingController();

  CheckoutDetailsModel? get details => _details;
  bool get isLoading => _isLoading;

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
    final cleanCardNumber = cardNumberController.text.replaceAll(' ', '');
    final cvc = cvcController.text;

    if (cleanCardNumber.length != 16 ||
        expiryDateController.text.length != 5 ||
        cvc.length != 3) {
      return false;
    }
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

}


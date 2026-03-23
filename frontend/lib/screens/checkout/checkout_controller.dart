import 'package:flutter/material.dart';
import 'models/checkout_details_model.dart';
import 'models/payment_method_model.dart';
import 'services/checkout_service.dart';

class CheckoutController extends ChangeNotifier {
  final CheckoutService _service = CheckoutService();

  CheckoutDetailsModel? _details;
  List<PaymentMethodModel> _paymentMethods = [];
  int? _expandedPaymentIndex;
  bool _isLoading = true;

  CheckoutDetailsModel? get details => _details;
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  int? get expandedPaymentIndex => _expandedPaymentIndex;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getCheckoutDetails(),
        _service.getPaymentMethods(),
      ]);

      _details = results[0] as CheckoutDetailsModel;
      _paymentMethods = results[1] as List<PaymentMethodModel>;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void togglePaymentMethod(int index) {
    _expandedPaymentIndex = _expandedPaymentIndex == index ? null : index;
    notifyListeners();
  }

  Future<bool> confirmPurchase() async {
    return await _service.confirmPurchase();
  }
}

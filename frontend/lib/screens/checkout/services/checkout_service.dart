import '../models/checkout_details_model.dart';
import '../models/payment_method_model.dart';
import '../models/purchase_item_model.dart';
import '../models/ticket_model.dart';

class CheckoutService {
  // Future: Add Dio or http client here
  
  Future<CheckoutDetailsModel> getCheckoutDetails() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const CheckoutDetailsModel(
      ticket: TicketModel(
        classType: 'ECONOMY CLASS',
        from: 'Jakarta',
        to: 'Ngawi Barat',
        date: '19/2/2026',
        departureTime: '9:00',
        arrivalTime: '11:00',
        trainNumber: '1234',
        carriage: '01',
        seatNumber: 'A12',
      ),
      purchaseItems: [
        PurchaseItemModel(label: 'Tiket Kereta', amount: 'Rp 14.000.000'),
        PurchaseItemModel(label: 'Voucher', amount: '-Rp 300.000', isDiscount: true),
        PurchaseItemModel(label: 'Diskon Liburan', amount: '-Rp 1.000.000', isDiscount: true),
        PurchaseItemModel(label: 'PPN 10%', amount: 'Rp 1.300.000'),
      ],
      totalPrice: 'Rp 15.000.000',
    );
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return const [
      PaymentMethodModel(id: '1', name: 'ABC'),
      PaymentMethodModel(id: '2', name: 'Master Bank'),
      PaymentMethodModel(id: '3', name: 'Visa'),
    ];
  }

  Future<bool> confirmPurchase() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

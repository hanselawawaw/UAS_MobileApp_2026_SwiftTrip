import 'package:dio/dio.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../../cart/models/cart_models.dart';
import '../models/checkout_details_model.dart';
import '../models/purchase_item_model.dart';

class CheckoutService {
  final _dio = Dio();

  Future<CheckoutDetailsModel> getCheckoutDetails() async {
    // Current implementation uses mock data for the details view, 
    // which is fine for UI but confirmPurchase needs a real API.
    await Future.delayed(const Duration(milliseconds: 500));

    return CheckoutDetailsModel(
      tickets: [
        const CartTicket(
          type: 'Train Ticket',
          bookingId: 'TRN-123456',
          classLabel: 'ECONOMY CLASS',
          priceRp: 14000000,
          from: 'Jakarta',
          to: 'Ngawi Barat',
          date: '19/2/2026',
          departure: '9:00',
          arrive: '11:00',
          operator: 'KAI',
          carriage: '01',
          seat: 'A12',
        ),
        const CartTicket(
          type: 'Accommodation Ticket',
          bookingId: 'HOT-789012',
          classLabel: 'Deluxe Room',
          priceRp: 1000000,
          imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
          stayDate: '20/2/2026',
          stayDuration: '1 Night',
          bedType: 'King Size',
          location: 'Ngawi, East Java',
        ),
      ],
      purchaseItems: [
        const PurchaseItemModel(label: 'Tiket Kereta', amount: 'Rp 14.000.000'),
        const PurchaseItemModel(label: 'Hotel Ngawi', amount: 'Rp 1.000.000'),
        const PurchaseItemModel(
          label: 'Voucher',
          amount: '-Rp 300.000',
          isDiscount: true,
        ),
        const PurchaseItemModel(
          label: 'Diskon Liburan',
          amount: '-Rp 1.000.000',
          isDiscount: true,
        ),
        const PurchaseItemModel(label: 'PPN 11%', amount: 'Rp 1.650.000'),
      ],
      totalPrice: 'Rp 15.350.000',
    );
  }

  Future<bool> confirmPurchase() async {
    try {
      final token = await AuthRepository().getToken();
      final response = await _dio.post(
        '${Constants.bookingsUrl}checkout/confirm/',
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}


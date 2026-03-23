import 'ticket_model.dart';
import 'purchase_item_model.dart';

class CheckoutDetailsModel {
  final TicketModel ticket;
  final List<PurchaseItemModel> purchaseItems;
  final String totalPrice;

  const CheckoutDetailsModel({
    required this.ticket,
    required this.purchaseItems,
    required this.totalPrice,
  });

  factory CheckoutDetailsModel.fromJson(Map<String, dynamic> json) {
    return CheckoutDetailsModel(
      ticket: TicketModel.fromJson(json['ticket'] as Map<String, dynamic>),
      purchaseItems: (json['purchase_items'] as List<dynamic>)
          .map((item) => PurchaseItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: json['total_price'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket': ticket.toJson(),
      'purchase_items': purchaseItems.map((item) => item.toJson()).toList(),
      'total_price': totalPrice,
    };
  }
}

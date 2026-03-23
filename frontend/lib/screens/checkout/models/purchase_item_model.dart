class PurchaseItemModel {
  final String label;
  final String amount;
  final bool isDiscount;

  const PurchaseItemModel({
    required this.label,
    required this.amount,
    this.isDiscount = false,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      label: json['label'] as String,
      amount: json['amount'] as String,
      isDiscount: json['is_discount'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'amount': amount,
      'is_discount': isDiscount,
    };
  }
}

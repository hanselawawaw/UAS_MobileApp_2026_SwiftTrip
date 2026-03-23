class PurchaseDetail {
  final String label;
  final String amount;

  const PurchaseDetail({
    required this.label,
    required this.amount,
  });

  factory PurchaseDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseDetail(
      label: json['label'] as String,
      amount: json['amount'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'amount': amount,
    };
  }
}

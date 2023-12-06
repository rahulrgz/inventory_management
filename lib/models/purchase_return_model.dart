class PurchaseReturnModel {
  final String purchaseId;
  final String purchaseReturnId;
  final DateTime purchaseReturnDate;
  final List<Map<String, dynamic>> products;
  final List<String> setSearch;
  final String total;

  PurchaseReturnModel(
      {required this.purchaseId,
      required this.purchaseReturnId,
      required this.purchaseReturnDate,
      required this.products,
      required this.total,
      required this.setSearch});

  PurchaseReturnModel copyWith({
    String? purchaseId,
    String? purchaseReturnId,
    DateTime? purchaseReturnDate,
    List<Map<String, dynamic>>? products,
    List<String>? setSearch,
    String? total,
  }) {
    return PurchaseReturnModel(
      purchaseId: purchaseId ?? this.purchaseId,
      purchaseReturnId: purchaseReturnId ?? this.purchaseReturnId,
      purchaseReturnDate: purchaseReturnDate ?? this.purchaseReturnDate,
      products: products ?? this.products,
      total: total ?? this.total,
      setSearch: setSearch ?? this.setSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'purchaseId': purchaseId,
      'purchaseReturnId': purchaseReturnId,
      'purchaseReturnDate': purchaseReturnDate,
      'products': products,
      'total': total,
      'setSearch': setSearch,
    };
  }

  factory PurchaseReturnModel.fromMap(Map<String, dynamic> map) {
    return PurchaseReturnModel(
      purchaseId: map['purchaseId'],
      purchaseReturnId: map['purchaseReturnId'],
      purchaseReturnDate: map['purchaseReturnDate'].toDate(),
      products: List<Map<String, dynamic>>.from(map['products']),
      total: map['total'],
      setSearch: List<String>.from(map['setSearch']),
    );
  }
}

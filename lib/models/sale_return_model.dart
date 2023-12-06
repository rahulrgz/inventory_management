class SaleReturnModel {
  final String saleId;
  final String saleReturnId;
  final DateTime saleReturnDate;
  final List<Map<String, dynamic>> products;
  final List<String> setSearch;
  final String total;

  SaleReturnModel(
      {required this.saleId,
      required this.saleReturnId,
      required this.saleReturnDate,
      required this.products,
      required this.total,
      required this.setSearch});

  SaleReturnModel copyWith({
    String? saleId,
    String? saleReturnId,
    DateTime? saleReturnDate,
    List<Map<String, dynamic>>? products,
    List<String>? setSearch,
    String? total,
  }) {
    return SaleReturnModel(
      saleId: saleId ?? this.saleId,
      saleReturnId: saleReturnId ?? this.saleReturnId,
      saleReturnDate: saleReturnDate ?? this.saleReturnDate,
      products: products ?? this.products,
      total: total ?? this.total,
      setSearch: setSearch ?? this.setSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'saleId': saleId,
      'saleReturnId': saleReturnId,
      'saleReturnDate': saleReturnDate,
      'products': products,
      'total': total,
      'setSearch': setSearch,
    };
  }

  factory SaleReturnModel.fromMap(Map<String, dynamic> map) {
    return SaleReturnModel(
      saleId: map['saleId'] as String,
      saleReturnId: map['saleReturnId'] as String,
      saleReturnDate: map['saleReturnDate'].toDate(),
      products: List<Map<String, dynamic>>.from(map['products']),
      setSearch: List<String>.from(map['setSearch']),
      total: map['total'],
    );
  }
}

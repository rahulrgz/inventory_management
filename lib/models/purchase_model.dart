class PurchaseModel {
  final String supplierId;
  final String id;
  final String name;
  final List<Map<String, dynamic>> products;
  final List<String> setSearch;
  final DateTime purchaseDate;
  final String totalPrice;

  const PurchaseModel({
    required this.supplierId,
    required this.id,
    required this.name,
    required this.products,
    required this.purchaseDate,
    required this.totalPrice,
    required this.setSearch,
  });
  PurchaseModel copyWith({
    String? supplierId,
    String? id,
    String? name,
    List<Map<String, dynamic>>? products,
    DateTime? purchaseDate,
    String? totalPrice,
    List<String>? setSearch,
  }) {
    return PurchaseModel(
      supplierId: supplierId ?? this.supplierId,
      id: id ?? this.id,
      name: name ?? this.name,
      products: products ?? this.products,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      totalPrice: totalPrice ?? this.totalPrice,
      setSearch: setSearch ?? this.setSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplierId': supplierId,
      'id': id,
      'name': name,
      'products': products,
      'purchaseDate': purchaseDate,
      'totalPrice': totalPrice,
      'setSearch': setSearch,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      supplierId: map['supplierId'],
      id: map['id'],
      name: map['name'],
      products: List<Map<String, dynamic>>.from(map['products']),
      purchaseDate: map['purchaseDate'] == null
          ? DateTime.now()
          : map['purchaseDate'].toDate(),
      totalPrice: map['totalPrice'],
      setSearch: List<String>.from(map['setSearch']),
    );
  }
}

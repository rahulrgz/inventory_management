class SalesModel {
  final String id;
  final DateTime saleDate;
  final List<Map<String, dynamic>> products;
  final String customerId;
  final String totalPrice;
  final String name;
  final List setSearch;

  SalesModel({
    required this.id,
    required this.saleDate,
    required this.products,
    required this.customerId,
    required this.totalPrice,
    required this.name,
    required this.setSearch,
  });
  factory SalesModel.fromJson(Map<String, dynamic> map) => SalesModel(
        name: map['name'],
        saleDate:
            map['saleDate'] == null ? DateTime.now() : map['saleDate'].toDate(),
        products: List<Map<String, dynamic>>.from(map['products']),
        customerId: map['customerId'],
        totalPrice: map['totalPrice'],
        id: map['id'],
        setSearch: List<String>.from(map['setSearch']),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'saleDate': saleDate,
      'products': products,
      'customerId': customerId,
      'totalPrice': totalPrice,
      'setSearch': setSearch,
    };
  }

  SalesModel copyWith({
    String? id,
    DateTime? saleDate,
    String? name,
    List<Map<String, dynamic>>? products,
    List<String>? setSearch,
    String? customerId,
    String? totalPrice,
  }) =>
      SalesModel(
          id: id ?? this.id,
          saleDate: saleDate ?? this.saleDate,
          name: name ?? this.name,
          products: products ?? this.products,
          customerId: customerId ?? this.customerId,
          totalPrice: totalPrice ?? this.totalPrice,
          setSearch: setSearch ?? this.setSearch);
}

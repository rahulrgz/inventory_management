class StockModel {
  final String itemName;
  double salePrice;
  final double purchasePrice;
  final String unit;
  int quantity;
  final List<String> setSearch;
  final bool deleted;

  StockModel({
    required this.itemName,
    required this.salePrice,
    required this.purchasePrice,
    required this.unit,
    required this.quantity,
    required this.setSearch,
    required this.deleted,
  });

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is StockModel &&
  //         runtimeType == other.runtimeType &&
  //         itemName == other.itemName &&
  //         itemPrice == other.itemPrice &&
  //         unit == other.unit &&
  //         quantity == other.quantity &&
  //         setSearch == other.setSearch &&
  //         deleted == other.deleted);
  //
  // @override
  // int get hashCode =>
  //     itemName.hashCode ^
  //     itemPrice.hashCode ^
  //     unit.hashCode ^
  //     quantity.hashCode ^
  //     setSearch.hashCode ^
  //     deleted.hashCode;
  //
  // @override
  // String toString() {
  //   return 'StockModel{' +
  //       ' itemName: $itemName,' +
  //       ' itemPrice: $itemPrice,' +
  //       ' unit: $unit,' +
  //       ' quantity: $quantity,' +
  //       ' setSearch: $setSearch,' +
  //       ' deleted: $deleted,' +
  //       '}';
  // }

  StockModel copyWith({
    String? itemName,
    double? salePrice,
    double? purchasePrice,
    String? unit,
    int? quantity,
    List<String>? setSearch,
    bool? deleted,
  }) {
    return StockModel(
      itemName: itemName ?? this.itemName,
      salePrice: salePrice ?? this.salePrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      setSearch: setSearch ?? this.setSearch,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'unit': unit,
      'quantity': quantity,
      'setSearch': setSearch,
      'deleted': deleted,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      itemName: map['itemName'],
      salePrice: map['salePrice'],
      purchasePrice: map['purchasePrice'],
      unit: map['unit'],
      quantity: map['quantity'],
      setSearch: List<String>.from(map['setSearch']),
      deleted: map['deleted'],
    );
  }
}

import 'package:flutter/foundation.dart';

class BillItems {
  String itemName;
  String unit;
  int itemQuantity;
  double salePrice;
  double purchasePrice;
  int itemReturned;
  double total;
  BillItems(
      {required this.itemName,
      required this.itemQuantity,
      required this.salePrice,
      required this.total,
      required this.unit,
      required this.purchasePrice,
      required this.itemReturned});
  factory BillItems.fromMap(Map<String, dynamic> map) => BillItems(
      itemName: map['itemName'],
      itemQuantity: map['itemQuantity'],
      salePrice: map['salePrice'],
      total: map['total'],
      unit: map['unit'],
      purchasePrice: map['purchasePrice'],
      itemReturned: map['itemReturned']);
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'itemQuantity': itemQuantity,
      'salePrice': salePrice,
      'total': total,
      'unit': unit,
      'purchasePrice': purchasePrice,
      'itemReturned': itemReturned,
    };
  }
}

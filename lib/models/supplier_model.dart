class SupplierModel {
  String name;
  String phoneNumber;
  List shopId;
  List setSearch;
  DateTime createdTime;
  bool deleted;
  List<String> PurchaseId;

  SupplierModel({
    required this.name,
    required this.phoneNumber,
    required this.shopId,
    required this.setSearch,
    required this.createdTime,
    required this.deleted,
    required this.PurchaseId,
  });

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is SupplierModel &&
  //         runtimeType == other.runtimeType &&
  //         name == other.name &&
  //         phoneNumber == other.phoneNumber &&
  //         shopId == other.shopId &&
  //         setSearch == other.setSearch &&
  //         createdTime == other.createdTime &&
  //         deleted == other.deleted &&
  //         PurchaseId == other.PurchaseId);
  //
  // @override
  // int get hashCode =>
  //     name.hashCode ^
  //     phoneNumber.hashCode ^
  //     shopId.hashCode ^
  //     setSearch.hashCode ^
  //     createdTime.hashCode ^
  //     deleted.hashCode ^
  //     PurchaseId.hashCode;
  //
  // @override
  // String toString() {
  //   return 'SupplierModel{' +
  //       ' name: $name,' +
  //       ' phoneNumber: $phoneNumber,' +
  //       ' shopId: $shopId,' +
  //       ' setSearch: $setSearch,' +
  //       ' createdTime: $createdTime,' +
  //       ' deleted: $deleted,' +
  //       ' PurchaseId: $PurchaseId,' +
  //       '}';
  // }

  SupplierModel copyWith({
    String? supplierAddress,
    String? name,
    String? phoneNumber,
    List? shopId,
    List? setSearch,
    DateTime? createdTime,
    bool? deleted,
    String? supplierProfile,
    List<String>? PurchaseId,
  }) {
    return SupplierModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      shopId: shopId ?? this.shopId,
      setSearch: setSearch ?? this.setSearch,
      createdTime: createdTime ?? this.createdTime,
      deleted: deleted ?? this.deleted,
      PurchaseId: PurchaseId ?? this.PurchaseId,
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'shopId': shopId,
      'setSearch': setSearch,
      'createdTime': createdTime,
      'deleted': deleted,
      'PurchaseId': PurchaseId,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      shopId: List<String>.from(map['shopId']),
      setSearch: map['setSearch'] as List,
      createdTime: map['createdTime'] == null
          ? DateTime.now()
          : map['createdTime'].toDate(),
      deleted: map['deleted'] as bool,
      PurchaseId: List<String>.from(map['PurchaseId']),
    );
  }
}

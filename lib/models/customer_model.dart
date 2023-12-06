class CustomerModel {
  final String customerName;
  final String phoneNumber;
  final List<String> saleId;
  final List<String> shopId;
  final List<String> setSearch;
  final DateTime createdTime;
  final bool deleted;
  // final String? customerProfile;

//<editor-fold desc="Data Methods">
  const CustomerModel({
    required this.customerName,
    required this.phoneNumber,
    required this.saleId,
    required this.shopId,
    required this.setSearch,
    required this.deleted,
    required this.createdTime,
    // this.customerProfile
  });

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     (other is CustomerModel &&
  //         runtimeType == other.runtimeType &&
  //         customerName == other.customerName &&
  //         phoneNumber == other.phoneNumber &&
  //         saleId == other.saleId &&
  //         shopeId == other.shopeId);
  //
  // @override
  // int get hashCode =>
  //     customerName.hashCode ^
  //     phoneNumber.hashCode ^
  //     saleId.hashCode ^
  //     shopeId.hashCode;
  //
  // @override
  // String toString() {
  //   return 'CustomerModel{' +
  //       ' customerName: $customerName,' +
  //       ' phoneNumber: $phoneNumber,' +
  //       ' saleId: $saleId,' +
  //       ' shopeId: $shopeId,' +
  //       '}';
  // }

  CustomerModel copyWith(
      {String? customerName,
      String? phoneNumber,
      List<String>? saleId,
      List<String>? shopId,
      List<String>? setSearch,
      bool? deleted,
      String? customerAddress,
      DateTime? createdTime,
      String? customerProfile}) {
    return CustomerModel(
        customerName: customerName ?? this.customerName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        saleId: saleId ?? this.saleId,
        shopId: shopId ?? this.shopId,
        setSearch: setSearch ?? this.setSearch,
        createdTime: createdTime ?? this.createdTime,
        // customerProfile: customerProfile ?? this.customerProfile,
        deleted: deleted ?? this.deleted);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'saleId': saleId,
      'shopId': shopId,
      'setSearch': setSearch,
      'deleted': deleted,
      'createdTime': createdTime,
      // 'customerProfile': customerProfile
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      customerName: map['customerName'],
      phoneNumber: map['phoneNumber'],
      saleId: List<String>.from((map['saleId'])),
      shopId: List<String>.from(
        (map['shopId']),
      ),
      setSearch: List<String>.from(map['setSearch']),
      deleted: map['deleted'],
      createdTime: map['createdTime'].toDate(),
      // customerProfile: map['customerProfile']
    );
  }

//</editor-fold>
}

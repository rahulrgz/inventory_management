class ExpenseModel {
  final String eid;
  final String shopId;
  final String expense;
  final double amount;
  final String billImage;
  final DateTime expenseDate;
  final List<String> setSearch;
  final bool deleted;

  ExpenseModel({
    required this.eid,
    required this.shopId,
    required this.expense,
    required this.amount,
    required this.billImage,
    required this.expenseDate,
    required this.setSearch,
    required this.deleted,
  });

  ExpenseModel copyWith({
    String? eid,
    String? shopId,
    String? expense,
    double? amount,
    DateTime? expenseDate,
    String? expenseImage,
    List<String>? setSearch,
    bool? deleted,
  }) {
    return ExpenseModel(
        eid: eid ?? this.eid,
        shopId: shopId ?? this.shopId,
        expense: expense ?? this.expense,
        amount: amount ?? this.amount,
        billImage: expenseImage ?? this.billImage,
        expenseDate: expenseDate ?? this.expenseDate,
        setSearch: setSearch ?? this.setSearch,
        deleted: deleted ?? this.deleted);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eid': eid,
      'shopId': shopId,
      'expense': expense,
      'amount': amount,
      'expenseImage': billImage,
      'expenseDate': expenseDate,
      'setSearch': setSearch,
      'deleted': deleted,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      eid: map['eid'] as String,
      shopId: map['shopId'] as String,
      expense: map['expense'] as String,
      amount: double.parse(map['amount'].toString()),
      billImage: map['expenseImage'] as String,
      expenseDate: map['expenseDate'].toDate(),
      setSearch: List<String>.from(
        (map['setSearch']),
      ),
      deleted: map['deleted'] as bool,
    );
  }
}

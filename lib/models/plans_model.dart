class PlanModel {
  final List<String> setSearch;
  final List<String> subscribers;
  final DateTime createDate;
  final String status;
  final bool deleted;
  final String name;
  final double price;
  final int duration;
  PlanModel({
    required this.subscribers,
    required this.setSearch,
    required this.createDate,
    required this.status,
    required this.deleted,
    required this.name,
    required this.price,
    required this.duration,
  });
  PlanModel copyWith({
    List<String>? subscribers,
    List<String>? setSearch,
    DateTime? createDate,
    String? status,
    bool? deleted,
    String? name,
    double? price,
    int? duration,
  }) =>
      PlanModel(
        setSearch: setSearch ?? this.setSearch,
        createDate: createDate ?? this.createDate,
        status: status ?? this.status,
        deleted: deleted ?? this.deleted,
        name: name ?? this.name,
        price: price ?? this.price,
        duration: duration ?? this.duration,
        subscribers: subscribers ?? this.subscribers,
      );
  Map<String, dynamic> toMap() {
    return {
      'subscribers': subscribers,
      'setSearch': setSearch,
      'createDate': createDate,
      'status': status,
      'deleted': deleted,
      'name': name,
      'price': price,
      'duration': duration,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) => PlanModel(
        setSearch: List<String>.from(map['setSearch']),
        createDate: map['createDate'] == null
            ? DateTime.now()
            : map['createDate'].toDate(),
        status: map['status'],
        deleted: map['deleted'],
        name: map['name'],
        price: double.parse(map['price'].toString()),
        duration: map['duration'],
        subscribers: List<String>.from(map['subscribers']),
      );
}

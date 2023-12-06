// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class ShopModel {
  final String uid;
  final String category;
  final String name;
  final String shopId;
  final String shopProfile;
  final String subscriptionId;
  final DateTime createdTime;
  final bool deleted;
  final List<String> setSearch;
  final bool accepted;
  final bool blocked;
  final String reason;
  final DateTime expirationDate;
  ShopModel(
      {required this.uid,
      required this.category,
      required this.name,
      required this.shopId,
      required this.subscriptionId,
      required this.createdTime,
      required this.shopProfile,
      required this.deleted,
      required this.setSearch,
      required this.accepted,
      required this.blocked,
      required this.reason,
      required this.expirationDate});

  ShopModel copyWith(
      {String? uid,
      String? category,
      String? name,
      String? shopId,
      String? shopProfile,
      String? subscriptionId,
      DateTime? createdTime,
      bool? deleted,
      List<String>? setSearch,
      bool? accepted,
      bool? blocked,
      String? reason,
      DateTime? expirationDate}) {
    return ShopModel(
        uid: uid ?? this.uid,
        category: category ?? this.category,
        name: name ?? this.name,
        shopId: shopId ?? this.shopId,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        createdTime: createdTime ?? this.createdTime,
        deleted: deleted ?? this.deleted,
        setSearch: setSearch ?? this.setSearch,
        shopProfile: shopProfile ?? this.shopProfile,
        accepted: accepted ?? this.accepted,
        blocked: blocked ?? this.blocked,
        reason: reason ?? this.reason,
        expirationDate: expirationDate ?? this.expirationDate);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'shopProfile': shopProfile,
      'category': category,
      'name': name,
      'shopId': shopId,
      'subscriptionId': subscriptionId,
      'createdTime': createdTime,
      'deleted': deleted,
      'setSearch': setSearch,
      'accepted': accepted,
      'blocked': blocked,
      'reason': reason,
      'expirationDate': expirationDate
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
        uid: map['uid'] as String,
        category: map['category'] as String,
        name: map['name'] as String,
        shopProfile: map['shopProfile'] as String,
        shopId: map['shopId'] as String,
        subscriptionId: map['subscriptionId'] as String,
        createdTime: map['createdTime'].toDate(),
        deleted: map['deleted'] as bool,
        setSearch: List<String>.from(
          (map['setSearch']),
        ),
        accepted: map['accepted'],
        blocked: map['blocked'],
        reason: map['reason'],
        expirationDate: map['expirationDate'] == null
            ? DateTime.now()
            : map['expirationDate'].toDate());
  }
//
// @override
// String toString() {
//   return 'ShopeModel(uid: $uid, category: $category, name: $name, shopId: $shopId, shopProfile: $shopProfile, subscriptionId: $subscriptionId, createdTime: $createdTime, deleted: $deleted, setSearch: $setSearch)';
// }
//
// @override
// bool operator ==(covariant ShopModel other) {
//   if (identical(this, other)) return true;
//
//   return other.uid == uid &&
//       other.category == category &&
//       other.name == name &&
//       other.shopId == shopId &&
//       other.shopProfile == shopProfile &&
//       other.subscriptionId == subscriptionId &&
//       other.createdTime == createdTime &&
//       other.deleted == deleted &&
//       listEquals(other.setSearch, setSearch);
// }
//
// @override
// int get hashCode {
//   return uid.hashCode ^
//       category.hashCode ^
//       name.hashCode ^
//       shopProfile.hashCode ^
//       shopId.hashCode ^
//       subscriptionId.hashCode ^
//       createdTime.hashCode ^
//       deleted.hashCode ^
//       setSearch.hashCode;
// }
}

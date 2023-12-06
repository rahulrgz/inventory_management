import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String uid;
  final String email;
  final String profilePic;
  final String phNo;
  final DateTime createdTime;
  final DateTime loginTime;
  final bool deleted;
  final List<String> setSearch;

  UserModel(
      {required this.name,
      required this.uid,
      required this.email,
      required this.profilePic,
      required this.phNo,
      required this.createdTime,
      required this.loginTime,
      required this.deleted,
      required this.setSearch});

  UserModel copyWith({
    String? name,
    String? uid,
    String? email,
    String? profilePic,
    String? phNo,
    DateTime? createdTime,
    DateTime? loginTime,
    bool? deleted,
    List<String>? setSearch,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      phNo: phNo ?? this.phNo,
      createdTime: createdTime ?? this.createdTime,
      loginTime: loginTime ?? this.loginTime,
      deleted: deleted ?? this.deleted,
      setSearch: setSearch ?? this.setSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'phNo': phNo,
      'createdTime': createdTime,
      'loginTime': loginTime,
      'deleted': deleted,
      'setSearch': setSearch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        uid: map['uid'] as String,
        email: map['email'] as String,
        profilePic: map['profilePic'] as String,
        phNo: map['phNo'] as String,
        createdTime: map['createdTime'].toDate(),
        loginTime: map['loginTime'].toDate(),
        deleted: map['deleted'] as bool,
        setSearch: List<String>.from(
          (map['setSearch']),
        ));
  }

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, email: $email,profilePic: $profilePic, phNo: $phNo, createdTime: $createdTime, loginTime: $loginTime, deleted: $deleted, setSearch: $setSearch)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.uid == uid &&
        other.email == email &&
        other.profilePic == profilePic &&
        other.phNo == phNo &&
        other.createdTime == createdTime &&
        other.loginTime == loginTime &&
        other.deleted == deleted &&
        listEquals(other.setSearch, setSearch);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        profilePic.hashCode ^
        phNo.hashCode ^
        createdTime.hashCode ^
        loginTime.hashCode ^
        deleted.hashCode ^
        setSearch.hashCode;
  }
}

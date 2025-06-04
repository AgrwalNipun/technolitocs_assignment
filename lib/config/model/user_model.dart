

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<User?>((ref) => null);



class User {
  String? id;
  String? accessToken;
  Map<String,dynamic>? userData;

  User({this.id, this.accessToken, this.userData});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    userData = json['userData'] != null
        ? json['user']
        : null;
  }
  User copyWith({
    String? id,
    String? accessToken,
    Map<String,dynamic>? userData,
  }) {
    return User(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      userData: userData??this.userData,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accessToken'] = this.accessToken;
    if (this.userData != null) {
      data['userData'] = this.userData!;
    }
    return data;
  }
}


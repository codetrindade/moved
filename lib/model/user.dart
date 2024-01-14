import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/driver.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String name;
  String email;
  String token;
  String photo;
  String status;
  @JsonKey(name: 'facebookid')
  String facebookId;
  bool facebook = false;
  String password;
  String type = 'driver';
  String phone;
  @JsonKey(name: 'sms_code')
  String smsCode;
  String document;
  String gender;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  int operationMode;
  @JsonKey(name: 'has_password')
  bool hasPassword;
  @JsonKey(name: 'use_facebook_photo')
  bool useFacebookPhoto;
  String rating;
  @JsonKey(name: 'display_my_phone')
  bool displayMyPhone;

//  Coordinates coordinates;

  Driver driver;

  User(
      {this.id,
      this.name,
      this.email,
      this.status,
      this.photo,
      this.useFacebookPhoto,
      this.hasPassword = true,
      this.password,
      this.displayMyPhone,
      this.operationMode = 0});

  factory User.fromJson(Map<String, dynamic> map) => _$UserFromJson(map);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

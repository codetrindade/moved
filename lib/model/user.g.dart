// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    status: json['status'] as String,
    photo: json['photo'] as String,
    useFacebookPhoto: json['use_facebook_photo'] as bool,
    hasPassword: json['has_password'] as bool,
    password: json['password'] as String,
    displayMyPhone: json['display_my_phone'] as bool,
    operationMode: json['operationMode'] as int,
  )
    ..token = json['token'] as String
    ..facebookId = json['facebookid'] as String
    ..facebook = json['facebook'] as bool
    ..type = json['type'] as String
    ..phone = json['phone'] as String
    ..smsCode = json['sms_code'] as String
    ..document = json['document'] as String
    ..gender = json['gender'] as String
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..rating = json['rating'] as String
    ..driver = json['driver'] == null
        ? null
        : Driver.fromJson(json['driver'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'token': instance.token,
      'photo': instance.photo,
      'status': instance.status,
      'facebookid': instance.facebookId,
      'facebook': instance.facebook,
      'password': instance.password,
      'type': instance.type,
      'phone': instance.phone,
      'sms_code': instance.smsCode,
      'document': instance.document,
      'gender': instance.gender,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'operationMode': instance.operationMode,
      'has_password': instance.hasPassword,
      'use_facebook_photo': instance.useFacebookPhoto,
      'rating': instance.rating,
      'display_my_phone': instance.displayMyPhone,
      'driver': instance.driver,
    };

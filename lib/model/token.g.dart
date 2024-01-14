// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
    message: json['message'] as String,
    token: json['token'] as String,
  )..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'message': instance.message,
      'token': instance.token,
      'user': instance.user,
    };

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/user.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  String message = '';
  String token = '';
  User user;

  Token({this.message, this.token});

  factory Token.fromJson(Map<String, dynamic> map) => _$TokenFromJson(map);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

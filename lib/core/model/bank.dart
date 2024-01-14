import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'bank.g.dart';

@JsonSerializable()
class Bank {
  String number;
  String name;

  Bank({this.name, this.number});

  factory Bank.fromJson(Map<String, dynamic> map) => _$BankFromJson(map);

  Map<String, dynamic> toJson() => _$BankToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bank _$BankFromJson(Map<String, dynamic> json) {
  return Bank(
    name: json['name'] as String,
    number: json['number'] as String,
  );
}

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
    };

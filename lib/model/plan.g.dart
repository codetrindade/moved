// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plan _$PlanFromJson(Map<String, dynamic> json) {
  return Plan(
    id: json['id'] as String,
  )
    ..name = json['name'] as String
    ..rides = json['rides'] as String
    ..detail = json['detail'] as String
    ..price = json['price'] as String;
}

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rides': instance.rides,
      'detail': instance.detail,
      'price': instance.price,
    };

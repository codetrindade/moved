// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Points _$PointsFromJson(Map<String, dynamic> json) {
  return Points(
    lat: json['lat'] as String,
    long: json['long'] as String,
    order: json['order'] as int,
    price: json['price'] as int,
    address: json['address'] as String,
  )
    ..id = json['id'] as String
    ..number = json['number'] as String
    ..district = json['district'] as String
    ..city = json['city'] as String
    ..state = json['state'] as String;
}

Map<String, dynamic> _$PointsToJson(Points instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'long': instance.long,
      'order': instance.order,
      'price': instance.price,
      'address': instance.address,
      'number': instance.number,
      'district': instance.district,
      'city': instance.city,
      'state': instance.state,
    };

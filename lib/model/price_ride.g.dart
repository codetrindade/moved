// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceRide _$PriceRideFromJson(Map<String, dynamic> json) {
  return PriceRide()
    ..origin = json['origin'] as int
    ..originAddress = json['originAddress'] as String
    ..destination = json['destination'] as int
    ..destinationAddress = json['destinationAddress'] as String
    ..main = json['main'] as bool
    ..distance = (json['distance'] as num).toDouble()
    ..price = (json['price'] as num).toDouble()
    ..duration = (json['duration'] as num).toDouble()
    ..originPoint = json['origin_point'] == null
        ? null
        : Address.fromJson(json['origin_point'] as Map<String, dynamic>)
    ..destinationPoint = json['destination_point'] == null
        ? null
        : Address.fromJson(json['destination_point'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PriceRideToJson(PriceRide instance) => <String, dynamic>{
      'origin': instance.origin,
      'originAddress': instance.originAddress,
      'destination': instance.destination,
      'destinationAddress': instance.destinationAddress,
      'main': instance.main,
      'distance': instance.distance,
      'price': instance.price,
      'duration': instance.duration,
      'origin_point': instance.originPoint,
      'destination_point': instance.destinationPoint,
    };

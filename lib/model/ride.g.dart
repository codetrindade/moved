// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) {
  return Ride(
    distance: json['distance'] as String,
    durationEstimate: json['duration'] as String,
    polyline: json['polyline'] as String,
    back: json['back'] as bool,
  )
    ..id = json['id'] as String
    ..price = (json['price'] as num).toDouble()
    ..date = json['date'] as String
    ..time = json['time'] as String
    ..reservations = json['reservations'] as int
    ..autoConfirm = json['auto_confirm'] as bool
    ..points = (json['points'] as List)
        .map((e) =>
            e == null ? null : Points.fromJson(e as Map<String, dynamic>))
        .toList()
    ..prices = (json['prices'] as List)
        .map((e) =>
            e == null ? null : PriceRide.fromJson(e as Map<String, dynamic>))
        .toList()
    ..pending = json['pending'] as bool;
}

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'date': instance.date,
      'time': instance.time,
      'reservations': instance.reservations,
      'auto_confirm': instance.autoConfirm,
      'distance': instance.distance,
      'duration': instance.durationEstimate,
      'points': instance.points,
      'prices': instance.prices,
      'back': instance.back,
      'pending': instance.pending,
      'polyline': instance.polyline,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Passenger _$PassengerFromJson(Map<String, dynamic> json) {
  return Passenger()
    ..id = json['id'] as String
    ..payment = json['payment'] as String
    ..ridePriceId = json['ride_price_id'] as String
    ..createdAt = json['created_at'] as String
    ..confirmed = json['confirmed'] as bool
    ..reservations = json['reservations'] as int
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..rideCount = json['ride_count'] as int
    ..ridePrice = json['ride_price'] == null
        ? null
        : PriceRide.fromJson(json['ride_price'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PassengerToJson(Passenger instance) => <String, dynamic>{
      'id': instance.id,
      'payment': instance.payment,
      'ride_price_id': instance.ridePriceId,
      'created_at': instance.createdAt,
      'confirmed': instance.confirmed,
      'reservations': instance.reservations,
      'user': instance.user,
      'ride_count': instance.rideCount,
      'ride_price': instance.ridePrice,
    };

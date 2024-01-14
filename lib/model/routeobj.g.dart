// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routeobj.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteObj _$RouteObjFromJson(Map<String, dynamic> json) {
  return RouteObj()
    ..id = json['id'] as String
    ..status = json['status'] as String
    ..payment = json['payment'] as String
    ..price = (json['price'] as num).toDouble()
    ..distance = (json['distance'] as num).toDouble()
    ..durationEstimate = (json['duration_estimate'] as num).toDouble()
    ..ratingDriver = json['rating_driver'] as String
    ..ratingDriverObservation = json['rating_driver_observation'] as String
    ..ratingUser = json['rating_user'] as String
    ..ratingUserObservation = json['rating_user_observation'] as String
    ..createdAt = json['created_at'] as String
    ..driverId = json['driver_id'] as String
    ..driverName = json['driver_name'] as String
    ..driverPhoto = json['driver_photo'] as String
    ..plate = json['plate'] as String
    ..color = json['color'] as String
    ..model = json['model'] as String
    ..origin = json['origin'] as String
    ..destination = json['destination'] as String;
}

Map<String, dynamic> _$RouteObjToJson(RouteObj instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'payment': instance.payment,
      'price': instance.price,
      'distance': instance.distance,
      'duration_estimate': instance.durationEstimate,
      'rating_driver': instance.ratingDriver,
      'rating_driver_observation': instance.ratingDriverObservation,
      'rating_user': instance.ratingUser,
      'rating_user_observation': instance.ratingUserObservation,
      'created_at': instance.createdAt,
      'driver_id': instance.driverId,
      'driver_name': instance.driverName,
      'driver_photo': instance.driverPhoto,
      'plate': instance.plate,
      'color': instance.color,
      'model': instance.model,
      'origin': instance.origin,
      'destination': instance.destination,
    };

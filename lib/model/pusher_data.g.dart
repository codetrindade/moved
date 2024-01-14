// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pusher_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PusherData _$PusherDataFromJson(Map<String, dynamic> json) {
  return PusherData(
    command: json['command'] as String,
    data: json['data'] == null
        ? null
        : ReceivedData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PusherDataToJson(PusherData instance) =>
    <String, dynamic>{
      'command': instance.command,
      'data': instance.data,
    };

ReceivedData _$ReceivedDataFromJson(Map<String, dynamic> json) {
  return ReceivedData()
    ..address = json['address'] as String
    ..destinies = (json['destinies'] as List).map((e) => e as String).toList()
    ..distance = (json['distance'] as num).toDouble()
    ..durationEstimate = (json['duration_estimate'] as num).toDouble()
    ..price = json['price'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..id = json['id'] as String
    ..payment = json['payment'] as String
    ..routeId = json['routeId'] as String
    ..status = json['status'] as String
    ..polyline = json['polyline'] as String
    ..travelledDistance = (json['travelled_distance'] as num).toDouble() ?? 0
    ..leftPoints = json['left_points'] as int ?? 0
    ..nextPointId = json['nextPointId'] as String;
}

Map<String, dynamic> _$ReceivedDataToJson(ReceivedData instance) =>
    <String, dynamic>{
      'address': instance.address,
      'destinies': instance.destinies,
      'distance': instance.distance,
      'duration_estimate': instance.durationEstimate,
      'price': instance.price,
      'user': instance.user,
      'id': instance.id,
      'payment': instance.payment,
      'routeId': instance.routeId,
      'status': instance.status,
      'polyline': instance.polyline,
      'travelled_distance': instance.travelledDistance,
      'left_points': instance.leftPoints,
      'nextPointId': instance.nextPointId,
    };

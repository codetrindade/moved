// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverStatus _$DriverStatusFromJson(Map<String, dynamic> json) {
  return DriverStatus(
    currentRouteId: json['current_route_id'] as String,
    driverStatus: json['driver_status'] as String,
    userStatus: json['user_status'] as String,
    currentRouteStatus: json['current_route_status'] as String,
  );
}

Map<String, dynamic> _$DriverStatusToJson(DriverStatus instance) =>
    <String, dynamic>{
      'user_status': instance.userStatus,
      'driver_status': instance.driverStatus,
      'current_route_id': instance.currentRouteId,
      'current_route_status': instance.currentRouteStatus,
    };

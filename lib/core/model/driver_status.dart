import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'driver_status.g.dart';

@JsonSerializable()
class DriverStatus {
  @JsonKey(name: 'user_status')
  String userStatus;
  @JsonKey(name: 'driver_status')
  String driverStatus;
  @JsonKey(name: 'current_route_id')
  String currentRouteId;
  @JsonKey(name: 'current_route_status')
  String currentRouteStatus;

  DriverStatus({this.currentRouteId, this.driverStatus, this.userStatus, this.currentRouteStatus});

  factory DriverStatus.fromJson(Map<String, dynamic> map) => _$DriverStatusFromJson(map);

  Map<String, dynamic> toJson() => _$DriverStatusToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
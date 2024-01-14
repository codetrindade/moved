import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routeobj.g.dart';

@JsonSerializable()
class RouteObj {
  String id;
  String status;
  String payment;
  double price;
  double distance;
  @JsonKey(name: 'duration_estimate')
  double durationEstimate;
  @JsonKey(name: 'rating_driver')
  String ratingDriver;
  @JsonKey(name: 'rating_driver_observation')
  String ratingDriverObservation;
  @JsonKey(name: 'rating_user')
  String ratingUser;
  @JsonKey(name: 'rating_user_observation')
  String ratingUserObservation;
  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'driver_id')
  String driverId;

  @JsonKey(name: 'driver_name')
  String driverName;

  @JsonKey(name: 'driver_photo')
  String driverPhoto;

  String plate;
  String color;
  String model;
  String origin;
  String destination;

  @JsonKey(ignore: true)
  CameraPosition initialPosition;
  @JsonKey(ignore: true)
  Set<Marker> points = new Set<Marker>();
  @JsonKey(ignore: true)
  List<LatLng> listPoints = new List<LatLng>();

  RouteObj();

  factory RouteObj.fromJson(Map<String, dynamic> map) => _$RouteObjFromJson(map);

  Map<String, dynamic> toJson() => _$RouteObjToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
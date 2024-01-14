import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/points.dart';
import 'package:movemedriver/model/price_ride.dart';

part 'ride.g.dart';

@JsonSerializable()
class Ride {
  String id;

  double price;
  String date;
  String time;
  int reservations;
  @JsonKey(name: 'auto_confirm')
  bool autoConfirm = false;
  String distance;
  @JsonKey(name: 'duration')
  String durationEstimate;
  List<Points> points;
  List<PriceRide> prices;
  bool back;
  bool pending;

  String polyline;

  Ride({
    this.distance,
    this.durationEstimate,
    this.polyline,
    this.back = false});

  factory Ride.fromJson(Map<String, dynamic> map) => _$RideFromJson(map);

  Map<String, dynamic> toJson() => _$RideToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/address.dart';

part 'price_ride.g.dart';

@JsonSerializable()
class PriceRide {

  int origin;
  String originAddress;
  int destination;
  String destinationAddress;
  bool main;
  double distance;
  double price;
  double duration;

  @JsonKey(name: 'origin_point')
  Address originPoint;
  @JsonKey(name: 'destination_point')
  Address destinationPoint;

  PriceRide();

  factory PriceRide.fromJson(Map<String, dynamic> map) => _$PriceRideFromJson(map);

  Map<String, dynamic> toJson() => _$PriceRideToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
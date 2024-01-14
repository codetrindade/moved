import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/price_ride.dart';
import 'package:movemedriver/model/user.dart';

part 'passenger.g.dart';

@JsonSerializable()
class Passenger {
  String id;
  String payment;
  @JsonKey(name: 'ride_price_id')
  String ridePriceId;
  @JsonKey(name: 'created_at')
  String createdAt;
  bool confirmed;
  int reservations;
  User user;
  @JsonKey(name: 'ride_count')
  int rideCount;

  @JsonKey(name: 'ride_price')
  PriceRide ridePrice;

  Passenger();

  factory Passenger.fromJson(Map<String, dynamic> map) => _$PassengerFromJson(map);

  Map<String, dynamic> toJson() => _$PassengerToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
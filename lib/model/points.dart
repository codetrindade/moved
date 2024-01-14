import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'points.g.dart';

@JsonSerializable()
class Points {

  String id;
  String lat;
  String long;
  int order;
  int price;
  String address;
  String number;
  String district;
  String city;
  String state;

  Points({this.lat, this.long, this.order, this.price, this.address});

  factory Points.fromJson(Map<String, dynamic> map) => _$PointsFromJson(map);

  Map<String, dynamic> toJson() => _$PointsToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/user.dart';

part 'pusher_data.g.dart';

@JsonSerializable()
class PusherData {
  String command;
  ReceivedData data;

  PusherData({this.command, this.data});

  factory PusherData.fromJson(Map<String, dynamic> map) => _$PusherDataFromJson(map);

  Map<String, dynamic> toJson() => _$PusherDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class ReceivedData {
  String address;
  List<String> destinies;
  double distance;
  @JsonKey(name: 'duration_estimate')
  double durationEstimate;
  String price;
  User user;
  String id;
  String payment;
  String routeId;
  String status;
  String polyline;
  @JsonKey(name: 'travelled_distance', defaultValue: 0, nullable: true)
  double travelledDistance;
  @JsonKey(name: 'left_points', defaultValue: 0, nullable: true)
  int leftPoints;
  String nextPointId;

  ReceivedData();

  factory ReceivedData.fromJson(Map<String, dynamic> map) => _$ReceivedDataFromJson(map);

  Map<String, dynamic> toJson() => _$ReceivedDataToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

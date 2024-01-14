import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan {
  String id;
  String name;
  String rides;
  String detail;
  String price;

  Plan({this.id});

  factory Plan.fromJson(Map<String, dynamic> map) => _$PlanFromJson(map);

  Map<String, dynamic> toJson() => _$PlanToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

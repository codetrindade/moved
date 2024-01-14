import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/driver.dart';
import 'package:movemedriver/model/ride.dart';

part 'preview.g.dart';

@JsonSerializable()
class Preview {
  Ride trip;
  List<Driver> drivers;

  Preview();

  factory Preview.fromJson(Map<String, dynamic> map) => _$PreviewFromJson(map);

  Map<String, dynamic> toJson() => _$PreviewToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
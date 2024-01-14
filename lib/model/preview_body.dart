import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:movemedriver/model/address.dart';

part 'preview_body.g.dart';

@JsonSerializable()
class PreviewBody {
  List<String> payments = [];
  List<Address> points;

  PreviewBody();

  factory PreviewBody.fromJson(Map<String, dynamic> map) => _$PreviewBodyFromJson(map);

  Map<String, dynamic> toJson() => _$PreviewBodyToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
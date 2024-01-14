import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'extract.g.dart';

@JsonSerializable()
class Extract {
  String day;
  double total;
  ExtractItem resume;
  List<Extract> days;

  Extract({this.total, this.day, this.resume});

  factory Extract.fromJson(Map<String, dynamic> map) => _$ExtractFromJson(map);

  Map<String, dynamic> toJson() => _$ExtractToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

@JsonSerializable()
class ExtractItem {
  double money;
  double card;
  double km;
  @JsonKey(name: 'duration_minutes')
  int durationMinutes;
  @JsonKey(name: 'routes_qtt')
  int routesQtt;

  ExtractItem({this.card, this.durationMinutes, this.km, this.money, this.routesQtt});

  factory ExtractItem.fromJson(Map<String, dynamic> map) => _$ExtractItemFromJson(map);

  Map<String, dynamic> toJson() => _$ExtractItemToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

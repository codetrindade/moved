import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'wizard.g.dart';

@JsonSerializable()
class Wizard {
  String name;
  String route;
  String status;
  String icon;

  Wizard({this.status, this.name, this.route, this.icon});

  factory Wizard.fromJson(Map<String, dynamic> map) => _$WizardFromJson(map);

  Map<String, dynamic> toJson() => _$WizardToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
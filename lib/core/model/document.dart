import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'document.g.dart';

@JsonSerializable()
class Document {
  String id;
  String photo;
  @JsonKey(name: 'admin_status')
  String adminStatus;
  String type;
  String obs;
  @JsonKey(name: 'created_at')
  DateTime createdAt;

  Document({this.adminStatus, this.id, this.obs, this.type, this.createdAt, this.photo});

  factory Document.fromJson(Map<String, dynamic> map) => _$DocumentFromJson(map);

  Map<String, dynamic> toJson() => _$DocumentToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
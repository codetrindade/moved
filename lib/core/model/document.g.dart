// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document(
    adminStatus: json['admin_status'] as String,
    id: json['id'] as String,
    obs: json['obs'] as String,
    type: json['type'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    photo: json['photo'] as String,
  );
}

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{
      'id': instance.id,
      'photo': instance.photo,
      'admin_status': instance.adminStatus,
      'type': instance.type,
      'obs': instance.obs,
      'created_at': instance.createdAt.toIso8601String(),
    };

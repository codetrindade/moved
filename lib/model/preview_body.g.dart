// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewBody _$PreviewBodyFromJson(Map<String, dynamic> json) {
  return PreviewBody()
    ..payments = (json['payments'] as List).map((e) => e as String).toList()
    ..points = (json['points'] as List)
        .map((e) =>
            e == null ? null : Address.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PreviewBodyToJson(PreviewBody instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'points': instance.points,
    };

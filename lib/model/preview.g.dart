// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preview _$PreviewFromJson(Map<String, dynamic> json) {
  return Preview()
    ..trip = json['trip'] == null
        ? null
        : Ride.fromJson(json['trip'] as Map<String, dynamic>)
    ..drivers = (json['drivers'] as List)
        .map((e) =>
            e == null ? null : Driver.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PreviewToJson(Preview instance) => <String, dynamic>{
      'trip': instance.trip,
      'drivers': instance.drivers,
    };

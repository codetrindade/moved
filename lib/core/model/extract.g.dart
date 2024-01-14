// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Extract _$ExtractFromJson(Map<String, dynamic> json) {
  return Extract(
    total: (json['total'] as num).toDouble(),
    day: json['day'] as String,
    resume: json['resume'] == null
        ? null
        : ExtractItem.fromJson(json['resume'] as Map<String, dynamic>),
  )..days = (json['days'] as List)
      .map(
          (e) => e == null ? null : Extract.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$ExtractToJson(Extract instance) => <String, dynamic>{
      'day': instance.day,
      'total': instance.total,
      'resume': instance.resume,
      'days': instance.days,
    };

ExtractItem _$ExtractItemFromJson(Map<String, dynamic> json) {
  return ExtractItem(
    card: (json['card'] as num).toDouble(),
    durationMinutes: json['duration_minutes'] as int,
    km: (json['km'] as num).toDouble(),
    money: (json['money'] as num).toDouble(),
    routesQtt: json['routes_qtt'] as int,
  );
}

Map<String, dynamic> _$ExtractItemToJson(ExtractItem instance) =>
    <String, dynamic>{
      'money': instance.money,
      'card': instance.card,
      'km': instance.km,
      'duration_minutes': instance.durationMinutes,
      'routes_qtt': instance.routesQtt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wizard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wizard _$WizardFromJson(Map<String, dynamic> json) {
  return Wizard(
    status: json['status'] as String,
    name: json['name'] as String,
    route: json['route'] as String,
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$WizardToJson(Wizard instance) => <String, dynamic>{
      'name': instance.name,
      'route': instance.route,
      'status': instance.status,
      'icon': instance.icon,
    };

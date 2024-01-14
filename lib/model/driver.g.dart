// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Driver _$DriverFromJson(Map<String, dynamic> json) {
  return Driver(
    id: json['id'] as String,
    flag: json['flag'] as String,
    description: json['description'] as String,
    minPriceOne: (json['min_price_one'] as num).toDouble(),
    minPriceTwo: (json['min_price_two'] as num).toDouble(),
    music: json['music'] as int,
    paymentCredit: json['payment_credit'] as int,
    paymentDebit: json['payment_debit'] as int,
    paymentOnline: json['payment_online'] as int,
    paymentMoney: json['payment_money'] as int,
    priceOne: (json['price_one'] as num).toDouble(),
    maxStopTime: json['max_stop_time'] as int,
    priceTwo: (json['price_two'] as num).toDouble(),
    smoke: json['smoke'] as int,
    talk: json['talk'] as int,
  );
}

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'talk': instance.talk,
      'smoke': instance.smoke,
      'music': instance.music,
      'flag': instance.flag,
      'min_price_one': instance.minPriceOne,
      'min_price_two': instance.minPriceTwo,
      'price_one': instance.priceOne,
      'price_two': instance.priceTwo,
      'payment_money': instance.paymentMoney,
      'payment_debit': instance.paymentDebit,
      'payment_credit': instance.paymentCredit,
      'payment_online': instance.paymentOnline,
      'max_stop_time': instance.maxStopTime,
    };

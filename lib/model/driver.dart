import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'driver.g.dart';

@JsonSerializable()
class Driver {
  String id;
  String description;
  int talk;
  int smoke;
  int music;
  String flag;
  @JsonKey(name: 'min_price_one', nullable: true)
  double minPriceOne;
  @JsonKey(name: 'min_price_two', nullable: true)
  double minPriceTwo;
  @JsonKey(name: 'price_one', nullable: true)
  double priceOne;
  @JsonKey(name: 'price_two', nullable: true)
  double priceTwo;
  @JsonKey(name: 'payment_money', nullable: true)
  int paymentMoney;
  @JsonKey(name: 'payment_debit', nullable: true)
  int paymentDebit;
  @JsonKey(name: 'payment_credit', nullable: true)
  int paymentCredit;
  @JsonKey(name: 'payment_online', nullable: true)
  int paymentOnline;
  @JsonKey(name: 'max_stop_time', nullable: true)
  int maxStopTime;

  Driver(
      {this.id,
      this.flag,
      this.description,
      this.minPriceOne,
      this.minPriceTwo,
      this.music,
      this.paymentCredit,
      this.paymentDebit,
      this.paymentOnline,
      this.paymentMoney,
      this.priceOne,
      this.maxStopTime,
      this.priceTwo,
      this.smoke,
      this.talk});

  factory Driver.fromJson(Map<String, dynamic> map) => _$DriverFromJson(map);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

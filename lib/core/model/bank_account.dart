import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'bank_account.g.dart';

@JsonSerializable()
class BankAccount {
  String postCode;
  String neighborhood;
  String street;
  String complement;
  String number;
  String city;
  String state;
  String bankNumber;
  String agencyNumber;
  String accountNumber;
  String accountComplementNumber;
  String accountCaixaNumber;
  String accountType;
  String accountHolderName;
  String accountHolderDocument;
  String birthDate;

  BankAccount(
      {this.city,
      this.complement,
      this.neighborhood,
      this.state,
      this.street,
      this.number,
      this.postCode,
      this.accountComplementNumber,
      this.accountHolderDocument,
      this.accountHolderName,
      this.accountNumber,
      this.accountType,
      this.agencyNumber,
      this.accountCaixaNumber,
      this.birthDate,
      this.bankNumber});

  factory BankAccount.fromJson(Map<String, dynamic> map) => _$BankAccountFromJson(map);

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}

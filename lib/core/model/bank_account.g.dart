// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return BankAccount(
    city: json['city'] as String,
    complement: json['complement'] as String,
    neighborhood: json['neighborhood'] as String,
    state: json['state'] as String,
    street: json['street'] as String,
    number: json['number'] as String,
    postCode: json['postCode'] as String,
    accountComplementNumber: json['accountComplementNumber'] as String,
    accountHolderDocument: json['accountHolderDocument'] as String,
    accountHolderName: json['accountHolderName'] as String,
    accountNumber: json['accountNumber'] as String,
    accountType: json['accountType'] as String,
    agencyNumber: json['agencyNumber'] as String,
    accountCaixaNumber: json['accountCaixaNumber'] as String,
    birthDate: json['birthDate'] as String,
    bankNumber: json['bankNumber'] as String,
  );
}

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'postCode': instance.postCode,
      'neighborhood': instance.neighborhood,
      'street': instance.street,
      'complement': instance.complement,
      'number': instance.number,
      'city': instance.city,
      'state': instance.state,
      'bankNumber': instance.bankNumber,
      'agencyNumber': instance.agencyNumber,
      'accountNumber': instance.accountNumber,
      'accountComplementNumber': instance.accountComplementNumber,
      'accountCaixaNumber': instance.accountCaixaNumber,
      'accountType': instance.accountType,
      'accountHolderName': instance.accountHolderName,
      'accountHolderDocument': instance.accountHolderDocument,
      'birthDate': instance.birthDate,
    };

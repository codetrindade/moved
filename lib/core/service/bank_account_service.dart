import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/bank.dart';
import 'package:movemedriver/core/model/bank_account.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';

class BankAccountService extends BaseService {
  Api _api;

  BankAccountService() {
    this._api = locator.get<Api>();
  }

  Future<BankAccount> getAddress(String zipCode) async {
    return BankAccount.fromJson(getResponse(await _api.get("general/address_from_zip_code/$zipCode")));
  }

  Future<BankAccount> getAccount() async {
    return BankAccount.fromJson(getResponse(await _api.get("driver/account/get")));
  }

  Future<BankAccount> saveAccount(BankAccount data) async {
    return BankAccount.fromJson(
        getResponse(await _api.post("driver/account/create_or_update", data.toString())));
  }

  Future<List<Bank>> getBankList() async {
    var data = getResponse(await _api.get('driver/account/get_bank_list'));
    return (data as List).map((i) => new Bank.fromJson(i)).toList();
  }
}

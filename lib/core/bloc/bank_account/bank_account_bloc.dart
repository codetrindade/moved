import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/bank.dart';
import 'package:movemedriver/core/model/bank_account.dart';
import 'package:movemedriver/core/service/bank_account_service.dart';
import 'package:movemedriver/locator.dart';

class BankAccountBloc extends BaseBloc {
  var bankAccountService = locator.get<BankAccountService>();
  List<Bank> banks = [];
  BankAccount model;

  Future<BankAccount> getAddressByZipCode(String zipCode) async {
    try {
      if (zipCode.length != 9) {
        dialogService.showDialog('Atenção', 'Digite o CEP corretamente');
        return null;
      }
      setLoading(true);
      var a = await bankAccountService.getAddress(zipCode);
      setLoading(false);
      return a;
    } catch (error) {
      onError(error);
      return null;
    }
  }

  getBankList() async {
    try {
      setLoading(true);
      banks = await bankAccountService.getBankList();
      await this.getAccount();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getAccount() async {
    try {
      model = await bankAccountService.getAccount();
      if (model.accountHolderName == null) model = null;
    } catch (e) {
      print(e);
    }
  }

  saveAccount(BankAccount data) async {
    try {
      setLoading(true);
      await bankAccountService.saveAccount(data);
      dialogService.showDialog('Sucesso', 'Dados salvos com sucesso');
      navigationManager.goBack();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}

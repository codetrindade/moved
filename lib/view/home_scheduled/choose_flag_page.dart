import 'package:flutter/material.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/bloc/home/home_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ChooseFlagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<HomeBloc>(context);
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: double.infinity,
        padding: EdgeInsets.only(top: 40, bottom: 40),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              Text('Selecione a tarifa que deseja utilizar',
                  style: AppTextStyle.textBlueLightMediumBold, textAlign: TextAlign.center),
              SizedBox(height: 15),
              Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () => bloc.chooseFlag('one'),
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: bloc.flag == "one" ? AppColors.colorGreenLight : AppColors.colorGreyLight, width: 2)),
                      child: Column(children: [
                        Text('Tarifa 1', style: AppTextStyle.textBlueDarkBigBold),
                        Text('Preço por km: ' + Util.formatMoney(AppState.user.driver.priceOne),
                            style: AppTextStyle.textGreyExtraSmall),
                        Text('Valor mínimo: ' + Util.formatMoney(AppState.user.driver.minPriceOne),
                            style: AppTextStyle.textGreyExtraSmall),
                      ])),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () => bloc.chooseFlag('two'),
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: bloc.flag == "two" ? AppColors.colorGreenLight : AppColors.colorGreyLight, width: 2)),
                      child: Column(children: [
                        Text('Tarifa 2', style: AppTextStyle.textBlueDarkBigBold),
                        Text('Preço por km: ' + Util.formatMoney(AppState.user.driver.priceTwo),
                            style: AppTextStyle.textGreyExtraSmall),
                        Text('Valor mínimo: ' + Util.formatMoney(AppState.user.driver.minPriceTwo),
                            style: AppTextStyle.textGreyExtraSmall),
                      ])),
                ),
              ])),
              RoundedButton(
                  text: 'Ok',
                  callback: () {
                    if (bloc.flag == '') {
                      bloc.dialogService.showDialog('Atenção', 'Selecione uma bandeira para prosseguir');
                      return;
                    }
                    Navigator.pop(context);
                  },
                  color: AppColors.colorBlueLight)
            ])));
  }
}

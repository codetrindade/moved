import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/operation/operation_config_bloc.dart';
import 'package:movemedriver/model/driver.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:provider/provider.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends BaseState<ConfigurationPage> {
  OperationConfigBloc bloc;
  bool moneyTrip = false;
  bool onlineTrip = false;
  bool debitTrip = false;
  bool creditTrip = false;
  int maxStopTime = 5;

  var routeLimit1 = MoneyMaskedTextController();
  var routePrice1 = MoneyMaskedTextController();
  var routeLimit2 = MoneyMaskedTextController();
  var routePrice2 = MoneyMaskedTextController();

  var routeLimit1Focus = FocusNode();
  var routePrice1Focus = FocusNode();
  var routeLimit2Focus = FocusNode();
  var routePrice2Focus = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      moneyTrip = bloc.model.paymentMoney == 1 ? true : false;
      debitTrip = bloc.model.paymentDebit == 1 ? true : false;
      creditTrip = bloc.model.paymentCredit == 1 ? true : false;
      onlineTrip = bloc.model.paymentOnline == 1 ? true : false;
      maxStopTime = bloc.model.maxStopTime ?? 5;
      if (bloc.model.minPriceOne != null) routeLimit1.text = Util.formatMoneyNoSymbol(bloc.model.minPriceOne);
      if (bloc.model.priceOne != null) routePrice1.text = Util.formatMoneyNoSymbol(bloc.model.priceOne);
      if (bloc.model.minPriceTwo != null) routeLimit2.text = Util.formatMoneyNoSymbol(bloc.model.minPriceTwo);
      if (bloc.model.priceTwo != null) routePrice2.text = Util.formatMoneyNoSymbol(bloc.model.priceTwo);
      bloc.refresh();
    });
  }

  @override
  void dispose() {
    routeLimit1.dispose();
    routePrice1.dispose();
    routeLimit2.dispose();
    routePrice2.dispose();
    routeLimit1Focus.dispose();
    routePrice1Focus.dispose();
    routeLimit2Focus.dispose();
    routePrice2Focus.dispose();
    super.dispose();
  }

  Future<void> onSendRegister() async {
    if (!creditTrip && !debitTrip && !moneyTrip) {
      Util.showMessage(
          context, 'Atenção', 'Selecione pelo menos 1 forma de pagamento para recebimento de corridas');
      return;
    }

    var driver = Driver();

    if (routePrice1.numberValue == 0) {
      bloc.dialogService.showDialog('Atenção', 'O preço por km da bandeira 1 está zerado');
      return;
    }

    if (routePrice2.numberValue == 0) {
      bloc.dialogService.showDialog('Atenção', 'O preço por km da bandeira 2 está zerado');
      return;
    }

    driver.priceOne = routePrice1.numberValue;
    driver.priceTwo = routePrice2.numberValue;
    driver.minPriceOne = routeLimit1.numberValue;
    driver.minPriceTwo = routeLimit2.numberValue;
    driver.paymentCredit = creditTrip ? 1 : 0;
    driver.paymentDebit = debitTrip ? 1 : 0;
    driver.paymentMoney = moneyTrip ? 1 : 0;
    driver.paymentOnline = onlineTrip ? 1 : 0;
    driver.maxStopTime = this.maxStopTime;
    await bloc.configRoute(driver);
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<OperationConfigBloc>(context);

    return new Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Operação', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(children: [
                Text('Tempo máximo de espera:\n${maxStopTime.toString()} minutos',
                    style: AppTextStyle.textBlueLightSmallBold, textAlign: TextAlign.center),
                Slider(
                    value: maxStopTime.toDouble(),
                    min: 5,
                    max: 20,
                    divisions: 15,
                    activeColor: Theme.of(context).colorScheme.primaryContainer,
                    label: '${maxStopTime.toString()} minutos',
                    onChanged: (value) {
                      maxStopTime = value.truncate();
                      setState(() {});
                    }),
                SizedBox(height: 20.0),
                Text('Tarifa Bandeira 1', style: AppTextStyle.textBlueLightSmallBold),
                SizedBox(height: 20.0),
                TextFieldCustom(
                    label: 'Receber corridas de no mínimo (R\$)',
                    controller: routeLimit1,
                    focus: routeLimit1Focus,
                    nextFocus: routePrice1Focus,
                    keyBoardType: TextInputType.numberWithOptions(decimal: true)),
                SizedBox(height: 20.0),
                TextFieldCustom(
                    label: 'Preço por KM',
                    controller: routePrice1,
                    focus: routePrice1Focus,
                    nextFocus: routeLimit2Focus,
                    keyBoardType: TextInputType.numberWithOptions(decimal: true)),
                SizedBox(height: 20.0),
                Text('Tarifa Bandeira 2', style: AppTextStyle.textBlueLightSmallBold),
                SizedBox(height: 20.0),
                TextFieldCustom(
                    label: 'Receber corridas de no mínimo (R\$)',
                    controller: routeLimit2,
                    focus: routeLimit2Focus,
                    nextFocus: routePrice2Focus,
                    keyBoardType: TextInputType.numberWithOptions(decimal: true)),
                SizedBox(height: 20.0),
                TextFieldCustom(
                    label: 'Preço por KM',
                    controller: routePrice2,
                    focus: routePrice2Focus,
                    keyBoardType: TextInputType.numberWithOptions(decimal: true),
                    action: TextInputAction.done)
              ])),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('Receber pagamentos', style: AppTextStyle.textBlueLightSmallBold)),
          TransparentButton(
              text: 'Pelo App',
              ok: onlineTrip,
              iconLeft: Icon(Icons.add_to_home_screen, color: AppColors.colorBlueLight),
              warning: !onlineTrip,
              arrow: false,
              callback: () {
                onlineTrip = !onlineTrip;
                bloc.refresh();
              }),
          TransparentButton(
              text: 'Dinheiro',
              ok: moneyTrip,
              iconLeft: Icon(Icons.attach_money, color: AppColors.colorBlueLight),
              warning: !moneyTrip,
              arrow: false,
              callback: () {
                moneyTrip = !moneyTrip;
                bloc.refresh();
              }),
          TransparentButton(
              text: 'Débito (sua maquininha)',
              ok: debitTrip,
              iconLeft: Icon(Icons.credit_card, color: AppColors.colorBlueLight),
              warning: !debitTrip,
              arrow: false,
              callback: () {
                debitTrip = !debitTrip;
                bloc.refresh();
              }),
          TransparentButton(
              text: 'Crédito (sua maquininha)',
              ok: creditTrip,
              warning: !creditTrip,
              iconLeft: Icon(Icons.credit_card, color: AppColors.colorBlueLight),
              arrow: false,
              callback: () {
                creditTrip = !creditTrip;
                bloc.refresh();
              }),
          SizedBox(height: 20.0),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: BlueDarkButton(callback: () async => await onSendRegister()))
        ])));
  }
}

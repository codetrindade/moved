import 'package:flutter/material.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/bank_account/bank_account_page.dart';
import 'package:movemedriver/view/extract/extract_page.dart';
import 'package:movemedriver/view/information/configuration_page.dart';
import 'package:movemedriver/view/information/documents_page.dart';
import 'package:movemedriver/view/information/profile_page.dart';
import 'package:movemedriver/view/information/sac_page.dart';
import 'package:movemedriver/view/information/term.dart';
import 'package:movemedriver/view/login/sms_page.dart';
import 'package:movemedriver/view/register/driver_preferences.dart';
import 'package:movemedriver/view/vehicle/vehicle_list_page.dart';
import 'package:movemedriver/view/wizard_page.dart';
import 'package:movemedriver/widgets/confirm_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends BaseState<InformationPage> {
  AppBloc bloc;
  PackageInfo packageInfo = PackageInfo(appName: '', buildNumber: '', packageName: '', version: '');

  void logout() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                Navigator.pop(context);
                bloc.logout();
              },
              text: 'Atenção\n\nTem certeza que deseja sair ?');
        });
  }

  verifyAccount(Widget target) {
    if (AppState.user.status == 'register') {
      Util.showConfirm(
          context,
          'Atenção',
          'Para acessar esta funcionalidade é necessário primeiro que você confirme sua conta!',
          'Confirmar',
          'Cancelar',
          true, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SmsPage(fromProfile: true)));
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => target));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      packageInfo = await PackageInfo.fromPlatform();
      bloc.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    return Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Informações'),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(height: 10),
          if (AppState.user.status == 'inactive')
            TransparentButton(
                text: 'Verificar pendências',
                iconLeft: Icon(Icons.ballot, color: AppColors.colorBlueLight),
                callback: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => WizardPage(isFromInfoPage: true)));
                }),
          TransparentButton(
              text: 'Meus Dados',
              iconLeft: Icon(MoveMeIcons.man_user, color: AppColors.colorBlueLight),
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              }),
          TransparentButton(
              text: 'Conta Bancária',
              iconLeft: Icon(Icons.account_balance, color: AppColors.colorBlueLight),
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BankAccountPage()));
              }),
          TransparentButton(
              text: 'Extrato',
              iconLeft: Icon(Icons.list, color: AppColors.colorBlueLight),
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExtractPage()));
              }),
          TransparentButton(
              text: 'Operação',
              iconLeft: Icon(Icons.build, color: AppColors.colorBlueLight),
              callback: () => verifyAccount(ConfigurationPage())),
          TransparentButton(
              text: 'Veículos',
              iconLeft: Icon(MoveMeIcons.sedan_car_front, color: AppColors.colorBlueLight),
              callback: () => verifyAccount(VehicleListPage())),
          TransparentButton(
              text: 'Meus documentos',
              iconLeft: Icon(MoveMeIcons.wallet_filled_money_tool, color: AppColors.colorBlueLight),
              callback: () => verifyAccount(DocumentsPage())),
          TransparentButton(
              text: 'Sobre você',
              iconLeft: Icon(MoveMeIcons.help, color: AppColors.colorBlueLight),
              callback: () => verifyAccount(DriverPreferences())),
          /*TransparentButton(
                  text: 'Meu plano',
                  iconLeft: Icon(Icons.payment, color: AppColors.colorBlueLight),
                  callback: () => verifyAccount(PlanListPage())),
              TransparentButton(
                  text: 'Idiomas',
                  iconLeft: Icon(MoveMeIcons.language, color: AppColors.colorBlueLight),
                  callback: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagePage()));
                  }),*/
          TransparentButton(
              text: 'Termos de uso',
              iconLeft: Icon(MoveMeIcons.routine, color: AppColors.colorBlueLight),
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage()));
              }),
          TransparentButton(
              text: 'Fale conosco',
              iconLeft: Icon(MoveMeIcons.phone_call, color: AppColors.colorBlueLight),
              callback: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SacPage()));
              }),
          // TransparentButton(
          //     text: 'Mudar operação',
          //     iconLeft: Icon(Icons.autorenew, color: AppColors.colorBlueLight),
          //     callback: () {
          //       eventBus.fire(ChangeStateEvent(AppStateEnum.CHOOSE));
          //     }),
          TransparentButton(
              text: 'Sair',
              iconLeft: Icon(Icons.exit_to_app, color: AppColors.colorBlueLight),
              callback: () => logout()),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                  'Versão: ' +
                      (packageInfo.version == null
                          ? ''
                          : packageInfo.version + '+' + packageInfo.buildNumber),
                  style: AppTextStyle.textGreyExtraSmall)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1)
        ])));
  }
}

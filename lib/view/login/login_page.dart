import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movemedriver/component/blue_light_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/login/login_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/information/term.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

// login
  Future<void> btnLoginAction() async {
    if (_email.text.isEmpty && !_email.text.contains('@')) {
      bloc.dialogService.showDialog('Atenção', 'Digite um email válido');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    if (_password.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Digite a senha');
      FocusScope.of(context).requestFocus(_passwordFocus);
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    await bloc.login(_email.text, _password.text);
  }

  // forgot
  Future<void> onForgot() async {
    if (_email.text.length == 0 || !_email.text.contains('@') && !_email.text.contains('.')) {
      Util.showMessage(context, 'Atenção', 'Informe seu email');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    await bloc.forgot(_email.text);
  }

  void openSmsPage() {
    eventBus.fire(ChangeStateEvent(AppStateEnum.SMS));
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<LoginBloc>(context);
    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: bloc.isLoading
            ? LoadingCircle()
            : Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      gradient: appGradient,
                      borderRadius:
                          BorderRadius.only(bottomRight: AppRadius.bottomRadius, bottomLeft: AppRadius.bottomRadius)),
                ),
                Align(
                    alignment: Alignment.center,
                    child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * AppSizes.logoMarginTop),
                        child: Center(child: SvgPicture.asset('assets/svg/icon_home.svg', width: 250)),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 20),
                          decoration: BoxDecoration(
                              color: AppColors.colorWhite,
                              borderRadius: BorderRadius.all(AppRadius.containerRadius),
                              border: Border.all(color: AppColors.colorBlueLight)),
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(children: <Widget>[
                                SizedBox(height: 30.0),
                                TextFieldCustom(
                                    controller: _email,
                                    focus: _emailFocus,
                                    label: 'E-mail',
                                    capitalization: TextCapitalization.none,
                                    nextFocus: _passwordFocus,
                                    keyBoardType: TextInputType.emailAddress),
                                SizedBox(height: 10.0),
                                TextFieldCustom(
                                    controller: _password,
                                    focus: _passwordFocus,
                                    label: 'Senha',
                                    onSubmitted: () async => await btnLoginAction(),
                                    obscureText: !bloc.showPassword,
                                    suffix: InkWell(
                                        child: Icon(!bloc.showPassword ? Icons.remove_red_eye : Icons.cancel,
                                            color: AppColors.colorBlueLight),
                                        onTap: () {
                                          bloc.showPassword = !bloc.showPassword;
                                          bloc.refresh();
                                        }),
                                    action: TextInputAction.done),
                                Container(
                                    alignment: Alignment.topRight,
                                    child: FlatButton(
                                        onPressed: onForgot,
                                        child: Text('Esqueci a senha', style: AppTextStyle.textGreyDarkSmall))),
                                BlueLightButton(text: 'Entrar', callback: () async => await btnLoginAction()),
                                // Container(
                                //   margin: EdgeInsets.all(10.0),
                                //   height: 1.0,
                                //   color: AppColors.colorBlueLight,
                                // ),
                                // BlueDarkButton(
                                //     text: 'Entrar com o Facebook',
                                //     callback: () {
                                //       _btnFacebookAction();
                                //     }),
                                SizedBox(height: 30.0)
                              ])))
                    ]))
              ]),
        bottomNavigationBar: bloc.isLoading
            ? SizedBox()
            : Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text('Não tem uma conta?', style: AppTextStyle.textGreyDarkSmall),
                  FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () => openRegisterPage(),
                      child: Text(' Criar Conta', style: AppTextStyle.textGreySmallBold))
                ])));
  }

  openRegisterPage() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage(edit: true)));
  }
}

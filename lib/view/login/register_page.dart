import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_light_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/register/register_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/user.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterBloc bloc;

  var _name = TextEditingController();
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();

  var _nameFocus = FocusNode();
  var _emailFocus = FocusNode();
  var _passwordFocus = FocusNode();
  var _confirmPasswordFocus = FocusNode();

  Future<void> onSubmit() async {
    if (_name.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha o nome para prosseguir');
      FocusScope.of(context).requestFocus(_nameFocus);
      return;
    }

    if ((_email.text.length == 0 || !_email.text.contains('@')) || _password.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha um e-mail válido para prosseguir');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    if (_password.text.length < 6) {
      Util.showMessage(context, 'Atenção', 'Preencha uma senha com no mínimo 6 dígitos para prosseguir');
      FocusScope.of(context).requestFocus(_passwordFocus);
      return;
    }

    if (_password.text != _confirmPassword.text) {
      Util.showMessage(context, 'Atenção', 'Senhas não conferem');
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    var model = User(name: _name.text, email: _email.text, password: _password.text);
    await bloc.register(model);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    _emailFocus.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RegisterBloc>(context);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBarCustom(
              title: 'Cadastro',
              callback: () {
                eventBus.fire(ChangeStateEvent(AppStateEnum.LOGIN));
              }),
        ),
        backgroundColor: AppColors.colorWhite,
        body: bloc.isLoading
            ? LoadingCircle()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  SizedBox(height: 15.0),
                  TextFieldCustom(
                      label: 'Nome',
                      controller: _name,
                      focus: _nameFocus,
                      nextFocus: _emailFocus,
                      capitalization: TextCapitalization.words),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      label: 'E-mail',
                      capitalization: TextCapitalization.none,
                      controller: _email,
                      focus: _emailFocus,
                      nextFocus: _passwordFocus,
                      keyBoardType: TextInputType.emailAddress),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      label: 'Senha',
                      controller: _password,
                      focus: _passwordFocus,
                      obscureText: !bloc.showPassword,
                      suffix: InkWell(
                          child: Icon(!bloc.showPassword ? Icons.remove_red_eye : Icons.cancel,
                              color: AppColors.colorBlueLight),
                          onTap: () {
                            bloc.showPassword = !bloc.showPassword;
                            bloc.refresh();
                          }),
                      nextFocus: _confirmPasswordFocus),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      label: 'Confirme sua Senha',
                      controller: _confirmPassword,
                      focus: _confirmPasswordFocus,
                      obscureText: !bloc.showConfirmPassword,
                      action: TextInputAction.done,
                      suffix: InkWell(
                          child: Icon(!bloc.showConfirmPassword ? Icons.remove_red_eye : Icons.cancel,
                              color: AppColors.colorBlueLight),
                          onTap: () {
                            bloc.showConfirmPassword = !bloc.showConfirmPassword;
                            bloc.refresh();
                          })),
                  SizedBox(height: 30.0),
                  BlueLightButton(text: 'Registrar', callback: () async => await onSubmit()),
                  SizedBox(height: 10.0),
                  // Text('ou', textAlign: TextAlign.center, style: AppTextStyle.textBlueDarkSmall),
                  // SizedBox(height: 10.0),
                  // BlueDarkButton(text: 'Registrar com o Facebook', callback: _btnFacebookAction)
                ]),
              ));
  }
}

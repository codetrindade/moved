import 'package:flutter/material.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/presenter/password_presenter.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/information/password_view.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends BaseState<PasswordPage> implements PasswordView {
  PasswordPresenter _presenter;
  var _oldPassword = TextEditingController();
  var _newPassword = TextEditingController();
  var _confirmPassword = TextEditingController();

  var _oldPasswordFocus = FocusNode();
  var _newPasswordFocus = FocusNode();
  var _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  _PasswordPageState() {
    _presenter = PasswordPresenter(this);
  }

  void onSavePassword() {
    if (AppState.user.hasPassword && _oldPassword.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha a senha antiga');
      FocusScope.of(context).requestFocus(_oldPasswordFocus);
      return;
    }
    if (_newPassword.text.length == 0 || _newPassword.text.length < 6) {
      Util.showMessage(context, 'Atenção', 'Preencha a nova senha com no mínimo 6 caracteres');
      FocusScope.of(context).requestFocus(_newPasswordFocus);
      return;
    }
    if (_confirmPassword.text.length == 0) {
      Util.showMessage(context, 'Atenção', 'Preencha a confirmação de senha');
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      return;
    }
    if (_newPassword.text != _confirmPassword.text) {
      Util.showMessage(context, 'Atenção', 'Senhas não conferem');
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
      return;
    }

    if (!AppState.user.hasPassword) _oldPassword.text = '';

    _presenter.password(_oldPassword.text, _newPassword.text);
  }

  @override
  void initState() {
    super.initState();
    _oldPassword.text = AppState.user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(
            title: 'Sobre Você',
            callback: () {
              Navigator.pop(context);
            },
          ),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            AppState.user != null && AppState.user.hasPassword != null && AppState.user.hasPassword
                ? TextFieldCustom(
                    controller: _oldPassword,
                    focus: _oldPasswordFocus,
                    label: 'Senha atual',
                    obscureText: true,
                    nextFocus: _newPasswordFocus)
                : Text('Você ainda não criou uma senha, configure uma agora:',
                    style: AppTextStyle.textBlueLightSmallBold),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              height: 1.0,
              color: AppColors.colorBlueLight,
            ),
            TextFieldCustom(
                controller: _newPassword,
                focus: _newPasswordFocus,
                label: 'Nova senha',
                obscureText: true,
                nextFocus: _confirmPasswordFocus),
            SizedBox(height: 20.0),
            TextFieldCustom(
                controller: _confirmPassword,
                focus: _confirmPasswordFocus,
                label: 'Confirme a senha',
                action: TextInputAction.done,
                obscureText: true),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: BlueDarkButton(
            text: 'Salvar nova senha',
            callback: () {
              onSavePassword();
            }),
      ),
    );
  }

  @override
  void onPasswordError(String error) {
    Util.showMessage(context, 'Erro', error);
  }

  @override
  void onPasswordSuccess(ResponseData message) {
    AppState.user.hasPassword = true;
    AppState().setUser(AppState.user);
    Util.showMessage(context, 'Sucesso', message.message);
  }
}

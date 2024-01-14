import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/model/term.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/core/service/login_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/login_data.dart';
import 'package:movemedriver/model/user.dart';

class LoginBloc extends BaseBloc {
  User model;
  var loginService = locator.get<LoginService>();
  bool showPassword = false;
  Term term;

  login(String email, String password) async {
    try {
      setLoading(true);
      var modelLogin = LoginData(email: email, password: password, type: 'driver');
      var user = await loginService.login(modelLogin);

      await AppState().setUser(user, token: true);
      locator.get<Api>().setToken(user.token, '');
      eventBus.fire(AppLoginEvent(user));
    } catch (e) {
      super.onError(e);
    } finally {
      Future.delayed(Duration(seconds: 3), () => setLoading(false));
    }
  }

  forgot(String email) async {
    try {
      setLoading(true);
      var modelLogin = LoginData(email: email);
      await loginService.forgot(modelLogin);
      dialogService.showDialog(
          'Sucesso', 'Verifique seu em seu e-mail as instruções para recuperação da senha');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getTerm() async {
    try {
      setLoading(true);
      term = await loginService.getTerm();
    } catch(e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}

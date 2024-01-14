import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/term.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/login_data.dart';
import 'package:movemedriver/model/token.dart';
import 'package:movemedriver/model/user.dart';
import 'package:movemedriver/settings.dart';

class LoginService extends BaseService {
  Api _api;

  LoginService() {
    this._api = locator.get<Api>();
  }

  Future<User> login(LoginData model) async {
    return User.fromJson(getResponse(await _api.post('login', model.toString())));
  }

  Future<Token> forgot(LoginData model) async {
    return Token.fromJson(getResponse(await _api.post('forgot', model.toString())));
  }

  Future<Term> getTerm() async {
    return Term.fromJson(getResponse(await _api.getOutBaseUrl(Settings.termUrl)));
  }
}

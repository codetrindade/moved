import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/user.dart';

class RegisterService extends BaseService {
  Api _api;

  RegisterService() {
    this._api = locator.get<Api>();
  }

  Future<User> register(User model) async {
    return User.fromJson(getResponse(await _api.post('register', model.toString())));
  }
}

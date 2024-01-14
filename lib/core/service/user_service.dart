import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/driver.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/user.dart';

class UserService extends BaseService {
  Api _api;

  UserService() {
    this._api = locator.get<Api>();
  }

  Future<User> updateProfile(User model) async {
    return User.fromJson(getResponse(await _api.put("update", model.toString())));
  }

  Future<ResponseData> updatePassword(String oldPassword, password) async {
    return ResponseData.fromJson(getResponse(
        await _api.put("password", '{"old_password": "$oldPassword", "password":"$password"}')));
  }

  Future<ResponseData> goOnline(flag, vehicleId) async {
    return ResponseData.fromJson(getResponse(
        await _api.post("driver/status", '{"flag": "$flag", "vehicle_id":"$vehicleId"}')));
  }

  Future<ResponseData> goOffline() async {
    return ResponseData.fromJson(getResponse(await _api.post('driver/status', null)));
  }

  Future<Driver> configRoute(Driver model) async {
    return Driver.fromJson(getResponse(await _api.post('driver/config_route', model.toString())));
  }

  Future<Driver> configAbout(Driver model) async {
    return Driver.fromJson(getResponse(await _api.post('driver/config_about', model.toString())));
  }
  
  Future<bool> changeDisplayMyPhone() async {
    return getResponse(await _api.put('common/change_display_my_phone', null));
  }
}

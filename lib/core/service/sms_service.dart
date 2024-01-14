import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/response.dart';

class SmsService extends BaseService {
  Api _api;

  SmsService() {
    this._api = locator.get<Api>();
  }

  Future<ResponseData> confirmSMS(String code, String phone) async {
    return ResponseData.fromJson(getResponse(await _api.post('phone/', '{"sms_code":"$code","phone":"$phone"}')));
  }
}

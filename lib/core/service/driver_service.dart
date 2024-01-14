import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/driver_status.dart';
import 'package:movemedriver/core/model/wizard.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';

class DriverService extends BaseService {
  Api _api;

  DriverService() {
    this._api = locator.get<Api>();
  }

  Future<DriverStatus> getStatus() async {
    return DriverStatus.fromJson(getResponse(await _api.get('driver/get-status')));
  }

  Future<List<Wizard>> getWizardStatus() async {
    var data = getResponse(await _api.get('driver/wizard'));
    return (data as List).map((i) => new Wizard.fromJson(i)).toList();
  }
}
import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/user.dart';

class VehicleService extends BaseService {
  Api _api;

  VehicleService() {
    this._api = locator.get<Api>();
  }

  Future<Vehicle> register(Vehicle model) async {
    return Vehicle.fromJson(getResponse(await _api.post("driver/vehicle/create", model.toString())));
  }

  Future<Vehicle> update(Vehicle model) async {
    return Vehicle.fromJson(getResponse(await _api.put("driver/vehicle/update", model.toString())));
  }

  Future<Vehicle> resend(String id) async {
    return Vehicle.fromJson(getResponse(await _api.post("driver/vehicle/resend", '{"id":"$id"}')));
  }

  Future<ResponseData> remove(String id) async {
    return ResponseData.fromJson(getResponse(await _api.delete("driver/vehicle/remove/$id")));
  }

  Future<Vehicle> enableModify(String id) async {
    return Vehicle.fromJson(getResponse(await _api.put("driver/vehicle/modify", '{"id":"$id"}')));
  }

  Future<List<Vehicle>> listAll() async {
    var data = getResponse(await _api.post('driver/vehicle/list', null));
    return (data as List).map((i) => new Vehicle.fromJson(i)).toList();
  }

  Future<List<User>> getDriversByVehicleId(String id) async {
    var data = getResponse(await _api.get('driver/vehicle/$id/drivers'));
    return (data as List).map((i) => new User.fromJson(i)).toList();
  }

  Future<ResponseData> removeRelatedDriver(String driverId, String vehicleId) async {
    return ResponseData.fromJson(getResponse(await _api.delete("driver/vehicle/$vehicleId/drivers/remove/$driverId")));
  }

  Future<List<Vehicle>> getAvailableVehicles() async {
    var data = getResponse(await _api.get('driver/vehicle/available'));
    return (data as List).map((i) => new Vehicle.fromJson(i)).toList();
  }
}

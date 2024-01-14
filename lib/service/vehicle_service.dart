import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/model/response.dart';

class VehicleService extends HttpBase {
  VehicleService(String token) : super(token);

  Future<Vehicle> register(Vehicle model) async {
    return await post('driver/vehicle/create', model.toString())
        .then((data) => Vehicle.fromJson(data));
  }

  Future<Vehicle> update(Vehicle model) async {
    return await put('driver/vehicle/update', model.toString())
        .then((data) => Vehicle.fromJson(data));
  }

  Future<List<Vehicle>> getVehicles() async {
    return await post('driver/vehicle/list', null)
        .then((data) => (data as List).map((i) => new Vehicle.fromJson(i)).toList());
  }

  Future<ResponseData> removeVehicle(String id) async {
    return await delete('driver/vehicle/remove/$id')
        .then((data) => ResponseData.fromJson(data));
  }

  Future<Vehicle> resend(String id) async {
    return await post('driver/vehicle/resend', '{"id":"$id"}')
        .then((data) => Vehicle.fromJson(data));
  }

  Future<Vehicle> changeStatus(String id) async {
    return await post('driver/vehicle/status', '{"id":"$id"}')
        .then((data) => Vehicle.fromJson(data));
  }

  Future<Vehicle> enableModify(String id) async {
    return await put('driver/vehicle/modify', '{"id":"$id"}')
        .then((data) => Vehicle.fromJson(data));
  }

  Future<List<Vehicle>> getAvailableVehicles() async {
    return await get('driver/vehicle/available')
        .then((data) => (data as List).map((i) => new Vehicle.fromJson(i)).toList());
  }
}

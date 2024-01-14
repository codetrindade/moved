import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/plan.dart';
import 'package:movemedriver/model/response.dart';

class PlanService extends HttpBase {
  PlanService(String token) : super(token);

  Future<Plan> register(Plan model) async {
    return await post('register', model.toString())
        .then((data) => Plan.fromJson(data));
  }

  Future<Plan> update(Plan model) async {
    return await put('update', model.toString())
        .then((data) => Plan.fromJson(data));
  }

  Future<List<Plan>> getPlans() async {
    return await post('driver/vehicle/list', null)
        .then((data) => (data as List).map((i) => new Plan.fromJson(i)).toList());
  }

  Future<ResponseData> ramoveVehicle(String id) async {
    return await delete('delete/$id')
        .then((data) => ResponseData.fromJson(data));
  }

}
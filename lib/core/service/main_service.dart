import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/response.dart';

class MainService extends BaseService {
  Api _api;

  MainService() {
    this._api = locator.get<Api>();
  }

  Future<ResponseData> updateMyPos(lat, long, distance) async {
    return ResponseData.fromJson(getResponse(
        await _api.post('driver/route/live', '{"lat":"$lat","long":"$long","travelled_distance":"$distance"}')));
  }
}

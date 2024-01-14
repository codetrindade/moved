import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/pusher_data.dart';
import 'package:movemedriver/model/route_history.dart';

class RouteService extends BaseService {
  Api _api;

  RouteService() {
    this._api = locator.get<Api>();
  }

  Future<ReceivedData> getRouteById(String id) async {
    return ReceivedData.fromJson(getResponse(await _api.get('driver/route/$id')));
  }

  Future<List<RouteHistory>> listHistory() async {
    var data = getResponse(await _api.post('driver/route/history', null));
    return (data as List).map((i) => new RouteHistory.fromJson(i)).toList();
  }

  Future<RouteHistory> getById(String id) async {
    return RouteHistory.fromJson(getResponse(await _api.get('common/route/$id')));
  }
}
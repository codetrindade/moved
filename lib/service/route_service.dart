import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/preview.dart';
import 'package:movemedriver/model/preview_body.dart';
import 'package:movemedriver/model/response.dart';

class RouteService extends HttpBase {
  RouteService(String token) : super(token);

  Future<Preview> getPreview(PreviewBody body) async {
    return await post('mobile/route/preview', body.toString())
        .then((map) => Preview.fromJson(map));
  }

  Future<ResponseData> statusRoute(String routeId, String status) async {
    return await post(
            'driver/route/status', '{"route_id":"$routeId","status":"$status"}')
        .then((map) => ResponseData.fromJson(map));
  }

  Future<ResponseData> recalculate(String routeId) async {
    return await get('common/recalculate_route/$routeId')
        .then((map) => ResponseData.fromJson(map));
  }

  Future<ResponseData> checkPoint(String routeId, String pointId) async {
    return await post('driver/route/checkpoint',
            '{"id":"$routeId","point_id":"$pointId"}')
        .then((map) => ResponseData.fromJson(map));
  }

  Future<ResponseData> evaluate(id, rating, observation) async {
    return await post('driver/route/evaluate',
            '{"id":"$id","rating_user":$rating,"rating_user_observation":"$observation"}')
        .then((map) => ResponseData.fromJson(map));
  }
}

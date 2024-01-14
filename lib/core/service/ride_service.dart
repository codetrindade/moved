import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/passenger.dart';
import 'package:movemedriver/model/price_ride.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/ride.dart';

class RideService extends BaseService {
  Api _api;

  RideService() {
    this._api = locator.get<Api>();
  }

  Future<List<Ride>> list() async {
    var data = getResponse(await _api.post('driver/ride/list', null));
    return (data as List).map((i) => new Ride.fromJson(i)).toList();
  }

  Future<dynamic> update(Ride model) async {
    return getResponse(await _api.put("driver/ride/update", model.toString()));
  }

  Future<List<Passenger>> getPassengers(String id) async {
    var data = getResponse(await _api.post('driver/ride/list_passengers', '{"id":"$id"}'));
    return (data as List).map((i) => new Passenger.fromJson(i)).toList();
  }

  Future<ResponseData> approvePassenger(String rideId, String passengerId) async {
    return ResponseData.fromJson(
        getResponse(await _api.post("driver/ride/approve", '{"ride_id":"$rideId","passenger_id":"$passengerId"}')));
  }

  Future<List<PriceRide>> getPreviewPrice(Ride model) async {
    var data = getResponse(await _api.post('driver/ride/pricepreview', model.toString()));
    return (data as List).map((i) => new PriceRide.fromJson(i)).toList();
  }
}

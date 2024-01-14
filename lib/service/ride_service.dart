import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/passenger.dart';
import 'package:movemedriver/model/price_ride.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/ride.dart';

class RideService extends HttpBase {
  RideService(String token) : super(token);

  Future<Ride> register(Ride model) async {
    return await post('driver/vehicle/create', model.toString())
        .then((data) => Ride.fromJson(data));
  }

  Future<dynamic> update(Ride model) async {
    return await put('driver/ride/update', model.toString())
        .then((data) => data);
  }

  Future<List<Ride>> getRides() async {
    return await post('driver/ride/list', null)
        .then((data) => (data as List).map((i) => new Ride.fromJson(i)).toList());
  }

  Future<ResponseData> removeRide(String id) async {
    return await delete('delete/$id')
        .then((data) => ResponseData.fromJson(data));
  }

  Future<List<PriceRide>> getPreviewPrice(Ride model) async {
    return await post('driver/ride/pricepreview', model.toString())
        .then((data) => (data as List).map((i) => new PriceRide.fromJson(i)).toList());
  }

  Future<ResponseData> createRide(List<Ride> model) async {
    return await post('driver/ride/create', '{"rides":' + model.toString() + '}')
        .then((data) => ResponseData.fromJson(data));
  }

  Future<List<Passenger>> getPassengers(String id) async {
    return await post('driver/ride/list_passengers', '{"id":"$id"}')
        .then((data) => (data as List).map((i) => new Passenger.fromJson(i)).toList());
  }

  Future<ResponseData> approvePassenger(String rideId, String passengerId) async {
    return await post('driver/ride/approve', '{"ride_id":"$rideId","passenger_id":"$passengerId"}')
        .then((data) => ResponseData.fromJson(data));
  }
}
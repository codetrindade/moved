import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/service/address_service.dart';
import 'package:movemedriver/service/config_service.dart';
import 'package:movemedriver/service/plan_service.dart';
import 'package:movemedriver/service/ride_service.dart';
import 'package:movemedriver/service/route_service.dart';
import 'package:movemedriver/service/user_service.dart';
import 'package:movemedriver/service/vehicle_service.dart';


class Injector {
  //singleton
  static final Injector _instance = new Injector.internal();
  static String _token = '';

  Injector.internal();

  factory Injector() {
    return _instance;
  }

  void setToken(String token) {
    _token = token;
    locator.get<Api>().setToken(token, '');
  }

  UserService get userService {
    return new UserService(_token);
  }

  VehicleService get vehicleService {
    return new VehicleService(_token);
  }

  PlanService get planService {
    return new PlanService(_token);
  }

  RideService get rideService {
    return new RideService(_token);
  }

  AddressService get addressService {
    return new AddressService(_token);
  }

  RouteService get routeService {
    return new RouteService(_token);
  }

  ConfigService get configService {
    return new ConfigService(_token);
  }
}

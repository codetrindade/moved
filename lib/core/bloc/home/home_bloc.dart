import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/core/service/driver_service.dart';
import 'package:movemedriver/core/service/user_service.dart';
import 'package:movemedriver/core/service/vehicle_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/util/util.dart';

class HomeBloc extends BaseBloc {
  var vehicleService = locator.get<VehicleService>();
  var userService = locator.get<UserService>();
  var driverService = locator.get<DriverService>();
  LocationData pos;

  List<Vehicle> vehicles = [];
  String flag = '';
  Set<Marker> points = new Set<Marker>();

  Vehicle selectedVehicle;
  Location location = Location();

  HomeBloc() {
    location.changeSettings(
        accuracy: LocationAccuracy.navigation, interval: 300, distanceFilter: 2);
    location.getLocation().then((value) {
      pos = value;
    });
    location.onLocationChanged.listen((event) {
      pos = event;
      eventBus.fire(GpsChangedEvent());
    });
  }

  getVehiclesList() async {
    try {
      setLoading(true);
      vehicles = await vehicleService.getAvailableVehicles();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  chooseVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  chooseFlag(String flag) {
    this.flag = flag;
    notifyListeners();
  }

  goOffline() async {
    try {
      setLoading(true);
      await userService.goOffline();
      AppState.user.status = 'unavailable';
      AppState().setUser(AppState.user);
      AppState().disconnectPusher();
      await notificationManager.removeOngoingNotification();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  goOnline() async {
    try {
      setLoading(true);
      await userService.goOnline(this.flag, selectedVehicle.id);
      AppState.user.status = 'available';
      AppState().setUser(AppState.user);
      AppState().initPusher();
      await notificationManager.showOngoingNotification(
          'Voce está online. Aguardando chamadas!');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  setMapMarkers(BuildContext context) async {
    if(AppState.pos == null) return;

    var myPosIcon = BitmapDescriptor.fromBytes(await new Util().getBytesFromCanvas(
        MediaQuery.of(context).devicePixelRatio.round() * 30,
        MediaQuery.of(context).devicePixelRatio.round() * 30,
        'assets/images/navigation.png'));
    points.clear();
    points.add(
      new Marker(
          markerId: new MarkerId('myPos'),
          position: LatLng(AppState.pos.latitude, AppState.pos.longitude),
          icon: myPosIcon),
    );
    notifyListeners();
  }

  Future<bool> getStatus() async {
    try {
      var result = await driverService.getStatus();
      if (result.userStatus == 'active' ||
          result.userStatus == 'available' ||
          result.userStatus == 'unavailable')
        return true;
      else
        return false;
    } catch (e) {
      super.onError(e);
      return false;
    }
  }
}

import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/core/service/vehicle_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/user.dart';

class ShareVehicleBloc extends BaseBloc {
  var vehicleService = locator.get<VehicleService>();
  List<User> drivers;
  Vehicle model;

  getDrivers() async {
    try {
      setLoading(false);
      drivers = await vehicleService.getDriversByVehicleId(model.id);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  removeDriver(String driverId) async {
    try {
      setLoading(true);
      await vehicleService.removeRelatedDriver(driverId, model.id);
      dialogService.showDialog('Sucesso', 'Motorista desvinculado com sucesso!');
      drivers = await vehicleService.getDriversByVehicleId(model.id);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}

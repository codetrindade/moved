
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/service/address_service.dart';
import 'package:movemedriver/core/service/ride_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/model/passenger.dart';
import 'package:movemedriver/model/price_ride.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/ride.dart';

class RideBloc extends BaseBloc {
  List<Ride> listRide = [];
  List<Address> routes = [];
  Ride model;
  Ride modelBack;
  int people = 1;
  int maxPeople = 6;
  Address myAddressNow = new Address(order: 0, address: 'Definir Origem');
  List<Address> listRideAddress = [];
  bool isPassengersLoading = true;
  bool newRide = false;
  bool updated = false;
  List<Passenger> passengers = [];
  List<PriceRide> prices = [];

  var rideService = locator.get<RideService>();
  var addressService = locator.get<AddressService>();

  list() async {
    try {
      setLoading(true);
      this.listRide = await rideService.list();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  update(Ride model) async {
    try {
      setLoading(true);
      await rideService.update(model);
      updated = true;
      dialogService.showDialog('Sucesso', 'Carona alterada com sucesso!');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getFromCoordinates(Address model) async {
    try {
      setLoading(true);
      model = await addressService.getFromCoordinates(model);
      myAddressNow.address = model.address;
      newRide = true;
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getPassenger(String id) async {
    try {
      setLoading(true);
      passengers = await rideService.getPassengers(id);
      isPassengersLoading = false;
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  approvePassenger(String rideId, String passengerId) async {
    try {
      setLoading(true);
      ResponseData response = await rideService.approvePassenger(rideId, passengerId);
      getPassenger(model.id);
      dialogService.showDialog('Sucesso', response.message);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getPricePreview(Ride model) async {
    try {
      setLoading(true);
      prices = await rideService.getPreviewPrice(model);

      prices.asMap().forEach((index, r) {
        r.originAddress = modelBack == null
            ? model.points.firstWhere((p) => p.order == r.origin).address
            : modelBack.points.firstWhere((p) => p.order == r.origin).address;
        r.destinationAddress = modelBack == null
            ? model.points.firstWhere((p) => p.order == r.destination).address
            : modelBack.points.firstWhere((p) => p.order == r.destination).address;
      });
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  clear() {
    model = null;
    listRideAddress = [];
    newRide = true;
  }
}

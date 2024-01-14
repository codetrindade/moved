import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/core/model/vehicle_document.dart';
import 'package:movemedriver/core/service/upload_service.dart';
import 'package:movemedriver/core/service/vehicle_service.dart';
import 'package:movemedriver/locator.dart';

class VehicleBloc extends BaseBloc {
  List<Vehicle> listVehicle = [];
  Vehicle vehicle;
  var vehicleService = locator.get<VehicleService>();
  var uploadService = locator.get<UploadService>();

  getListVehicle() async {
    try {
      setLoading(true);
      this.listVehicle = await vehicleService.listAll();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  register() async {
    try {
      setLoading(true);
      vehicle = await vehicleService.register(vehicle);
      listVehicle = await vehicleService.listAll();
      navigationManager.goBack();
      navigationManager.navigateTo('/vehicle_create');
    } catch (e) {
      vehicle = null;
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  sendForReview() async {
    try {
      this.vehicle = await vehicleService.resend(vehicle.id);
      dialogService.showDialog('Sucesso',
          'Veículo enviado para aprovação, por favor, aguarde um retorno de nossa equipe');
      navigationManager.goBack();
    } catch (e) {
      super.onError(e);
    }
  }

  update(Vehicle model) async {
    try {
      setLoading(true);
      this.vehicle = await vehicleService.update(model);
      navigationManager.goBack();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  chooseImage(ImageSource source, String type) async {
    try {
      setLoading(true);
      var pickedFile = await ImagePicker().getImage(source: source, maxWidth: 1080, maxHeight: 1080);
      if (pickedFile != null) {
        var img = File(pickedFile.path);
        var result = await uploadService.uploadImage(vehicle.id, 'vehicle', img, subtype: type);
        if (vehicle.documents == null)
          vehicle.documents = [];
        else
          vehicle.documents.removeWhere((element) => element.type == type);
        vehicle.documents.add(VehicleDocument.fromJson(result.data));
      }
      notifyListeners();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  editIncompleteVehicle(String id) async {
    try {
      vehicle = listVehicle.firstWhere((element) => element.id == id);
      await navigationManager.navigateTo('/vehicle_create');
      await this.getListVehicle();
    } catch (e) {
      super.onError(e);
    }
  }

  getDetails(Vehicle v) async {
    try {
      this.vehicle = v;
      await navigationManager.navigateTo('/vehicle_detail');
      await this.getListVehicle();
    } catch (e) {
      super.onError(e);
    }
  }

  onDispose() {
    vehicle = null;
  }

  remove() async {
    try {
      setLoading(true);
      await vehicleService.remove(vehicle.id);
      navigationManager.goBack();
      await this.getListVehicle();
    } catch (e) {
      setLoading(false);
      super.onError(e);
    }
  }

  modify() async {
    try {
      setLoading(true);
      navigationManager.goBack();
      String id = vehicle.id;
      await vehicleService.enableModify(id);
      this.listVehicle = await vehicleService.listAll();
      vehicle = listVehicle.firstWhere((element) => element.id == id);
      await navigationManager.navigateTo('/vehicle_create');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  VehicleDocument getDocument(String type) {
    return vehicle?.documents?.firstWhere((element) => element.type == type, orElse: () => null);
  }
}

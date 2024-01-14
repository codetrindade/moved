import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/service/address_service.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/view/ride/map_address/map_address_view.dart';

class MapAddressPresenter extends BasePresenter {
  MapAddressView _view;
  AddressService _addressService;

  MapAddressPresenter(this._view) {
    super.view = _view;
    _addressService = new Injector().addressService;
  }

  void getFromCoordinates(Address model) {
    _addressService.getFromCoordinates(model)
        .then((data) => _view.onGetFromCoordinatesSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}
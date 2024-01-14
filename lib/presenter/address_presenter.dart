import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/service/address_service.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/view/ride/address_route/address_route_view.dart';

class AddressRoutePresenter extends BasePresenter {
  AddressRouteView _view;
  AddressService _addressService;

  AddressRoutePresenter(this._view) {
    super.view = _view;
    _addressService = new Injector().addressService;
  }

  void getAutoCompleteResults(Address address) {
    _addressService.getAutoCompleteResults(address)
        .then((data) => _view.onGetAutoCompleteResultsSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}
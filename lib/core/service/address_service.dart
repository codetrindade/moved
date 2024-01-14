import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/address.dart';

class AddressService extends BaseService {
  Api _api;

  AddressService() {
    this._api = locator.get<Api>();
  }

  Future<Address> getFromCoordinates(Address model) async {
    return Address.fromJson(getResponse(await _api.post('address', model.toString())));
  }

  Future<List<Address>> getAutoCompleteResults(Address model) async {
    var data = getResponse(await _api.post('address/auto_complete', null));
    return (data as List).map((i) => new Address.fromJson(i)).toList();
  }
}

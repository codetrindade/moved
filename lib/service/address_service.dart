import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/address.dart';

class AddressService extends HttpBase {
  AddressService(String token) : super(token);

  Future<Address> getFromCoordinates(Address model) async {
    return await post('address', model.toString())
        .then((map) => Address.fromJson(map));
  }

  Future<List<Address>> getAutoCompleteResults(Address model) async {
    return await post('address/auto_complete', model.toString())
        .then((map) => (map as List).map((i) => new Address.fromJson(i)).toList());
  }

}
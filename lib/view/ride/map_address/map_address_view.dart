import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/address.dart';

abstract class MapAddressView extends BaseView {

  void onError(String message);

  void onGetFromCoordinatesSuccess(Address address);
}
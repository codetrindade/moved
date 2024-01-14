import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/address.dart';

abstract class AddressRouteView extends BaseView {

  void onError(String message);

  void onGetAutoCompleteResultsSuccess(List<Address> result);
}
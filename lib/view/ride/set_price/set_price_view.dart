import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/price_ride.dart';

abstract class SetPriceView extends BaseView {

  void onGetPricePreviewSuccess(List<PriceRide> result);

  void onError(String error);

}
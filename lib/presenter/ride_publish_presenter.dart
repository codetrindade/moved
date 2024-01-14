import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/service/ride_service.dart';
import 'package:movemedriver/view/ride/ride_publish/ride_publish_view.dart';

class RidePublishPresenter extends BasePresenter {
  RidePublishView _view;
  RideService _service;

  RidePublishPresenter(this._view){
    super.view = _view;
    _service = new Injector().rideService;
  }

  void createRoute(List<Ride> model) {
    _service.createRide(model)
        .then((data) => _view.onCreateRouteSuccess())
        .catchError((error) => super.onError(error, (message) => _view.onError(message)));
  }
}
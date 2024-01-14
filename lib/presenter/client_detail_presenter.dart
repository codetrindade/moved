import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/service/route_service.dart';
import 'package:movemedriver/view/route/route_detail/client_detail_page.dart';

class ClientDetailPresenter extends BasePresenter {
  ClientDetailView _view;
  RouteService _routeService;

  ClientDetailPresenter(this._view) {
    super.view = _view;
    _routeService = Injector().routeService;
  }

  void evaluate(id, rating, observation) {
    _routeService.evaluate(id, rating, observation)
        .then((data) => _view.onEvaluateSuccess())
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }
}
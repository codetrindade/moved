import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/service/route_service.dart';
import 'package:movemedriver/view/route/new_route_page.dart';

class NewRoutePresenter extends BasePresenter {
  NewRoutePageView _view;
  RouteService _routeService;

  NewRoutePresenter(this._view) {
    super.view = _view;
    _routeService = new Injector().routeService;
  }

  void cancelRoute(String routeId) {
    _routeService.statusRoute(routeId, 'refused')
        .then((data) => _view.onCancelSuccess())
        .catchError((error) =>_view.onCancelRouteError());
  }

  void acceptRoute(String routeId) {
    _routeService.statusRoute(routeId, 'accepted')
        .then((data) => _view.onAcceptRouteSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onAcceptRouteError(message)));
  }

  void startRoute(String routeId) {
    _routeService.statusRoute(routeId, 'in_progress')
        .then((data) => _view.onStartRouteSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onAcceptRouteError(message)));
  }
  
  void finishRoute(String routeId) {
    _routeService.statusRoute(routeId, 'finished')
        .then((data) => _view.onFinishedRouteSuccess())
        .catchError((error) =>
        super.onError(error, (message) => _view.onAcceptRouteError(message)));
  }

  void notifyUser(String routeId) {
    _routeService.statusRoute(routeId, 'waiting');
  }

  void recalculate(String routeId) {
    _routeService.recalculate(routeId)
        .then((data) => _view.onRecalculateSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onAcceptRouteError(message)));
  }

  void checkPoint(String routeId, String pointId) {
    _routeService.checkPoint(routeId, pointId)
        .then((data) => _view.onCheckPointSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onAcceptRouteError(message)));
  }
}
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/service/route_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/route_history.dart';
import 'package:movemedriver/model/user.dart';

class HistoryBloc extends BaseBloc {
  var routeService = locator.get<RouteService>();
  List<RouteHistory> history = [];
  RouteHistory model;
  User appDataUser;

  HistoryBloc() {
    eventBus.on<RouteFinishedEvent>().listen((event) {
      appDataUser =  AppState.user;
      this.getRouteHistoryById(event.id);
    });
  }

  listHistory() async {
    try {
      setLoading(true);
      history = await routeService.listHistory();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getRouteHistoryById(String id) async {
    try {
      setLoading(true);
      model = await routeService.getById(id);
      navigationManager.navigateTo('/route_resume');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  getModel(String id) async {
    try {
      setLoading(true);
      model = await routeService.getById(id);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}

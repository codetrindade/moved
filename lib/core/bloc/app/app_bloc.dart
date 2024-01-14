import 'dart:convert';

import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/core/service/driver_service.dart';
import 'package:movemedriver/core/service/push_service.dart';
import 'package:movemedriver/core/service/route_service.dart';
import 'package:movemedriver/core/service/set_config_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/pusher_data.dart';
import 'package:movemedriver/model/user.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/util/util.dart';

enum AppStateEnum { LOGIN, MAIN, SPLASH, SMS, REGISTER, WIZARD }

class AppBloc extends BaseBloc {
  var firebase = locator.get<PushService>();
  var setConfigService = locator.get<SetConfigService>();
  var driverService = locator.get<DriverService>();
  var routeService = locator.get<RouteService>();

  AppBloc() {
    super.state = AppStateEnum.SPLASH;
    eventBus.on().listen((event) async {
      if (event is AppNewMessageEvent) {
        if (event.pushMessage.type == 'approved') {
          notificationManager.showNotification(event.pushMessage);
        }
      }

      if (event is UnauthenticatedEvent) {
        this.logout();
      }

      if (event is AppLoginEvent) {
        homeInitialize(event.user);
      }

      if (event is AppLogoffEvent) {
        this.logout();
      }

      if (event is ChangeStateEvent) {
        changeState(event.state);
      }
    });
  }

  initialize() {
    Future.delayed(Duration(seconds: 3), () async {
      var token = await Util.getPreference('TOKEN');
      var data = await Util.getPreference('USER');
      if (data != null) {
        if (token != null) {
          Injector().setToken(token);
          locator.get<Api>().setToken(token, '');
          eventBus.fire(AppLoginEvent(User.fromJson(json.decode(data))));
        }
      } else {
        changeState(AppStateEnum.LOGIN);
      }
    });
  }

  homeInitialize(User user) async {
    try {
      setLoading(true);
      var status = await driverService.getStatus();
      await firebase.initialize();
      await setConfigService.setConfig();
      user.status = status.userStatus;
      await AppState().setUser(user);

      if (!await AppState().getGPS()) {
        dialogService.showDialog('Atenção', 'Não foi possível obter sua localização.');
      }

      if (status.userStatus == 'register')
        changeState(AppStateEnum.SMS);
      else {
        if (status.currentRouteStatus == 'accepted' || status.currentRouteStatus == 'in_progress') {
          var route = await routeService.getRouteById(status.currentRouteId);
          if (route.status == 'accepted' || route.status == 'in_progress') {
            AppState().setActiveRoute(PusherData(data: route));
            navigationManager.navigateTo('/new_route');
          }
        }
        if (status.userStatus == 'inactive')
          changeState(AppStateEnum.WIZARD);
        else {
          if (status.userStatus == 'available')
            await notificationManager.showOngoingNotification('Voce está online. Aguardando chamadas!');
          if (status.userStatus == 'unavailable') await notificationManager.removeOngoingNotification();
          changeState(AppStateEnum.MAIN);
        }
      }
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  logout() async {
    await AppState().setUser(null);
    firebase.token = null;
    navigationManager.goBackUntil();
    changeState(AppStateEnum.LOGIN);
  }
}

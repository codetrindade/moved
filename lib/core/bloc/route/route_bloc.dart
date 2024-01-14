import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/service/route_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/pusher_data.dart';

class RouteBloc extends BaseBloc {
  var routeService = locator.get<RouteService>();

  RouteBloc() {
    eventBus.on<AppNewMessageEvent>().listen((event) async {
      if (event.pushMessage.type == 'new_route') {
        if (event.pushMessage.isBackground) {
          var currentRoute = AppState().activeRoute.data;
          if (currentRoute == null ||
              (currentRoute.status == 'finished' ||
                  currentRoute.status == 'refused' ||
                  currentRoute.status == 'canceled')) {
            var route = await routeService.getRouteById(event.pushMessage.id);
            if (route.status == 'pending') {
              AppState().setActiveRoute(PusherData(data: route));
              navigationManager.navigateTo('/new_route');
            }
          }
        } else
          notificationManager.showNotification(event.pushMessage);
      }

      //{\"title\":\"Nova corrida\",\"body\":\"Clique para visualizar no app\",\"type\":\"new_route\",\"id\":\"991fa272-c37e-42dc-a571-4c2cc0dc250a\"}
    });
  }
}

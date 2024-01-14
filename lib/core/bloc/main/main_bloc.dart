import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/service/main_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/pusher_data.dart';
import 'package:movemedriver/util/util.dart';
import 'package:screen/screen.dart';

enum MainState { HOME, RIDE, PROFILE, HISTORY, CHAT }

class MainBloc extends BaseBloc {
  AndroidIntent intent;
  var mainService = locator.get<MainService>();
  StreamController<double> gpsStreamController = new StreamController<double>();
  double lat;
  double lng;

  MainBloc() : super(state: MainState.HOME);

  initialize() async {
    Screen.keepOn(true);
    AppState().gpsStreamController.add(gpsStreamController);
    //this.verifyGps();
    this.listenToPusher();
    await this.listenToGps();
    if (AppState.user.status == 'available') AppState().initPusher();
  }

  listenToPusher() {
    AppState().pusherStreamController.stream.listen((data) async {
      if (data == null) return;
      var pusher = new PusherData.fromJson(data.data);
      var currentRoute = AppState().activeRoute.data;
      switch (pusher.command) {
        case 'driverStatusRoute':
          if (pusher.data.status == 'canceled') {
            if (currentRoute != null && currentRoute.status != 'finished') {
              currentRoute.status = 'canceled';
              navigationManager.goBack();
            }
          }
          break;
        case 'newRoute':
          if (currentRoute == null ||
              currentRoute.status == 'finished' ||
              currentRoute.status == 'refused' ||
              currentRoute.status == 'canceled') {
            FlutterRingtonePlayer.play(
                android: AndroidSounds.notification,
                ios: IosSounds.glass,
                looping: false,
                volume: 1.0,
                asAlarm: true);
            pusher.data.status = 'pending';
            AppState().setActiveRoute(pusher);
            navigationManager.navigateTo('/new_route');
          }
          break;
      }
    });
  }

  listenToGps() async {
    if (AppState.pos != null) await mainService.updateMyPos(AppState.pos.latitude, AppState.pos.longitude, 0);
    gpsStreamController.stream
        .listen((data) async {
          if (AppState.user != null && AppState.user.status == 'available') if ((Util.haversine(lat, lng, AppState.pos.latitude, AppState.pos.longitude) * 1000) > 25) {
            lat = AppState.pos.latitude;
            lng = AppState.pos.longitude;
            await mainService.updateMyPos(AppState.pos.latitude, AppState.pos.longitude,
                AppState().activeRoute.data != null ? AppState().activeRoute.data.travelledDistance : 0.0);
          }
        })
        .asFuture()
        .catchError((_) {
          disposeStream();
        });
  }

  disposeStream() {
    AppState().gpsStreamController.remove(gpsStreamController);
    gpsStreamController.close();
  }
}

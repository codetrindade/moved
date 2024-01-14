import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:location/location.dart';
import 'package:movemedriver/model/pusher_data.dart';
import 'package:movemedriver/model/user.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/settings.dart';
import 'package:movemedriver/util/util.dart';
import 'package:pusher/pusher.dart';

class AppState {
  static AppState _instance;
  static User user;

  //static int gpsOk;
  static Position pos;
  CameraPosition initialPosition;
  Pusher pusher = Pusher();
  PusherData activeRoute = PusherData();
  StreamController<PusherResult> pusherStreamController = StreamController<PusherResult>.broadcast();
  List<StreamController<double>> gpsStreamController = List<StreamController<double>>();
  static int devicePixelRatio;

  factory AppState() => _instance ??= AppState._();

  AppState._();

  initPusher() {
    pusher.init(Settings.pusherAuth, user.token, Settings.pusherCluster, Settings.pusherKey);
    pusher.subscribeToAChannel(Settings.pusherChannel + user.id, true);
    pusher.bindOnAChannel(Settings.pusherChannel + user.id, 'statusRoute', true);
    pusher.bindOnAChannel(Settings.pusherChannel + user.id, 'autoLive', true);
    pusher.callback = sendPusherEvent;
  }

  sendPusherEvent(PusherResult result) {
    pusherStreamController.add(result);
  }

  disconnectPusher() {
    pusher.disconnect();
  }

  setUser(User u, {bool token = false}) async {
    if (u == null) {
      await Util.setPreference('TOKEN', null);
      await Util.setPreference('USER', null);
      user = null;
      return;
    }

    if (token) {
      await Util.setPreference('TOKEN', u.token);
      Injector().setToken(u.token);
    }

    await Util.setPreference('USER', u.toString());
    user = u;
  }

  setActiveRoute(PusherData data) {
    if (data == null) {
      activeRoute = null;
      return;
    }
    activeRoute = data;
  }

  Future<bool> getGPS() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //await Geolocator.openAppSettings();
      await Geolocator.openLocationSettings();
      return false;
    }
    //Location location = Location();
    //location.changeSettings(accuracy: LocationAccuracy.navigation, interval: 300, distanceFilter: 2);
    try {
      //pos = await location.getLocation();
      pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation, timeLimit: Duration(seconds: 10));
      Geolocator.getPositionStream()
          .listen((data) {
        var d = Util.haversine(pos.latitude, pos.longitude, data.latitude, data.longitude) * 1000;
        pos = data;
        initialPosition = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          bearing: data.heading,
          zoom: 17,
        );

        gpsStreamController.forEach((gsc) {
          if (gsc.isClosed || !gsc.hasListener) return;
          gsc.add(d);
        });
      });

      initialPosition = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        bearing: pos.heading,
        zoom: 15,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  dispose() {
    pusherStreamController.close();
    gpsStreamController.forEach((gsc) {
      gsc.close();
    });
    gpsStreamController.clear();
  }
}

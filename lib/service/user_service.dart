import 'dart:async';

import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/driver.dart';
import 'package:movemedriver/model/register.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/user.dart';

class UserService extends HttpBase {
  UserService(String token) : super(token);

  Future<User> register(User model) async {
    return await post('register', model.toString()).then((data) => User.fromJson(data));
  }

  Future<User> update(User model) async {
    return await put('update', model.toString()).then((data) => User.fromJson(data));
  }

  Future<Driver> configAbout(Driver model) async {
    return await post('driver/config_about', model.toString()).then((data) => Driver.fromJson(data));
  }

  Future<Driver> configRoute(Driver model) async {
    return await post('driver/config_route', model.toString()).then((data) => Driver.fromJson(data));
  }

  Future<Driver> addDocument(Driver model) async {
    return await post('driver/document/add', model.toString()).then((data) => Driver.fromJson(data));
  }

  Future<ResponseData> password(String oldPassword, password) async {
    return await put('password', '{"old_password": "$oldPassword", "password":"$password"}')
        .then((data) => ResponseData.fromJson(data));
  }

  Future<ResponseData> resendSMS() async {
    return await get('mobile/register/resend').then((data) => ResponseData.fromJson(data));
  }

  Future<User> registerFacebook(RegisterData model) async {
    return await post('register/facebook', model.toString()).then((data) => User.fromJson(data));
  }

  Future<ResponseData> goOnline(flag, vehicleId) async {
    return await post('driver/status', '{"flag": "$flag", "vehicle_id":"$vehicleId"}')
        .then((data) => ResponseData.fromJson(data));
  }

  Future<ResponseData> goOffline() async {
    return await post('driver/status', null).then((data) => ResponseData.fromJson(data));
  }

  Future<ResponseData> updateMyPos(lat, long, distance) async {
    return await post('driver/route/live', '{"lat":"$lat","long":"$long","travelled_distance":"$distance"}')
        .then((data) => ResponseData.fromJson(data));
  }
}

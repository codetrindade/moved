import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/util/util.dart';

abstract class BaseState<T extends StatefulWidget> extends State implements BaseView {
  BaseState() : super();

  @override
  void onUnauthenticated() {
    Util.showMessage(context, 'Sessão expirada', 'Por favor efetue o login novamente');
    this.onLogout();
  }

  void onLogout() {
    //AppState().setUser(null);
    eventBus.fire(AppLogoffEvent());
  }

  @override
  void onError(String message) {
    Util.showMessage(context, 'Erro', message);
  }

  Future<bool> getAuthenticated() async {
    var data = await Util.getPreference('TOKEN');
    return (data != null);
  }
}

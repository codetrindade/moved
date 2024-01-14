
import 'package:flutter/material.dart';
import 'package:movemedriver/core/service/local_notification_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/ui/manager/navigation_manager.dart';

import 'app_exception.dart';
import 'dialog_service.dart';

class BaseBloc with ChangeNotifier {
  var state;
  var isLoading = false;
  var dialogService = locator<DialogService>();

  var navigationManager = locator<NavigationManager>();
  var notificationManager = locator<LocalNotificationService>();

  BaseBloc({this.isLoading = false, this.state});

  initState(_initialState) {
    state = _initialState;
  }

  refresh() {
    notifyListeners();
  }

  changeState(_state) {
    this.state = _state;
    notifyListeners();
  }

  setLoading(_isLoading) {
    if (this.isLoading != _isLoading) {
      this.isLoading = _isLoading;
    }
    notifyListeners();
  }

  onError(error) {
    String message =
    error is AppException ? error.message : "Ocorreu um erro inesperado, tente fechar o seu aplicativo";
    dialogService.showDialog("Ops... ", message);
    return false;
  }

  isNullOrEmpty(dynamic val) {
    return val == null || val.length == 0;
  }

}

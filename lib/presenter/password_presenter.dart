import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/service/user_service.dart';
import 'package:movemedriver/view/information/password_view.dart';

class PasswordPresenter extends BasePresenter{
  PasswordView _view;
  UserService _service;

  PasswordPresenter(this._view) {
    super.view = _view;
    _service = new Injector().userService;
  }

  void password(String oldPassword, String password) {
    _service
        .password(oldPassword, password)
        .then((data) => _view.onPasswordSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onPasswordError(message)));
  }

}
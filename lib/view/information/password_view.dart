import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/response.dart';

abstract class PasswordView extends BaseView {

  void onPasswordSuccess(ResponseData message);

  void onPasswordError(String error);

}
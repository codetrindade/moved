
import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/driver.dart';

abstract class ConfigurationView extends BaseView {
  void onRegisterSuccess(Driver model);
}
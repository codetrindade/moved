import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/service/user_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/driver.dart';

class DriverPreferenceBloc extends BaseBloc {
  Driver model;
  var userService = locator.get<UserService>();

  DriverPreferenceBloc() {
    model = Driver.fromJson(AppState.user.driver.toJson());
  }

  configAbout(Driver driver) async {
    try {
      setLoading(true);
      model = await userService.configAbout(driver);
      AppState.user.driver = model;
      AppState().setUser(AppState.user);
      dialogService.showDialog('Sucesso', 'Dados alterados com sucesso');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

}
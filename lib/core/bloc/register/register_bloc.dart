import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/service/register_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/user.dart';

class RegisterBloc extends BaseBloc {
  var registerService = locator.get<RegisterService>();
  bool showPassword = false;
  bool showConfirmPassword = false;

  register(User model) async {
    try {
      setLoading(true);
      var user = await registerService.register(model);
      await AppState().setUser(user, token: true);
      eventBus.fire(AppLoginEvent(user));
    } catch (e) {
      super.onError(e);
      setLoading(false);
    }
  }
}

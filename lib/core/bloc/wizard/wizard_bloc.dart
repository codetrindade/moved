import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/wizard.dart';
import 'package:movemedriver/core/service/driver_service.dart';
import 'package:movemedriver/locator.dart';

class WizardBloc extends BaseBloc {
  var driverService = locator.get<DriverService>();
  List<Wizard> items = [];

  initialize() async {
    try {
      setLoading(true);
      items = await driverService.getWizardStatus();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}

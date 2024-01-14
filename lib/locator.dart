import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:movemedriver/core/base/dialog_service.dart';
import 'package:movemedriver/core/bloc/app/app_data.dart';
import 'package:movemedriver/core/service/address_service.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/core/service/bank_account_service.dart';
import 'package:movemedriver/core/service/chat_service.dart';
import 'package:movemedriver/core/service/document_service.dart';
import 'package:movemedriver/core/service/driver_service.dart';
import 'package:movemedriver/core/service/extract_service.dart';
import 'package:movemedriver/core/service/local_notification_service.dart';
import 'package:movemedriver/core/service/login_service.dart';
import 'package:movemedriver/core/service/main_service.dart';
import 'package:movemedriver/core/service/push_service.dart';
import 'package:movemedriver/core/service/register_service.dart';
import 'package:movemedriver/core/service/ride_service.dart';
import 'package:movemedriver/core/service/route_service.dart';
import 'package:movemedriver/core/service/sac_service.dart';
import 'package:movemedriver/core/service/set_config_service.dart';
import 'package:movemedriver/core/service/sms_service.dart';
import 'package:movemedriver/core/service/upload_service.dart';
import 'package:movemedriver/core/service/user_service.dart';
import 'package:movemedriver/core/service/vehicle_service.dart';
import 'package:movemedriver/ui/manager/navigation_manager.dart';

GetIt locator = GetIt.instance;
EventBus eventBus = EventBus();

void setupLocator() {
  locator.registerLazySingleton(() => AppData());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationManager());
  locator.registerLazySingleton(() => PushService());
  locator.registerLazySingleton(() => LocalNotificationService()..initialize());

  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => SetConfigService());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => SmsService());
  locator.registerLazySingleton(() => VehicleService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => LoginService());
  locator.registerLazySingleton(() => RegisterService());
  locator.registerLazySingleton(() => MainService());
  locator.registerLazySingleton(() => RideService());
  locator.registerLazySingleton(() => AddressService());
  locator.registerLazySingleton(() => UploadService());
  locator.registerLazySingleton(() => DocumentService());
  locator.registerLazySingleton(() => DriverService());
  locator.registerLazySingleton(() => RouteService());
  locator.registerLazySingleton(() => SacService());
  locator.registerLazySingleton(() => ExtractService());
  locator.registerLazySingleton(() => BankAccountService());

}

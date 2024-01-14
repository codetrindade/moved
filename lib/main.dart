import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/bank_account/bank_account_bloc.dart';
import 'package:movemedriver/core/bloc/chat/chat_bloc.dart';
import 'package:movemedriver/core/bloc/document/document_bloc.dart';
import 'package:movemedriver/core/bloc/driver_preferences/driver_preference_bloc.dart';
import 'package:movemedriver/core/bloc/extract_bloc.dart';
import 'package:movemedriver/core/bloc/history/history_bloc.dart';
import 'package:movemedriver/core/bloc/home/home_bloc.dart';
import 'package:movemedriver/core/bloc/login/login_bloc.dart';
import 'package:movemedriver/core/bloc/main/main_bloc.dart';
import 'package:movemedriver/core/bloc/operation/operation_config_bloc.dart';
import 'package:movemedriver/core/bloc/register/register_bloc.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/core/bloc/route/route_bloc.dart';
import 'package:movemedriver/core/bloc/sac/sac_bloc.dart';
import 'package:movemedriver/core/bloc/sms_bloc.dart';
import 'package:movemedriver/core/bloc/user/user_bloc.dart';
import 'package:movemedriver/core/bloc/vehicle/share_vehicle_bloc.dart';
import 'package:movemedriver/core/bloc/vehicle/vehicle_bloc.dart';
import 'package:movemedriver/core/bloc/wizard/wizard_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/ui/manager/dialog_manager.dart';
import 'package:movemedriver/ui/manager/navigation_manager.dart';
import 'package:movemedriver/view/main/main_page.dart';
import 'package:movemedriver/view/bank_account/bank_account_page.dart';
import 'package:movemedriver/view/chat/chat_page.dart';
import 'package:movemedriver/view/history/history_list_detail.dart';
import 'package:movemedriver/view/information/configuration_page.dart';
import 'package:movemedriver/view/information/documents_page.dart';
import 'package:movemedriver/view/information/profile_page.dart';
import 'package:movemedriver/view/login/login_main_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movemedriver/view/main/home_page.dart';
import 'package:movemedriver/view/register/driver_preferences.dart';
import 'package:movemedriver/view/route/new_route_page.dart';
import 'package:movemedriver/view/vehicle/vehicle_create_page.dart';
import 'package:movemedriver/view/vehicle/vehicle_detail.dart';
import 'package:movemedriver/view/vehicle/vehicle_list_page.dart';
import 'package:movemedriver/widgets/crop_page.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    setupLocator();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => ChatBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => SmsBloc()),
      ChangeNotifierProvider(create: (context) => VehicleBloc()),
      ChangeNotifierProvider(create: (context) => UserBloc()),
      ChangeNotifierProvider(create: (context) => RegisterBloc()),
      ChangeNotifierProvider(create: (context) => MainBloc()),
      ChangeNotifierProvider(create: (context) => LoginBloc()),
      ChangeNotifierProvider(create: (context) => RideBloc()),
      ChangeNotifierProvider(create: (context) => DocumentBloc()),
      ChangeNotifierProvider(create: (context) => HomeBloc()),
      ChangeNotifierProvider(create: (context) => WizardBloc()),
      ChangeNotifierProvider(create: (context) => OperationConfigBloc()),
      ChangeNotifierProvider(create: (context) => DriverPreferenceBloc()),
      ChangeNotifierProvider(create: (context) => HistoryBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => ShareVehicleBloc()),
      ChangeNotifierProvider(create: (context) => RouteBloc(), lazy: false),
      ChangeNotifierProvider(create: (context) => SacBloc()),
      ChangeNotifierProvider(create: (context) => ExtractBloc()),
      ChangeNotifierProvider(create: (context) => BankAccountBloc()),
    ], child: MovemeDriverApp()));
  });
}

class MovemeDriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, widget) => Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => DialogManager(child: widget))),
        title: 'MovemeDriver',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: MainPage(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginMainPage(),
          '/splash': (BuildContext context) => MainPage(),
          '/home': (BuildContext context) => HomePage(),
          '/chat_page': (BuildContext context) => ChatPage(),
          '/new_route': (BuildContext context) => NewRoutePage(),
          '/vehicle_create': (BuildContext context) => VehicleCreatePage(),
          '/vehicle_list': (BuildContext context) => VehicleListPage(),
          '/vehicle_detail': (BuildContext context) => VehicleDetail(),
          '/documents': (BuildContext context) => DocumentsPage(),
          '/preferences': (BuildContext context) => DriverPreferences(),
          '/operation': (BuildContext context) => ConfigurationPage(),
          '/profile': (BuildContext context) => ProfilePage(),
          '/crop': (BuildContext context) => CropPage(),
          '/bank_account': (BuildContext context) => BankAccountPage(),
          '/route_resume': (BuildContext context) => HistoryListDetail()
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        navigatorKey: locator<NavigationManager>().navigatorKey,
        supportedLocales: [
          const Locale('pt', 'BR'), //
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/view/login/login_page.dart';
import 'package:movemedriver/view/login/register_page.dart';
import 'package:movemedriver/view/login/sms_page.dart';
import 'package:movemedriver/view/main/home_page.dart';
import 'package:movemedriver/view/wizard_page.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AppBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.initialize());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<AppBloc>(context);
    switch (bloc.state) {
      case AppStateEnum.MAIN:
        return HomePage();
      case AppStateEnum.LOGIN:
        return LoginPage();
      case AppStateEnum.REGISTER:
        return RegisterPage();
      case AppStateEnum.SMS:
        return SmsPage();
      case AppStateEnum.WIZARD:
        return WizardPage();
      default:
        return Splash(isLoading: bloc.isLoading);
    }
  }
}

class Splash extends StatelessWidget {
  bool isLoading;

  Splash({this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: isLoading ? LoadingCircle() : Center(child: Image.asset('assets/images/logo_new.png')));
  }
}

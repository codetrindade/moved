
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/blue_light_button.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/information/term.dart';
import 'package:movemedriver/view/login/login_page.dart';

class LoginMainPage extends StatefulWidget {
  @override
  _LoginMainPageState createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  PageController _pageController;
  int _page = 0;
  static const _duration = const Duration(milliseconds: 500);

  void onNextPage() {
    setState(() {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void onBackPage() {
    setState(() {
      _page != 4 ? _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null;
    });
  }

  void onChangeWalkItem(int page) {
    if (_pageController.hasClients && _pageController.hasListeners) {
      _page = page;
      _pageController.animateToPage(page, duration: _duration, curve: Curves.ease);
    }
  }

  void openLoginPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future openRegisterPage() async {
    var a = await Navigator.push(context, MaterialPageRoute(builder: (context) => TermPage(edit: true)));

    if (!a) {
      Util.showConfirm(context, 'Atenção', 'Ao recusar os termos, não será possível acessar o aplicativo',
          'Ler novamente', 'Cancelar', true, () {
        openRegisterPage();
      });
    } else
      eventBus.fire(ChangeStateEvent(AppStateEnum.REGISTER));
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(gradient: appGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/svg/icon_home.svg', width: 250),
            SizedBox(height: 60.0),
            BlueDarkButton(text: 'Já tenho uma conta', callback: openLoginPage),
            SizedBox(height: 10.0),
            BlueLightButton(text: 'Criar uma conta', callback: openRegisterPage),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

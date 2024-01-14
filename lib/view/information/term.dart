
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/login/login_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TermPage extends StatefulWidget {
  final bool edit;

  TermPage({this.edit = false});

  @override
  _TermPageState createState() => _TermPageState(edit: this.edit);
}

class _TermPageState extends State<TermPage> {
  LoginBloc bloc;
  bool accept;
  bool edit;

  _TermPageState({this.edit});

  @override
  void initState() {
    super.initState();
    accept = !edit;
    Future.microtask(() async => await bloc.getTerm());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<LoginBloc>(context);
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(title: 'Termos de Uso', callback: () => Navigator.pop(context)),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: bloc.isLoading
          ? LoadingCircle(showBackground: true)
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ListView(padding: EdgeInsets.all(0), children: <Widget>[
                Html(
                    data: bloc.term.content.rendered,
                    onLinkTap:(url, context, attributes, element) {
                      try {
                        launchUrlString(url);
                      } catch (e) {}
                    }),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        accept = !accept;
                      });
                    },
                    child: Row(children: <Widget>[
                      Checkbox(
                        value: accept,
                        activeColor: AppColors.colorGreenLight,
                        onChanged: (bool resp) {
                          if (edit)
                            setState(() {
                              accept = resp;
                            });
                        },
                      ),
                      Text('Li e aceito os termos de uso', style: AppTextStyle.textBlueDarkSmall)
                    ])),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 30),
                  child: BlueDarkButton(
                      text: 'Continuar',
                      callback: () {
                        if (edit && !accept) {
                          bloc.dialogService.showDialog('Atenção',
                              'Para poder acessar o aplicativo é ncessário ler e concordar com os termos de uso');
                          return;
                        }
                        if (edit) eventBus.fire(ChangeStateEvent(AppStateEnum.REGISTER));
                        Navigator.pop(context, accept);
                      }),
                ),
              ])),
    );
  }
}

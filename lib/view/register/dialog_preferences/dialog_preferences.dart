import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/theme.dart';

class DialogPreferences extends StatefulWidget {
  final DialogPreferencesListener listener;
  final String title;
  final String option1;
  final String option2;
  final int selectedOption;

  DialogPreferences(
      {@required this.title,
      @required this.option1,
      @required this.option2,
      @required this.listener,
      @required this.selectedOption});

  @override
  _DialogPreferencesState createState() => _DialogPreferencesState(
      title: title, option1: option1, option2: option2, listener: listener, confirm: selectedOption);
}

class _DialogPreferencesState extends BaseState<DialogPreferences> {
  DialogPreferencesListener listener;
  String title;
  String option1;
  String option2;
  int confirm = 3;

  _DialogPreferencesState({this.title, this.option1, this.option2, this.listener, this.confirm});

  void changeConfirm(int _confirm) {
    setState(() {
      var preference;
      if (option1 == 'Adoro conversar!') {
        preference = 1;
      } else if (option1 == 'Não é permitido fumar') {
        preference = 2;
      } else if (option1 == 'Adoro ouvir música!') {
        preference = 3;
      }
      listener.onDriverPreferences(_confirm, preference);
      confirm = _confirm;
    });
  }

  void closeDialogConfirm(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.colorBlackTransparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: AppColors.colorWhite,
                  borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputRadiusDouble))),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(title ?? '', style: AppTextStyle.textBlueDarkSmall),
                    Container(
                      color: AppColors.colorGreenLight,
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          changeConfirm(0);
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(option1 ?? '', style: AppTextStyle.textGreyDarkSmall),
                                ],
                              ),
                            ),
                            Icon(Icons.check,
                                size: 20.0, color: confirm == 0 ? AppColors.colorGreenLight : Colors.transparent)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          changeConfirm(1);
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(option2 ?? '', style: AppTextStyle.textGreyDarkSmall),
                                ],
                              ),
                            ),
                            Icon(Icons.check,
                                size: 20.0, color: confirm == 1 ? AppColors.colorGreenLight : Colors.transparent)
                          ],
                        ),
                      ),
                    ),
                    BlueDarkButton(
                        text: 'Salvar',
                        callback: () {
                          closeDialogConfirm(context);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class DialogPreferencesListener {
  void onDriverPreferences(int value, int preference);
}

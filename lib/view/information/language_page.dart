import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/theme.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends BaseState<LanguagePage> {
  var language = 0;

  void changeLanguage(int lang) {
    setState(() {
      language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(
            title: 'Idiomas',
            callback: () {
              Navigator.pop(context);
            },
          ),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(0);
                },
                child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: new Text('Português', style: AppTextStyle.textBlueDarkSmallBold),
                        ),
                        language == 0 ? new Icon(Icons.check, color: AppColors.colorGreenLight) : SizedBox()
                      ],
                    ))),
            new SizedBox(height: 20.0),
            new FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(1);
                },
                child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: new Text('Inglês', style: AppTextStyle.textBlueDarkSmallBold),
                        ),
                        language == 1 ? new Icon(Icons.check, color: AppColors.colorGreenLight) : SizedBox()
                      ],
                    ))),
            new SizedBox(height: 20.0),
            new FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(2);
                },
                child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: new Text('Espanhol', style: AppTextStyle.textBlueDarkSmallBold),
                        ),
                        language == 2 ? new Icon(Icons.check, color: AppColors.colorGreenLight) : SizedBox()
                      ],
                    ))),
            new SizedBox(height: 20.0),
            new FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  changeLanguage(3);
                },
                child: new Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                        borderRadius: AppSizes.buttonCorner),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                          child: new Text('Francês', style: AppTextStyle.textBlueDarkSmallBold),
                        ),
                        language == 3 ? new Icon(Icons.check, color: AppColors.colorGreenLight) : SizedBox()
                      ],
                    ))),
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: BlueDarkButton(text: 'Salvar alteração', callback: null),
      ),
    );
  }
}

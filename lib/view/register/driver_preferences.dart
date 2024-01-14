import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/driver_preferences/driver_preference_bloc.dart';
import 'package:movemedriver/model/driver.dart';
import 'package:movemedriver/theme.dart';
import 'package:provider/provider.dart';

class DriverPreferences extends StatefulWidget {
  @override
  _DriverPreferencesState createState() => _DriverPreferencesState();
}

class _DriverPreferencesState extends BaseState<DriverPreferences> {
  DriverPreferenceBloc bloc;
  int talk;
  int smoke;
  int music;

  var _description = TextEditingController();

  void openDialogPreference(_option1, _option2, callback1, callback2) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('Qual a sua preferencia?',
                            textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold))),
                Row(children: <Widget>[
                  Expanded(
                      child: InkWell(
                          onTap: () => callback1(),
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border(top: BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 0.5))),
                              height: 90,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.check_circle, color: AppColors.colorBlueLight)),
                                Text(_option1, style: AppTextStyle.textBlueLightSmallBold, textAlign: TextAlign.center)
                              ])))),
                  Expanded(
                      child: InkWell(
                          onTap: () => callback2(),
                          child: Container(
                              height: 90,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.cancel, color: Colors.white)),
                                Text(_option2, style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center)
                              ]))))
                ])
              ]));
        });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _description.text = bloc.model.description;
      this.music = bloc.model.music;
      this.talk = bloc.model.talk;
      this.smoke = bloc.model.smoke;
      bloc.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<DriverPreferenceBloc>(context);

    return Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Sobre Você', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Adicionar biografia', style: AppTextStyle.textBlueLightSmallBold),
          ),
          SizedBox(height: 15.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                  style: AppTextStyle.textBlueLightExtraSmall,
                  keyboardType: TextInputType.multiline,
                  controller: _description,
                  maxLines: 5,
                  maxLength: 255,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: AppSizes.inputPadding,
                    hintText: 'Digite algo sobre o você',
                    hintStyle: AppTextStyle.textBlueLightExtraSmall,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.colorBlueLight, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.colorBlueLight, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                  ))),
          SizedBox(height: 30.0),
          Text('Adicionar preferências', style: AppTextStyle.textBlueLightSmallBold),
          SizedBox(height: 10.0),
          TransparentButton(
              text: this.talk == 0 ? 'Só o necessário' : 'Adoro Conversar!',
              iconLeft: Icon(MoveMeIcons.speech_bubble, color: AppColors.colorBlueLight),
              arrow: false,
              ok: this.talk == 1,
              warning: this.talk == 0,
              callback: () => openDialogPreference('Adoro conversar!', 'Só o necessário', () {
                    this.talk = 1;
                    bloc.refresh();
                    Navigator.pop(context);
                  }, () {
                    this.talk = 0;
                    bloc.refresh();
                    Navigator.pop(context);
                  })),
          TransparentButton(
              text: this.smoke == 0 ? 'Não é permitido fumar!' : 'Cigarro não me incomoda',
              iconLeft: Icon(MoveMeIcons.cigarette, color: AppColors.colorBlueLight),
              arrow: false,
              ok: this.smoke == 1,
              warning: this.smoke == 0,
              callback: () => openDialogPreference('Cigarro não me incomoda', 'Não é permitido fumar', () {
                    this.smoke = 1;
                    bloc.refresh();
                    Navigator.pop(context);
                  }, () {
                    this.smoke = 0;
                    bloc.refresh();
                    Navigator.pop(context);
                  })),
          TransparentButton(
              text: this.music == 0 ? 'Sem música no carro' : 'Adoro ouvir música!',
              iconLeft: Icon(MoveMeIcons.music_player, color: AppColors.colorBlueLight),
              arrow: false,
              ok: this.music == 1,
              warning: this.music == 0,
              callback: () => openDialogPreference('Adoro ouvir música!', 'Sem música no carro', () {
                    this.music = 1;
                    bloc.refresh();
                    Navigator.pop(context);
                  }, () {
                    this.music = 0;
                    bloc.refresh();
                    Navigator.pop(context);
                  })),
        ])),
        bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: BlueDarkButton(
                callback: () async => await bloc.configAbout(
                    Driver(description: _description.text, talk: this.talk, smoke: this.smoke, music: this.music)))));
  }
}

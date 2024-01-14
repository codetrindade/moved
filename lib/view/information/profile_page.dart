
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_light_button.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/user/user_bloc.dart';
import 'package:movemedriver/model/user.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/information/password_page.dart';
import 'package:movemedriver/view/login/sms_page.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  UserBloc bloc;
  var _name = TextEditingController();

  // var _document = TextEditingController();
  var _email = TextEditingController();
  var _phone = MaskedTextController(mask: '+00 (00) 00000-0000');

  var _nameFocus = FocusNode();

  //var _documentFocus = FocusNode();
  var _emailFocus = FocusNode();
  var _phoneFocus = FocusNode();

  void showImageSourceSheet() {
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text('De onde deseja adicionar uma foto?',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.textBlueLightSmallBold))),
                Row(children: <Widget>[
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                          width: 0.5))),
                              height: 70,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                        child: Icon(Icons.camera_alt,
                                            color: AppColors.colorBlueLight)),
                                    Text('Câmera', style: AppTextStyle.textBlueLightSmallBold)
                                  ])))),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(child: Icon(Icons.photo_library, color: Colors.white)),
                                    Text('Galeria', style: AppTextStyle.textWhiteSmallBold)
                                  ]))))
                ])
              ]));
        });
  }

  void openPasswordPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage()));
  }

  Future<void> onSaveUpdate() async {
    if (_name.text.length == 0) {
      bloc.dialogService.showDialog('Atenção', 'Preencha o nome');
      FocusScope.of(context).requestFocus(_nameFocus);
      return;
    }
    /*
    if (_document.text.length == 0) {
      bloc.dialogService.showDialog('Atenção', 'Preencha o Documento');
      FocusScope.of(context).requestFocus(_documentFocus);
      return;
    }*/
    if (_phone.text.length == 0) {
      bloc.dialogService.showDialog('Atenção', 'Preencha o telefone');
      FocusScope.of(context).requestFocus(_phoneFocus);
      return;
    }
    if (_email.text.length == 0) {
      bloc.dialogService.showDialog('Atenção', 'Preencha o e-mail');
      FocusScope.of(context).requestFocus(_emailFocus);
      return;
    }

    await bloc.update(User(name: _name.text, email: _email.text));
  }

  @override
  void dispose() {
    _name.dispose();
    //_document.dispose();
    _email.dispose();
    _phone.dispose();
    _nameFocus.dispose();
    //_documentFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _name.text = bloc.appDataUser.name;
      _email.text = bloc.appDataUser.email;
      _phone.text = bloc.appDataUser.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<UserBloc>(context);

    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            appBar: PreferredSize(
                child: AppBarCustom(title: 'Perfil', callback: () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 20.0),
              FlatButton(
                  onPressed: () => showImageSourceSheet(),
                  child: bloc.appDataUser.photo != null && bloc.appDataUser.photo.isNotEmpty
                      ? ClipOval(
                          child: FadeInImage.assetNetwork(
                              width: 80,
                              height: 80,
                              placeholder: 'assets/images/user.png',
                              image: bloc.appDataUser.photo,
                              fit: BoxFit.fill))
                      : Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(MoveMeIcons.perfil,
                              color: AppColors.colorGreyLight, size: 50.0))),
              SizedBox(height: 20.0),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFieldCustom(
                      action: TextInputAction.done,
                      controller: _email,
                      focus: _emailFocus,
                      label: 'E-mail',
                      enabled: false)),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(color: AppColors.colorBlueLight)),
                child: Text(
                    bloc.appDataUser.phone == null || bloc.appDataUser.phone.isEmpty
                        ? 'Telefone ainda não informado'
                        : bloc.appDataUser.phone,
                    style: AppTextStyle.textBlueLightExtraSmall),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SmsPage(fromProfile: true)));
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                            bloc.appDataUser.phone == null || bloc.appDataUser.phone.isEmpty
                                ? 'Confirmar conta'
                                : 'Alterar telefone',
                            style: AppTextStyle.textGreyExtraSmallBold),
                      ],
                    )),
              ),
              SizedBox(height: 20),
              TransparentButton(
                  text: 'Disponibilizar meu telefone para os passageiros durante a corrida',
                  arrow: false,
                  height: 100,
                  border: 5,
                  callback: () async => await bloc.changeDisplayMyPhone(),
                  ok: bloc.showMyPhone,
                  iconLeft: Icon(Icons.contact_phone_rounded, color: AppColors.colorBlueLight),
                  warning: !bloc.showMyPhone)
            ])),
            bottomNavigationBar: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 1.0),
                child: Column(children: <Widget>[
                  BlueLightButton(text: 'Alterar Senha', callback: openPasswordPage)
                ])));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/star_rating.dart';
import 'package:movemedriver/presenter/client_detail_presenter.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';

class ClientPageDetail extends StatefulWidget {
  final bool canEvaluate;
  final String name;
  final String photo;
  final String routeId;

  ClientPageDetail({this.canEvaluate = true, @required this.name, @required this.photo, @required this.routeId});

  @override
  _ClientPageDetailState createState() =>
      _ClientPageDetailState(name: name, photo: photo, canEvaluate: canEvaluate, routeId: routeId);
}

class _ClientPageDetailState extends BaseState<ClientPageDetail> implements ClientDetailView {
  double _rating = 5;
  String name;
  String photo;
  String routeId;
  bool canEvaluate;

  ClientDetailPresenter _presenter;

  var _observation = TextEditingController();

  _ClientPageDetailState({this.name, this.photo, this.routeId, this.canEvaluate}) {
    _presenter = new ClientDetailPresenter(this);
  }

  void evaluate() {
    if (_rating == 0) {
      return;
    }
    _presenter.evaluate(routeId, _rating, _observation.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(decoration: BoxDecoration(gradient: appGradient)),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Text('Avaliação do Passageiro', style: AppTextStyle.textBoldWhiteMedium)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14, left: 20.0, right: 20.0),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
                        height: AppSizes.buttonHeight * 1.5,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 60.0,
                              margin: EdgeInsets.only(right: 15.0),
                              child: photo.isEmpty
                                  ? Image.asset('assets/images/user.png')
                                  : ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/user.png',
                                        image: photo,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            ),
                            SizedBox(width: 5.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(name, overflow: TextOverflow.ellipsis, style: AppTextStyle.textWhiteSmallBold),
                              ],
                            ),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(color: AppColors.colorWhite),
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      height: 1.0,
                    ),
                    Text('Avaliação:', style: AppTextStyle.textWhiteSmallBold),
                    StarRating(
                        rating: _rating,
                        onRatingChanged: (rating) => setState(() {
                              _rating = rating;
                            }),
                        color: Colors.yellow,
                        sizeIcon: 30.0),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          canEvaluate
                              ? TextField(
                                  style: AppTextStyle.textWhiteSmall,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 6,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(255),
                                  ],
                                  textInputAction: TextInputAction.done,
                                  controller: _observation,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      border: InputBorder.none,
                                      hintText: 'Digite algo sobre o passageiro',
                                      hintStyle: AppTextStyle.textWhiteSmall),
                                )
                              : Text(_observation.text, style: AppTextStyle.textWhiteSmall),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: canEvaluate
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  color: AppColors.colorGradientSecondary,
                  child: BlueDarkButton(text: 'Avaliar', callback: evaluate),
                )
              : SizedBox(),
        ));
  }

  @override
  void onEvaluateSuccess() {
    Navigator.pop(context);
    Util.showMessage(context, 'Sucesso', 'Avaliação cadastrada, obrigado!');
  }
}

abstract class ClientDetailView extends BaseView {
  void onEvaluateSuccess();
}

import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/passenger.dart';
import 'package:movemedriver/theme.dart';

class DetailPassenger extends StatefulWidget {
  final Passenger model;
  final Function callback;

  DetailPassenger({@required this.model, this.callback});

  @override
  _DetailPassengerState createState() =>
      _DetailPassengerState(model: model, callback: callback);
}

class _DetailPassengerState extends BaseState<DetailPassenger> {
  Passenger model;
  Function callback;

  _DetailPassengerState({this.model, this.callback});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: AppColors.colorGreenLight,
        elevation: 0.0,
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: new Text('Detalhes do Cliente',
            style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            new Expanded(
              child: new ListView(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('Origem',
                                  style: AppTextStyle.textBlueLightSmallBold),
                              new Text(model.ridePrice.originPoint.address,
                                  style: AppTextStyle.textWhiteSmall),
                            ]),
                      )
                    ],
                  ),
                  new SizedBox(height: 15.0),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('Destino',
                                  style: AppTextStyle.textBlueLightSmallBold),
                              new Text(model.ridePrice.destinationPoint.address,
                                  style: AppTextStyle.textWhiteSmall),
                            ]),
                      )
                    ],
                  ),
                  new SizedBox(height: 15.0),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new Container(
                      padding: EdgeInsets.only(
                          right: 15.0, left: 5.0, top: 5.0, bottom: 5.0),
                      height: AppSizes.buttonHeight * 1.5,
                      child: new Row(
                        children: <Widget>[
                          ClipOval(
                            child: new Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 60.0,
                            ),
                          ),
                          new SizedBox(width: 10.0),
                          new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(model.user.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style:
                                          AppTextStyle.textBlueLightSmallBold),
                                ),
                                new SizedBox(height: 10.0),
                                new Row(
                                  children: <Widget>[
                                    new Text('Avaliação: ',
                                        style: AppTextStyle
                                            .textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                    new Image(
                                        image: AssetImage(
                                            "assets/icons/man_user_branco.png"),
                                        height: 13.0),
                                    new SizedBox(width: 5.0),
                                    new Text(' 4.75 ',
                                        style: AppTextStyle
                                            .textWhiteExtraSmallBold),
                                    new SizedBox(width: 5.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new SizedBox(height: 5.0),
                  new Row(
                    children: <Widget>[
                      new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Quantidade de Viagens:',
                                style: AppTextStyle.textBlueLightSmallBold),
                            new Text(model.rideCount.toString(),
                                style: AppTextStyle.textWhiteSmall),
                          ])
                    ],
                  ),
                  new SizedBox(height: 5.0),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new SizedBox(height: 5.0),
                  new Row(
                    children: <Widget>[
                      new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Membro desde:',
                                style: AppTextStyle.textBlueLightSmallBold),
                            new Text('2019',
                                style: AppTextStyle.textWhiteSmall),
                          ]),
                    ],
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new SizedBox(height: 5.0),
                  new Row(
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('Número de Reservas',
                              style: AppTextStyle.textBlueLightSmallBold),
                          new Text(model.reservations.toString() + ' Pessoas',
                              style: AppTextStyle.textWhiteSmall),
                        ],
                      ),
                    ],
                  ),
                  new SizedBox(height: 5.0),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.only(top: 8, bottom: 20.0),
                    height: 1.0,
                  ),
                  new Text('Comentários:',
                      style: AppTextStyle.textBlueLightSmallBold),
                  new SizedBox(height: 8.0),
                  new Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: new BoxDecoration(
                        border: Border.all(
                            color: AppColors.colorWhite,
                            style: BorderStyle.solid,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(30)),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                            'teste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, testeteste, teste, teste, teste',
                            style: AppTextStyle.textWhiteSmall),
                        new SizedBox(
                          height: 15.0,
                        ),
                        new Text('08:00',
                            style: AppTextStyle.textGreyDarkExtraSmall)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            model.confirmed
                ? Container(
                    margin: EdgeInsets.symmetric(
                        vertical: AppSizes.inputPaddingHorizontalDouble),
                    alignment: Alignment.bottomCenter,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            eventBus.fire(CreateOrOpenNewChatEvent('ride', model.id));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                    color: AppColors.colorWhite,
                                    width: 1,
                                    style: BorderStyle.solid)),
                            child: new Icon(MoveMeIcons.speech_bubble,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.height * 0.08,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                  color: AppColors.colorWhite,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: new Icon(MoveMeIcons.phone_call,
                              color: Colors.white),
                        ),
                        new SizedBox(width: 15.0),
                      ],
                    ),
                  )
                : new Container(
                    margin: EdgeInsets.symmetric(
                        vertical: AppSizes.inputPaddingHorizontalDouble),
                    alignment: Alignment.bottomCenter,
                    child: new FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                          callback(model.id);
                        },
                        child: new Container(
                            height: AppSizes.buttonHeight,
                            decoration: BoxDecoration(
                                color: AppColors.colorPurpleDark,
                                borderRadius: AppSizes.buttonCorner),
                            child: new Center(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text('Aprovar',
                                      style: AppTextStyle.textWhiteSmallBold)
                                ],
                              ),
                            ))),
                  ),
          ],
        ),
      ),
    );
  }
}

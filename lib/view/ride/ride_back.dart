import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/ride/ride_back_register.dart';
import 'package:movemedriver/view/ride/ride_publish/ride_publish.dart';

// class RideBack extends StatefulWidget {
//   final Ride model;
//
//   RideBack({@required this.model});
//
//   @override
//   _RideBackState createState() => _RideBackState(model: model);
// }
class RideBack extends StatefulWidget {
  RideBack();

  @override
  _RideBackState createState() => _RideBackState();
}


class _RideBackState extends BaseState<RideBack> {
  RideBloc bloc;

  _RideBackState();

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
        title:
            new Text('Oferecer Carona', style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            new Expanded(
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: 60.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          child: new Text(
                              'Que tal oferecer carona para o retorno?',
                              style: AppTextStyle.textWhiteSmallBold),
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 80.0,
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: new BoxDecoration(
                      border: Border.all(
                          color: AppColors.colorWhite,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new RideBackRegister()));
                      },
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Sim, claro!',
                                    style: AppTextStyle.textWhiteSmallBold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new SizedBox(height: 5.0),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: new BoxDecoration(
                      border: Border.all(
                          color: AppColors.colorWhite,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    RidePublish(model: [bloc.model])));
                      },
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Não, quem sabe da próxima',
                                    style: AppTextStyle.textWhiteSmallBold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*new Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.inputPaddingHorizontalDouble),
              alignment: Alignment.bottomCenter,
              child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {

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
                            new Text('Continuar',
                                style: AppTextStyle.textWhiteSmallBold)
                          ],
                        ),
                      ))),
            ),*/
          ],
        ),
      ),
    );
  }
}
